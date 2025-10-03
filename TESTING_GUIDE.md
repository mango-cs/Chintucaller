# Testing Guide for Chintucaller

## Quick Start

### VSCode Users
Press `F5` and select from dropdown:
- **Development (Auto Device)** - Runs on any available device
- **Android Emulator** - Specific to emulator
- **Physical Android** - Physical Android phone
- **Physical iPhone** - Physical iOS device
- **iOS Simulator** - iOS simulator (Mac only)
- **Profile Mode** - Performance testing
- **Release Mode** - Final testing before deployment

### Android Studio/IntelliJ Users
Top toolbar → Run Configuration dropdown → Select your target

### Command Line
Double-click these batch files:
- `run_emulator.bat` - Auto-detect and run
- `run_android.bat` - Physical Android device
- `run_ios.bat` - Physical iOS device
- `build_android.bat` - Build release APK
- `build_ios.bat` - Build iOS release

Or use Flutter commands directly:
```bash
# See all devices
flutter devices

# Run on specific device
flutter run --dart-define-from-file=env.json -d <device-id>

# Run on Android
flutter run --dart-define-from-file=env.json -d android

# Run on iOS
flutter run --dart-define-from-file=env.json -d ios
```

## Testing Workflow

### Daily Development (80% of time)
1. **Start Android Emulator** in Android Studio (Tools → Device Manager → Play button)
2. **Run app** with `F5` in VSCode or `run_emulator.bat`
3. **Hot Reload** - Press `r` in terminal or save file in VSCode
4. **Hot Restart** - Press `R` in terminal

### Weekly Device Testing (15% of time)
1. **Physical Android:**
   - Enable Developer Options (tap Build Number 7 times)
   - Enable USB Debugging
   - Connect via USB
   - Run with "Physical Android" configuration

2. **Physical iPhone:**
   - Connect via USB
   - Trust computer on device
   - Run with "Physical iPhone" configuration

### Pre-Release Testing (5% of time)
1. **Build release versions:**
   - Android: Double-click `build_android.bat`
   - iOS: Double-click `build_ios.bat` (Mac only)

2. **Test on physical devices:**
   - Install APK on Android phone
   - Install via TestFlight or Xcode on iPhone

## Critical Features to Test on Physical Devices

### Audio Features (Your App's Core)
- ✅ Microphone recording quality
- ✅ Audio playback quality
- ✅ Background audio behavior
- ✅ Bluetooth audio devices
- ✅ Headphone jack/wireless earbuds

### Permissions
- ✅ Microphone permission prompt
- ✅ Storage permission (saving recordings)
- ✅ Notification permissions
- ✅ Camera permission (if used)

### Performance
- ✅ Battery drain during recording
- ✅ App performance on older devices
- ✅ Memory usage during long recordings
- ✅ Network behavior (Supabase sync)

### Device-Specific
- ✅ Different screen sizes
- ✅ Notch/dynamic island handling
- ✅ Dark mode appearance
- ✅ Gesture navigation vs buttons

## Device Recommendations

### Minimum for Production-Grade Development:
1. **Android Emulator** (Pixel 6 Pro, API 33) - Daily development
2. **Physical Android Phone** (Mid-range, Android 10+) - Audio testing
3. **Physical iPhone** (iPhone 11 or newer) - iOS testing

### Ideal Setup:
1. **Android Emulator** - Fast iteration
2. **Physical Android** (Budget: Pixel 4a, Samsung A-series)
3. **Physical iPhone** (Budget: iPhone SE 2020 or 11)
4. **Tablet** (Optional: iPad or Android tablet for large screens)

## Debugging Tips

### View Logs
```bash
# Android
flutter logs -d android

# iOS
flutter logs -d ios
```

### Debug Performance
```bash
# Run in profile mode
flutter run --profile --dart-define-from-file=env.json

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

### Clear Build
```bash
flutter clean
flutter pub get
flutter run --dart-define-from-file=env.json
```

## CI/CD for iOS (Windows Users)

Since you're on Windows, use cloud services for iOS:

### Codemagic (Recommended)
1. Sign up at https://codemagic.io
2. Connect GitHub repo
3. Configure `codemagic.yaml`:
```yaml
workflows:
  ios-workflow:
    name: iOS Build
    max_build_duration: 60
    environment:
      flutter: stable
      xcode: latest
    scripts:
      - flutter pub get
      - flutter build ios --release --dart-define-from-file=env.json
```

### GitHub Actions
Create `.github/workflows/ios.yml` for automated iOS builds.

## Quick Commands Cheat Sheet

```bash
# Device management
flutter devices                    # List all devices
flutter emulators                  # List emulators
flutter emulators --launch <id>    # Start emulator

# Running
flutter run --dart-define-from-file=env.json              # Auto device
flutter run --dart-define-from-file=env.json -d android   # Android
flutter run --dart-define-from-file=env.json -d ios       # iOS

# Building
flutter build apk --release --dart-define-from-file=env.json
flutter build appbundle --release --dart-define-from-file=env.json
flutter build ios --release --dart-define-from-file=env.json

# Maintenance
flutter clean          # Clean build
flutter pub get        # Install dependencies
flutter doctor         # Check setup
flutter upgrade        # Update Flutter
```

## Answer: Physical or Emulator?

**Use BOTH - Hybrid Approach:**

**Emulators for:**
- ✅ Fast daily development
- ✅ Quick feature testing
- ✅ Different screen sizes
- ✅ Hot reload iterations

**Physical Devices for:**
- ✅ Audio quality testing (CRITICAL for your app!)
- ✅ Real performance metrics
- ✅ True user experience
- ✅ Hardware sensor testing
- ✅ Pre-release validation

**Not "2 phones connected" - Instead:**
- 1 Android Emulator (always running during dev)
- 1 Physical Android (test daily/weekly)
- 1 Physical iPhone (test weekly/before release)

Switch between them easily using VSCode dropdown or batch files!

