import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/init/cache/locale_storage_service.dart';
import '../../home/view/home_view.dart';

/// Profil Kayıt Ekranı
///
/// ## Ne Zaman Gösterilir?
/// OTP doğrulaması başarılı olup `isAlreadyUser == false` döndüğünde
/// kullanıcı bu sayfaya yönlendirilir.
///
/// ## Ne Yapar?
/// Kullanıcıdan temel profil bilgilerini alır (Ad, Soyad).
/// Bilgiler kaydedildikten sonra telefon numarası için `isUserRegistered = true`
/// işaretlenir ve [HomeView]'a geçiş yapılır.
class ProfileView extends StatefulWidget {
  final String? phoneNumber;

  const ProfileView({super.key, this.phoneNumber});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Profil kayıt API'si geldiğinde buraya eklenecek
    // Simülasyon gecikmesi
    await Future.delayed(const Duration(milliseconds: 600));

    // Telefon numarasını kayıtlı olarak işaretle ve sayacı 1 yap
    final phone = widget.phoneNumber ??
        LocaleStorageService.instance.lastPhoneNumber ??
        '';

    if (phone.isNotEmpty) {
      await LocaleStorageService.instance.setUserRegistered(phone, true);
      await LocaleStorageService.instance.incrementLoginCount(phone);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
      (route) => false,
    );
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
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),

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
                const SizedBox(height: 40),

                // Ad alanı
                _ProfileTextField(
                  controller: _nameController,
                  label: 'Adınız',
                  hint: 'Adınızı girin',
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ad alanı boş bırakılamaz.';
                    }
                    if (value.trim().length < 2) {
                      return 'Ad en az 2 karakter olmalıdır.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Soyad alanı
                _ProfileTextField(
                  controller: _surnameController,
                  label: 'Soyadınız',
                  hint: 'Soyadınızı girin',
                  icon: Icons.person_outline_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Soyad alanı boş bırakılamaz.';
                    }
                    if (value.trim().length < 2) {
                      return 'Soyad en az 2 karakter olmalıdır.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Kaydet Butonu
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0099E6),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color(0xFF0099E6).withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Kaydet ve Devam Et',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Profil formu için tekrar kullanılabilir metin alanı widget'ı
class _ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;

  const _ProfileTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
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
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFADB5BD)),
            prefixIcon: Icon(icon, color: const Color(0xFF9CA3AF), size: 20),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
