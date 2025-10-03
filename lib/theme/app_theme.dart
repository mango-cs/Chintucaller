import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the AI-powered call management application.
/// Implements Contemporary Professional Minimalism with Professional Dark Foundation.
class AppTheme {
  AppTheme._();

  // Professional Dark Foundation Color Palette
  static const Color primaryBlack =
      Color(0xFF000000); // Pure black background optimizing OLED displays
  static const Color contentSurface =
      Color(0xFF1C1C1E); // Dark gray cards for subtle separation
  static const Color activeGreen =
      Color(0xFF34C759); // iOS system green for progress and active states
  static const Color textPrimary =
      Color(0xFFFFFFFF); // Pure white for primary content
  static const Color textSecondary =
      Color(0xFF8E8E93); // Muted gray for supporting information
  static const Color warningAmber =
      Color(0xFFFF9500); // System orange for attention-requiring states
  static const Color errorRed =
      Color(0xFFFF3B30); // System red for spam indicators and alerts
  static const Color successTeal =
      Color(0xFF30D158); // Vibrant green for completed actions
  static const Color borderSubtle =
      Color(0xFF38383A); // Minimal border color for separations
  static const Color overlayDark =
      Color(0xCC000000); // 80% black overlay for modal backgrounds

  // Light theme colors (minimal usage for accessibility)
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF2F2F7);
  static const Color onBackgroundLight = Color(0xFF000000);
  static const Color onSurfaceLight = Color(0xFF000000);

  // Shadow colors for minimal elevation
  static const Color shadowDark =
      Color(0x33000000); // 20% opacity for subtle shadows
  static const Color shadowLight =
      Color(0x1A000000); // 10% opacity for light theme

  /// Dark theme - Primary theme for the application
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: activeGreen,
      onPrimary: primaryBlack,
      primaryContainer: activeGreen,
      onPrimaryContainer: primaryBlack,
      secondary: successTeal,
      onSecondary: primaryBlack,
      secondaryContainer: successTeal,
      onSecondaryContainer: primaryBlack,
      tertiary: warningAmber,
      onTertiary: primaryBlack,
      tertiaryContainer: warningAmber,
      onTertiaryContainer: primaryBlack,
      error: errorRed,
      onError: textPrimary,
      surface: primaryBlack,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: borderSubtle,
      outlineVariant: borderSubtle,
      shadow: shadowDark,
      scrim: overlayDark,
      inverseSurface: textPrimary,
      onInverseSurface: primaryBlack,
      inversePrimary: activeGreen,
    ),
    scaffoldBackgroundColor: primaryBlack,
    cardColor: contentSurface,
    dividerColor: borderSubtle,

    // AppBar theme for professional header
    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlack,
      foregroundColor: textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),
    ),

    // Card theme for content surfaces
    cardTheme: CardThemeData(
      color: contentSurface,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // Bottom navigation for main app navigation
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: contentSurface,
      selectedItemColor: activeGreen,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),

    // Floating Action Button for contextual actions
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: activeGreen,
      foregroundColor: primaryBlack,
      elevation: 2,
      focusElevation: 4,
      hoverElevation: 4,
      highlightElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
    ),

    // Button themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: primaryBlack,
        backgroundColor: activeGreen,
        disabledForegroundColor: textSecondary,
        disabledBackgroundColor: borderSubtle,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        disabledForegroundColor: textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: const BorderSide(color: borderSubtle, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: activeGreen,
        disabledForegroundColor: textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
      ),
    ),

    // Text theme using Inter and SF Pro equivalents
    textTheme: _buildDarkTextTheme(),

    // Input decoration for forms
    inputDecorationTheme: InputDecorationTheme(
      fillColor: contentSurface,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderSubtle, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderSubtle, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: activeGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorRed, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),

    // Switch theme for settings
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return activeGreen;
        }
        return textSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return activeGreen.withAlpha(77);
        }
        return borderSubtle;
      }),
    ),

    // Checkbox theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return activeGreen;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(primaryBlack),
      side: const BorderSide(color: borderSubtle, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    // Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return activeGreen;
        }
        return borderSubtle;
      }),
    ),

    // Progress indicator theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: activeGreen,
      linearTrackColor: borderSubtle,
      circularTrackColor: borderSubtle,
    ),

    // Slider theme
    sliderTheme: SliderThemeData(
      activeTrackColor: activeGreen,
      inactiveTrackColor: borderSubtle,
      thumbColor: activeGreen,
      overlayColor: activeGreen.withAlpha(51),
      valueIndicatorColor: activeGreen,
      valueIndicatorTextStyle: GoogleFonts.inter(
        color: primaryBlack,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),

    // Tab bar theme
    tabBarTheme: TabBarThemeData(
      labelColor: textPrimary,
      unselectedLabelColor: textSecondary,
      indicatorColor: activeGreen,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
    ),

    // Tooltip theme
    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: contentSurface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: shadowDark,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      textStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // SnackBar theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: contentSurface,
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: activeGreen,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
    ),

    // Dialog theme
    dialogTheme: DialogThemeData(
      backgroundColor: contentSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
      ),
      contentTextStyle: GoogleFonts.inter(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
    ),

    // Bottom sheet theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: contentSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
    ),
  );

  /// Light theme - Minimal usage for accessibility compliance
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: activeGreen,
      onPrimary: textPrimary,
      primaryContainer: activeGreen.withAlpha(26),
      onPrimaryContainer: activeGreen,
      secondary: successTeal,
      onSecondary: textPrimary,
      secondaryContainer: successTeal.withAlpha(26),
      onSecondaryContainer: successTeal,
      tertiary: warningAmber,
      onTertiary: textPrimary,
      tertiaryContainer: warningAmber.withAlpha(26),
      onTertiaryContainer: warningAmber,
      error: errorRed,
      onError: textPrimary,
      surface: backgroundLight,
      onSurface: onBackgroundLight,
      onSurfaceVariant: onBackgroundLight.withAlpha(153),
      outline: onBackgroundLight.withAlpha(51),
      outlineVariant: onBackgroundLight.withAlpha(26),
      shadow: shadowLight,
      scrim: onBackgroundLight.withAlpha(204),
      inverseSurface: primaryBlack,
      onInverseSurface: textPrimary,
      inversePrimary: activeGreen,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardColor: surfaceLight,
    dividerColor: onBackgroundLight.withAlpha(31),
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: onBackgroundLight,
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: 0.15,
      ),
      iconTheme: IconThemeData(
        color: onBackgroundLight,
        size: 24,
      ),
    ),
    textTheme: _buildLightTextTheme(), dialogTheme: DialogThemeData(backgroundColor: backgroundLight),
  );

  /// Helper method to build dark text theme
  static TextTheme _buildDarkTextTheme() {
    return TextTheme(
      // Display styles - Inter for headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),

      // Headline styles - Inter for headings
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Title styles - Inter for headings
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
      ),

      // Body styles - Inter for body text (SF Pro Text equivalent)
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
      ),

      // Label styles - Inter for captions and data
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
    );
  }

  /// Helper method to build light text theme
  static TextTheme _buildLightTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: onBackgroundLight,
        letterSpacing: 0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight,
        letterSpacing: 0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight,
        letterSpacing: 0.25,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight.withAlpha(153),
        letterSpacing: 0.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: onBackgroundLight.withAlpha(153),
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: onBackgroundLight.withAlpha(153),
        letterSpacing: 0.5,
      ),
    );
  }
}
