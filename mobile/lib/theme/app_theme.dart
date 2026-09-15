import 'package:flutter/material.dart';
import 'app_constants.dart';

/// AppTheme provides light and dark theme configurations with Material 3 support
/// Generated with Flutter Theme Generator - Clean, modular, and maintainable
///
/// Features:
/// ✅ Uses AppConstants for consistent design tokens
/// ✅ Modular structure with separate theme components
/// ✅ Material 3 compliant color schemes
/// ✅ Support for 6 contrast modes (light, dark, medium/high contrast variants)
/// ✅ Production-ready with proper type declarations
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 PUBLIC THEME GETTERS
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light theme configuration
  static ThemeData get lightTheme => theme(lightScheme());

  /// Dark theme configuration
  static ThemeData get darkTheme => theme(darkScheme());

  /// Light medium contrast theme
  static ThemeData get lightMediumContrast => theme(lightMediumContrastScheme());

  /// Light high contrast theme
  static ThemeData get lightHighContrast => theme(lightHighContrastScheme());

  /// Dark medium contrast theme
  static ThemeData get darkMediumContrast => theme(darkMediumContrastScheme());

  /// Dark high contrast theme
  static ThemeData get darkHighContrast => theme(darkHighContrastScheme());

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🌈 COLOR SCHEMES - Material 3 compliant, matching the "who can come" mockup
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Light color scheme
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF25A55C),
      surfaceTint: Color(0xFF25A55C),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFD8F4E3),
      onPrimaryContainer: Color(0xFF07341A),
      secondary: Color(0xFFF0A93E),
      onSecondary: Color(0xFF3A2600),
      secondaryContainer: Color(0xFFFFEBC2),
      onSecondaryContainer: Color(0xFF3A2600),
      tertiary: Color(0xFFE5484D),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFFDBDC),
      onTertiaryContainer: Color(0xFF410006),
      error: Color(0xFFE5484D),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFDBDC),
      onErrorContainer: Color(0xFF410006),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF1A1F1D),
      onSurfaceVariant: Color(0xFF667169),
      outline: Color(0xFFD6DED9),
      outlineVariant: Color(0xFFE6ECE8),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF1A1F1D),
      onInverseSurface: Color(0xFFEEF4F0),
      inversePrimary: Color(0xFF8ADAA9),
      primaryFixed: Color(0xFFD8F4E3),
      onPrimaryFixed: Color(0xFF07341A),
      primaryFixedDim: Color(0xFF8ADAA9),
      onPrimaryFixedVariant: Color(0xFF0D5A2E),
      secondaryFixed: Color(0xFFFFEBC2),
      onSecondaryFixed: Color(0xFF3A2600),
      secondaryFixedDim: Color(0xFFF0A93E),
      onSecondaryFixedVariant: Color(0xFF5B3D00),
      tertiaryFixed: Color(0xFFFFDBDC),
      onTertiaryFixed: Color(0xFF410006),
      tertiaryFixedDim: Color(0xFFFF8A8F),
      onTertiaryFixedVariant: Color(0xFF8C1F24),
      surfaceDim: Color(0xFFE3E9E4),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF7FAF7),
      surfaceContainer: Color(0xFFF1F5F1),
      surfaceContainerHigh: Color(0xFFEBF0EB),
      surfaceContainerHighest: Color(0xFFE3E9E4),
    );
  }

  /// Dark color scheme
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF3ECB7A),
      surfaceTint: Color(0xFF3ECB7A),
      onPrimary: Color(0xFF04310F),
      primaryContainer: Color(0xFF0D5A2E),
      onPrimaryContainer: Color(0xFFD8F4E3),
      secondary: Color(0xFFF7B94F),
      onSecondary: Color(0xFF3A2600),
      secondaryContainer: Color(0xFF5B3D00),
      onSecondaryContainer: Color(0xFFFFEBC2),
      tertiary: Color(0xFFFF6A70),
      onTertiary: Color(0xFF410006),
      tertiaryContainer: Color(0xFF8C1F24),
      onTertiaryContainer: Color(0xFFFFDBDC),
      error: Color(0xFFFF6A70),
      onError: Color(0xFF410006),
      errorContainer: Color(0xFF8C1F24),
      onErrorContainer: Color(0xFFFFDBDC),
      surface: Color(0xFF0D1F19),
      onSurface: Color(0xFFE7F1EA),
      onSurfaceVariant: Color(0xFFA0AFA6),
      outline: Color(0xFF3E4D45),
      outlineVariant: Color(0xFF223028),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFE7F1EA),
      onInverseSurface: Color(0xFF1A1F1D),
      inversePrimary: Color(0xFF25A55C),
      primaryFixed: Color(0xFFD8F4E3),
      onPrimaryFixed: Color(0xFF07341A),
      primaryFixedDim: Color(0xFF8ADAA9),
      onPrimaryFixedVariant: Color(0xFF0D5A2E),
      secondaryFixed: Color(0xFFFFEBC2),
      onSecondaryFixed: Color(0xFF3A2600),
      secondaryFixedDim: Color(0xFFF7B94F),
      onSecondaryFixedVariant: Color(0xFF5B3D00),
      tertiaryFixed: Color(0xFFFFDBDC),
      onTertiaryFixed: Color(0xFF410006),
      tertiaryFixedDim: Color(0xFFFF8A8F),
      onTertiaryFixedVariant: Color(0xFF8C1F24),
      surfaceDim: Color(0xFF0D1F19),
      surfaceBright: Color(0xFF334038),
      surfaceContainerLowest: Color(0xFF071410),
      surfaceContainerLow: Color(0xFF121F16),
      surfaceContainer: Color(0xFF16261C),
      surfaceContainerHigh: Color(0xFF203024),
      surfaceContainerHighest: Color(0xFF2B3B2E),
    );
  }

  /// Light medium contrast color scheme
  static ColorScheme lightMediumContrastScheme() {
    return lightScheme().copyWith(
      primary: Color(0xFF127A42),
      outline: Color(0xFF5C6A62),
    );
  }

  /// Light high contrast color scheme
  static ColorScheme lightHighContrastScheme() {
    return lightScheme().copyWith(
      primary: Color(0xFF04350F),
      outline: const Color(0xFF000000),
    );
  }

  /// Dark medium contrast color scheme
  static ColorScheme darkMediumContrastScheme() {
    return darkScheme().copyWith(
      primary: Color(0xFF5EDB93),
      outline: Color(0xFFB6C4BB),
    );
  }

  /// Dark high contrast color scheme
  static ColorScheme darkHighContrastScheme() {
    return darkScheme().copyWith(
      primary: Color(0xFF8AF0B6),
      outline: const Color(0xFFFFFFFF),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎯 MAIN THEME BUILDER - Clean and modular structure
  // ═══════════════════════════════════════════════════════════════════════════════

  /// Main theme function that combines all theme components
  /// Uses clean, modular structure with proper AppConstants integration
  static ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: _textTheme,
    appBarTheme: colorScheme.brightness == Brightness.light ? _lightAppBarTheme : _darkAppBarTheme,
    elevatedButtonTheme: elevatedButtonTheme(colorScheme),
    filledButtonTheme: filledButtonTheme(colorScheme),
    textButtonTheme: textButtonTheme(colorScheme),
    outlinedButtonTheme: outlinedButtonTheme(colorScheme),
    iconButtonTheme: iconButtonTheme(colorScheme),
    inputDecorationTheme: _inputDecorationTheme,
    cardTheme: _cardTheme,
    chipTheme: _chipTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    dividerTheme: _dividerTheme,
    bottomNavigationBarTheme: _bottomNavigationBarTheme,
    navigationBarTheme: navigationBarTheme(colorScheme),
    tabBarTheme: _tabBarTheme,
    switchTheme: switchTheme(colorScheme),
    checkboxTheme: _checkboxTheme,
    radioTheme: _radioTheme,
    sliderTheme: _sliderTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
  );

  // ═══════════════════════════════════════════════════════════════════════════════
  // 🎨 THEME COMPONENTS - All using AppConstants for consistency
  // ═══════════════════════════════════════════════════════════════════════════════


  /// Text theme using AppConstants for consistent font sizes
  static final TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: AppConstants.fontSizeDisplayLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      height: 1.12,
    ),
    displayMedium: TextStyle(
      fontSize: AppConstants.fontSizeDisplayMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.16,
    ),
    displaySmall: TextStyle(
      fontSize: AppConstants.fontSizeDisplaySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      height: 1.22,
    ),
    headlineLarge: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineLarge,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineMedium,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.29,
    ),
    headlineSmall: TextStyle(
      fontSize: AppConstants.fontSizeHeadlineSmall,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      height: 1.33,
    ),
    titleLarge: TextStyle(
      fontSize: AppConstants.fontSizeTitleLarge,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
    ),
    titleMedium: TextStyle(
      fontSize: AppConstants.fontSizeTitleMedium,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    titleSmall: TextStyle(
      fontSize: AppConstants.fontSizeTitleSmall,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelLarge: TextStyle(
      fontSize: AppConstants.fontSizeLabelLarge,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      height: 1.43,
    ),
    labelMedium: TextStyle(
      fontSize: AppConstants.fontSizeLabelMedium,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.33,
    ),
    labelSmall: TextStyle(
      fontSize: AppConstants.fontSizeLabelSmall,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.45,
    ),
    bodyLarge: TextStyle(
      fontSize: AppConstants.fontSizeBodyLarge,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.50,
    ),
    bodyMedium: TextStyle(
      fontSize: AppConstants.fontSizeBodyMedium,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.43,
    ),
    bodySmall: TextStyle(
      fontSize: AppConstants.fontSizeBodySmall,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.33,
    ),
  );


  /// Elevated button theme - M3 compliant with WidgetStateProperty
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) => ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) return 0;
        if (states.contains(WidgetState.hovered)) return AppConstants.elevationLevel3;
        if (states.contains(WidgetState.pressed)) return AppConstants.elevationLevel1;
        return AppConstants.elevationLevel2;
      }),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLG,
          vertical: AppConstants.spacingMD,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }
        return colorScheme.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        return colorScheme.onPrimary;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.onPrimary.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.onPrimary.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return colorScheme.onPrimary.withValues(alpha: 0.1);
        }
        return null;
      }),
      shadowColor: WidgetStateProperty.all(colorScheme.shadow),
    ),
  );

  /// Filled button theme - M3 compliant with WidgetStateProperty
  static FilledButtonThemeData filledButtonTheme(ColorScheme colorScheme) => FilledButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLG,
          vertical: AppConstants.spacingMD,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
      ),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.12);
        }
        return colorScheme.primary;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        return colorScheme.onPrimary;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.onPrimary.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.onPrimary.withValues(alpha: 0.08);
        }
        return null;
      }),
    ),
  );

  /// Text button theme - M3 compliant with WidgetStateProperty
  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) => TextButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLG,
          vertical: AppConstants.spacingMD,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        return colorScheme.primary;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.primary.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.primary.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.focused)) {
          return colorScheme.primary.withValues(alpha: 0.1);
        }
        return null;
      }),
    ),
  );

  /// Outlined button theme - M3 compliant with WidgetStateProperty
  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) => OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(
          horizontal: AppConstants.spacingLG,
          vertical: AppConstants.spacingMD,
        ),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
      ),
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.12));
        }
        if (states.contains(WidgetState.focused)) {
          return BorderSide(color: colorScheme.primary);
        }
        return BorderSide(color: colorScheme.outline);
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        return colorScheme.primary;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.primary.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.primary.withValues(alpha: 0.08);
        }
        return null;
      }),
    ),
  );

  /// Icon button theme - M3 compliant with WidgetStateProperty
  static IconButtonThemeData iconButtonTheme(ColorScheme colorScheme) => IconButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return colorScheme.onSurface.withValues(alpha: 0.38);
        }
        return colorScheme.onSurfaceVariant;
      }),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return colorScheme.onSurfaceVariant.withValues(alpha: 0.1);
        }
        if (states.contains(WidgetState.hovered)) {
          return colorScheme.onSurfaceVariant.withValues(alpha: 0.08);
        }
        return null;
      }),
    ),
  );


  /// Input decoration theme
  static final InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingMD,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusMD),
    ),
  );


  /// App bar theme for light mode
  static final AppBarTheme _lightAppBarTheme = AppBarTheme(
    elevation: AppConstants.elevationLevel0,
    centerTitle: false,
    titleSpacing: AppConstants.spacingMD,
    scrolledUnderElevation: AppConstants.elevationLevel1,
  );

  /// App bar theme for dark mode
  static final AppBarTheme _darkAppBarTheme = AppBarTheme(
    elevation: AppConstants.elevationLevel0,
    centerTitle: false,
    titleSpacing: AppConstants.spacingMD,
    scrolledUnderElevation: AppConstants.elevationLevel1,
  );

  /// Card theme
  static final CardThemeData _cardTheme = CardThemeData(
    elevation: AppConstants.elevationLevel0,
    margin: EdgeInsets.all(AppConstants.spacingSM),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusLG),
    ),
  );

  /// Chip theme
  static final ChipThemeData _chipTheme = ChipThemeData(
    padding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingSM,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusFull),
    ),
  );

  /// Progress indicator theme
  static final ProgressIndicatorThemeData _progressIndicatorTheme = ProgressIndicatorThemeData();

  /// Divider theme
  static final DividerThemeData _dividerTheme = DividerThemeData(
    thickness: AppConstants.borderWidthThin,
    space: AppConstants.spacingMD,
  );

  /// Bottom navigation bar theme
  static final BottomNavigationBarThemeData _bottomNavigationBarTheme = BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
  );

  /// Navigation bar theme - selected item uses the mockup's green accent.
  static NavigationBarThemeData navigationBarTheme(ColorScheme colorScheme) {
    return NavigationBarThemeData(
      backgroundColor: colorScheme.surfaceContainer,
      indicatorColor: Colors.transparent,
      elevation: AppConstants.elevationLevel0,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: AppConstants.fontSizeLabelMedium,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
        );
      }),
    );
  }

  /// Tab bar theme
  static final TabBarThemeData _tabBarTheme = TabBarThemeData(
    labelPadding: EdgeInsets.symmetric(
      horizontal: AppConstants.spacingMD,
      vertical: AppConstants.spacingSM,
    ),
  );

  /// Switch theme - uses colorScheme from theme() parameter
  static SwitchThemeData switchTheme(ColorScheme colorScheme) => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary;
      }
      return null;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primaryContainer;
      }
      return null;
    }),
  );

  /// Checkbox theme
  static final CheckboxThemeData _checkboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppConstants.radiusXS),
    ),
  );

  /// Radio theme
  static final RadioThemeData _radioTheme = RadioThemeData();

  /// Slider theme
  static final SliderThemeData _sliderTheme = SliderThemeData();
}

/// Custom theme colors extension for the "who can come" door status.
/// Matches the mockup's three status circles: green / amber / red,
/// consistent across light and dark mode.
extension CustomColors on ColorScheme {
  /// "Anyone can come" / "Friends can come" - open door status
  Color get statusOpen => const Color(0xFF25A55C);

  /// "Only one can come" - limited status
  Color get statusLimited => const Color(0xFFF0A93E);

  /// "No one can come" - closed door status
  Color get statusClosed => const Color(0xFFE5484D);
}
