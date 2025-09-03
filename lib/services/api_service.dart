import 'dart:convert';
import 'dart:io';
import 'package:http/io_client.dart';

class ApiService {
  static final _baseUrl = "https://10.130.54.40:5000/api";

  static IOClient _client() {
    final ioc = HttpClient()
      ..badCertificateCallback = (cert, host, port) => true;
    return IOClient(ioc);
  }

  static Future<List<dynamic>> fetchReservations() async {
    final response = await _client().get(Uri.parse("$_baseUrl/reservations"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch reservations: ${response.statusCode}");
  }

  static Future<List<dynamic>> fetchMenu() async {
    final response = await _client().get(Uri.parse("$_baseUrl/menu"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch menu: ${response.statusCode}");
  }
}
