import 'package:material_ui/material_ui.dart';

class AppColors {
  static const navy = Color(0xFF101B35);
  static const blue = Color(0xFF4169F5);
  static const turquoise = Color(0xFF16C6B3);
  static const background = Color(0xFFF5F7FC);
  static const secondary = Color(0xFF718096);
  static const purple = Color(0xFF8A63D2);
}

class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: brightness,
      primary: dark ? const Color(0xFF9EB2FF) : AppColors.blue,
      secondary: AppColors.turquoise,
      surface: dark ? const Color(0xFF18243B) : Colors.white,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Manrope',
    );
    return base.copyWith(
      splashFactory: InkRipple.splashFactory,
      scaffoldBackgroundColor: dark
          ? const Color(0xFF0E1729)
          : AppColors.background,
      textTheme: base.textTheme
          .apply(
            bodyColor: dark ? const Color(0xFFE7ECF8) : AppColors.navy,
            displayColor: dark ? Colors.white : AppColors.navy,
          )
          .copyWith(
            headlineLarge: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.25,
              letterSpacing: -1,
              color: dark ? Colors.white : AppColors.navy,
            ),
            titleLarge: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: dark ? Colors.white : AppColors.navy,
            ),
            titleMedium: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: dark ? Colors.white : AppColors.navy,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              height: 1.65,
              color: dark ? const Color(0xFFACBAD0) : AppColors.secondary,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? const Color(0xFF0E1729) : AppColors.background,
        foregroundColor: dark ? Colors.white : AppColors.navy,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: dark ? Colors.white : AppColors.navy,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: dark
                ? Colors.white.withValues(alpha: .07)
                : const Color(0xFFE9EDF5),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: dark ? Colors.white12 : const Color(0xFFEDF0F7),
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: dark ? Colors.white12 : const Color(0xFFE5EAF3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark ? const Color(0xFF344565) : AppColors.navy,
        contentTextStyle: const TextStyle(
          fontFamily: 'Manrope',
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        elevation: 0,
        backgroundColor: scheme.surface,
        indicatorColor: scheme.primary.withValues(alpha: .12),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w800
                : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
