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

  bool get isSuccess {
    final lower = status.toLowerCase();
    return lower == 'success' ||
        lower == 'ok' ||
        lower == 'true' ||
        (status.isEmpty && data != null);
  }

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    String parsedStatus = json['status'] as String? ?? '';
    if (parsedStatus.isEmpty && json['success'] == true) {
      parsedStatus = 'Success';
    }

    return VerifyOtpResponseModel(
      status: parsedStatus,
      message: json['message'] as String? ?? json['error'] as String?,
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
