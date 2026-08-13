/// Response model returned after login attempt
class LoginResponseModel {
  final bool success;
  final String message;
  final String? token;
  final String? userId;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.token,
    this.userId,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      token: json['token'] as String?,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (token != null) 'token': token,
      if (userId != null) 'userId': userId,
    };
  }

  @override
  String toString() =>
      'LoginResponseModel(success: $success, message: $message, token: $token)';
}
