/// POST customers/sign-up İstek Modeli
///
/// Sunucuya gönderilecek gövde (JSON):
/// ```json
/// {
///   "phoneVerificationId": "e2c3e0c8-...",
///   "name": "Ahmet",
///   "surname": "Yılmaz",
///   "email": "ahmet@ornek.com",
///   "notificationToken": "",
///   "kvkkAgreement": true,
///   "generalCa": true,
///   "smsCa": true,
///   "emailCa": true,
///   "phoneCa": true
/// }
/// ```
class SignUpRequestModel {
  final String? phoneVerificationId;
  final String? name;
  final String? surname;
  final String? email;
  final String? notificationToken;
  final bool? kvkkAgreement;
  final bool? generalCa;
  final bool? smsCa;
  final bool? emailCa;
  final bool? phoneCa;

  const SignUpRequestModel({
    this.phoneVerificationId,
    this.name,
    this.surname,
    this.email,
    this.notificationToken = '',
    this.kvkkAgreement = true,
    this.generalCa = true,
    this.smsCa = false,
    this.emailCa = false,
    this.phoneCa = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneVerificationId': phoneVerificationId ?? '',
      'name': name ?? '',
      'surname': surname ?? '',
      'email': email ?? '',
      'notificationToken': notificationToken ?? '',
      'kvkkAgreement': kvkkAgreement ?? false,
      'generalCa': generalCa ?? false,
      'smsCa': smsCa ?? false,
      'emailCa': emailCa ?? false,
      'phoneCa': phoneCa ?? false,
    };
  }

  @override
  String toString() {
    return 'SignUpRequestModel(name: $name, surname: $surname, email: $email, phoneVerificationId: $phoneVerificationId)';
  }
}
