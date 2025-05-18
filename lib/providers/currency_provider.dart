import 'package:flutter/foundation.dart';
import '../models/currency.dart';
import '../services/api_service.dart';

class CurrencyProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, Currency> _currencies = {};
  bool _isLoading = false;
  String _error = '';
  String _baseCurrency = 'USD';

  Map<String, Currency> get currencies => _currencies;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get baseCurrency => _baseCurrency;

  Future<void> fetchCurrencies() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _currencies = await _apiService.fetchCurrencies();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setBaseCurrency(String currency) {
    _baseCurrency = currency;
    notifyListeners();
  }
}