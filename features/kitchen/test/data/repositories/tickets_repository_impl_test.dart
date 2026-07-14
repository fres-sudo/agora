import 'package:database/database.dart';
import 'package:drift/native.dart';
import 'package:feature_kitchen/data/repositories/tickets_repository_impl.dart';
import 'package:feature_kitchen/data/sources/local/daos/tickets_dao.dart';
import 'package:kitchen/kitchen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:result/result.dart';
import 'package:sync_engine/sync_engine.dart';

import 'tickets_repository_impl_test.mocks.dart';

Future<int> _insertOrder(AgoraDatabase db, {String? syncId}) {
  return db
      .into(db.ordersTable)
      .insert(
        OrdersTableCompanion.insert(
          subtotal: 1000,
          grandTotal: 1000,
          syncId: Value(syncId),
        ),
      );
}

Future<void> _insertItem(
  AgoraDatabase db, {
  required int orderId,
  required String productName,
  required String? prepStation,
  int ticketStatus = 0,
}) async {
  await db
      .into(db.orderItemsTable)
      .insert(
        OrderItemsTableCompanion.insert(
          orderId: orderId,
          productName: productName,
          unitPrice: 500,
          costPrice: 0,
          prepStation: Value(prepStation),
          ticketStatus: Value(ticketStatus),
        ),
      );
}

@GenerateMocks([SyncManager])
void main() {
  late AgoraDatabase db;
  late MockSyncManager syncManager;
  late TicketsDao ticketsDao;
  late TicketsRepositoryImpl repo;

  setUp(() {
    db = AgoraDatabase(NativeDatabase.memory());
    syncManager = MockSyncManager();
    when(
      syncManager.enqueue(
        entityType: anyNamed('entityType'),
        operation: anyNamed('operation'),
        entityLocalId: anyNamed('entityLocalId'),
        payload: anyNamed('payload'),
        remoteId: anyNamed('remoteId'),
      ),
    ).thenAnswer((_) async {});
    ticketsDao = TicketsDao(db);
    repo = TicketsRepositoryImpl(
      ticketsDao: ticketsDao,
      syncManager: syncManager,
      deviceId: const DeviceId('test-device'),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('TicketsRepositoryImpl.watchTicketsForStation', () {
    test(
      'groups all items of an order that share a station into one ticket',
      () async {
        final orderId = await _insertOrder(db);
        await _insertItem(
          db,
          orderId: orderId,
          productName: 'Bruschette',
          prepStation: 'Griglia',
        );
        await _insertItem(
          db,
          orderId: orderId,
          productName: 'Salsicce',
          prepStation: 'Griglia',
        );
        // A different station on the same order must not appear here.
        await _insertItem(
          db,
          orderId: orderId,
          productName: 'Acqua',
          prepStation: 'Bar',
        );
        // An unrouted item must never appear on any station's queue.
        await _insertItem(
          db,
          orderId: orderId,
          productName: 'Tovagliolo',
          prepStation: null,
        );

        final tickets = await repo.watchTicketsForStation('Griglia').first;

        expect(tickets, hasLength(1));
        final ticket = tickets.single;
        expect(ticket.orderId, orderId);
        expect(ticket.station, 'Griglia');
        expect(ticket.status, TicketStatus.pending);
        expect(
          ticket.items.map((i) => i.productName),
          unorderedEquals(['Bruschette', 'Salsicce']),
        );
      },
    );

    test('excludes bumped tickets from the queue', () async {
      final orderId = await _insertOrder(db);
      await _insertItem(
        db,
        orderId: orderId,
        productName: 'Bruschette',
        prepStation: 'Griglia',
        ticketStatus: TicketStatus.bumped.index,
      );

      final tickets = await repo.watchTicketsForStation('Griglia').first;

      expect(tickets, isEmpty);
    });

    test('excludes tickets belonging to a voided order', () async {
      final orderId = await _insertOrder(db);
      await db
          .update(db.ordersTable)
          .write(const OrdersTableCompanion(status: Value(2))); // voided
      await _insertItem(
        db,
        orderId: orderId,
        productName: 'Bruschette',
        prepStation: 'Griglia',
      );

      final tickets = await repo.watchTicketsForStation('Griglia').first;

      expect(tickets, isEmpty);
    });
  });

  group('TicketsRepositoryImpl.advanceTicket', () {
    test('updates all items of the ticket locally', () async {
      final orderId = await _insertOrder(db);
      await _insertItem(
        db,
        orderId: orderId,
        productName: 'Bruschette',
        prepStation: 'Griglia',
      );
      await _insertItem(
        db,
        orderId: orderId,
        productName: 'Salsicce',
        prepStation: 'Griglia',
      );

      final result = await repo.advanceTicket(
        orderId: orderId,
        station: 'Griglia',
        newStatus: TicketStatus.inProgress,
      );

      expect(result.isSuccess, isTrue);
      final items = await db.select(db.orderItemsTable).get();
      expect(
        items.map((i) => i.ticketStatus),
        everyElement(TicketStatus.inProgress.index),
      );
    });

    test(
      'never enqueues a sync entry for an order with no syncId (legacy/unpaired)',
      () async {
        final orderId = await _insertOrder(db); // no syncId
        await _insertItem(
          db,
          orderId: orderId,
          productName: 'Bruschette',
          prepStation: 'Griglia',
        );

        await repo.advanceTicket(
          orderId: orderId,
          station: 'Griglia',
          newStatus: TicketStatus.inProgress,
        );

        verifyNever(
          syncManager.enqueue(
            entityType: anyNamed('entityType'),
            operation: anyNamed('operation'),
            entityLocalId: anyNamed('entityLocalId'),
            payload: anyNamed('payload'),
            remoteId: anyNamed('remoteId'),
          ),
        );
      },
    );

    test('enqueues a ticket_status sync entry for a paired order', () async {
      final orderId = await _insertOrder(db, syncId: 'order-sync-id');
      await _insertItem(
        db,
        orderId: orderId,
        productName: 'Bruschette',
        prepStation: 'Griglia',
      );

      await repo.advanceTicket(
        orderId: orderId,
        station: 'Griglia',
        newStatus: TicketStatus.ready,
      );

      final captured = verify(
        syncManager.enqueue(
          entityType: captureAnyNamed('entityType'),
          operation: anyNamed('operation'),
          entityLocalId: captureAnyNamed('entityLocalId'),
          payload: captureAnyNamed('payload'),
          remoteId: anyNamed('remoteId'),
        ),
      ).captured;
      expect(captured[0], 'ticket_status');
      expect(captured[1], 'order-sync-id:Griglia');
      final payload = captured[2] as Map<String, dynamic>;
      expect(payload['orderSyncId'], 'order-sync-id');
      expect(payload['station'], 'Griglia');
      expect(payload['status'], TicketStatus.ready.index);
    });
  });
}
