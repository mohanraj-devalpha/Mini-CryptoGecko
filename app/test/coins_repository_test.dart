import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app/core/network/api_client.dart';
import 'package:app/core/network/device_id_store.dart';
import 'package:app/features/coins/data/coins_repository.dart';

class MockDio extends Mock implements Dio {}
class MockDeviceIdStore extends Mock implements DeviceIdStore {}

void main() {
  late MockDio mockDio;
  late MockDeviceIdStore mockStore;
  late ApiClient apiClient;
  late CoinsRepository repository;

  setUp(() {
    mockDio = MockDio();
    mockStore = MockDeviceIdStore();
    apiClient = ApiClient(
      dio: mockDio,
      deviceIdStore: mockStore,
      slowRequestNotifier: SlowRequestNotifier(),
    );
    repository = CoinsRepository(apiClient: apiClient);
  });

  test('getCoins returns parsed CoinsResponse on 200', () async {
    when(() => mockDio.get(
          '/api/coins',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer(
      (_) async => Response(
        requestOptions: RequestOptions(path: '/api/coins'),
        statusCode: 200,
        data: {
          'data': [
            {
              'id': 'bitcoin',
              'symbol': 'BTC',
              'name': 'Bitcoin',
              'image_url': 'https://icon.png',
              'category': 'Layer 1',
              'rank': 1,
              'price': 67500.0,
              'volume_24h': 35000000000.0,
              'market_cap': 1300000000000.0,
              'change_24h_pct': 2.5,
              'high_24h': 68000.0,
              'low_24h': 66000.0,
            }
          ],
          'meta': {
            'page': 1,
            'per_page': 25,
            'total': 1,
            'pages': 1,
          },
          'updated_at': '2026-10-23T06:00:00Z',
        },
      ),
    );

    final res = await repository.getCoins(page: 1, sort: 'market_cap');
    expect(res.coins.length, 1);
    expect(res.coins.first.name, 'Bitcoin');
    expect(res.coins.first.symbol, 'BTC');
    expect(res.coins.first.rank, 1);
    expect(res.total, 1);
  });

  test('getCoins throws mapped AppException on DioException', () async {
    when(() => mockDio.get(
          '/api/coins',
          queryParameters: any(named: 'queryParameters'),
        )).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/api/coins'),
        type: DioExceptionType.connectionTimeout,
        error: const AppException('Connection timed out', code: 'TIMEOUT'),
      ),
    );

    expect(
      () => repository.getCoins(),
      throwsA(isA<AppException>()),
    );
  });
}
