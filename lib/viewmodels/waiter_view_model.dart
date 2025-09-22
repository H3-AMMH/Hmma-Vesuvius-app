import '../models/_reservation.dart';
import '../models/create_reservation.dart';
import '../services/api_service.dart';
import '../models/menu_item.dart';

class WaiterViewModel {
  Future<List<Reservation>> fetchReservations({bool future = false}) async {
    final data = await ApiService.fetchReservations(future: future);
    return data.map<Reservation>((json) => Reservation.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> createReservation(CreateReservation reservation) async {
    return await ApiService.createReservation(reservation.toJson());
  }

  Future<List<MenuItem>> fetchMenu() async {
    final data = await ApiService.fetchMenu();
    return data.map<MenuItem>((json) => MenuItem.fromJson(json)).toList();
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    return (await ApiService.fetchCategories()).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> createOrder(int reservationId) async {
    return await ApiService.createOrder(reservationId);
  }

  Future<Map<String, dynamic>> createOrderLine({
    required int orderId,
    required int menuItemId,
    required int quantity,
    required double unitPrice,
  }) async {
    return await ApiService.createOrderLine(
      orderId: orderId,
      menuItemId: menuItemId,
      quantity: quantity,
      unitPrice: unitPrice,
    );
  }
}
