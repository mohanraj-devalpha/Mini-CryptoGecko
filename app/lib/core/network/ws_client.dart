import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'api_client.dart';

class PriceUpdate {
  final String coinId;
  final double price;
  final double change24h;

  const PriceUpdate({
    required this.coinId,
    required this.price,
    required this.change24h,
  });
}

class WsClient {
  final String baseUrl;
  final ApiClient apiClient;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  final _priceStreamController = StreamController<List<PriceUpdate>>.broadcast();
  Stream<List<PriceUpdate>> get priceStream => _priceStreamController.stream;

  bool _isDisposed = false;
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;
  Timer? _pollingTimer;
  List<String> _subscribedCoins = [];

  WsClient({
    required this.baseUrl,
    required this.apiClient,
  });

  String get _wsUrl {
    final uri = Uri.parse(baseUrl);
    final wsScheme = uri.scheme == 'https' ? 'wss' : 'ws';
    final portSuffix = (uri.hasPort && uri.port != 80 && uri.port != 443 && uri.port != 0)
        ? ':${uri.port}'
        : '';
    return '$wsScheme://${uri.host}$portSuffix/ws/prices';
  }

  void connect() {
    if (_isDisposed) return;
    _cancelTimers();

    try {
      final uri = Uri.parse(_wsUrl);
      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        (data) {
          _reconnectAttempts = 0;
          _stopPolling();
          _handleMessage(data);
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint('WebSocket closed');
          _scheduleReconnect();
        },
        cancelOnError: true,
      );

      // Re-send subscription if we have coins subscribed
      if (_subscribedCoins.isNotEmpty) {
        subscribe(_subscribedCoins);
      }
    } catch (e) {
      debugPrint('Failed to connect WebSocket: $e');
      _scheduleReconnect();
    }
  }

  void subscribe(List<String> coinIds) {
    _subscribedCoins = coinIds;
    if (_channel != null) {
      try {
        _channel!.sink.add(jsonEncode({'subscribe': coinIds}));
      } catch (e) {
        debugPrint('Failed to send subscribe message: $e');
      }
    }
  }

  void _handleMessage(dynamic data) {
    try {
      final List<dynamic> list = jsonDecode(data.toString());
      final updates = list.map((item) {
        final map = item as Map<String, dynamic>;
        return PriceUpdate(
          coinId: map['id'] as String,
          price: (map['price'] as num).toDouble(),
          change24h: (map['change_24h'] as num).toDouble(),
        );
      }).toList();

      if (!_priceStreamController.isClosed) {
        _priceStreamController.add(updates);
      }
    } catch (e) {
      debugPrint('Error parsing WS price updates: $e');
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;
    _subscription?.cancel();
    _channel = null;

    _reconnectAttempts++;
    if (_reconnectAttempts > 3) {
      // WS having persistent issues -> start 30s polling fallback
      _startPollingFallback();
    }

    // Exponential backoff: 1s, 2s, 4s, 8s, up to 30s max
    final backoffSeconds = min(pow(2, _reconnectAttempts - 1).toInt(), 30);
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(seconds: backoffSeconds), () {
      if (!_isDisposed) {
        connect();
      }
    });
  }

  void _startPollingFallback() {
    if (_pollingTimer != null && _pollingTimer!.isActive) return;
    debugPrint('Starting 30s polling fallback for prices');

    _pollPrices(); // Immediate first poll
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _pollPrices();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> _pollPrices() async {
    try {
      final res = await apiClient.dio.get('/api/coins?per_page=100');
      final data = res.data['data'] as List<dynamic>;
      final updates = data.map((item) {
        return PriceUpdate(
          coinId: item['id'] as String,
          price: (item['price'] as num).toDouble(),
          change24h: (item['change_24h_pct'] as num).toDouble(),
        );
      }).toList();

      if (!_priceStreamController.isClosed) {
        _priceStreamController.add(updates);
      }
    } catch (e) {
      debugPrint('Polling fallback error: $e');
    }
  }

  void _cancelTimers() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void dispose() {
    _isDisposed = true;
    _cancelTimers();
    _stopPolling();
    _subscription?.cancel();
    _channel?.sink.close();
    _priceStreamController.close();
  }
}
