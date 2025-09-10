class Currencies {
  Currencies({required this.currencies});

  final Map<String, String> currencies;

  factory Currencies.fromJson(Map<String, dynamic> json) {
    return Currencies(
      currencies: json.map((key, value) => MapEntry(key, value as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return currencies;
  }
}