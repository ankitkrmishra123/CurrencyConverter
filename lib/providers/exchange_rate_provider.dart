import 'package:flutter/foundation.dart';
import '../models/exchange_rate.dart';
import '../services/api_service.dart';

class ExchangeRateProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  ExchangeRate? _exchangeRate;
  bool _isLoading = false;
  String _error = '';

  ExchangeRate? get exchangeRate => _exchangeRate;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchExchangeRates(String base) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _exchangeRate = await _apiService.fetchLatestRates(base);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  double convert(double amount, String from, String to) {
    if (_exchangeRate == null) return 0;

    if (from == _exchangeRate!.base) {
      return amount * (_exchangeRate!.rates[to] ?? 1);
    } else if (to == _exchangeRate!.base) {
      return amount / (_exchangeRate!.rates[from] ?? 1);
    } else {
      // Convert from source to base, then from base to target
      double amountInBase = amount / (_exchangeRate!.rates[from] ?? 1);
      return amountInBase * (_exchangeRate!.rates[to] ?? 1);
    }
  }
}