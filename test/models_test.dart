import 'package:flutter_test/flutter_test.dart';
import 'package:cafe/models/menu_item.dart';
import 'package:cafe/models/_reservation.dart';

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
}
