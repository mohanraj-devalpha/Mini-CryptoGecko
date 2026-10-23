import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/network/device_id_store.dart';
import 'package:app/features/market/data/market_repository.dart';

class MockDio extends Mock implements Dio {}
class MockDeviceIdStore extends Mock implements DeviceIdStore {}

void main() {
  late MockDio mockDio;
  late MockDeviceIdStore mockStore;
  late ApiClient apiClient;
  late MarketRepository repository;

  setUp(() {
    mockDio = MockDio();
    mockStore = MockDeviceIdStore();
    apiClient = ApiClient(
      dio: mockDio,
      deviceIdStore: mockStore,
      slowRequestNotifier: SlowRequestNotifier(),
    );
    repository = MarketRepository(apiClient: apiClient);
  });

  test('getGlobalMarket returns parsed GlobalMarket on 200', () async {
    when(() => mockDio.get('/api/market/global')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/market/global'),
        statusCode: 200,
        data: {
          'data': {
            'total_market_cap': 2500000000000.0,
            'total_volume_24h': 85000000000.0,
            'btc_dominance': 54.2,
            'eth_dominance': 16.8,
            'coin_count': 53,
            'market_cap_change_24h_pct': 3.12,
          },
        },
      ),
    );

    final global = await repository.getGlobalMarket();
    expect(global.totalMarketCap, 2500000000000.0);
    expect(global.totalVolume24h, 85000000000.0);
    expect(global.btcDominance, 54.2);
    expect(global.ethDominance, 16.8);
    expect(global.coinCount, 53);
    expect(global.marketCapChange24hPct, 3.12);
  });

  test('getMarketMovers returns parsed MarketMovers on 200', () async {
    when(() => mockDio.get(
          '/api/market/movers',
          queryParameters: {'limit': 5},
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/market/movers'),
        statusCode: 200,
        data: {
          'data': {
            'gainers': [
              {
                'id': 'solana',
                'symbol': 'SOL',
                'name': 'Solana',
                'image_url': 'https://sol.png',
                'category': 'Layer 1',
                'rank': 5,
                'price': 180.0,
                'volume_24h': 4000000000.0,
                'market_cap': 85000000000.0,
                'change_24h_pct': 12.5,
                'high_24h': 185.0,
                'low_24h': 160.0,
              }
            ],
            'losers': [
              {
                'id': 'cardano',
                'symbol': 'ADA',
                'name': 'Cardano',
                'image_url': 'https://ada.png',
                'category': 'Layer 1',
                'rank': 10,
                'price': 0.35,
                'volume_24h': 300000000.0,
                'market_cap': 12000000000.0,
                'change_24h_pct': -4.5,
                'high_24h': 0.38,
                'low_24h': 0.34,
              }
            ],
          },
        },
      ),
    );

    final movers = await repository.getMarketMovers(limit: 5);
    expect(movers.gainers.length, 1);
    expect(movers.gainers.first.symbol, 'SOL');
    expect(movers.gainers.first.change24hPct, 12.5);
    expect(movers.losers.length, 1);
    expect(movers.losers.first.symbol, 'ADA');
    expect(movers.losers.first.change24hPct, -4.5);
  });

  test('getCategories returns parsed CategoryItem list on 200', () async {
    when(() => mockDio.get('/api/categories')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/categories'),
        statusCode: 200,
        data: {
          'data': [
            {'name': 'Layer 1', 'count': 14},
            {'name': 'DeFi', 'count': 12},
          ],
        },
      ),
    );

    final cats = await repository.getCategories();
    expect(cats.length, 2);
    expect(cats[0].name, 'Layer 1');
    expect(cats[0].count, 14);
    expect(cats[1].name, 'DeFi');
    expect(cats[1].count, 12);
  });
}
