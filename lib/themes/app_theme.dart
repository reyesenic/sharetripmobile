                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      import 'package:flutter/material.dart';

/// Extra colors that don't fit into Material's ColorScheme.
/// Read them anywhere with `context.st`.
@immutable
class ShareTripColors extends ThemeExtension<ShareTripColors> {
  const ShareTripColors({
    required this.background,
    required this.card,
    required this.text,
    required this.mutedText,
    required this.sectionLabel,
    required this.divider,
    required this.border,
    required this.iconButtonBg,
    required this.toggleOff,
    required this.primaryTint,
    required this.danger,
    required this.dangerBorder,
    required this.success,
    required this.successBg,
  });

  final Color background;
  final Color card;
  final Color text;
  final Color mutedText;
  final Color sectionLabel;
  final Color divider;
  final Color border;
  final Color iconButtonBg;
  final Color toggleOff;
  final Color primaryTint;
  final Color danger;
  final Color dangerBorder;
  final Color success;
  final Color successBg;

  static const light = ShareTripColors(
    background: Color(0xFFF6F7FE),
    card: Color(0xFFFFFFFF),
    text: Color(0xFF111827),
    mutedText: Color(0xFF7B8497),
    sectionLabel: Color(0xFF9AA3B5),
    divider: Color(0xFFF0F1F6),
    border: Color(0xFFE3E6EF),
    iconButtonBg: Color(0xFFEEF0F4),
    toggleOff: Color(0xFFE4E5EA),
    primaryTint: Color(0xFFEEF0FF),
    danger: Color(0xFFE5173F),
    dangerBorder: Color(0xFFFBCFD8),
    success: Color(0xFF0E9F6E),
    successBg: Color(0xFFE8F8F1),
  );

  static const dark = ShareTripColors(
    background: Color(0xFF0F111A),
    card: Color(0xFF1A1D29),
    text: Color(0xFFF3F4F8),
    mutedText: Color(0xFF9AA1B5),
    sectionLabel: Color(0xFF7C849A),
    divider: Color(0xFF262A38),
    border: Color(0xFF2C3142),
    iconButtonBg: Color(0xFF262A38),
    toggleOff: Color(0xFF3A3F52),
    primaryTint: Color(0xFF25244A),
    danger: Color(0xFFFF6B84),
    dangerBorder: Color(0xFF5A2A36),
    success: Color(0xFF34D399),
    successBg: Color(0xFF12372B),
  );

  @override
  ThemeExtension<ShareTripColors> copyWith() => this;

  @override
  ThemeExtension<ShareTripColors> lerp(
      ThemeExtension<ShareTripColors>? other, double t) {
    if (other is! ShareTripColors) return this;
    return t < 0.5 ? this : other;
  }
}

extension ShareTripThemeX on BuildContext {
  ShareTripColors get st => Theme.of(this).extension<ShareTripColors>()!;
}

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final c = isDark ? ShareTripColors.dark : ShareTripColors.light;
    final primary =
        isDark ? const Color(0xFF7062FF) : const Color(0xFF4F3CF2);

    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(primary: primary, surface: c.card);

    final baseText = (isDark ? ThemeData.dark() : ThemeData.light())
        .textTheme
        .apply(bodyColor: c.text, displayColor: c.text);

    final buttonShape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
    const buttonText = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.background,
      textTheme: baseText,
      extensions: [c],
      dividerColor: c.divider,
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? primary : c.toggleOff,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primary.withAlpha(110),
          disabledForegroundColor: Colors.white.withAlpha(235),
          minimumSize: const Size.fromHeight(52),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.text,
          side: BorderSide(color: c.border),
          minimumSize: const Size.fromHeight(52),
          shape: buttonShape,
          textStyle: buttonText,
        ),
      ),
      dialogTheme: DialogThemeData(backgroundColor: c.card),
    );
  }
}