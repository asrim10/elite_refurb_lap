import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Core Palette
  static const Color primary = Color(0xFF050206);
  static const Color secondary = Color(0xFF3B3B3B);
  static const Color accent = Color(0xFF9A8174);
  static const Color white = Color(0xFFFFFFFF);

  // Surface Colors
  static const Color background = Color(0xFFF5F0EC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEDE8E4);
  static const Color surfaceTertiary = Color(0xFFE8E0D8);
  static const Color surfaceSubtle = Color(0xFFFAF7F5);
  static const Color inputFill = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF050206);
  static const Color textSecondary = Color(0xFF3B3B3B);
  static const Color textMuted = Color(0xFF6B5A50);
  static const Color textHint = Color(0xFF9A8174);
  static const Color textDisabled = Color(0xFFC4B0A4);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Border & Divider
  static const Color border = Color(0xFFE8E0D8);
  static const Color borderActive = Color(0xFFC4B0A4);
  static const Color borderStrong = Color(0xFF050206);
  static const Color borderAccent = Color(0xFF9A8174);
  static const Color divider = Color(0xFFF0EAE5);

  // Button Colors
  static const Color buttonPrimaryBg = Color(0xFF050206);
  static const Color buttonPrimaryFg = Color(0xFFFFFFFF);
  static const Color buttonOutlineBg = Color(0xFFFFFFFF);
  static const Color buttonOutlineFg = Color(0xFF050206);
  static const Color buttonGhostBg = Color(0xFFF5F0EC);
  static const Color buttonGhostFg = Color(0xFF3B3B3B);
  static const Color buttonAccentBg = Color(0xFF9A8174);
  static const Color buttonAccentFg = Color(0xFFFFFFFF);
  static const Color buttonDangerBg = Color(0xFF8A3030);
  static const Color buttonDangerFg = Color(0xFFFFFFFF);

  // Badge Colors - Verified
  static const Color badgeVerifiedBg = Color(0xFFF5F0EC);
  static const Color badgeVerifiedFg = Color(0xFF6B5A50);
  static const Color badgeVerifiedBorder = Color(0xFFC4B0A4);

  // Badge Colors - Good
  static const Color badgeGoodBg = Color(0xFFF0F5EC);
  static const Color badgeGoodFg = Color(0xFF4A6630);
  static const Color badgeGoodBorder = Color(0xFFB0C49A);

  // Badge Colors - Fair
  static const Color badgeFairBg = Color(0xFFFDF5EC);
  static const Color badgeFairFg = Color(0xFF7A5A20);
  static const Color badgeFairBorder = Color(0xFFDFC090);

  // Badge Colors - Sold
  static const Color badgeSoldBg = Color(0xFFF5ECEC);
  static const Color badgeSoldFg = Color(0xFF8A3030);
  static const Color badgeSoldBorder = Color(0xFFD4A0A0);

  // Badge Colors - Price Drop
  static const Color badgePriceDropBg = Color(0xFFFDF0E8);
  static const Color badgePriceDropFg = Color(0xFF7A4A20);
  static const Color badgePriceDropBorder = Color(0xFFDDB080);

  // Badge Colors - Pick-up Only
  static const Color badgePickupBg = Color(0xFFF0ECF5);
  static const Color badgePickupFg = Color(0xFF504070);
  static const Color badgePickupBorder = Color(0xFFB4A0CC);

  // Badge Colors - Count
  static const Color badgeCountBg = Color(0xFF050206);
  static const Color badgeCountFg = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF2D6A3F);
  static const Color successLight = Color(0xFFF0F5EC);
  static const Color warning = Color(0xFF7A4A20);
  static const Color warningLight = Color(0xFFFDF5EC);
  static const Color error = Color(0xFF8A3030);
  static const Color errorLight = Color(0xFFF5ECEC);
  static const Color info = Color(0xFF0C2E50);
  static const Color infoLight = Color(0xFFE8F0FA);

  // Modal & Overlay
  static const Color modalOverlay = Color(0x80050206);
  static const Color modalBg = Color(0xFFFFFFFF);
  static const Color modalDivider = Color(0xFFF0EAE5);
  static const Color sheetHandle = Color(0xFFE8E0D8);

  // Toast Colors
  static const Color toastWishlistBg = Color(0xFF1C4A2C);
  static const Color toastMessageBg = Color(0xFF050206);
  static const Color toastPriceDropBg = Color(0xFF5A3800);
  static const Color toastSoldBg = Color(0xFF0C2E50);
  static const Color toastTitleFg = Color(0xFFFFFFFF);
  static const Color toastSubtitleFg = Color(0xB3FFFFFF);
  static const Color toastCloseFg = Color(0x80FFFFFF);

  // Chat Bubble Colors
  static const Color bubbleTheirsBg = Color(0xFFF5F0EC);
  static const Color bubbleTheirsBorder = Color(0xFFE8E0D8);
  static const Color bubbleTheirsFg = Color(0xFF050206);
  static const Color bubbleMineBg = Color(0xFF050206);
  static const Color bubbleMineFg = Color(0xFFFFFFFF);

  // Bottom Navigation
  static const Color navBg = Color(0xFFFFFFFF);
  static const Color navBorder = Color(0xFFF0EAE5);
  static const Color navActiveColor = Color(0xFF050206);
  static const Color navActiveDot = Color(0xFF9A8174);
  static const Color navInactiveColor = Color(0x663B3B3B);

  // Star Rating
  static const Color starFilled = Color(0xFF9A8174);
  static const Color starEmpty = Color(0xFFE8E0D8);

  // Loading
  static const Color loadingTrack = Color(0xFFF0EAE5);
  static const Color loadingFill = Color(0xFF050206);

  // White with opacity
  static const Color white90 = Color(0xE6FFFFFF);
  static const Color white80 = Color(0xCCFFFFFF);
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color white20 = Color(0x33FFFFFF);

  // Black with opacity
  static const Color black20 = Color(0x33000000);
  static const Color black10 = Color(0x1A000000);

  // Accent with opacity
  static const Color accent60 = Color(0x999A8174);
  static const Color accent30 = Color(0x4D9A8174);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9A8174), Color(0xFF050206)],
  );

  static const LinearGradient loadingGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF9A8174), Color(0xFF050206)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF5F0EC), Color(0xFFFFFFFF)],
  );

  static const LinearGradient heroFadeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xFFFFFFFF)],
  );

  static const LinearGradient priceDropGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9A8174), Color(0xFF6B5A50)],
  );

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x0A050206), blurRadius: 8, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> cardShadowMd = [
    BoxShadow(color: Color(0x14050206), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(color: Color(0x1A050206), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> modalShadow = [
    BoxShadow(color: Color(0x29050206), blurRadius: 40, offset: Offset(0, 16)),
  ];

  static const List<BoxShadow> toastShadow = [
    BoxShadow(color: Color(0x33050206), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x08050206), blurRadius: 8, offset: Offset(0, 2)),
  ];

  // MaterialColor Swatch
  static const MaterialColor primarySwatch =
      MaterialColor(0xFF050206, <int, Color>{
        50: Color(0xFFF5F0EC),
        100: Color(0xFFE8E0D8),
        200: Color(0xFFC4B0A4),
        300: Color(0xFF9A8174),
        400: Color(0xFF6B5A50),
        500: Color(0xFF3B3B3B),
        600: Color(0xFF2C2C2C),
        700: Color(0xFF1E1E1E),
        800: Color(0xFF111111),
        900: Color(0xFF050206),
      });
}
