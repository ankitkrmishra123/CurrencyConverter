import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../lib/models/exchange_rate.dart';
import '../lib/providers/exchange_rate_provider.dart';
import '../lib/services/api_service.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  group('ExchangeRateProvider', () {
    late ExchangeRateProvider provider;
    late MockApiService mockApiService;

    setUp(() {
      mockApiService = MockApiService();
      provider = ExchangeRateProvider();
      // Inject mock service
    });

    test('should convert currency correctly', () {
      // Arrange
      final exchangeRate = ExchangeRate(
        base: 'USD',
        rates: {'EUR': 0.85, 'GBP': 0.75},
        timestamp: DateTime.now(),
      );

      // Act
      double result = provider.convert(100, 'USD', 'EUR');

      // Assert
      expect(result, 85.0);
    });

    // Add more tests...
  });
}