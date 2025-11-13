enum ChartTimeRange {
  oneDay('1D', 'Past day', 1, 0, 0),
  oneWeek('1W', 'Past week', 7, 0, 0),
  oneMonth('1M', 'Past month', 0, 1, 0),
  threeMonths('3M', 'Past 3 months', 0, 3, 0),
  oneYear('1Y', 'Past year', 0, 0, 1),
  fiveYears('5Y', 'Past 5 years', 0, 0, 5),
  tenYears('10Y', 'Past 10 years', 0, 0, 10)
  ;

  const ChartTimeRange(
    this.label,
    this.description,
    this.days,
    this.months,
    this.years,
  );
  final String label;
  final String description;
  final int days;
  final int months;
  final int years;

  /// Returns the start date for this time range relative to today
  DateTime getStartDate(DateTime today) {
    if (days > 0) {
      return today.subtract(Duration(days: days));
    } else if (months > 0) {
      return DateTime(today.year, today.month - months, today.day);
    } else {
      return DateTime(today.year - years, today.month, today.day);
    }
  }

  /// Formats a DateTime to YYYY-MM-DD format for API requests
  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
