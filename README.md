<div align="center">
  <img src="https://raw.githubusercontent.com/asrim10/elite_refurb_lap/main/assets/images/logo.png" alt="Elite Refurb Lap Logo" width="120" height="auto" />
  <h1>💻 Elite Refurb Lap</h1>
  <p align="center">
    <strong>A Flutter marketplace for buying and selling refurbished laptops.</strong>
    <br />
    Built with Clean Architecture, Riverpod state management, and a feature-first folder structure.
  </p>
  <p align="center">
    <a href="https://flutter.dev">
      <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter" />
    </a>
    <a href="https://dart.dev">
      <img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    </a>
    <a href="https://riverpod.dev">
      <img src="https://img.shields.io/badge/Riverpod-5E35B1?style=for-the-badge&logo=flutter&logoColor=white" alt="Riverpod" />
    </a>
    <a href="https://pub.dev/packages/dio">
      <img src="https://img.shields.io/badge/Dio-007EC6?style=for-the-badge&logo=dart&logoColor=white" alt="Dio" />
    </a>
    <a href="https://socket.io">
      <img src="https://img.shields.io/badge/Socket.IO-010101?style=for-the-badge&logo=socket.io&logoColor=white" alt="Socket.IO" />
    </a>
    <a href="https://pub.dev/packages/hive">
      <img src="https://img.shields.io/badge/Hive-FFC107?style=for-the-badge&logo=hive&logoColor=black" alt="Hive" />
    </a>
    <a href="https://maplibre.org">
      <img src="https://img.shields.io/badge/MapLibre-396CB2?style=for-the-badge&logo=maplibre&logoColor=white" alt="MapLibre" />
    </a>
    <a href="https://github.com/asrim10/elite_refurb_lap-backend">
      <img src="https://img.shields.io/badge/Backend%20Repo-2F4876?style=for-the-badge&logo=github&logoColor=white" alt="Backend Repo" />
    </a>
  </p>
  <p align="center">
    <img src="https://img.shields.io/github/last-commit/asrim10/elite_refurb_lap?style=flat-square&color=%232F4876" alt="Last Commit" />
    <img src="https://img.shields.io/github/repo-size/asrim10/elite_refurb_lap?style=flat-square&color=%232F4876" alt="Repo Size" />
    <img src="https://img.shields.io/badge/sdk-%5E3.9.2-2F4876?style=flat-square" alt="SDK" />
    <img src="https://img.shields.io/badge/license-private-2F4876?style=flat-square" alt="License" />
  </p>
</div>

---

## ✨ Features

### 🔐 Authentication
- Email/password registration & login
- JWT-based secure session management
- Forgot/reset password flow
- Google & Apple sign-in support

### 🏠 Home
- Curated laptop listings with image carousel
- Banner promotions and featured deals
- Smart search and category filtering
- Real-time wishlist toggle on cards

### 🔍 Search & Filters
- Full-text search across laptop listings
- Filter by condition, price range, storage type, location
- Category chips for quick browsing
- Featured & compact product card layouts

### 💬 Chat
- Real-time messaging via Socket.IO
- Chat rooms tied to laptop listings
- Notification badges for unread messages

### 📦 Laptop Listings
- Create, edit, and delete listings
- Upload multiple images with preview
- Mark listings as sold
- Seller profile with all listings
- Detailed specs, condition, price history

### ❤️ Wishlist
- Public & private wishlists
- Add/remove laptops with one tap
- Create/delete/clear wishlists
- Similar items recommendations

### ⭐ Ratings & Reviews
- Rate sellers with star ratings
- View seller rating history
- Public seller profiles

### 🔔 Notifications
- Real-time push notifications via WebSocket
- Mark individual or all notifications as read
- Unread count badge

### 👤 Profile
- Edit profile (photo, name, phone, bio)
- View your listings & sold items
- App settings & logout

---

## 🛠 Tech Stack

| Layer              | Technology                                  |
| ------------------ | ------------------------------------------- |
| **Framework**      | Flutter (Dart)                              |
| **State Mgmt**     | Riverpod (flutter_riverpod, hooks_riverpod) |
| **Architecture**   | Clean Architecture (feature-first modules)  |
| **Networking**     | Dio + Dio Smart Retry                       |
| **WebSockets**     | socket_io_client                            |
| **Local Storage**  | Hive, SharedPreferences                     |
| **Secure Storage** | flutter_secure_storage                      |
| **Auth Tokens**    | jwt_decoder                                 |
| **Maps**           | Baato Maps, Flutter Map, MapLibre GL       |
| **Images**         | image_picker, cached_network_image          |
| **Payments**       | WebView (for integrated payment gateway)    |
| **Code Gen**       | freezed, json_serializable, build_runner    |

---

## 🏗 Architecture

```
lib/
├── core/                    # Shared infrastructure
│   ├── api/                 # API client & endpoints
│   ├── error/               # Failure classes
│   ├── services/            # Token, storage, session services
│   ├── usecases/            # Base use case class
│   └── utils/               # Shared utilities (snackbar, etc.)
│
├── features/                # Feature modules
│   ├── auth/                # Authentication (login, signup, reset password)
│   ├── chat/                # Real-time messaging
│   ├── home/                # Home feed & carousel
│   ├── laptop/              # Laptop CRUD & listings
│   ├── notification/        # Push notifications
│   ├── profile/             # User profile & settings
│   ├── rating/              # Ratings & seller reviews
│   ├── search/              # Search & filters
│   ├── splash/              # Splash/onboarding screens
│   └── wishlist/            # Wishlists
│
└── app/
    ├── pages/               # App shell (bottom nav wrapper)
    ├── theme/               # Light/dark theme & color palette
    └── app.dart             # MaterialApp with routing
```

Each feature module follows **Clean Architecture**:

```
feature/
├── data/
│   ├── datasources/         # Remote/local data sources
│   ├── models/              # DTOs (JSON serializable)
│   └── repositories/        # Repository implementations
├── domain/
│   ├── entities/            # Business objects
│   ├── repositories/        # Abstract repository interfaces
│   └── usecases/            # Business logic use cases
└── presentation/
    ├── pages/               # Screens
    ├── providers/           # Riverpod providers
    ├── state/               # State classes
    ├── view_model/          # View models / notifiers
    └── widgets/             # Reusable UI components
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ^3.9.2
- Dart SDK ^3.9.2
- Node.js & npm
- MongoDB (local or Atlas)

---

### 📦 Backend Setup

The backend is a **Node.js + TypeScript + Express** API with MongoDB, Socket.IO, JWT auth, and more.

```bash
# 1. Clone the backend repo
git clone https://github.com/asrim10/elite_refurb_lap-backend.git
cd elite_refurb_lap-backend

# 2. Install dependencies
npm install

# 3. Create environment file
cp .env.example .env
```

Edit `.env` and configure the following variables:

| Variable        | Description                           | Required | Default                           |
| --------------- | ------------------------------------- | -------- | --------------------------------- |
| `PORT`          | API server port                       | ❌       | `3000`                            |
| `MONGODB_URI`   | MongoDB connection string             | ❌       | `mongodb://localhost:27017/defaultdb` |
| `JWT_SECRET`    | Secret key for signing JWT tokens     | ✅       | —                                 |
| `EMAIL_USER`    | Gmail address for sending emails      | ⚠️       | —                                 |
| `EMAIL_PASS`    | Gmail app password for authentication | ⚠️       | —                                 |

> ⚠️ `EMAIL_USER` and `EMAIL_PASS` are only needed for the forgot/reset password flow.
> For Gmail, generate an [App Password](https://support.google.com/accounts/answer/185833) (requires 2FA enabled).

```bash
# 4. Start the server in dev mode
npm run dev
```

The API will start at **`http://localhost:3000`**. To match the Flutter app's default config (`5050`), set `PORT=5050` in your `.env`.

---

### 📱 Flutter App Setup

```bash
# 1. Clone the repo
git clone https://github.com/asrim10/elite_refurb_lap.git
cd elite_refurb_lap

# 2. Install dependencies
flutter pub get

# 3. Configure API endpoint
# Edit lib/core/api/api_endpoints.dart
#   - Update compIpAddress to your server's IP
#   - Set isPhysicalDevice to true for physical device testing

# 4. Generate code (if models change)
dart run build_runner build --delete-conflicting-outputs

# 5. Run the app
flutter run
```

---

### 🔗 API Base URL Configuration

The app auto-detects the platform — update `compIpAddress` in `lib/core/api/api_endpoints.dart` if needed:

| Platform         | Default URL                     |
| ---------------- | ------------------------------- |
| Web              | `http://localhost:5050/api`     |
| Android Emulator | `http://10.0.2.2:5050/api`     |
| iOS Simulator    | `http://localhost:5050/api`     |
| Physical Device  | `http://<compIpAddress>:5050/api` |

---

## 📱 App Routes

| Route              | Screen                        |
| ------------------ | ----------------------------- |
| `/`                | SplashScreen                  |
| `/splash2`         | SplashScreen2 (onboarding)    |
| `/login`           | LoginScreen                   |
| `/signup`          | SignupScreen                  |
| `/forgot-password` | ForgotPasswordScreen          |
| `/reset-password`  | ResetPasswordScreen           |
| `/home`            | MainShell (bottom nav)        |
| `/my-listings`     | MyListingsScreen              |

**Bottom Navigation (MainShell):**
1. 🏠 Home
2. 🔍 Search
3. ➕ Post (pushes AddLaptopScreen)
4. 💬 Chat
5. 👤 Profile

---

## 📦 Key Dependencies

| Package                          | Purpose                          |
| -------------------------------- | -------------------------------- |
| flutter_riverpod / riverpod      | State management                 |
| dio / dio_smart_retry            | HTTP client with retry           |
| socket_io_client                 | Real-time chat                   |
| hive / hive_flutter              | Local persistence                |
| flutter_secure_storage           | Secure token storage             |
| jwt_decoder                      | JWT token parsing                |
| cached_network_image             | Efficient image caching          |
| image_picker                     | Camera/gallery media picker      |
| flutter_map / maplibre_gl        | Map & location picker            |
| baato_maps / baato_api           | Baato map integration            |
| share_plus                       | Share listings                   |
| google_sign_in / sign_in_with_apple | Social auth                  |
| webview_flutter                  | In-app payment gateway           |

---

## 🤝 Contributing

1. Create a feature branch from `main`: `git checkout -b feature/your-feature`
2. Make your changes following the existing code conventions
3. Ensure the app builds: `flutter analyze`
4. Open a pull request to `main`

---

## 📄 License

Private project — all rights reserved.
