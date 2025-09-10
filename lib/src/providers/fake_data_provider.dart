class FakeDataProvider {
  static const Map<String, String> currencies = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'SEK': 'Swedish Krona',
    'NZD': 'New Zealand Dollar',
    'MXN': 'Mexican Peso',
    'SGD': 'Singapore Dollar',
    'HKD': 'Hong Kong Dollar',
    'NOK': 'Norwegian Krone',
    'KRW': 'South Korean Won',
    'TRY': 'Turkish Lira',
    'RUB': 'Russian Ruble',
    'INR': 'Indian Rupee',
    'BRL': 'Brazilian Real',
    'ZAR': 'South African Rand',
    'DKK': 'Danish Krone',
    'PLN': 'Polish Zloty',
    'THB': 'Thai Baht',
    'IDR': 'Indonesian Rupiah',
    'HUF': 'Hungarian Forint',
    'CZK': 'Czech Koruna',
    'ILS': 'Israeli Shekel',
    'CLP': 'Chilean Peso',
    'PHP': 'Philippine Peso',
    'AED': 'UAE Dirham',
    'COP': 'Colombian Peso',
    'SAR': 'Saudi Riyal',
    'MYR': 'Malaysian Ringgit',
    'RON': 'Romanian Leu',
  };

  static const Map<String, String> currencyFlags = {
    'USD': '🇺🇸',
    'EUR': '🇪🇺',
    'GBP': '🇬🇧',
    'JPY': '🇯🇵',
    'AUD': '🇦🇺',
    'CAD': '🇨🇦',
    'CHF': '🇨🇭',
    'CNY': '🇨🇳',
    'SEK': '🇸🇪',
    'NZD': '🇳🇿',
    'MXN': '🇲🇽',
    'SGD': '🇸🇬',
    'HKD': '🇭🇰',
    'NOK': '🇳🇴',
    'KRW': '🇰🇷',
    'TRY': '🇹🇷',
    'RUB': '🇷🇺',
    'INR': '🇮🇳',
    'BRL': '🇧🇷',
    'ZAR': '🇿🇦',
    'DKK': '🇩🇰',
    'PLN': '🇵🇱',
    'THB': '🇹🇭',
    'IDR': '🇮🇩',
    'HUF': '🇭🇺',
    'CZK': '🇨🇿',
    'ILS': '🇮🇱',
    'CLP': '🇨🇱',
    'PHP': '🇵🇭',
    'AED': '🇦🇪',
    'COP': '🇨🇴',
    'SAR': '🇸🇦',
    'MYR': '🇲🇾',
    'RON': '🇷🇴',
  };

  // Fake exchange rates (base: USD)
  static const Map<String, double> _usdRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 149.50,
    'AUD': 1.52,
    'CAD': 1.36,
    'CHF': 0.88,
    'CNY': 7.24,
    'SEK': 10.59,
    'NZD': 1.66,
    'MXN': 17.13,
    'SGD': 1.35,
    'HKD': 7.83,
    'NOK': 10.64,
    'KRW': 1324.37,
    'TRY': 28.92,
    'RUB': 91.45,
    'INR': 83.12,
    'BRL': 4.97,
    'ZAR': 18.86,
    'DKK': 6.86,
    'PLN': 4.00,
    'THB': 35.53,
    'IDR': 15625.0,
    'HUF': 353.75,
    'CZK': 22.61,
    'ILS': 3.71,
    'CLP': 928.45,
    'PHP': 55.85,
    'AED': 3.67,
    'COP': 3960.25,
    'SAR': 3.75,
    'MYR': 4.67,
    'RON': 4.57,
  };

  static double getExchangeRate(String from, String to) {
    if (from == to) return 1.0;
    
    // Convert through USD as base
    final fromRate = _usdRates[from] ?? 1.0;
    final toRate = _usdRates[to] ?? 1.0;
    
    if (from == 'USD') {
      return toRate;
    } else if (to == 'USD') {
      return 1.0 / fromRate;
    } else {
      // Cross rate calculation
      return toRate / fromRate;
    }
  }

  static String getFlag(String currencyCode) {
    return currencyFlags[currencyCode] ?? '🏳️';
  }

  static String getCurrencyName(String currencyCode) {
    return currencies[currencyCode] ?? currencyCode;
  }
}