import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/network/device_id_store.dart';
import 'package:app/features/coin_detail/data/coin_detail_repository.dart';

class MockDio extends Mock implements Dio {}
class MockDeviceIdStore extends Mock implements DeviceIdStore {}

void main() {
  late MockDio mockDio;
  late MockDeviceIdStore mockStore;
  late ApiClient apiClient;
  late CoinDetailRepository repository;

  setUp(() {
    mockDio = MockDio();
    mockStore = MockDeviceIdStore();
    apiClient = ApiClient(
      dio: mockDio,
      deviceIdStore: mockStore,
      slowRequestNotifier: SlowRequestNotifier(),
    );
    repository = CoinDetailRepository(apiClient: apiClient);
  });

  test('getCoinDetail returns parsed CoinDetail on 200', () async {
    when(() => mockDio.get('/api/coins/bitcoin')).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/coins/bitcoin'),
        statusCode: 200,
        data: {
          'data': {
            'id': 'bitcoin',
            'symbol': 'BTC',
            'name': 'Bitcoin',
            'image_url': 'https://icon.png',
            'description': 'Peer-to-peer electronic cash',
            'category': 'Layer 1',
            'circulating_supply': 19760000.0,
            'total_supply': 19760000.0,
            'max_supply': 21000000.0,
            'rank': 1,
            'market': {
              'price': 67500.0,
              'volume_24h': 35000000000.0,
              'market_cap': 1300000000000.0,
              'change_24h_pct': 2.5,
              'high_24h': 68000.0,
              'low_24h': 66000.0,
              'ath': 73750.0,
              'ath_date': '2024-03-14T00:00:00Z',
              'updated_at': '2026-10-23T06:00:00Z',
            },
          },
          'updated_at': '2026-10-23T06:00:00Z',
        },
      ),
    );

    final detail = await repository.getCoinDetail('bitcoin');
    expect(detail.id, 'bitcoin');
    expect(detail.name, 'Bitcoin');
    expect(detail.rank, 1);
    expect(detail.market.price, 67500.0);
    expect(detail.market.ath, 73750.0);
  });

  test('getCoinChart returns downsampled ChartPoint list on 200', () async {
    when(() => mockDio.get(
          '/api/coins/bitcoin/chart',
          queryParameters: {'range': '7d'},
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/coins/bitcoin/chart'),
        statusCode: 200,
        data: {
          'data': [
            {'t': '2026-10-16T00:00:00Z', 'price': 65000.0},
            {'t': '2026-10-23T00:00:00Z', 'price': 67500.0},
          ],
          'updated_at': '2026-10-23T06:00:00Z',
        },
      ),
    );

    final points = await repository.getCoinChart('bitcoin', '7d');
    expect(points.length, 2);
    expect(points.first.price, 65000.0);
    expect(points.last.price, 67500.0);
  });
}
