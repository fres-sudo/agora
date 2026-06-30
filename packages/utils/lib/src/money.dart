/// Money formatting and parsing helpers.
///
/// All monetary values in Agora are stored as integer **cents** to avoid
/// floating-point rounding errors. This is the single shared place that turns
/// those cents into display strings and parses user input back into cents.
///
/// The currency symbol defaults to the Euro (`€`) since the app targets Italian
/// sagre & fiere, but it can be overridden (e.g. from settings).
library;

/// The default currency symbol used across the app.
const String kDefaultCurrencySymbol = '€';

/// Formats an integer amount of [cents] into a currency string.
///
/// ```dart
/// formatCents(1234);                 // '€12,34'
/// formatCents(1234, symbol: r'$');   // r'$12.34' (use decimalSeparator: '.')
/// formatCents(-50);                  // '-€0,50'
/// formatCents(150000);               // '€1.500,00'
/// ```
///
/// - [symbol] is prefixed (with no space) before the number, or suffixed when
///   [symbolAfter] is true.
/// - [decimalSeparator] separates the whole and fractional part (Italian uses
///   `,`). [thousandSeparator] groups the integer part (Italian uses `.`).
/// - Negative amounts are rendered with a leading `-` before the symbol.
String formatCents(
  int cents, {
  String symbol = kDefaultCurrencySymbol,
  String decimalSeparator = ',',
  String thousandSeparator = '.',
  bool symbolAfter = false,
}) {
  final isNegative = cents < 0;
  final absCents = isNegative ? -cents : cents;

  final whole = absCents ~/ 100;
  final fraction = absCents % 100;

  final wholeStr = _groupThousands(whole.toString(), thousandSeparator);
  final fractionStr = fraction.toString().padLeft(2, '0');

  final number = '$wholeStr$decimalSeparator$fractionStr';

  final sign = isNegative ? '-' : '';
  return symbolAfter ? '$sign$number$symbol' : '$sign$symbol$number';
}

/// Parses a user-entered [input] string into an integer amount of cents.
///
/// Returns `null` when the input cannot be interpreted as a number. Tolerant of
/// the currency symbol, surrounding whitespace, and either `,` or `.` as the
/// decimal separator (the last separator in the string is treated as decimal so
/// grouping characters are ignored). More than two fractional digits are
/// truncated.
///
/// ```dart
/// parseCents('12,34');     // 1234
/// parseCents(r'$ 12.34');  // 1234
/// parseCents('1.500,00');  // 150000
/// parseCents('7');         // 700
/// parseCents('abc');       // null
/// ```
int? parseCents(String input) {
  // Keep only digits, separators and a leading sign.
  final cleaned = input.replaceAll(RegExp(r'[^0-9,.\-]'), '').trim();
  if (cleaned.isEmpty || cleaned == '-') return null;

  final isNegative = cleaned.startsWith('-');
  final digitsAndSeparators = isNegative ? cleaned.substring(1) : cleaned;

  // Determine the decimal separator as the last occurring '.' or ','.
  final lastComma = digitsAndSeparators.lastIndexOf(',');
  final lastDot = digitsAndSeparators.lastIndexOf('.');
  final decimalIndex = lastComma > lastDot ? lastComma : lastDot;

  String wholePart;
  String fractionPart;
  if (decimalIndex == -1) {
    wholePart = digitsAndSeparators;
    fractionPart = '';
  } else {
    wholePart = digitsAndSeparators.substring(0, decimalIndex);
    fractionPart = digitsAndSeparators.substring(decimalIndex + 1);
  }

  // Strip any remaining grouping separators from each part.
  wholePart = wholePart.replaceAll(RegExp(r'[,.]'), '');
  fractionPart = fractionPart.replaceAll(RegExp(r'[,.]'), '');

  if (wholePart.isEmpty && fractionPart.isEmpty) return null;

  final whole = wholePart.isEmpty ? 0 : int.tryParse(wholePart);
  if (whole == null) return null;

  // Normalise the fraction to exactly two digits (truncate extras).
  final normalisedFraction = fractionPart.padRight(2, '0').substring(0, 2);
  final fraction = int.tryParse(normalisedFraction) ?? 0;

  final cents = whole * 100 + fraction;
  return isNegative ? -cents : cents;
}

/// Inserts [separator] every three digits in an integer string [value].
String _groupThousands(String value, String separator) {
  if (separator.isEmpty || value.length <= 3) return value;

  final buffer = StringBuffer();
  final firstGroupLength = value.length % 3;

  if (firstGroupLength > 0) {
    buffer.write(value.substring(0, firstGroupLength));
    if (value.length > firstGroupLength) buffer.write(separator);
  }

  for (var i = firstGroupLength; i < value.length; i += 3) {
    buffer.write(value.substring(i, i + 3));
    if (i + 3 < value.length) buffer.write(separator);
  }

  return buffer.toString();
}
