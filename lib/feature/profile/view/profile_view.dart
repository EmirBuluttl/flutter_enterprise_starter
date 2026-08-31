import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../core/constants/app_constants.dart';
import '../view_model/profile_view_model.dart';

/// Profil Kayıt Ekranı (Renault Port Sign-Up)
///
/// ## Ne Zaman Gösterilir?
/// OTP doğrulaması başarılı olup `isAlreadyUser == false` döndüğünde
/// kullanıcı bu sayfaya yönlendirilir.
///
/// ## Ne Yapar?
/// Kullanıcıdan Ad, Soyad, E-posta (opsiyonel) ve KVKK onaylarını alır.
/// `POST /api/v1/customers/sign-up` API'sine istek atarak kaydı tamamlar.
class ProfileView extends StatefulWidget {
  final String phoneNumber;
  final String phoneVerificationId;

  const ProfileView({
    super.key,
    required this.phoneNumber,
    required this.phoneVerificationId,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel(
      phoneNumber: widget.phoneNumber,
      phoneVerificationId: widget.phoneVerificationId,
    );
    _viewModel.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.setContext(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/images/renault_logo.png',
          height: 28,
          errorBuilder: (context, error, stackTrace) => Text(
            AppStrings.appTitle,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),

              // Başlık
              const Text(
                'Profilinizi Oluşturun',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hesabınızı kullanabilmek için\nlütfen bilgilerinizi girin.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Hata Mesajı Banner'ı
              Observer(
                builder: (_) {
                  if (_viewModel.errorMessage == null) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _viewModel.errorMessage!,
                            style: const TextStyle(
                              color: Color(0xFFDC2626),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Ad alanı (Zorunlu)
              _ProfileInputField(
                label: 'Adınız *',
                hint: 'Adınızı girin',
                icon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
                onChanged: _viewModel.setName,
              ),
              const SizedBox(height: 16),

              // Soyad alanı (Zorunlu)
              _ProfileInputField(
                label: 'Soyadınız *',
                hint: 'Soyadınızı girin',
                icon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
                onChanged: _viewModel.setSurname,
              ),
              const SizedBox(height: 16),

              // E-posta alanı (İsteğe Bağlı)
              _ProfileInputField(
                label: 'E-posta Adresi (İsteğe Bağlı)',
                hint: 'ornek@email.com',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onChanged: _viewModel.setEmail,
              ),
              const SizedBox(height: 24),

              const Divider(color: Color(0xFFE2E8F0)),
              const SizedBox(height: 16),

              // KVKK Onay Kutusu (Zorunlu)
              Observer(
                builder: (_) => _CheckboxTile(
                  value: _viewModel.isKvkkAccepted,
                  onChanged: (val) => _viewModel.setKvkkAccepted(val ?? false),
                  title: RichText(
                    text: const TextSpan(
                      text: 'KVKK Aydınlatma Metni',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0099E6),
                      ),
                      children: [
                        TextSpan(
                          text: '\'ni okudum ve kabul ediyorum. *',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // İletişim İzni Kutusu (Opsiyonel)
              Observer(
                builder: (_) => _CheckboxTile(
                  value: _viewModel.isCommunicationAccepted,
                  onChanged: (val) => _viewModel.setCommunicationAccepted(val ?? false),
                  title: const Text(
                    'Bana SMS, E-posta ve Telefon ile kampanya ve bilgilendirme iletileri gönderilmesini onaylıyorum.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF334155),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Kayıt Ol ve Devam Et Butonu
              Observer(
                builder: (_) => SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _viewModel.isButtonEnabled
                        ? _viewModel.submitSignUp
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0099E6),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF0099E6).withValues(alpha: 0.35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _viewModel.isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Kayıt Ol ve Devam Et',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Profil Formu Giriş Alanı Widget'ı
class _ProfileInputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String> onChanged;

  const _ProfileInputField({
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.textInputAction,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            prefixIcon: Icon(icon, color: const Color(0xFF94A3B8), size: 20),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0099E6), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

/// Onay Kutusu (Checkbox) Widget'ı
class _CheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Widget title;

  const _CheckboxTile({
    required this.value,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFF0099E6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(color: Color(0xFF94A3B8), width: 1.5),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(child: title),
          ],
        ),
      ),
    );
  }
}
