# SubTracker — Subscription & Membership Tracker

A Flutter mobile application to help users manage, organize, and monitor all their recurring subscriptions in one place. Track spending, renewal dates, and billing cycles across streaming services, gym memberships, SaaS tools, utilities, and more.

---

## Screenshots

| | |
|---|---|
| <img width="250" src="https://github.com/user-attachments/assets/90669b48-fa7f-476e-8597-831e043f5ba8" /> | <img width="250" src="https://github.com/user-attachments/assets/8ba34b9f-bc9e-4913-9713-9e108dc8cf69" /> |


---

## Features

- **Full Subscription CRUD** — Create, view, edit, and delete subscriptions
- **Smart Renewal Tracking** — Color-coded urgency indicators for upcoming renewals (red ≤3 days, orange ≤7 days, green >7 days)
- **Multi-Currency Support** — USD, EGP, EUR, GBP, JPY
- **Flexible Billing Cycles** — Monthly, yearly, and weekly billing with automatic monthly cost normalization
- **Category Filtering** — Organize subscriptions by Streaming, Gym, SaaS, Utility, or Other
- **Dashboard Overview** — Monthly spend total, active subscription count, and "Renewing Soon" highlights
- **Offline-First Architecture** — SQLite local caching with Firebase sync when online
- **Firebase Authentication** — Email/password sign-in and registration with persistent session
- **Dark Theme** — Cohesive dark UI with indigo accents

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.11.1+ |
| Language | Dart |
| State Management | Provider (ChangeNotifier) |
| Navigation | GoRouter 13 |
| Remote Backend | Firebase Auth + Firebase Realtime Database |
| Local Storage | SQLite via sqflite |
| ID Generation | uuid |
| Date Formatting | intl |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Dark theme color palette
│   │   └── app_text_styles.dart     # Typography definitions
│   ├── router/
│   │   └── app_router.dart          # GoRouter config with auth redirect
│   └── utils/
│       └── date_utils.dart          # Date formatting & billing cycle helpers
│
├── data/
│   ├── local/
│   │   ├── database_helper.dart     # SQLite schema & initialization
│   │   └── subscription_dao.dart    # Local CRUD operations
│   ├── remote/
│   │   └── firebase_service.dart    # Firebase Realtime DB operations
│   └── repositories/
│       └── subscription_repository.dart  # Hybrid local/remote data layer
│
├── models/
│   └── subscription_model.dart      # Subscription entity & serialization
│
├── providers/
│   ├── auth_provider.dart           # Firebase auth state
│   └── subscription_provider.dart  # Subscription list & filtering state
│
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── subscriptions/
│   │   ├── subscription_list_screen.dart
│   │   ├── subscription_detail_screen.dart
│   │   └── add_edit_subscription_screen.dart
│   └── settings/
│       └── settings_screen.dart
│
├── widgets/
│   ├── main_scaffold.dart           # Bottom nav shell with 3 tabs
│   ├── subscription_card.dart       # Reusable list item widget
│   └── total_spend_card.dart        # Monthly spend overview widget
│
├── firebase_options.dart            # Firebase platform config
└── main.dart                        # App entry point & theme setup
```

---

## Navigation

```
/login                               ← Auth guard redirects here if unauthenticated
/register

ShellRoute (Bottom navigation — 3 tabs)
├── /dashboard
├── /subscriptions
│   ├── /subscriptions/add
│   └── /subscriptions/:id
│       └── /subscriptions/:id/edit
└── /settings
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.11.1 or higher
- Dart SDK (bundled with Flutter)
- A Firebase project (Realtime Database + Authentication enabled)
- Android Studio / VS Code with Flutter extension

### 1. Clone the repository

```bash
git clone https://github.com/Joevegas47/flutter_application_1.git
cd flutter_application_1
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable **Email/Password** authentication under Authentication → Sign-in method
3. Enable **Realtime Database** and set the security rules below
4. Run the FlutterFire CLI to generate `firebase_options.dart`:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Or manually place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the appropriate platform directories.

### 4. Run the app

```bash
flutter run
```

---

## Firebase Realtime Database Rules

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

---

## Data Model

```dart
class Subscription {
  String id;           // UUID
  String name;         // e.g., "Netflix"
  String category;     // streaming | gym | saas | utility | other
  double price;
  String currency;     // USD | EGP | EUR | GBP | JPY
  String billingCycle; // monthly | yearly | weekly
  DateTime startDate;
  DateTime nextBillingDate;
  String? notes;
  bool isActive;
}
```

Data is stored under `users/{uid}/subscriptions/{id}` in Firebase and mirrored in a local SQLite database for offline access.

---

## Architecture Overview

```
UI (Screens & Widgets)
       │
       ▼
  Providers (Provider / ChangeNotifier)
       │
       ▼
  Repository (Hybrid: tries Firebase → falls back to SQLite)
       │
  ┌────┴────┐
  ▼         ▼
Firebase   SQLite
(remote)  (local cache)
```

- **AuthProvider** listens to `FirebaseAuth.authStateChanges()` and manages sign-in, registration, and sign-out.
- **SubscriptionProvider** reacts to auth changes via `ChangeNotifierProxyProvider`, automatically loading or clearing subscriptions on login/logout.
- **SubscriptionRepository** abstracts the data source — online operations target Firebase Realtime Database; failures fall back to the local SQLite cache.

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## License

[MIT](LICENSE)
