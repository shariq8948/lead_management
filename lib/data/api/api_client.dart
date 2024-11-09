import 'dart:convert';
import 'dart:io';
import '../models/login_response.model.dart';

class ApiClient {
  final String baseUrl = 'https://lead.mumbaicrm.com/api';

  Future<LoginResponse> loginRequest(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true; // Bypass SSL for testing

      final request = await client.postUrl(url);
      request.headers.set(HttpHeaders.contentTypeHeader, "application/json; charset=UTF-8");
      request.write(jsonEncode(body));

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        if (data is List && data.isNotEmpty) {
          final loginResponse = LoginResponse.fromJson(data[0]); // Parse the first item
          if (loginResponse.success == '1') {
            return loginResponse; // Return the parsed LoginResponse
          } else {
            return LoginResponse(message: loginResponse.message ?? "Login failed.");
          }
        } else {
          return LoginResponse(message: "Unexpected response format.");
        }
      } else {
        return LoginResponse(message: "Login failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      return LoginResponse(message: "Error: $e");
    }
  }
}
