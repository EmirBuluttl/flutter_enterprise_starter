/// Request body model matching POST /api/v1/customers/verifications/phone
class VerifyOtpRequestModel {
  final String phoneVerificationId;
  final String code;
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
      'id': phoneVerificationId,
      if (phone != null && phone!.isNotEmpty) 'phone': phone!.startsWith('90') ? phone : '90$phone',
      'code': code,
      'notificationToken': notificationToken,
    };
  }

  @override
  String toString() =>
      'VerifyOtpRequestModel(phoneVerificationId: $phoneVerificationId, code: $code, phone: $phone)';
}
