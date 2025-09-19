import 'package:flutter_test/flutter_test.dart';
import 'package:cafe/models/menu_item.dart';
import 'package:cafe/models/_reservation.dart';
import 'package:cafe/models/order.dart';

void main() {
  group('MenuItem', () {
    test('fromJson creates correct MenuItem', () {
      final json = {'name': 'Pizza', 'price': 120};
      final item = MenuItem.fromJson(json);
      expect(item.name, 'Pizza');
      expect(item.price, 120);
    });
  });

  group('Reservation', () {
    test('fromJson creates correct Reservation', () {
      final json = {
        'name': 'Alice',
        'tel': '12345678',
        'time': '18:00',
        'party_size': 4,
        'tables_needed': 1,
        'status': 'confirmed',
      };
      final res = Reservation.fromJson(json);
      expect(res.name, 'Alice');
      expect(res.tel, '12345678');
      expect(res.time, '18:00');
      expect(res.partySize, 4);
      expect(res.tablesNeeded, 1);
      expect(res.status, 'confirmed');
    });
  });

  group('Order', () {
    test('fromJson creates correct Order', () {
      final json = {
        'id': 1,
        'reservation_id': 123,
        'status': 'open',
        'reservation_name': 'John Doe',
        'table_numbers': '1,2',
      };
      final order = Order.fromJson(json);
      expect(order.id, 1);
      expect(order.reservationId, 123);
      expect(order.status, 'open');
      expect(order.reservationName, 'John Doe');
      expect(order.tableNumbers, '1,2');
    });

    test('statusDisplay returns correct Danish translation', () {
      final orderOpen = Order(id: 1, reservationId: 123, status: 'open');
      final orderPrepared = Order(id: 1, reservationId: 123, status: 'being_prepared');
      final orderReady = Order(id: 1, reservationId: 123, status: 'ready_for_pickup');

      expect(orderOpen.statusDisplay, 'Åben');
      expect(orderPrepared.statusDisplay, 'Under forberedelse');
      expect(orderReady.statusDisplay, 'Klar til afhentning');
    });

    test('nextStatus returns correct progression', () {
      final orderOpen = Order(id: 1, reservationId: 123, status: 'open');
      final orderPrepared = Order(id: 1, reservationId: 123, status: 'being_prepared');
      final orderReady = Order(id: 1, reservationId: 123, status: 'ready_for_pickup');

      expect(orderOpen.nextStatus, 'being_prepared');
      expect(orderPrepared.nextStatus, 'ready_for_pickup');
      expect(orderReady.nextStatus, null);
    });

    test('nextStatusDisplay returns correct action text', () {
      final orderOpen = Order(id: 1, reservationId: 123, status: 'open');
      final orderPrepared = Order(id: 1, reservationId: 123, status: 'being_prepared');
      final orderReady = Order(id: 1, reservationId: 123, status: 'ready_for_pickup');

      expect(orderOpen.nextStatusDisplay, 'Start forberedelse');
      expect(orderPrepared.nextStatusDisplay, 'Marker som klar');
      expect(orderReady.nextStatusDisplay, null);
    });

    test('copyWith creates correct copy', () {
      final original = Order(id: 1, reservationId: 123, status: 'open');
      final copy = original.copyWith(status: 'being_prepared');
      
      expect(copy.id, 1);
      expect(copy.reservationId, 123);
      expect(copy.status, 'being_prepared');
    });
  });
}
