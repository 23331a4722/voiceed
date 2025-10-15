import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Professional Blue-based Color Palette
  static const primaryBlue = Color(0xFF1E3A8A); // Deep professional blue
  static const primaryBlueLight = Color(0xFF3B82F6); // Bright blue
  static const accentTeal = Color(0xFF059669); // Professional teal
  static const accentTealLight = Color(0xFF10B981); // Light teal
  
  // Neutral Colors
  static const neutralDarkest = Color(0xFF1F2937); // Almost black
  static const neutralDark = Color(0xFF374151); // Dark gray
  static const neutralMedium = Color(0xFF6B7280); // Medium gray
  static const neutralLight = Color(0xFF9CA3AF); // Light gray
  static const neutralLightest = Color(0xFFF9FAFB); // Very light gray
  static const white = Color(0xFFFFFFFF);
  
  // Status Colors
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);
  
  // Surface Colors
  static const surfacePrimary = Color(0xFFFFFFFF);
  static const surfaceSecondary = Color(0xFFF8FAFC);
  static const surfaceTertiary = Color(0xFFF1F5F9);
  
  // Dark Mode Colors
  static const darkSurfacePrimary = Color(0xFF0F172A);
  static const darkSurfaceSecondary = Color(0xFF1E293B);
  static const darkSurfaceTertiary = Color(0xFF334155);
}

class AppDimensions {
  // Spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  
  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 999.0;
  
  // Elevations
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 16.0;
}

class AppTypography {
  static const double displayLarge = 64.0;
  static const double displayMedium = 48.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 18.0;
  static const double titleSmall = 16.0;
  static const double labelLarge = 16.0;
  static const double labelMedium = 14.0;
  static const double labelSmall = 12.0;
  static const double bodyLarge = 18.0;
  static const double bodyMedium = 16.0;
  static const double bodySmall = 14.0;
}

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryBlue,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryBlueLight.withValues(alpha: 0.1),
    onPrimaryContainer: AppColors.primaryBlue,
    secondary: AppColors.accentTeal,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.accentTeal.withValues(alpha: 0.1),
    onSecondaryContainer: AppColors.accentTeal,
    tertiary: AppColors.primaryBlueLight,
    onTertiary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.error.withValues(alpha: 0.1),
    onErrorContainer: AppColors.error,
    surface: AppColors.surfacePrimary,
    onSurface: AppColors.neutralDarkest,
    surfaceContainerHighest: AppColors.surfaceSecondary,
    onSurfaceVariant: AppColors.neutralMedium,
    outline: AppColors.neutralLight,
    shadow: Colors.black.withValues(alpha: 0.15),
  ),
  
  // App Bar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.surfacePrimary,
    foregroundColor: AppColors.neutralDarkest,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: AppTypography.titleLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralDarkest,
    ),
    iconTheme: const IconThemeData(color: AppColors.neutralDarkest),
    surfaceTintColor: Colors.transparent,
  ),
  
  // Card Theme
  cardTheme: CardThemeData(
    color: AppColors.surfacePrimary,
    elevation: AppDimensions.elevationSM,
    shadowColor: Colors.black.withValues(alpha: 0.1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: AppDimensions.spaceMD,
      vertical: AppDimensions.spaceSM,
    ),
  ),
  
  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: AppColors.white,
      elevation: AppDimensions.elevationSM,
      shadowColor: AppColors.primaryBlue.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG,
        vertical: AppDimensions.spaceMD,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: AppTypography.labelLarge,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      side: const BorderSide(color: AppColors.primaryBlue),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG,
        vertical: AppDimensions.spaceMD,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: AppTypography.labelLarge,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceSecondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      borderSide: const BorderSide(color: AppColors.neutralLight),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      borderSide: const BorderSide(color: AppColors.neutralLight),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.spaceMD,
      vertical: AppDimensions.spaceMD,
    ),
    labelStyle: GoogleFonts.inter(
      fontSize: AppTypography.bodyMedium,
      color: AppColors.neutralMedium,
    ),
    hintStyle: GoogleFonts.inter(
      fontSize: AppTypography.bodyMedium,
      color: AppColors.neutralLight,
    ),
  ),
  
  // Text Theme
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: AppTypography.displayLarge,
      fontWeight: FontWeight.w800,
      color: AppColors.neutralDarkest,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: AppTypography.displayMedium,
      fontWeight: FontWeight.w700,
      color: AppColors.neutralDarkest,
      letterSpacing: -1.0,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: AppTypography.displaySmall,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralDarkest,
      letterSpacing: -0.5,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: AppTypography.headlineLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralDarkest,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: AppTypography.headlineMedium,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralDarkest,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: AppTypography.headlineSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralDarkest,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: AppTypography.titleLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralDarkest,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: AppTypography.titleMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralDarkest,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: AppTypography.titleSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralDark,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: AppTypography.labelLarge,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralDark,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: AppTypography.labelMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralMedium,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: AppTypography.labelSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralMedium,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: AppTypography.bodyLarge,
      fontWeight: FontWeight.w400,
      color: AppColors.neutralDark,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: AppTypography.bodyMedium,
      fontWeight: FontWeight.w400,
      color: AppColors.neutralDark,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: AppTypography.bodySmall,
      fontWeight: FontWeight.w400,
      color: AppColors.neutralMedium,
      height: 1.4,
    ),
  ),
  
  // Icon Theme
  iconTheme: const IconThemeData(
    color: AppColors.neutralDark,
    size: 24,
  ),
  
  // Divider Theme
  dividerTheme: DividerThemeData(
    color: AppColors.neutralLight.withValues(alpha: 0.3),
    thickness: 1,
    space: 1,
  ),
);

ThemeData get darkTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryBlueLight,
    onPrimary: AppColors.neutralDarkest,
    primaryContainer: AppColors.primaryBlue.withValues(alpha: 0.3),
    onPrimaryContainer: AppColors.primaryBlueLight,
    secondary: AppColors.accentTealLight,
    onSecondary: AppColors.neutralDarkest,
    secondaryContainer: AppColors.accentTeal.withValues(alpha: 0.3),
    onSecondaryContainer: AppColors.accentTealLight,
    tertiary: AppColors.primaryBlueLight,
    onTertiary: AppColors.neutralDarkest,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.error.withValues(alpha: 0.3),
    onErrorContainer: AppColors.error,
    surface: AppColors.darkSurfacePrimary,
    onSurface: AppColors.neutralLightest,
    surfaceContainerHighest: AppColors.darkSurfaceSecondary,
    onSurfaceVariant: AppColors.neutralLight,
    outline: AppColors.neutralMedium,
    shadow: Colors.black.withValues(alpha: 0.3),
  ),
  
  // App Bar Theme for Dark Mode
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkSurfacePrimary,
    foregroundColor: AppColors.neutralLightest,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: GoogleFonts.inter(
      fontSize: AppTypography.titleLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralLightest,
    ),
    iconTheme: const IconThemeData(color: AppColors.neutralLightest),
    surfaceTintColor: Colors.transparent,
  ),
  
  // Card Theme for Dark Mode
  cardTheme: CardThemeData(
    color: AppColors.darkSurfaceSecondary,
    elevation: AppDimensions.elevationSM,
    shadowColor: Colors.black.withValues(alpha: 0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: AppDimensions.spaceMD,
      vertical: AppDimensions.spaceSM,
    ),
  ),
  
  // Elevated Button Theme for Dark Mode
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlueLight,
      foregroundColor: AppColors.neutralDarkest,
      elevation: AppDimensions.elevationSM,
      shadowColor: AppColors.primaryBlueLight.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceLG,
        vertical: AppDimensions.spaceMD,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      ),
      textStyle: GoogleFonts.inter(
        fontSize: AppTypography.labelLarge,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
  
  // Input Decoration Theme for Dark Mode
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurfaceSecondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      borderSide: const BorderSide(color: AppColors.neutralMedium),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      borderSide: const BorderSide(color: AppColors.neutralMedium),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      borderSide: const BorderSide(color: AppColors.primaryBlueLight, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.spaceMD,
      vertical: AppDimensions.spaceMD,
    ),
    labelStyle: GoogleFonts.inter(
      fontSize: AppTypography.bodyMedium,
      color: AppColors.neutralLight,
    ),
    hintStyle: GoogleFonts.inter(
      fontSize: AppTypography.bodyMedium,
      color: AppColors.neutralMedium,
    ),
  ),
  
  // Text Theme for Dark Mode (same structure, different colors)
  textTheme: TextTheme(
    displayLarge: GoogleFonts.inter(
      fontSize: AppTypography.displayLarge,
      fontWeight: FontWeight.w800,
      color: AppColors.neutralLightest,
      letterSpacing: -1.5,
    ),
    displayMedium: GoogleFonts.inter(
      fontSize: AppTypography.displayMedium,
      fontWeight: FontWeight.w700,
      color: AppColors.neutralLightest,
      letterSpacing: -1.0,
    ),
    displaySmall: GoogleFonts.inter(
      fontSize: AppTypography.displaySmall,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralLightest,
      letterSpacing: -0.5,
    ),
    headlineLarge: GoogleFonts.inter(
      fontSize: AppTypography.headlineLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralLightest,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: AppTypography.headlineMedium,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralLightest,
    ),
    headlineSmall: GoogleFonts.inter(
      fontSize: AppTypography.headlineSmall,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralLightest,
    ),
    titleLarge: GoogleFonts.inter(
      fontSize: AppTypography.titleLarge,
      fontWeight: FontWeight.w600,
      color: AppColors.neutralLightest,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: AppTypography.titleMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralLightest,
    ),
    titleSmall: GoogleFonts.inter(
      fontSize: AppTypography.titleSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralLight,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: AppTypography.labelLarge,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralLight,
    ),
    labelMedium: GoogleFonts.inter(
      fontSize: AppTypography.labelMedium,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralLight,
    ),
    labelSmall: GoogleFonts.inter(
      fontSize: AppTypography.labelSmall,
      fontWeight: FontWeight.w500,
      color: AppColors.neutralLight,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: AppTypography.bodyLarge,
      fontWeight: FontWeight.w400,
      color: AppColors.neutralLight,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: AppTypography.bodyMedium,
      fontWeight: FontWeight.w400,
      color: AppColors.neutralLight,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: AppTypography.bodySmall,
      fontWeight: FontWeight.w400,
      color: AppColors.neutralMedium,
      height: 1.4,
    ),
  ),
  
  // Icon Theme for Dark Mode
  iconTheme: const IconThemeData(
    color: AppColors.neutralLight,
    size: 24,
  ),
  
  // Divider Theme for Dark Mode
  dividerTheme: DividerThemeData(
    color: AppColors.neutralMedium.withValues(alpha: 0.3),
    thickness: 1,
    space: 1,
  ),
);