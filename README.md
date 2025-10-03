# 🚀 AI Call Assistant - Never Miss a Delivery. Never Answer Spam.

> **India's First Visual Address-Based AI Call Assistant**  
> Smart spam blocking + Intelligent delivery call handling with photos & location

[![Flutter](https://img.shields.io/badge/Flutter-3.35.5-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![License](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)

---

## 🎯 **The Problem We Solve**

**For 200M+ Indians who order deliveries daily:**
- 📞 **Miss deliveries** because of spam call overload
- 🏠 **Explain directions** to delivery partners 5-10x per week
- 🚫 **Get spammed** by credit cards, loans, insurance calls
- ❓ **Unknown numbers** - Is it spam or important?

## 💡 **Our Solution**

An AI assistant that:
1. ✅ **Detects & blocks spam** automatically (loans, credit cards, marketing)
2. ✅ **Identifies unknown callers** (HDFC Bank, Amazon, Swiggy, etc.)
3. ✅ **Handles delivery calls** with your saved address + photos + directions
4. ✅ **Visual address setup** - Show AI your house photos, pinpoint location
5. ✅ **Smart in Hindi + English** - Understands Indian delivery conversations

---

## 🌟 **Key Features**

### 🏡 **Visual Address Setup**
- 📸 Upload photos of your house, road, landmarks
- 📍 Pinpoint exact location on map
- ✍️ Add manual delivery instructions
- 🎯 AI uses all this to guide delivery partners perfectly

### 🛡️ **Smart Spam Protection**
- 🚫 Auto-blocks known spam numbers
- 🤖 AI detects spam patterns in real-time
- 📊 Crowd-sourced spam database (Indian numbers)
- ⚡ Instant call rejection - no disturbance

### 🔍 **Caller Identification**
- 🏦 Identifies businesses (HDFC, ICICI, Amazon, Flipkart)
- 🍔 Recognizes delivery services (Swiggy, Zomato, Zepto, Blinkit)
- 👤 Shows contact info before you answer
- ⚠️ Spam score for unknown numbers

### 🎙️ **AI Delivery Assistant**
- 📦 Answers delivery calls automatically
- 🗺️ Gives turn-by-turn directions from your photos
- 🏢 Explains building entry, floor, parking
- 🇮🇳 Speaks Hindi + English naturally

---

## 🎬 **How It Works**

```
1️⃣ Unknown Call Comes In
   ↓
2️⃣ AI Identifies: Spam / Delivery / Important
   ↓
3️⃣ If SPAM → Block automatically
   ↓
4️⃣ If DELIVERY → AI answers with your address
   ↓
5️⃣ If IMPORTANT → Rings your phone normally
```

---

## 📱 **Screenshots** (Coming Soon)

| Home Dashboard | Address Setup | Live Call | Spam Protection |
|---------------|---------------|-----------|-----------------|
| Coming Soon   | Coming Soon   | Coming Soon | Coming Soon |

---

## 🛠️ **Technical Stack**

### **Frontend**
- 🎨 Flutter 3.35.5 (Cross-platform)
- 🎯 Dart 3.9.2
- 📏 Responsive design (Sizer)
- 🎨 Material Design 3

### **Backend**
- ⚡ Supabase (Auth, Database, Storage)
- 🧠 OpenAI GPT-4 (AI conversations)
- 🗺️ Google Maps API (Location)
- ☁️ Cloud storage for photos

### **AI & ML**
- 🤖 GPT-4o-mini for delivery calls (cost-effective)
- 🔊 Whisper for speech-to-text
- 📊 Custom spam detection algorithm
- 🧠 Pattern recognition for caller ID

---

## ✅ **Current Setup Status**

- ✅ Flutter SDK installed: `C:\Users\conta\flutter`
- ✅ Dependencies installed
- ✅ VSCode configured
- ✅ Launch configurations ready
- ✅ Supabase backend configured
- ⚠️ **NEXT STEP: Install Android Studio** (see START_HERE.md)

---

## 🚀 **Quick Start**

### **For Development:**

1. **Prerequisites:**
   ```bash
   - Flutter SDK 3.35.5+
   - Android Studio (for Android development)
   - Xcode (for iOS development)
   - Supabase account
   - OpenAI API key
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment:**
   - Copy `env.json.example` to `env.json`
   - Add your API keys:
     ```json
     {
       "SUPABASE_URL": "your-supabase-url",
       "SUPABASE_ANON_KEY": "your-anon-key",
       "OPENAI_API_KEY": "your-openai-key"
     }
     ```

4. **Run the App:**
   ```bash
   flutter run --dart-define-from-file=env.json
   ```

### **Testing on Your Phone:**
See [START_HERE.md](START_HERE.md) for detailed phone testing instructions.

---

## 📋 **Prerequisites**

### **Required:**
- ✅ Flutter SDK (3.35.5+)
- ✅ Dart SDK (3.9.2+)
- ✅ Android Studio (for Android)
- ✅ Git

### **For iOS Development:**
- ❌ Xcode (Mac only - use CI/CD on Windows)

## 🛠️ Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the application:

To run the app with environment variables defined in an env.json file, follow the steps mentioned below:
1. Through CLI
    ```bash
    flutter run --dart-define-from-file=env.json
    ```
2. For VSCode
    - Open .vscode/launch.json (create it if it doesn't exist).
    - Add or modify your launch configuration to include --dart-define-from-file:
    ```json
    {
        "version": "0.2.0",
        "configurations": [
            {
                "name": "Launch",
                "request": "launch",
                "type": "dart",
                "program": "lib/main.dart",
                "args": [
                    "--dart-define-from-file",
                    "env.json"
                ]
            }
        ]
    }
    ```
3. For IntelliJ / Android Studio
    - Go to Run > Edit Configurations.
    - Select your Flutter configuration or create a new one.
    - Add the following to the "Additional arguments" field:
    ```bash
    --dart-define-from-file=env.json
    ```

## 📁 Project Structure

```
flutter_app/
├── android/            # Android-specific configuration
├── ios/                # iOS-specific configuration
├── lib/
│   ├── core/           # Core utilities and services
│   │   └── utils/      # Utility classes
│   ├── presentation/   # UI screens and widgets
│   │   └── splash_screen/ # Splash screen implementation
│   ├── routes/         # Application routing
│   ├── theme/          # Theme configuration
│   ├── widgets/        # Reusable UI components
│   └── main.dart       # Application entry point
├── assets/             # Static assets (images, fonts, etc.)
├── pubspec.yaml        # Project dependencies and configuration
└── README.md           # Project documentation
```

## 🧩 Adding Routes

To add new routes to the application, update the `lib/routes/app_routes.dart` file:

```dart
import 'package:flutter/material.dart';
import 'package:package_name/presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // Add more routes as needed
  }
}
```

## 🎨 Theming

This project includes a comprehensive theming system with both light and dark themes:

```dart
// Access the current theme
ThemeData theme = Theme.of(context);

// Use theme colors
Color primaryColor = theme.colorScheme.primary;
```

The theme configuration includes:
- Color schemes for light and dark modes
- Typography styles
- Button themes
- Input decoration themes
- Card and dialog themes

## 📱 Responsive Design

The app is built with responsive design using the Sizer package:

```dart
// Example of responsive sizing
Container(
  width: 50.w, // 50% of screen width
  height: 20.h, // 20% of screen height
  child: Text('Responsive Container'),
)
```
## 📦 Deployment

Build the application for production:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

## 🙏 Acknowledgments
- Built with [Rocket.new](https://rocket.new)
- Powered by [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- Styled with Material Design

Built with ❤️ on Rocket.new
