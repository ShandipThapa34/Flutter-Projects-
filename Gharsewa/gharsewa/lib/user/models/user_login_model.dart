class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

class RequestResponse {
  final String message;
  final int statusCode; // Updated to statusCode

  RequestResponse({required this.message, required this.statusCode});

  factory RequestResponse.fromJson(Map<String, dynamic> json) {
    return RequestResponse(
      message: json['message'] ?? 'No message provided',
      statusCode:
          json['statusCode'] ?? 500, // Assuming default status code is 500
    );
  }
}
