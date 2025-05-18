import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/currency.dart';
import '../providers/currency_provider.dart';
import '../providers/exchange_rate_provider.dart';
import 'settings_screen.dart';
import 'currencies_list_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<CurrencyField> _currencyFields = [];
  double _totalInBaseCurrency = 0.0;

  @override
  void initState() {
    super.initState();
    // Add initial currency field
    _currencyFields.add(CurrencyField(
      key: UniqueKey(),
      onRemove: _removeCurrencyField,
      onChanged: _updateTotal,
    ));

    // Fetch currencies and exchange rates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);
      final exchangeRateProvider = Provider.of<ExchangeRateProvider>(context, listen: false);

      currencyProvider.fetchCurrencies();
      exchangeRateProvider.fetchExchangeRates(currencyProvider.baseCurrency);
    });
  }

  void _addCurrencyField() {
    setState(() {
      _currencyFields.add(CurrencyField(
        key: UniqueKey(),
        onRemove: _removeCurrencyField,
        onChanged: _updateTotal,
      ));
    });
  }

  void _removeCurrencyField(Key key) {
    setState(() {
      _currencyFields.removeWhere((field) => field.key == key);
      _updateTotal();
    });
  }

  void _updateTotal() {
    final exchangeRateProvider = Provider.of<ExchangeRateProvider>(context, listen: false);
    final currencyProvider = Provider.of<CurrencyProvider>(context, listen: false);

    double total = 0.0;

    for (var field in _currencyFields) {
      if (field.amount > 0 && field.selectedCurrency.isNotEmpty) {
        total += exchangeRateProvider.convert(
            field.amount,
            field.selectedCurrency,
            currencyProvider.baseCurrency
        );
      }
    }

    setState(() {
      _totalInBaseCurrency = total;
    });
  }

  void _calculateTotal() {
    _updateTotal();
    // Show a snackbar or update UI to indicate calculation is complete
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Total calculated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CurrenciesListScreen()),
              );
            },
          ),
        ],
      ),
      body: currencyProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : currencyProvider.error.isNotEmpty
          ? Center(child: Text('Error: ${currencyProvider.error}'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ..._currencyFields,
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addCurrencyField,
                    child: Text('Add Currency'),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _calculateTotal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text('Calculate Total', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total in ${currencyProvider.baseCurrency}:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_totalInBaseCurrency.toStringAsFixed(2)} ${currencyProvider.baseCurrency}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyField extends StatefulWidget {
  final Function(Key) onRemove;
  final Function() onChanged;

  double amount = 0.0;
  String selectedCurrency = '';

  CurrencyField({
    required Key key,
    required this.onRemove,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CurrencyFieldState createState() => _CurrencyFieldState();
}

class _CurrencyFieldState extends State<CurrencyField> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyProvider = Provider.of<CurrencyProvider>(context);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  widget.amount = double.tryParse(value) ?? 0.0;
                  widget.onChanged();
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Currency',
                  border: OutlineInputBorder(),
                ),
                value: widget.selectedCurrency.isEmpty ? null : widget.selectedCurrency,
                items: currencyProvider.currencies.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text('${entry.key} - ${entry.value.name}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    widget.selectedCurrency = value ?? '';
                    widget.onChanged();
                  });
                },
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => widget.onRemove(widget.key!),
            ),
          ],
        ),
      ),
    );
  }
}