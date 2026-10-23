import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_client.dart';
import 'device_id_store.dart';
import 'ws_client.dart';

final deviceIdStoreProvider = Provider<DeviceIdStore>((ref) {
  return DeviceIdStore();
});

final slowRequestNotifierProvider = ChangeNotifierProvider<SlowRequestNotifier>((ref) {
  return SlowRequestNotifier();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final store = ref.watch(deviceIdStoreProvider);
  final slowNotifier = ref.watch(slowRequestNotifierProvider);
  return ApiClient.create(
    deviceIdStore: store,
    slowNotifier: slowNotifier,
  );
});

final wsClientProvider = Provider<WsClient>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final client = WsClient(
    baseUrl: apiClient.dio.options.baseUrl,
    apiClient: apiClient,
  );
  client.connect();
  ref.onDispose(() => client.dispose());
  return client;
});

final priceStreamProvider = StreamProvider<List<PriceUpdate>>((ref) {
  final ws = ref.watch(wsClientProvider);
  return ws.priceStream;
});
