import 'package:flutter/material.dart';

class KappaTheme {
  static ThemeData light({ThemeData? extension}) {
    final base = extension ?? ThemeData.light(useMaterial3: true);

    return base.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // Cấu hình phông chữ Web mượt mà hơn
      typography: Typography.material2021(),
      // Các config mặc định cho Web
      scrollbarTheme: base.scrollbarTheme.copyWith(
        thumbVisibility: const WidgetStatePropertyAll(true),
      ),
    );
  }

  static ThemeData dark({ThemeData? extension}) {
    final base = extension ?? ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      typography: Typography.material2021(),
      scrollbarTheme: base.scrollbarTheme.copyWith(
        thumbVisibility: const WidgetStatePropertyAll(true),
      ),
    );
  }
}
