import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color palette
  static const Color primary = Color(0xFF0A2540);
  static const Color accent = Color(0xFF00C896);
  static const Color danger = Color(0xFFFF4D4F);
  static const Color warning = Color(0xFFFFAB00);
  static const Color surface = Color(0xFFF7F8FA);
  static const Color cardBg = Color(0xFFFFFFFF);

  // Dark mode
  static const Color primaryDark = Color(0xFFE8EEF4);
  static const Color surfaceDark = Color(0xFF0D1117);
  static const Color cardDark = Color(0xFF161B22);
  static const Color accentDark = Color(0xFF00E5A8);

  // Semantic colors (kept for backward compat)
  static const Color incomeColor = accent;
  static const Color expenseColor = danger;
  static const Color transferColor = Color(0xFF1E88E5);
  static const Color primaryColor = primary;
  static const Color secondaryColor = accent;
  static const Color errorColor = danger;

  // Spacing system
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  // Text styles
  static TextStyle get balanceStyle => GoogleFonts.sora(
        fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle get sectionTitle => GoogleFonts.sora(
        fontSize: 18, fontWeight: FontWeight.w600);
  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 15, fontWeight: FontWeight.w600);
  static TextStyle get bodyText => GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.3);

  static ThemeData get light {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: accent,
        onSecondary: Colors.white,
        error: danger,
        onError: Colors.white,
        surface: surface,
        onSurface: primary,
        surfaceContainerHighest: const Color(0xFFEEF0F3),
        onSurfaceVariant: const Color(0xFF6B7280),
      ),
      scaffoldBackgroundColor: surface,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.sora(fontSize: 36, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w600),
        headlineSmall: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.3),
        labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 18, fontWeight: FontWeight.w600, color: primary),
        iconTheme: const IconThemeData(color: primary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0x0F000000), width: 1),
        ),
        margin: EdgeInsets.zero,
        shadowColor: const Color(0x0F000000),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF0F2F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accent, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF6B7280)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: const BorderSide(color: primary),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: cardBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: const Color(0x14000000),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? accent : const Color(0xFF9CA3AF),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? accent : const Color(0xFF9CA3AF), size: 22);
        }),
        indicatorColor: accent.withOpacity(0.12),
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        labelStyle: GoogleFonts.inter(fontSize: 13),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFF0F2F5), thickness: 1, space: 0),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
    return base.copyWith(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: primaryDark,
        onPrimary: surfaceDark,
        secondary: accentDark,
        onSecondary: surfaceDark,
        error: danger,
        onError: Colors.white,
        surface: surfaceDark,
        onSurface: primaryDark,
        surfaceContainerHighest: const Color(0xFF21262D),
        onSurfaceVariant: const Color(0xFF8B949E),
      ),
      scaffoldBackgroundColor: surfaceDark,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.sora(fontSize: 36, fontWeight: FontWeight.w700, color: primaryDark),
        headlineMedium: GoogleFonts.sora(fontSize: 24, fontWeight: FontWeight.w600, color: primaryDark),
        headlineSmall: GoogleFonts.sora(fontSize: 20, fontWeight: FontWeight.w600, color: primaryDark),
        titleLarge: GoogleFonts.sora(fontSize: 18, fontWeight: FontWeight.w600, color: primaryDark),
        titleMedium: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: primaryDark),
        bodyLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: primaryDark),
        bodyMedium: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: const Color(0xFFB8C2CC)),
        bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.3, color: const Color(0xFF8B949E)),
        labelSmall: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF8B949E)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.sora(
          fontSize: 18, fontWeight: FontWeight.w600, color: primaryDark),
        iconTheme: const IconThemeData(color: primaryDark),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0x1AFFFFFF), width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF21262D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.transparent, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentDark, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF8B949E)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentDark,
          foregroundColor: surfaceDark,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentDark,
        foregroundColor: surfaceDark,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: cardDark,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return GoogleFonts.inter(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? accentDark : const Color(0xFF8B949E),
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? accentDark : const Color(0xFF8B949E), size: 22);
        }),
        indicatorColor: accentDark.withOpacity(0.15),
        indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  static Color colorFromHex(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  static String hexFromColor(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }
}
