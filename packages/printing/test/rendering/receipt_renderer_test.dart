import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:printing/src/models/receipt.dart';
import 'package:printing/src/rendering/receipt_renderer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const renderer = ReceiptRenderer();

  Receipt buildReceipt({String storeName = 'Caffè Rossi'}) {
    return Receipt(
      storeName: storeName,
      orderNumber: '42',
      createdAt: DateTime(2026, 7, 9, 12, 30),
      lines: const [
        ReceiptLine(
          name: 'Bruschetta al pomodoro',
          quantity: 1,
          unitPriceCents: 450,
        ),
      ],
      subtotalCents: 450,
      taxCents: 0,
      discountCents: 0,
      totalCents: 450,
    );
  }

  test(
    'emits an ESC t CP1252 code-page command before any receipt text',
    () async {
      final bytes = await renderer.toEscPos(buildReceipt());

      // ESC/POS "select character code table": 0x1B 0x74 <n>. The default
      // capability profile maps CP1252 to id 16 — see
      // esc_pos_utils_plus's resources/capabilities.json.
      const escT = 0x1B;
      const tCommand = 0x74;
      const cp1252Id = 16;

      final commandIndex = _indexOfSequence(bytes, [escT, tCommand, cp1252Id]);
      expect(
        commandIndex,
        isNonNegative,
        reason:
            'Expected an ESC t <CP1252 id> code-page command in the receipt '
            'bytes so the printer decodes accented characters correctly.',
      );

      // The code-page command must be sent before any printable text, so the
      // whole receipt (including the store name) is interpreted with it.
      final storeNameBytes = latin1.encode('Caff');
      final storeNameIndex = _indexOfSequence(bytes, storeNameBytes);
      expect(storeNameIndex, isNonNegative);
      expect(commandIndex, lessThan(storeNameIndex));
    },
  );

  test(
    'accented characters round-trip through the Latin-1 byte stream',
    () async {
      final bytes = await renderer.toEscPos(buildReceipt(storeName: 'àèìòù'));

      final expected = latin1.encode('àèìòù');
      expect(_indexOfSequence(bytes, expected), isNonNegative);
    },
  );
}

/// Returns the index of the first occurrence of [needle] inside [haystack],
/// or -1 if it never occurs.
int _indexOfSequence(List<int> haystack, List<int> needle) {
  if (needle.isEmpty) return -1;
  for (var i = 0; i <= haystack.length - needle.length; i++) {
    var matches = true;
    for (var j = 0; j < needle.length; j++) {
      if (haystack[i + j] != needle[j]) {
        matches = false;
        break;
      }
    }
    if (matches) return i;
  }
  return -1;
}
