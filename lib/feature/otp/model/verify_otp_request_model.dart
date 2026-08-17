/// Request body model matching POST /api/v1/customers/verifications/phone
class VerifyOtpRequestModel {
  final String phoneVerificationId;
  final String code;
  final String notificationToken;

  VerifyOtpRequestModel({
    required this.phoneVerificationId,
    required this.code,
    this.notificationToken = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneVerificationId': phoneVerificationId,
      'code': code,
      'notificationToken': notificationToken,
    };
  }

  @override
  String toString() =>
      'VerifyOtpRequestModel(phoneVerificationId: $phoneVerificationId, code: $code)';
}
