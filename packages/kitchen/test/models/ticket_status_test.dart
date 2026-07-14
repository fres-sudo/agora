import 'package:flutter_test/flutter_test.dart';
import 'package:kitchen/models/ticket_status.dart';

void main() {
  group('TicketStatus.next', () {
    test('advances pending -> inProgress -> ready -> bumped', () {
      expect(TicketStatus.pending.next, TicketStatus.inProgress);
      expect(TicketStatus.inProgress.next, TicketStatus.ready);
      expect(TicketStatus.ready.next, TicketStatus.bumped);
    });

    test('bumped has no further status', () {
      expect(TicketStatus.bumped.next, isNull);
    });
  });
}
