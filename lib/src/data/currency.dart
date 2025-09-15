enum Currency {
  // ignore_for_file: constant_identifier_names
  USD(desc: 'US Dollar', symbol: '\$', flag: '🇺🇸'),
  EUR(desc: 'Euro', symbol: '€', flag: '🇪🇺'),
  GBP(desc: 'British Pound', symbol: '£', flag: '🇬🇧'),
  JPY(desc: 'Japanese Yen', symbol: '¥', flag: '🇯🇵'),
  AUD(desc: 'Australian Dollar', symbol: 'A\$', flag: '🇦🇺'),
  CAD(desc: 'Canadian Dollar', symbol: 'C\$', flag: '🇨🇦'),
  CHF(desc: 'Swiss Franc', symbol: 'CHF', flag: '🇨🇭'),
  CNY(desc: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳'),
  SEK(desc: 'Swedish Krona', symbol: 'kr', flag: '🇸🇪'),
  NZD(desc: 'New Zealand Dollar', symbol: 'NZ\$', flag: '🇳🇿'),
  MXN(desc: 'Mexican Peso', symbol: '\$', flag: '🇲🇽'),
  SGD(desc: 'Singapore Dollar', symbol: 'S\$', flag: '🇸🇬'),
  HKD(desc: 'Hong Kong Dollar', symbol: 'HK\$', flag: '🇭🇰'),
  NOK(desc: 'Norwegian Krone', symbol: 'kr', flag: '🇳🇴'),
  KRW(desc: 'South Korean Won', symbol: '₩', flag: '🇰🇷'),
  TRY(desc: 'Turkish Lira', symbol: '₺', flag: '🇹🇷'),
  RUB(desc: 'Russian Ruble', symbol: '₽', flag: '🇷🇺'),
  INR(desc: 'Indian Rupee', symbol: '₹', flag: '🇮🇳'),
  BRL(desc: 'Brazilian Real', symbol: 'R\$', flag: '🇧🇷'),
  ZAR(desc: 'South African Rand', symbol: 'R', flag: '🇿🇦'),
  DKK(desc: 'Danish Krone', symbol: 'kr', flag: '🇩🇰'),
  PLZ(desc: 'Polish Zloty', symbol: 'zł', flag: '🇵🇱'),
  THB(desc: 'Thai Baht', symbol: '฿', flag: '🇹🇭'),
  IDR(desc: 'Indonesian Rupiah', symbol: 'Rp', flag: '🇮🇩'),
  HUF(desc: 'Hungarian Forint', symbol: 'Ft', flag: '🇭🇺'),
  CZK(desc: 'Czech Koruna', symbol: 'Kč', flag: '🇨🇿'),
  ILS(desc: 'Israeli Shekel', symbol: '₪', flag: '🇮🇱'),
  CLP(desc: 'Chilean Peso', symbol: '\$', flag: '🇨🇱'),
  PHP(desc: 'Philippine Peso', symbol: '₱', flag: '🇵🇭'),
  AED(desc: 'UAE Dirham', symbol: 'د.إ', flag: '🇦🇪'),
  COP(desc: 'Colombian Peso', symbol: '\$', flag: '🇨🇴'),
  SAR(desc: 'Saudi Riyal', symbol: '﷼', flag: '🇸🇦'),
  MYR(desc: 'Malaysian Ringgit', symbol: 'RM', flag: '🇲🇾'),
  RON(desc: 'Romanian Leu', symbol: 'lei', flag: '🇷🇴');

  final String desc;
  final String symbol;
  final String flag;

  const Currency({
    required this.desc,
    required this.symbol,
    required this.flag,
  });

  static Currency from(String code) {
    return Currency.values.firstWhere(
      (currency) => currency.name == code,
      orElse: () => throw ArgumentError('Unknown currency code: $code'),
    );
  }
}
