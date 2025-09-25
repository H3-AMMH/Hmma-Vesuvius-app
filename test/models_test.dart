import 'package:flutter_test/flutter_test.dart';
import 'package:cafe/models/menu_item.dart';
import 'package:cafe/models/_reservation.dart';
import 'package:cafe/services/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: "assets/.env");
  });

  group('MenuItem', () {
    test('fromJson creates correct MenuItem', () {
      final json = {
        'id': 1,
        'name': 'Pizza',
        'category_id': 1,
        'description_danish': 'Lækker pizza',
        'description_english': 'Delicious pizza',
        'price': 120.0,
        'is_available': true,
      };
      final item = MenuItem.fromJson(json);
      expect(item.id, 1);
      expect(item.name, 'Pizza');
      expect(item.categoryId, 1);
      expect(item.descriptionDanish, 'Lækker pizza');
      expect(item.descriptionEnglish, 'Delicious pizza');
      expect(item.price, 120.0);
      expect(item.isAvailable, true); 
    });
  });

  group('Reservation', () {
    test('fromJson creates correct Reservation', () {
      final json = {
        'id': 1,
        'name': 'Alice',
        'tel': '12345678',
        'date': '2024-06-01',
        'time': '18:00',
        'party_size': 4,
        'tables_needed': 1,
        'status': 'confirmed',
      };
      final res = Reservation.fromJson(json);
      expect(res.id, 1);
      expect(res.name, 'Alice');
      expect(res.tel, '12345678');
      expect(res.date, '2024-06-01');
      expect(res.time, '18:00');
      expect(res.partySize, 4);
      expect(res.tablesNeeded, 1);
      expect(res.status, 'confirmed');
    });
  });

  group('Order', () {
    test('createOrder and createOrderLine works', () async {
      const testReservationId = 1;
      const testMenuItemId = 1;

      // Create order
      final orderResult = await ApiService.createOrder(testReservationId);
      expect(orderResult['id'], isNotNull);
      final orderId = orderResult['id'];

      // Create order line
      final orderLineResult = await ApiService.createOrderLine(
        orderId: orderId,
        menuItemId: testMenuItemId,
        quantity: 2,
        unitPrice: 99.0,
      );
      expect(orderLineResult['id'], isNotNull);
      expect(orderLineResult['order_id'], orderId);
      expect(orderLineResult['menu_item_id'], testMenuItemId);
      expect(orderLineResult['quantity'], 2);
      expect(orderLineResult['unit_price'], 99.0);
    }, skip: 'Integration test - requires local API server');
  });
}