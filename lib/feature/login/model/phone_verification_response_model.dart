/// Model matching the GET /api/v1/customers/verifications/phone response
class PhoneVerificationResponseModel {
  final String status;
  final PhoneVerificationData? data;

  PhoneVerificationResponseModel({
    required this.status,
    this.data,
  });

  bool get isSuccess => status.toLowerCase() == 'success';

  factory PhoneVerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationResponseModel(
      status: json['status'] as String? ?? '',
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? PhoneVerificationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      if (data != null) 'data': data!.toJson(),
    };
  }

  @override
  String toString() => 'PhoneVerificationResponseModel(status: $status, data: $data)';
}

class PhoneVerificationData {
  final PhoneVerificationDetail? phoneVerification;

  PhoneVerificationData({this.phoneVerification});

  factory PhoneVerificationData.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationData(
      phoneVerification: json['phoneVerification'] != null &&
              json['phoneVerification'] is Map<String, dynamic>
          ? PhoneVerificationDetail.fromJson(
              json['phoneVerification'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (phoneVerification != null)
        'phoneVerification': phoneVerification!.toJson(),
    };
  }

  @override
  String toString() => 'PhoneVerificationData(phoneVerification: $phoneVerification)';
}

class PhoneVerificationDetail {
  final String id;
  final String phone;
  final String? verifiedAt;

  PhoneVerificationDetail({
    required this.id,
    required this.phone,
    this.verifiedAt,
  });

  factory PhoneVerificationDetail.fromJson(Map<String, dynamic> json) {
    return PhoneVerificationDetail(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      verifiedAt: json['verifiedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      if (verifiedAt != null) 'verifiedAt': verifiedAt,
    };
  }

  @override
  String toString() =>
      'PhoneVerificationDetail(id: $id, phone: $phone, verifiedAt: $verifiedAt)';
}
