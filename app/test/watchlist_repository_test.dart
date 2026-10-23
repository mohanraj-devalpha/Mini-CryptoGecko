import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/network/device_id_store.dart';
import 'package:app/features/watchlist/data/watchlist_repository.dart';

class MockDio extends Mock implements Dio {}
class MockDeviceIdStore extends Mock implements DeviceIdStore {}

void main() {
  late MockDio mockDio;
  late MockDeviceIdStore mockStore;
  late ApiClient apiClient;
  late WatchlistRepository repository;

  setUp(() {
    mockDio = MockDio();
    mockStore = MockDeviceIdStore();
    apiClient = ApiClient(
      dio: mockDio,
      deviceIdStore: mockStore,
      slowRequestNotifier: SlowRequestNotifier(),
    );
    repository = WatchlistRepository(apiClient: apiClient);
  });

  test('getWatchlist returns parsed WatchlistItem list on 200', () async {
    when(() => mockDio.get('/api/watchlist')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/watchlist'),
        statusCode: 200,
        data: {
          'data': [
            {
              'id': 1,
              'device_id': 'dev-123',
              'coin_id': 'bitcoin',
              'created_at': '2026-10-23T00:00:00Z',
              'coin': {
                'id': 'bitcoin',
                'symbol': 'BTC',
                'name': 'Bitcoin',
                'image_url': 'https://btc.png',
                'category': 'Layer 1',
                'rank': 1,
                'price': 68000.0,
                'volume_24h': 35000000000.0,
                'market_cap': 1300000000000.0,
                'change_24h_pct': 2.4,
                'high_24h': 68500.0,
                'low_24h': 66500.0,
              },
            },
          ],
        },
      ),
    );

    final items = await repository.getWatchlist();
    expect(items.length, 1);
    expect(items.first.coinId, 'bitcoin');
    expect(items.first.coin.name, 'Bitcoin');
    expect(items.first.coin.price, 68000.0);
  });

  test('addToWatchlist sends post request and returns WatchlistItem', () async {
    when(() => mockDio.post(
          '/api/watchlist',
          data: {'coin_id': 'ethereum'},
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/watchlist'),
        statusCode: 201,
        data: {
          'data': {
            'id': 2,
            'device_id': 'dev-123',
            'coin_id': 'ethereum',
            'created_at': '2026-10-23T01:00:00Z',
            'coin': {
              'id': 'ethereum',
              'symbol': 'ETH',
              'name': 'Ethereum',
              'image_url': 'https://eth.png',
              'category': 'Smart Contracts',
              'rank': 2,
              'price': 3500.0,
              'volume_24h': 18000000000.0,
              'market_cap': 420000000000.0,
              'change_24h_pct': 1.8,
              'high_24h': 3550.0,
              'low_24h': 3420.0,
            },
          },
        },
      ),
    );

    final item = await repository.addToWatchlist('ethereum');
    expect(item.id, 2);
    expect(item.coinId, 'ethereum');
    expect(item.coin.symbol, 'ETH');
  });

  test('removeFromWatchlist calls delete on api endpoint', () async {
    when(() => mockDio.delete('/api/watchlist/bitcoin')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/watchlist/bitcoin'),
        statusCode: 200,
        data: {'success': true},
      ),
    );

    await expectLater(
      repository.removeFromWatchlist('bitcoin'),
      completes,
    );
    verify(() => mockDio.delete('/api/watchlist/bitcoin')).called(1);
  });
}
