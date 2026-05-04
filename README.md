# HisobKit — Personal Finance Tracker

> **100% offline · Encrypted · Privacy-first**
> Built with Flutter 3.x for Android & iOS

---

## Features

| Feature | Details |
|---|---|
| **Biometric Lock** | Face ID / Fingerprint + fallback 4–8 digit PIN |
| **Encrypted Database** | SQLCipher AES-256, key stored in iOS Keychain / Android EncryptedSharedPreferences |
| **Multi-Currency** | UZS, USD, EUR, RUB, GBP, KZT — manual exchange rates |
| **Accounts** | Cash, Card, Savings — unlimited accounts |
| **Transactions** | Income, Expense, Transfer — with category, note, recurring rule |
| **Budgets** | Monthly/yearly per-category budgets with progress bars & alerts |
| **Debts & Loans** | Track lent/borrowed money with partial payments |
| **Reports** | 12-month bar chart, expense donut chart, top categories |
| **Export** | PDF report + Excel spreadsheet, shared via system share sheet |
| **3 Languages** | O'zbek · Русский · English — switchable at runtime |
| **Themes** | Light / Dark / System (Material You) |
| **Data Backup** | JSON export/import for full local backup |

---

## Tech Stack

```
Flutter 3.x (null safety)
State management : flutter_riverpod 2.x
Database         : Drift (moor) + SQLCipher
Navigation       : GoRouter
Charts           : fl_chart
Biometrics       : local_auth
Secure storage   : flutter_secure_storage
PDF export       : pdf (dart)
Excel export     : excel (dart)
Localization     : flutter_localizations + ARB
```

---

## Architecture

Feature-first layout:

```
lib/
├── core/
│   ├── database/        # Drift DB, tables, DAOs
│   │   └── daos/        # accounts, transactions, categories, budgets, debts, currencies, settings
│   ├── security/        # EncryptionService, BiometricService, PinService
│   ├── theme/           # AppTheme (light + dark)
│   ├── navigation/      # GoRouter config + shell
│   ├── providers/       # AppSettingsNotifier, AuthNotifier
│   ├── l10n/            # Generated AppLocalizations
│   └── utils/           # CurrencyFormatter, DateFormatter, IconMap, Validators
├── features/
│   ├── auth/            # LockScreen, OnboardingScreen
│   ├── dashboard/       # DashboardScreen
│   ├── transactions/    # TransactionsScreen, AddTransactionScreen, AccountsScreen
│   ├── categories/      # CategoriesScreen
│   ├── budgets/         # BudgetsScreen
│   ├── reports/         # ReportsScreen (charts)
│   ├── debts/           # DebtsScreen, DebtDetailScreen
│   ├── settings/        # SettingsScreen
│   └── export/          # ExportScreen (PDF + Excel)
├── l10n/
│   ├── app_en.arb
│   ├── app_uz.arb
│   └── app_ru.arb
└── main.dart
```

---

## Setup & Run

### Prerequisites

- Flutter 3.22+ (`flutter --version`)
- Dart 3.0+
- For Android: Android Studio or `sdkmanager`, NDK installed
- For iOS: Xcode 15+, CocoaPods

### 1 — Install dependencies

```bash
flutter pub get
```

### 2 — Generate code (Drift + Riverpod)

```bash
dart run build_runner build --delete-conflicting-outputs
```

This generates:
- `lib/core/database/app_database.g.dart`
- `lib/core/database/daos/*.g.dart`

### 3 — Generate localizations

```bash
flutter gen-l10n
```

This produces `lib/core/l10n/app_localizations.dart` (and per-locale delegates).

### 4 — Run

```bash
# Android
flutter run -d android

# iOS
cd ios && pod install && cd ..
flutter run -d ios
```

---

## Database Encryption

The SQLCipher encryption key is **generated randomly on first launch** using `dart:math` secure random and stored in:

- **Android**: `EncryptedSharedPreferences` (via `flutter_secure_storage`)
- **iOS**: iOS Keychain with `kSecAttrAccessibleAfterFirstUnlock`

The key is **never hardcoded** and **never transmitted**. If the user clears all data, the old key is deleted and a new one is generated, making old database files unreadable.

---

## Localization

Add new strings in `lib/l10n/app_en.arb` (template), then mirror them in `app_uz.arb` and `app_ru.arb`. After editing ARB files, re-run:

```bash
flutter gen-l10n
```

Language changes at runtime without restart via the `appSettingsProvider`.

---

## Running Tests

```bash
flutter test
```

Tests use an **in-memory Drift database** (no encryption, no file I/O), so they work on any machine without Android/iOS setup.

---

## Minimum Requirements

| Platform | Minimum |
|---|---|
| Android | API 23 (Android 6.0 Marshmallow) |
| iOS | iOS 13.0 |

---

## Privacy

- **No internet permission** requested (only `android:required="false"` marker)
- **No analytics SDK** — zero third-party tracking
- **No crash reporting** — zero telemetry
- All data lives exclusively on the device

---

## Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS Archive (Xcode required)
flutter build ios --release
```

Sign the Android release with your keystore and the iOS release via Xcode's Signing & Capabilities.
