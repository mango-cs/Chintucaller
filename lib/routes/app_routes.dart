import 'package:flutter/material.dart';
import '../presentation/permission_request_screen/permission_request_screen.dart';
import '../presentation/voice_selection_screen/voice_selection_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/settings_screen/settings_screen.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/name_input_and_profile_setup/name_input_and_profile_setup.dart';
import '../presentation/private_beta_welcome_card/private_beta_welcome_card.dart';
import '../presentation/call_history/call_history.dart';
import '../presentation/activating_assistant_progress/activating_assistant_progress.dart';
import '../presentation/live_call_screen/live_call_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/signup_screen/signup_screen.dart';
import '../presentation/analytics_screen/analytics_screen.dart';
import '../presentation/phone_login_screen/phone_login_screen.dart';
import '../presentation/otp_verification_screen/otp_verification_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String permissionRequest = '/permission-request-screen';
  static const String voiceSelection = '/voice-selection-screen';
  static const String splash = '/splash-screen';
  static const String settings = '/settings-screen';
  static const String homeDashboard = '/home-dashboard';
  static const String nameInputAndProfileSetup =
      '/name-input-and-profile-setup';
  static const String privateBetaWelcomeCard = '/private-beta-welcome-card';
  static const String callHistory = '/call-history';
  static const String activatingAssistantProgress =
      '/activating-assistant-progress';
  static const String liveCall = '/live-call-screen';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String analytics = '/analytics';
  static const String phoneLogin = '/phone-login';
  static const String otpVerification = '/otp-verification';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    permissionRequest: (context) => const PermissionRequestScreen(),
    voiceSelection: (context) => const VoiceSelectionScreen(),
    splash: (context) => const SplashScreen(),
    settings: (context) => const SettingsScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    nameInputAndProfileSetup: (context) => const NameInputAndProfileSetup(),
    privateBetaWelcomeCard: (context) => const PrivateBetaWelcomeCard(),
    callHistory: (context) => const CallHistory(),
    activatingAssistantProgress: (context) =>
        const ActivatingAssistantProgress(),
    liveCall: (context) => const LiveCallScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    analytics: (context) => const AnalyticsScreen(),
    phoneLogin: (context) => const PhoneLoginScreen(),
    otpVerification: (context) => const OtpVerificationScreen(),
    // TODO: Add your other routes here
  };
}
