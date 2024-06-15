import 'dart:convert';
import 'package:gharsewa/user/models/user_login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://localhost:9090/api/v1/auth';

  Future<RequestResponse> login(LoginRequest loginRequest) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', responseData['accessToken']);
      await prefs.setString('refreshToken', responseData['refreshToken']);
      return RequestResponse.fromJson(responseData);
    } else {
      return RequestResponse(
        message: jsonDecode(response.body)['message'] ?? 'Failed to login',
        statusCode: response.statusCode,
      );
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
