/// POST customers/sign-up Yanıt Modeli
///
/// Başarılı Yanıt Örneği:
/// ```json
/// {
///   "status": "Success",
///   "data": { ... }
/// }
/// ```
class SignUpResponseModel {
  final String status;
  final String? message;
  final Map<String, dynamic>? data;

  const SignUpResponseModel({
    required this.status,
    this.message,
    this.data,
  });

  bool get isSuccess {
    final lower = status.toLowerCase();
    return lower == 'success' || lower == 'ok';
  }

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    String parsedStatus = json['status'] as String? ?? '';
    if (parsedStatus.isEmpty && json['success'] == true) {
      parsedStatus = 'Success';
    }

    String? parsedMessage = json['message'] as String?;
    if (parsedMessage == null && json['error'] is Map<String, dynamic>) {
      parsedMessage = json['error']['message'] as String?;
    } else if (parsedMessage == null && json['error'] is String) {
      parsedMessage = json['error'] as String?;
    }

    return SignUpResponseModel(
      status: parsedStatus,
      message: parsedMessage,
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : null,
    );
  }

  @override
  String toString() => 'SignUpResponseModel(status: $status, message: $message)';
}
