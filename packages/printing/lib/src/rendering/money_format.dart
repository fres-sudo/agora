/// Formats an integer [cents] amount into a `<symbol><whole>.<fraction>`
/// string for receipts (e.g. `€12.34`).
///
/// Receipts deliberately use a plain `.` decimal separator so the output is
/// unambiguous on a narrow thermal column, independent of locale.
String formatReceiptMoney(int cents, {String symbol = '€'}) {
  final isNegative = cents < 0;
  final abs = isNegative ? -cents : cents;
  final whole = abs ~/ 100;
  final fraction = (abs % 100).toString().padLeft(2, '0');
  final sign = isNegative ? '-' : '';
  return '$sign$symbol$whole.$fraction';
}
