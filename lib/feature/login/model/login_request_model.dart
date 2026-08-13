/// Request model for phone-based login
class LoginRequestModel {
  final String rawPhoneNumber;

  LoginRequestModel({required this.rawPhoneNumber});

  /// Returns international standard format: +905XXXXXXXXX
  String get formattedPhoneNumber => '+90$rawPhoneNumber';

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': formattedPhoneNumber,
      'devicePlatform': 'Flutter',
      'requestTimestamp': DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() => 'LoginRequestModel(phoneNumber: $formattedPhoneNumber)';
}
