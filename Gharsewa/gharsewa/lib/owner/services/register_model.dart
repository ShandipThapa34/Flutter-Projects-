import 'dart:convert';
import 'package:gharsewa/user/models/user_register_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:9090/api/v1/auth';

  Future<RequestResponse> register(User user) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    // print('Request: ${jsonEncode(user.toJson())}');
    // print('Response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      return RequestResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to register user');
    }
  }
}
