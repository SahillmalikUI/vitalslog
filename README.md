# 🏥 VitalsLog — Full Stack Health Tracker App

## 📱 App Screenshots

<img width="200" alt="Screen 1" src="https://github.com/user-attachments/assets/ea297114-f064-43e0-9c3e-9eb68069c90e" />
<img width="200" alt="Screen 2" src="https://github.com/user-attachments/assets/27fbaeef-fb69-4988-b611-2e7c012c76ae" />
<img width="200" alt="Screen 3" src="https://github.com/user-attachments/assets/519223af-1adf-47e6-bce7-09a8c0c6e459" />
<img width="200" alt="Screen 4" src="https://github.com/user-attachments/assets/ca7e3d74-b8f5-4cc6-b2f4-7d75720fb012" />
<img width="200" alt="Screen 5" src="https://github.com/user-attachments/assets/3c299b47-83b7-4fbe-9a9d-07ddb35f8ffe" />
<img width="200" alt="Screen 6" src="https://github.com/user-attachments/assets/f16bcc11-882d-46a9-964a-88063d8245b5" />

> A complete full stack health tracking mobile application built with Flutter and Node.js. Track your daily vitals, monitor health trends, and stay on top of your wellbeing.



## ✨ Features

- 🔐 **Real Authentication** — Register and login with JWT tokens and bcrypt password encryption
- 📊 **Vitals Dashboard** — Track heart rate, SpO2, blood pressure, and temperature
- 📝 **Log Vitals** — Save daily health readings with automatic status calculation
- 📈 **History Screen** — View all past records with Normal/Warning/Critical status
- 👤 **Profile Screen** — Real user data fetched from MongoDB
- 🚪 **Logout** — Secure session management
- 🔄 **Pull to Refresh** — Real-time data sync with backend
- 🌙 **Dark Theme** — Clean modern dark UI throughout

---

## 🛠️ Tech Stack

### Frontend (This Repository)
| Technology | Usage |
|-----------|-------|
| **Flutter** | Cross-platform mobile framework |
| **Dart** | Programming language |
| **HTTP Package** | API communication |
| **Shared Preferences** | Local token storage |

### Backend (Separate Repository)
| Technology | Usage |
|-----------|-------|
| **Node.js** | Server runtime |
| **Express.js** | Web framework |
| **MongoDB Atlas** | Cloud database |
| **Mongoose** | MongoDB ODM |
| **JWT** | Authentication tokens |
| **bcrypt** | Password encryption |

---

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── splash_screen.dart        # Animated splash screen
├── login_screen.dart         # Login with real API
├── register_screen.dart      # Register with validation
├── main_screen.dart          # Bottom navigation
├── home_screen.dart          # Dashboard with real vitals
├── log_vitals_screen.dart    # Log new vitals
├── history_screen.dart       # Vitals history from MongoDB
├── profile_screen.dart       # Real user profile
└── services/
    └── api_service.dart      # All API calls centralized
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Android Studio or VS Code
- Android Emulator or physical device
- Backend server running (see backend repo)

### Installation

**1. Clone the repository**
```bash
git clone https://github.com/SahillmalikUI/vitalslog.git
cd vitalslog
```

**2. Install dependencies**
```bash
flutter pub get
```

**3. Update API base URL**

Open `lib/services/api_service.dart` and update the base URL:
```dart
// For Android Emulator:
static const String baseUrl = 'http://10.0.2.2:5000/api';

// For Physical Device (use your computer's IP):
static const String baseUrl = 'http://192.168.1.x:5000/api';

// For Production (deployed backend):
static const String baseUrl = 'https://your-backend-url.com/api';
```

**4. Run the app**
```bash
flutter run
```

---

## 🔗 Backend Repository

The backend is in a separate repository:

👉 **[VitalsLog Backend — Node.js + Express + MongoDB](https://github.com/SahillmalikUI/vitalslog-backend)**

Make sure the backend is running before using the app!

---

## 📡 API Endpoints Used

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/register` | Create new account |
| POST | `/api/auth/login` | Login and get token |
| GET | `/api/auth/profile` | Get user profile |
| POST | `/api/vitals` | Save new vital reading |
| GET | `/api/vitals` | Get all vitals history |
| GET | `/api/vitals/latest` | Get most recent vital |
| DELETE | `/api/vitals/:id` | Delete a vital record |

---

## 🔐 Authentication Flow

```
User Registers → Server creates account → Returns JWT token
                                                  ↓
User Logs In → Server validates → Returns JWT token
                                          ↓
Token saved on device (SharedPreferences)
                                          ↓
Every API request → Token sent in Authorization header
                                          ↓
Server validates token → Returns user's data
```

---

## 🎨 Design

All screens were designed in **Figma** before implementation, following a consistent dark theme design system:

- **Background:** `#1A1A2E` (Dark Navy)
- **Primary:** `#6C63FF` (Purple)
- **Accent:** `#00D4FF` (Cyan)
- **Cards:** `#16213E` (Dark Blue)
- **Text:** `#FFFFFF` (White)

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.2.0
  shared_preferences: ^2.2.2
  fl_chart: ^0.68.0
  cupertino_icons: ^1.0.6
```

---

## 🔮 Future Improvements

- [ ] Add charts and graphs to History screen
- [ ] Edit Profile functionality
- [ ] Push notifications for health alerts
- [ ] Dark/Light theme toggle
- [ ] Export health data as PDF
- [ ] Apple Health and Google Fit integration
- [ ] Offline mode with local storage

---

## 👨‍💻 Developer

**Mohammed Sahil Ali**
- Flutter & Embedded UI Developer
- 16+ months professional experience
- Worked on commercially shipped medical device UI

📧 mohdsahilali6051@gmail.com
🐙 [github.com/SahillmalikUI](https://github.com/SahillmalikUI)
💼 [Fiverr Profile](https://fiverr.com/sahilaliui)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

⭐ **If you found this project helpful, please give it a star!**
