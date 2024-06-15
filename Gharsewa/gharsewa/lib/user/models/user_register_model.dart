class User {
  final String userName;
  final String email;
  final String phoneNumber;
  final String password;
  final String role;

  User({
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'role': role,
      };
}

class RequestResponse {
  final String message;
  final int statusCode; // Updated to statusCode

  RequestResponse({required this.message, required this.statusCode});

  factory RequestResponse.fromJson(Map<String, dynamic> json) {
    return RequestResponse(
      message: json['message'] ?? 'No message provided',
      statusCode: json['statusCode'] ?? 500,
    );
  }
}
