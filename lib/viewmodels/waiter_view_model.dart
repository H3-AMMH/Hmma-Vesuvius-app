import '../models/_reservation.dart';
import '../services/api_service.dart';

class WaiterViewModel {
  Future<List<Reservation>> fetchReservations() async {
    final data = await ApiService.fetchReservations();
    return data.map<Reservation>((json) => Reservation.fromJson(json)).toList();
  }
}
