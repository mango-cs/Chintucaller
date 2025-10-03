# Setup Instructions - Next Steps

## ✅ What's Already Done
- Flutter SDK installed at `C:\Users\conta\flutter`
- VSCode configured with Flutter path
- Launch configurations created
- Windows development ready

## 🔧 What You Need to Do Now

### 1. Install Android Studio (Required for Android Development)

**Download:**
https://developer.android.com/studio

**Installation Steps:**
1. Run the installer
2. Choose "Standard" installation
3. Accept all licenses
4. Let it download Android SDK components (this takes ~10-15 minutes)

**Important:** During installation, it will install:
- Android SDK
- Android SDK Platform-Tools
- Android SDK Build-Tools
- Android Emulator
- Android Virtual Device (AVD)

### 2. After Android Studio Installation

**Open a NEW PowerShell window** (important - PATH needs to refresh):

```powershell
# Verify Flutter can find Android Studio
C:\Users\conta\flutter\bin\flutter.bat doctor

# Accept Android licenses
C:\Users\conta\flutter\bin\flutter.bat doctor --android-licenses
```

Press `y` to accept all licenses.

### 3. Create Android Emulator

**In Android Studio:**
1. Top menu → Tools → Device Manager
2. Click "Create Device"
3. Choose "Pixel 6 Pro" (recommended)
4. Select System Image: "Tiramisu" (API 33) or "UpsideDownCake" (API 34)
5. Click "Download" if needed
6. Name it (e.g., "Pixel_6_Pro_API_33")
7. Click "Finish"

### 4. Install Dependencies

```powershell
cd C:\Users\conta\OneDrive\Desktop\custom-software\Chintucaller
C:\Users\conta\flutter\bin\flutter.bat pub get
```

### 5. Run Your App!

**Option A: Using VSCode**
1. Start Android Emulator from Android Studio Device Manager
2. In VSCode, press `F5`
3. Select "Android Emulator" from dropdown
4. Wait for app to build and launch

**Option B: Using Batch Files**
1. Start Android Emulator
2. Double-click `run_emulator.bat`

**Option C: Command Line**
```powershell
# List emulators
C:\Users\conta\flutter\bin\flutter.bat emulators

# Launch emulator
C:\Users\conta\flutter\bin\flutter.bat emulators --launch Pixel_6_Pro_API_33

# Run app
cd C:\Users\conta\OneDrive\Desktop\custom-software\Chintucaller
C:\Users\conta\flutter\bin\flutter.bat run --dart-define-from-file=env.json
```

---

## 🎯 Quick Start After Setup

Once Android Studio is installed:

1. **Start Emulator:**
   - Open Android Studio
   - Tools → Device Manager
   - Click ▶️ play button on your virtual device

2. **Run App:**
   - Open Cursor/VSCode
   - Press `F5`
   - Choose "Development (Auto Device)"
   - Your app will launch!

---

## 🔍 Troubleshooting

### Flutter commands not working in new terminal?
**Close and reopen PowerShell/Terminal** - PATH was updated after installation.

Or temporarily use:
```powershell
$env:Path += ";C:\Users\conta\flutter\bin"
```

### "Android licenses not accepted"?
```powershell
C:\Users\conta\flutter\bin\flutter.bat doctor --android-licenses
```
Press `y` for all.

### Emulator won't start?
- Enable virtualization in BIOS (Intel VT-x or AMD-V)
- Restart computer after enabling
- Or use a physical Android device instead

### Physical Android Phone Setup
1. Enable Developer Options:
   - Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Settings → Developer Options
   - Enable "USB Debugging"
3. Connect via USB
4. On phone, tap "Allow" when prompted
5. Run: `C:\Users\conta\flutter\bin\flutter.bat devices`

---

## 📱 iOS Development (You're on Windows)

Since you're on Windows, you **cannot** develop for iOS locally. Options:

### Option 1: Physical iPhone Only
- Connect iPhone via USB
- Test directly on device
- Limited (no simulator access)

### Option 2: Cloud CI/CD (Recommended)
Use **Codemagic** for iOS builds:
1. Sign up: https://codemagic.io/start (free tier)
2. Connect your GitHub repo
3. Configure iOS build
4. Get IPA file for TestFlight/App Store

### Option 3: Get a Mac
- Mac Mini M1/M2 (~$500 used)
- Remote access from Windows
- Full iOS development capability

**For production-grade iOS app:** You'll need Option 2 or 3.

---

## ✅ Final Checklist

Before you start developing:
- [ ] Android Studio installed
- [ ] Flutter doctor shows all green (except iOS)
- [ ] Android emulator created
- [ ] `flutter pub get` completed
- [ ] App runs on emulator successfully

**Estimated setup time:** 30-45 minutes (mostly Android Studio download)

---

## 🚀 Ready to Code?

Once setup is complete, your workflow will be:

**Daily:**
1. Start Android emulator (30 seconds)
2. Press `F5` in VSCode
3. Code with hot reload

**Weekly:**
- Test on physical Android phone
- Check performance

**Before Release:**
- Build release APK
- Test on multiple devices
- Use Codemagic for iOS build

Good luck! 🎉


