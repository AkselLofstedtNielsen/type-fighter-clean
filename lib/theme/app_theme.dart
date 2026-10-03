import 'package:material_ui/material_ui.dart';

class AppTheme {
  static const purple = Color(0xFFBF5AF2);
  static const backgroundTop = Color(0xFF1A1A2E);
  static const backgroundBottom = Color(0xFF16213E);
  static const topBar = Color(0xFF0F3460);
  static const deadLine = Color(0xFFFF453A);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundTop, backgroundBottom],
  );

  static final dark = _dark();

  static ThemeData _dark() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: purple, brightness: .dark, dynamicSchemeVariant: .fidelity),
      fontFamily: 'Nunito',
    );
    final colorScheme = base.colorScheme;
    final textTheme = base.textTheme;
    final rounded = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

    return base.copyWith(
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: Colors.white,
          minimumSize: const Size(64, 52),
          shape: rounded,
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: .w800),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          minimumSize: const Size(0, 44),
          textStyle: textTheme.labelLarge?.copyWith(fontWeight: .w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withValues(alpha: 0.6), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        titleTextStyle: textTheme.headlineSmall?.copyWith(fontWeight: .w800),
      ),
    );
  }
}
