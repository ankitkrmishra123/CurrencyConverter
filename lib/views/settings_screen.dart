import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';
import '../providers/exchange_rate_provider.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    final exchangeRateProvider = Provider.of<ExchangeRateProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Base Currency',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            currencyProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Select Base Currency',
                border: OutlineInputBorder(),
              ),
              value: currencyProvider.baseCurrency,
              items: currencyProvider.currencies.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text('${entry.key} - ${entry.value.name}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  currencyProvider.setBaseCurrency(value);
                  exchangeRateProvider.fetchExchangeRates(value);
                }
              },
            ),
            SizedBox(height: 24),
            Text(
              'About',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Currency Converter App v1.0.0\n'
                  'This app uses real-time exchange rates from ExchangeRates API.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}