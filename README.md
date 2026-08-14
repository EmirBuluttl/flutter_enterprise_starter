# Flutter Enterprise Starter 🚀

Kurumsal standartlarda inşa edilmiş, **Clean MVVM (Model-View-ViewModel)** ve **Katmanlı Mimari (Layered Architecture)** prensiplerini temel alan Flutter başlangıç projesi.

---

## 🏛️ Mimari Yapı (Architecture Overview)

Proje; sürdürülebilirlik, test edilebilirlik ve yüksek performans için 3 ana katmana ayrılmıştır:

```text
lib/
├── core/                                   # 🌐 Projeden bağımsız çekirdek altyapı
│   ├── base/
│   │   ├── view/base_view.dart             # MVVM Yaşam Döngüsü Yöneticisi (Stateful Base)
│   │   └── view_model/base_view_model.dart # Base ViewModel Sözleşmesi
│   ├── constants/app_constants.dart        # Merkezi metinler, maskeler, regex ve API sabitleri
│   └── init/
│       ├── network/
│       │   ├── core_interceptor.dart       # 📡 Generic Dio Interceptor (Log & Token)
│       │   └── network_manager.dart        # 📡 Singleton Dio İstemcisi
│       └── theme/
│           ├── app_colors.dart             # 🎨 Light & Dark renk token'ları
│           ├── app_text_styles.dart        # 🔤 Inter font ailesiyle merkezi tipografi
│           └── app_theme.dart              # 🌓 ThemeData konfigürasyonları
│
├── product/                                # 📦 Uygulamaya özel ortak bileşenler
│   ├── theme/theme_view_model.dart         # 🌓 MobX Dark/Light Tema Store'u
│   └── widgets/
│       ├── custom_phone_field.dart         # 📱 Stateless +90 maskeli telefon girdisi
│       └── custom_primary_button.dart      # 🔘 Stateless reaktif loading & disabled buton
│
├── feature/
│   └── login/                              # 📱 Login Modülü (MVVM)
│       ├── model/                          # Request & Response veri modelleri
│       ├── service/                        # ILoginService arayüzü & Dio Mock Servisi
│       ├── view_model/                     # MobX Store (@observable, @computed, @action)
│       └── view/login_view.dart            # Stateless bileşenler + Observer ile UI
└── main.dart                               # 🏁 Uygulama giriş noktası
```

---

## 🔑 Öne Çıkan Özellikler ve Kurumsal Standartlar

### 1. Reaktif State Yönetimi (MobX)
- **`@observable`**: Telefon numarası, yüklenme durumu ve hata mesajı reaktif olarak dinlenir.
- **`@computed`**: Telefon numarasının 10 haneli olması ve 5 ile başlaması (`+90 (5XX) XXX XX XX`) kuralına göre butonun aktifliği türetilir (`isButtonEnabled => isPhoneValid && !isLoading`).
- **`Observer`**: Sadece değişen buton ve uyarı alanı yeniden çizilir (re-render), ekranın tamamı gereksiz yükten kurtarılır.

### 2. Stateless Widget Yaklaşımı & BaseView
- Ekran parçaları (`_LoginHeader`, `_PhoneValidationInfo`, `CustomPhoneField`, `CustomPrimaryButton`) tamamen **`StatelessWidget`** olarak tasarlanmıştır.
- `BaseView<T>` yaşam döngüsünü (`initState`, `dispose`, `setContext`) arkada yönetir.

### 3. Network & Generic Interceptor (Dio)
- `NetworkManager` üzerinden tekil (singleton) `Dio` örneği yönetilir.
- `CoreInterceptor`, atılan tüm istekleri (`onRequest`), gelen yanıtları (`onResponse`) ve olası hataları (`onError`) kurumsal standartta formatlayarak loglar ve ortak header'ları ekler.

### 4. Ayrı Katmanda Tema & Tipografi (Light / Dark Mode)
- Renkler ve font stilleri kod içine gömülmez (hardcoded yazılmaz).
- `ThemeViewModel.instance.toggleTheme()` ile tek tıkla canlı olarak Açık/Koyu tema geçişi yapılır.

---

## 🧪 Test Kapsamı (Unit & Widget Tests)

Tüm iş mantığı ve arayüz bileşenleri test edilmiştir:

```bash
flutter test
```

- [x] Başlangıç durumu doğrulaması (buton pasif, girdi boş, yükleme kapalı)
- [x] Geçersiz telefon numarası senaryoları (10 haneden az, 5 ile başlamayan)
- [x] Geçerli telefon numarasında butonun aktifleşmesi
- [x] Servis çağrısının tetiklenmesi ve `loginResult` durumunun güncellenmesi
- [x] Arayüz bileşenlerinin render edilmesi ve Tema butonunun çalışması

---

## 🚀 Başlangıç ve Çalıştırma

### Bağımlılıkları Yükleme ve Kod Üretimi:
```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### Statik Kod Analizi:
```powershell
flutter analyze
```

### Uygulamayı Çalıştırma (Web / Chrome):
```powershell
flutter run -d chrome
```

---

## 👨‍💻 Geliştirici
- **Emir Bulut** - [@EmirBuluttl](https://github.com/EmirBuluttl)
