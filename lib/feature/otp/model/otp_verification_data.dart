/// POST OTP doğrulaması sonrası gelen `data` alanının modeli.
///
/// Response Body örneği:
/// ```json
/// {
///   "status": "Success",
///   "data": {
///     "isAlreadyUser": false,
///     "phoneVerification": {
///       "id": "e2c3e0c8-...",
///       "phone": "905535439265",
///       "verifiedAt": "2026-08-27T06:54:17.193Z"
///     }
///   }
/// }
/// ```
class OtpVerificationData {
  /// Kullanıcının sistemde daha önce kayıtlı olup olmadığı.
  /// true  → HomeView'a yönlendir
  /// false → Profil Kayıt Sayfasına yönlendir
  final bool isAlreadyUser;

  /// Doğrulanan telefon bilgisi
  final PhoneVerificationInfo phoneVerification;

  const OtpVerificationData({
    required this.isAlreadyUser,
    required this.phoneVerification,
  });

  factory OtpVerificationData.fromJson(Map<String, dynamic> json) {
    return OtpVerificationData(
      isAlreadyUser: json['isAlreadyUser'] as bool? ?? false,
      phoneVerification: PhoneVerificationInfo.fromJson(
        json['phoneVerification'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  String toString() =>
      'OtpVerificationData(isAlreadyUser: $isAlreadyUser, phone: ${phoneVerification.phone})';
}

/// Doğrulanan telefon bilgisi
class PhoneVerificationInfo {
  final String id;
  final String phone;
  final String? verifiedAt;

  const PhoneVerificationInfo({
    required this.id,
    required this.phone,
    this.verifiedAt,
  });

  factory PhoneVerificationInfo.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationInfo(
      id: json['id'] as String? ?? '',
      phone: json['phone']?.toString() ?? '',
      verifiedAt: json['verifiedAt'] as String?,
    );
  }
}
