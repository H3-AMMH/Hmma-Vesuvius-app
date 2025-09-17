import '../models/_reservation.dart';
import '../models/create_reservation.dart';
import '../services/api_service.dart';

class WaiterViewModel {
  Future<List<Reservation>> fetchReservations({bool future = false}) async {
    final data = await ApiService.fetchReservations(future: future);
    return data.map<Reservation>((json) => Reservation.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> createReservation(CreateReservation reservation) async {
    return await ApiService.createReservation(reservation.toJson());
  }
}
