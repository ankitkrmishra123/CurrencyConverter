class ExchangeRate {
  final String base;
  final Map<String, double> rates;
  final DateTime timestamp;

  ExchangeRate({
    required this.base,
    required this.rates,
    required this.timestamp,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      base: json['base'],
      rates: (json['rates'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, (value as num).toDouble())),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000),
    );
  }


}