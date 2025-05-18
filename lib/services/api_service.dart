import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency.dart';
import '../models/exchange_rate.dart';
import '../utils/constants.dart';

class ApiService {
  final String _baseUrl = 'https://api.apilayer.com/exchangerates_data';
  final String _apiKey = 'EJYlrycWKbKPNrsfhPjbAC1ATcH3gj2A'; // Replace with your actual API key

  Future<Map<String, Currency>> fetchCurrencies() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/symbols'),
        headers: {'apikey': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final symbols = data['symbols'] as Map<String, dynamic>;
          final Map<String, Currency> currencies = {};

          symbols.forEach((code, name) {
            currencies[code] = Currency.fromJson(code, name.toString());
          });

          return currencies;
        }
      }
      throw Exception('Failed to load currencies');
    } catch (e) {
      throw Exception('Error fetching currencies: $e');
    }
  }

  Future<ExchangeRate> fetchLatestRates(String base) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/latest?base=$base'),
        headers: {'apikey': _apiKey},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return ExchangeRate.fromJson(data);
        }
      }
      throw Exception('Failed to load exchange rates');
    } catch (e) {
      throw Exception('Error fetching exchange rates: $e');
    }
  }
}