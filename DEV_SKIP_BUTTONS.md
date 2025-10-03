# Development Skip Buttons

## ⚠️ TEMPORARY - FOR DEVELOPMENT/TESTING ONLY

Skip buttons have been added to bypass authentication during development and testing.

## Where to Find Skip Buttons:

### 1. Phone Login Screen
- **Location:** `/phone-login` screen
- **Button:** Orange "SKIP (DEV/TESTING ONLY)" button below the "Send OTP" button
- **Action:** Skips directly to Home Dashboard without authentication

### 2. OTP Verification Screen
- **Location:** `/otp-verification` screen
- **Button:** Orange "SKIP (DEV/TESTING ONLY)" button below the "Verify OTP" button
- **Action:** Skips OTP verification and goes to Home Dashboard

## Visual Style:
- Orange outlined button
- Skip icon (▶▶)
- Clearly labeled as "DEV/TESTING ONLY"
- Shows warning snackbar when clicked

## How to Use:

1. **Launch app** - it will show Phone Login screen
2. **Click "SKIP (DEV/TESTING ONLY)"** button at the bottom
3. **Done!** - You're now in the Home Dashboard without authentication

## Important Notes:

⚠️ **REMOVE BEFORE PRODUCTION**
- These buttons must be removed or hidden before releasing to production
- They completely bypass authentication and security

⚠️ **No Real Authentication**
- Using skip means you're not actually logged in
- Features requiring authentication may not work properly
- User profile data will not be available

## To Remove Skip Buttons for Production:

### Option 1: Delete the skip methods and buttons
Remove these sections from:
- `lib/presentation/phone_login_screen/phone_login_screen.dart`
- `lib/presentation/otp_verification_screen/otp_verification_screen.dart`

### Option 2: Add environment flag
```dart
// Only show in debug mode
if (kDebugMode) {
  // Skip button code here
}
```

### Option 3: Use build configurations
```dart
// In env.json or build config
const bool DEV_MODE = bool.fromEnvironment('DEV_MODE', defaultValue: false);

if (DEV_MODE) {
  // Skip button code here
}
```

## Current Files Modified:

1. **lib/presentation/phone_login_screen/phone_login_screen.dart**
   - Added `_skipLoginForDevelopment()` method
   - Added skip button in UI

2. **lib/presentation/otp_verification_screen/otp_verification_screen.dart**
   - Added `_skipOTPForDevelopment()` method
   - Added skip button in UI

## Testing the Skip Flow:

```
1. Launch app
2. App shows Phone Login screen
3. Click "SKIP (DEV/TESTING ONLY)"
4. Shows orange warning: "⚠️ SKIPPED LOGIN - DEV MODE ONLY"
5. Navigates to Home Dashboard
```

---

**Created:** October 3, 2025  
**Purpose:** Development and testing without OTP functionality  
**TODO:** Remove before production release!

