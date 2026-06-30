import 'package:flutter_test/flutter_test.dart';
import 'package:utils/utils.dart';

void main() {
  group('formatCents', () {
    test('formats whole and fractional parts with Italian separators', () {
      expect(formatCents(1234), '€12,34');
      expect(formatCents(0), '€0,00');
      expect(formatCents(5), '€0,05');
      expect(formatCents(100), '€1,00');
    });

    test('groups thousands', () {
      expect(formatCents(150000), '€1.500,00');
      expect(formatCents(123456789), '€1.234.567,89');
    });

    test('renders negatives with leading sign before symbol', () {
      expect(formatCents(-50), '-€0,50');
      expect(formatCents(-150000), '-€1.500,00');
    });

    test('supports custom symbol and separators', () {
      expect(
        formatCents(
          1234,
          symbol: r'$',
          decimalSeparator: '.',
          thousandSeparator: ',',
        ),
        r'$12.34',
      );
      expect(formatCents(1234, symbol: ' EUR', symbolAfter: true), '12,34 EUR');
    });
  });

  group('parseCents', () {
    test('parses plain numbers', () {
      expect(parseCents('12,34'), 1234);
      expect(parseCents('12.34'), 1234);
      expect(parseCents('7'), 700);
      expect(parseCents('0'), 0);
    });

    test('ignores currency symbols and whitespace', () {
      expect(parseCents(r'$ 12.34'), 1234);
      expect(parseCents('  €12,34 '), 1234);
    });

    test('treats last separator as decimal and ignores grouping', () {
      expect(parseCents('1.500,00'), 150000);
      expect(parseCents('1,234,567.89'), 123456789);
    });

    test('truncates extra fractional digits', () {
      expect(parseCents('12,349'), 1234);
    });

    test('handles negatives', () {
      expect(parseCents('-0,50'), -50);
    });

    test('returns null for invalid input', () {
      expect(parseCents('abc'), isNull);
      expect(parseCents(''), isNull);
      expect(parseCents('-'), isNull);
    });

    test('round-trips with formatCents', () {
      for (final cents in [0, 5, 100, 1234, 150000, 999999]) {
        expect(parseCents(formatCents(cents)), cents);
      }
    });
  });
}
