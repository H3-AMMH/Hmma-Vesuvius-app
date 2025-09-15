import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class ApiService {
  static String get _baseUrl => dotenv.env['API_BASE_URL'] ?? "";

  static IOClient _client() {
    final ioc = HttpClient();
    ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return IOClient(ioc);
  }

  static Future<List<dynamic>> fetchMenu() async {
    final response = await _client().get(Uri.parse("$_baseUrl/menu"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch menu: ${response.statusCode}");
  }

  static Future<List<dynamic>> fetchReservations() async {
    final response = await _client().get(Uri.parse("$_baseUrl/reservations"));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception("Failed to fetch reservations: ${response.statusCode}");
  }


  static Future<Map<String, dynamic>> createReservation(Map<String, dynamic> reservation) async {
    final response = await _client().post(
      Uri.parse("$_baseUrl/reservations"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(reservation),
    );
    if (response.statusCode == 201) {
      return json.decode(response.body);
    }
    return json.decode(response.body);
  }
}
