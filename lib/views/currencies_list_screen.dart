import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/currency_provider.dart';

class CurrenciesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Currencies'),
      ),
      body: currencyProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : currencyProvider.error.isNotEmpty
          ? Center(child: Text('Error: ${currencyProvider.error}'))
          : ListView.builder(
        itemCount: currencyProvider.currencies.length,
        itemBuilder: (context, index) {
          final currency = currencyProvider.currencies.entries.elementAt(index);
          return ListTile(
            title: Text(currency.value.name),
            subtitle: Text(currency.key),
            trailing: currency.key == currencyProvider.baseCurrency
                ? Icon(Icons.check_circle, color: Colors.green)
                : null,
          );
        },
      ),
    );
  }
}