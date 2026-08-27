import 'otp_verification_data.dart';

/// POST OTP doğrulaması yanıt modeli.
///
/// Sunucudan gelen JSON:
/// ```json
/// {
///   "status": "Success",
///   "data": {
///     "isAlreadyUser": false,
///     "phoneVerification": { "id": "...", "phone": "...", "verifiedAt": "..." }
///   }
/// }
/// ```
/// Bearer Token ise Response Header'ından alınır:
/// `Authorization: Bearer eyJhbGci...`
class VerifyOtpResponseModel {
  final String status;
  final String? message;

  /// Header'dan alınan Bearer Token (OtpService tarafından doldurulur)
  final String? token;

  /// Tip-güvenli parse edilmiş `data` alanı
  final OtpVerificationData? otpData;

  VerifyOtpResponseModel({
    required this.status,
    this.message,
    this.token,
    this.otpData,
  });

  /// HTTP 200/201 ve status == 'Success' ise true
  bool get isSuccess {
    final lower = status.toLowerCase();
    return lower == 'success' || lower == 'ok';
  }

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    String parsedStatus = json['status'] as String? ?? '';
    if (parsedStatus.isEmpty && json['success'] == true) {
      parsedStatus = 'Success';
    }

    // `data` alanı varsa OtpVerificationData olarak parse et
    OtpVerificationData? parsedData;
    if (json['data'] is Map<String, dynamic>) {
      parsedData = OtpVerificationData.fromJson(
        json['data'] as Map<String, dynamic>,
      );
    }

    return VerifyOtpResponseModel(
      status: parsedStatus,
      message: json['message'] as String? ?? json['error'] as String?,
      otpData: parsedData,
    );
  }

  @override
  String toString() =>
      'VerifyOtpResponseModel(status: $status, isAlreadyUser: ${otpData?.isAlreadyUser})';
}
