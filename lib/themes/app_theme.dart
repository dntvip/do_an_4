import 'package:flutter/material.dart';

class HomeCookedTheme {
  // 🎨 Định nghĩa Palette màu sắc theo Material Design 3
  static const Color primary = Color(0xFF38B000); // Xanh lá đậm chính
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFC8EDA7); // Xanh lá nhạt hơn
  static const Color onPrimaryContainer = Color(0xFF002100);

  static const Color secondary = Color(0xFF008000); // Xanh lá mạ tươi sáng
  static const Color onSecondary = Colors.black;
  static const Color secondaryContainer = Color(0xFFD6F69D);
  static const Color onSecondaryContainer = Color(0xFF1E3300);

  static const Color tertiary = Color(0xFFFFA07A); // Cam đào
  static const Color onTertiary = Colors.black;
  static const Color tertiaryContainer = Color(0xFFFFDBCA);
  static const Color onTertiaryContainer = Color(0xFF4C0A00);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Colors.white;
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF410002);

  static const Color background = Color(0xFFE8F5E9); // Xanh lá cây rất nhạt
  static const Color onBackground = Colors.black;

  static const Color surface = Color(0xFFF0FDF0); // Màu nền cho các bề mặt
  static const Color onSurface = Colors.black87;
  static const Color surfaceVariant = Color(0xFFE2F3E2);
  static const Color onSurfaceVariant = Color(0xFF42473F);

  static const Color outline = Color(0xFF8B9284);
  static const Color shadow = Color(0xFF000000);
  static const Color inverseSurface = Color(0xFF2F312B);
  static const Color onInverseSurface = Color(0xFFF2F1E4);
  static const Color inversePrimary = Color(0xFFACD18D);
  static const Color scrim = Color(0xFF000000);

  static const Color customDarkGreenForAppBar = Color(0xFF004B23); // Màu xanh đậm riêng cho AppBar

  static const Color selectedItemLimeGreen = Color(0xFF9EF01A); // Màu xanh nõn chuối mong muốn


  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      // ✅ ĐÂY LÀ NƠI BẠN ĐẶT FONT CHỮ CHÍNH CHO TOÀN ỨNG DỤNG
      // Bỏ dòng này đi để dùng font mặc định của hệ thống (thường là Roboto trên Android, SF Pro trên iOS)
      // Hoặc đặt 'Roboto' nếu bạn đã thêm nó vào pubspec.yaml
      // fontFamily: 'Roboto',
      // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY ĐỂ DÙNG FONT NGHIÊM TÚC HƠN

      scaffoldBackgroundColor: background, // Sử dụng biến background mới

      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        background: background,
        onBackground: onBackground,
        surface: surface,
        onSurface: onSurface,
        surfaceVariant: surfaceVariant,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        shadow: shadow,
        inverseSurface: inverseSurface,
        onInverseSurface: onInverseSurface,
        inversePrimary: inversePrimary,
        scrim: scrim,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: customDarkGreenForAppBar,
        foregroundColor: onPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: onPrimary,
        ),
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: onPrimary,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          textStyle: const TextStyle(
            // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          textStyle: const TextStyle(
            // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(
            // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface,
        selectedColor: primary,
        disabledColor: Colors.grey.shade300,
        labelStyle: const TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          color: onSurface,
          fontSize: 14,
        ),
        secondaryLabelStyle: const TextStyle(color: onPrimary),
        brightness: Brightness.light,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        hintStyle: const TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          color: Colors.black38,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          color: primary,
          fontSize: 16,
        ),
        errorStyle: const TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          color: error,
          fontSize: 12,
        ),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: primary,
        selectedItemColor: selectedItemLimeGreen,
        unselectedItemColor: onPrimary,
        selectedIconTheme: IconThemeData(size: 28),
        unselectedIconTheme: IconThemeData(size: 24),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 11,
        ),
        elevation: 5,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: const TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: onBackground,
        ),
        contentTextStyle: const TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 16,
          color: onSurface,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: customDarkGreenForAppBar,
        contentTextStyle: const TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          color: onPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // ✅ CẬP NHẬT TOÀN BỘ TEXTTHEME CỦA BẠN VỚI FONT MỚI (MẶC ĐỊNH HỆ THỐNG)
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 57, fontWeight: FontWeight.normal, color: onBackground,
        ),
        displayMedium: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 45, fontWeight: FontWeight.normal, color: onBackground,
        ),
        displaySmall: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 36, fontWeight: FontWeight.normal, color: onBackground,
        ),

        headlineLarge: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 32, fontWeight: FontWeight.bold, color: onBackground,
        ),
        headlineMedium: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 28, fontWeight: FontWeight.w600, color: onBackground,
        ),
        headlineSmall: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 24, fontWeight: FontWeight.w500, color: onBackground,
        ),

        titleLarge: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 22, fontWeight: FontWeight.w500, color: onBackground,
        ),
        titleMedium: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 16, fontWeight: FontWeight.w600, color: onBackground,
        ),
        titleSmall: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 14, fontWeight: FontWeight.w500, color: onBackground,
        ),

        bodyLarge: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 16, color: onSurface,
        ),
        bodyMedium: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 14, color: onSurface,
        ),
        bodySmall: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 12, color: onSurface,
        ),

        labelLarge: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 14, fontWeight: FontWeight.w600, color: primary,
        ),
        labelMedium: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 12, fontWeight: FontWeight.w500, color: onSurface,
        ),
        labelSmall: TextStyle(
          // fontFamily: 'Borel', // ✅ ĐÃ XÓA/COMMENT DÒNG NÀY
          fontSize: 11, fontWeight: FontWeight.w400, color: onSurface,
        ),
      ),
    );
  }
}
