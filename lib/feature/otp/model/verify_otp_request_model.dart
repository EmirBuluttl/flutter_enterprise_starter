/// Request body model matching exact POST /api/v1/customers/verifications/phone schema
class VerifyOtpRequestModel {
  final String phoneVerificationId;
  final dynamic code;
  final String notificationToken;
  final String? phone;

  VerifyOtpRequestModel({
    required this.phoneVerificationId,
    required this.code,
    this.notificationToken = '',
    this.phone,
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
