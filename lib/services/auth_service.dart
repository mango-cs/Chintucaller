import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthService {
  final _client = SupabaseService.instance.client;

  /// Get current user
  User? get currentUser => _client.auth.currentUser;

  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;

  /// Sign up new user
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName ?? email.split('@')[0],
        },
      );

      if (response.user != null && response.session != null) {
        // Profile will be created automatically by the trigger
        return response;
      } else {
        throw AuthException('Sign up failed: No user or session returned');
      }
    } catch (error) {
      throw AuthException('Sign up failed: $error');
    }
  }

  /// Sign in existing user
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null && response.session != null) {
        return response;
      } else {
        throw AuthException('Sign in failed: Invalid credentials');
      }
    } catch (error) {
      throw AuthException('Sign in failed: $error');
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw AuthException('Sign out failed: $error');
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = currentUser?.id;
      if (userId == null) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  /// Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    String? fullName,
    String? phone,
    String? preferredLanguage,
    String? profileImageUrl,
    Map<String, dynamic>? settings,
  }) async {
    try {
      final userId = currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updateData['full_name'] = fullName;
      if (phone != null) updateData['phone'] = phone;
      if (preferredLanguage != null)
        updateData['preferred_language'] = preferredLanguage;
      if (profileImageUrl != null)
        updateData['profile_image_url'] = profileImageUrl;
      if (settings != null) updateData['settings'] = settings;

      final response = await _client
          .from('user_profiles')
          .update(updateData)
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw AuthException('Password reset failed: $error');
    }
  }

  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Sign in with phone number using OTP
  Future<void> signInWithPhone(String phone) async {
    try {
      await _client.auth.signInWithOtp(
        phone: phone,
      );
    } catch (error) {
      throw AuthException('Phone sign in failed: $error');
    }
  }

  /// Verify phone OTP
  Future<AuthResponse> verifyPhoneOTP({
    required String phone,
    required String token,
  }) async {
    try {
      final response = await _client.auth.verifyOTP(
        type: OtpType.sms,
        phone: phone,
        token: token,
      );

      if (response.user != null && response.session != null) {
        return response;
      } else {
        throw AuthException('OTP verification failed: No user or session returned');
      }
    } catch (error) {
      throw AuthException('OTP verification failed: $error');
    }
  }
}
