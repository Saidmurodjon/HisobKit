<div align="center">

<img src="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" width="96" alt="HisobKit logo" />

# HisobKit

**Shaxsiy moliyaviy daftar — 100% offline, shifrlangan, maxfiy**

[![Release](https://img.shields.io/github/v/release/Saidmurodjon/HisobKit?style=flat-square&color=4CAF50&label=Oxirgi%20versiya)](https://github.com/Saidmurodjon/HisobKit/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/Saidmurodjon/HisobKit/total?style=flat-square&color=2196F3&label=Yuklab%20olishlar)](https://github.com/Saidmurodjon/HisobKit/releases)
[![License: MIT](https://img.shields.io/badge/Litsenziya-MIT-yellow.svg?style=flat-square)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=flat-square&logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/Platforma-Android%20%7C%20iOS-lightgrey?style=flat-square)](https://github.com/Saidmurodjon/HisobKit/releases)
[![Build](https://img.shields.io/github/actions/workflow/status/Saidmurodjon/HisobKit/build_release.yml?style=flat-square&label=Build)](https://github.com/Saidmurodjon/HisobKit/actions)

[📲 **Android APK yuklab olish**](#-yuklab-olish) · [✨ Xususiyatlar](#-xususiyatlar) · [🛠 Dasturchilar uchun](#%EF%B8%8F-dasturchilar-uchun)

</div>

---

## 📲 Yuklab olish

### Android (tavsiya etiladi)

| Versiya | Hajm | Talab |
|---------|------|-------|
| [⬇ Oxirgi APK](https://github.com/Saidmurodjon/HisobKit/releases/latest) | ~25 MB | Android 6.0+ |

**O'rnatish:**
1. Yuqoridagi havoladan `HisobKit-vX.X.X.apk` ni yuklab oling
2. Telefonda faylni oching
3. *"Noma'lum manbalardan o'rnatish"* ni ruxsat bering
4. O'rnating va ishga tushiring

> ✅ Eskisi o'rnatilgan bo'lsa, avval o'chirmasdan yangilang — barcha ma'lumotlar saqlanadi.

### iOS

Hozircha App Store da mavjud emas. Xcode orqali o'zingiz build qiling (pastdagi [Dasturchilar uchun](#%EF%B8%8F-dasturchilar-uchun) bo'limiga qarang).

---

## ✨ Xususiyatlar

| Xususiyat | Tafsilot |
|-----------|---------|
| 🔒 **Biometrik qulf** | Barmoq izi / Yuz identifikatori + zahira 4–8 raqamli PIN |
| 🗄 **Shifrlangan baza** | SQLCipher AES-256, kalit iOS Keychain / Android EncryptedSharedPreferences da |
| 💱 **Ko'p valyuta** | UZS, USD, EUR, RUB, GBP, KZT — qo'lda kurs kiritish |
| 🏦 **Hisoblar** | Naqd, Karta, Jamg'arma — cheksiz hisoblar |
| 📊 **Tranzaksiyalar** | Kirim, Chiqim, Transfer — kategoriya, izoh, takrorlanish |
| 🎯 **Byudjet** | Oylik/yillik kategoriya byudjetlari, progress va ogohlantirishlar |
| 🤝 **Qarzlar** | Berilgan/olingan qarzlar, qisman to'lovlar |
| 📈 **Hisobotlar** | 12 oylik grafik, xarajat doirasi, top kategoriyalar |
| 📤 **Eksport** | PDF hisobot + Excel jadval |
| 🌐 **3 til** | O'zbek · Русский · English — istalgan vaqt almashtirish |
| 🎨 **Mavzular** | Yorug' / Qorong'u / Tizim (Material You) |
| 💾 **Zaxira nusxa** | JSON eksport/import — to'liq lokal backup |

---

## 🔒 Xavfsizlik va Maxfiylik

- ✅ **Internetga ulanmaydi** — barcha ma'lumot faqat qurilmada
- ✅ **Hech qanday analitika yo'q** — zero tracking
- ✅ **Hech qanday crash reporting yo'q** — zero telemetry
- ✅ **AES-256 shifrlash** — SQLCipher orqali
- ✅ **Kalit hech qachon uzatilmaydi** — faqat qurilma xotirasida

---

## 🛠️ Dasturchilar uchun

### Talablar

- Flutter 3.22+ (`flutter --version`)
- Dart 3.0+
- Android: Android Studio, NDK
- iOS: Xcode 15+, CocoaPods

### O'rnatish

```bash
# 1. Reponi klonlash
git clone https://github.com/saidmurod1010/hisobkit.git
cd hisobkit

# 2. Bog'liqliklarni o'rnatish
flutter pub get

# 3. Kod generatsiya (Drift + Riverpod)
dart run build_runner build --delete-conflicting-outputs

# 4. Lokalizatsiya generatsiya
flutter gen-l10n

# 5. Ishga tushirish
flutter run
```

### Arxitektura

```
lib/
├── core/
│   ├── database/        # Drift DB, jadvallar, DAO lar
│   ├── security/        # EncryptionService, BiometricService, PinService
│   ├── theme/           # AppTheme (yorug' + qorong'u)
│   ├── navigation/      # GoRouter konfiguratsiya + shell
│   ├── providers/       # AppSettingsNotifier, AuthNotifier
│   ├── l10n/            # Generatsiya qilingan AppLocalizations
│   └── utils/           # CurrencyFormatter, DateFormatter, IconMap
├── features/
│   ├── auth/            # LockScreen, OnboardingScreen, Google Sign-In
│   ├── dashboard/       # DashboardScreen
│   ├── transactions/    # TransactionsScreen, AddTransactionScreen
│   ├── categories/      # CategoriesScreen
│   ├── budgets/         # BudgetsScreen
│   ├── reports/         # ReportsScreen (grafiklar)
│   ├── debts/           # DebtsScreen, DebtDetailScreen
│   ├── settings/        # SettingsScreen (Profil)
│   ├── house/           # HouseDashboardScreen (uy xarajatlari)
│   └── export/          # ExportScreen (PDF + Excel)
└── main.dart
```

### Release APK yig'ish

```bash
# Debug APK
flutter build apk --debug

# Release APK (imzolangan)
flutter build apk --release

# App Bundle (Play Store uchun)
flutter build appbundle --release
```

### GitHub Actions (CI/CD)

Har bir tag push da avtomatik:
- ✅ Release APK yig'iladi va imzolanadi
- ✅ GitHub Release yaratiladi
- ✅ APK yuklab olinadi

Kerakli GitHub Secrets:
| Secret | Tavsif |
|--------|--------|
| `KEYSTORE_BASE64` | Release keystore (base64) |
| `KEY_ALIAS` | Kalit taxallusi |
| `KEY_PASSWORD` | Kalit paroli |
| `STORE_PASSWORD` | Keystore paroli |

---

## 📋 Minimal Talablar

| Platforma | Talab |
|-----------|-------|
| Android | API 23+ (Android 6.0) |
| iOS | 13.0+ |

---

## 🤝 Hissa qo'shish

Pull request lar xush kelibdi! Katta o'zgartirishlar uchun avval [issue oching](https://github.com/Saidmurodjon/HisobKit/issues/new/choose).

1. Fork qiling
2. Feature branch yarating (`git checkout -b feature/yangi-xususiyat`)
3. O'zgartirishlarni commit qiling
4. Branch ga push qiling
5. Pull Request oching

---

## 📄 Litsenziya

[MIT](LICENSE) © 2024-2026 [Saidmurod Toshmatov](https://github.com/Saidmurodjon)

---

<div align="center">

**HisobKit** — O'zbekistonda yaratilgan 🇺🇿

*Agar yoqsa ⭐ bering — bu eng katta motivatsiya!*

</div>
