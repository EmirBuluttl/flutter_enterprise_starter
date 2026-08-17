/// Response model for POST OTP verification
class VerifyOtpResponseModel {
  final String status;
  final String? message;
  final String? token;
  final Map<String, dynamic>? data;

  VerifyOtpResponseModel({
    required this.status,
    this.message,
    this.token,
    this.data,
  });

  bool get isSuccess =>
      status.toLowerCase() == 'success' || status.toLowerCase() == 'ok';

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      status: json['status'] as String? ?? (json['success'] == true ? 'Success' : ''),
      message: json['message'] as String?,
      token: json['token'] as String? ?? json['accessToken'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (message != null) 'message': message,
      if (token != null) 'token': token,
      if (data != null) 'data': data,
    };
  }

  @override
  String toString() => 'VerifyOtpResponseModel(status: $status, message: $message)';
}
