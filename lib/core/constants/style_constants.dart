import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'color_constants.dart';

/// Constantes de estilos predefinidos para facilitar o uso
class StyleConstants {
  // ===========================================
  // BORDAS E BORDER RADIUS
  // ===========================================
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusCircular = 50.0;
  
  // ===========================================
  // ESPAÇAMENTOS
  // ===========================================
  
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // ===========================================
  // ELEVAÇÕES
  // ===========================================
  
  static const double elevationNone = 0.0;
  static const double elevationSmall = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationLarge = 8.0;
  static const double elevationXLarge = 16.0;
  
  // ===========================================
  // TAMANHOS DE FONTE
  // ===========================================
  
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeXXXL = 24.0;
  static const double fontSizeDisplay = 32.0;
  
  // ===========================================
  // PESOS DE FONTE
  // ===========================================
  
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightExtraBold = FontWeight.w800;
  
  // ===========================================
  // ESTILOS DE TEXTO PREDEFINIDOS
  // ===========================================
  
  static const TextStyle heading1 = TextStyle(
    fontSize: fontSizeDisplay,
    fontWeight: fontWeightBold,
    color: ColorConstants.textLight,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: fontSizeXXXL,
    fontWeight: fontWeightBold,
    color: ColorConstants.textLight,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: fontSizeXXL,
    fontWeight: fontWeightSemiBold,
    color: ColorConstants.textLight,
  );
  
  static const TextStyle heading4 = TextStyle(
    fontSize: fontSizeXL,
    fontWeight: fontWeightSemiBold,
    color: ColorConstants.textLight,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSizeL,
    fontWeight: fontWeightNormal,
    color: ColorConstants.textLight,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSizeM,
    fontWeight: fontWeightNormal,
    color: ColorConstants.textLight,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSizeS,
    fontWeight: fontWeightNormal,
    color: ColorConstants.textSecondaryLight,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: fontSizeXS,
    fontWeight: fontWeightNormal,
    color: ColorConstants.textSecondaryLight,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: fontSizeL,
    fontWeight: fontWeightSemiBold,
    color: Colors.white,
  );
  
  static const TextStyle link = TextStyle(
    fontSize: fontSizeM,
    fontWeight: fontWeightMedium,
    color: ColorConstants.primary,
    decoration: TextDecoration.underline,
  );
  
  // ===========================================
  // ESTILOS DE CARD PREDEFINIDOS
  // ===========================================
  
  static BoxDecoration cardDecoration = BoxDecoration(
    color: ColorConstants.surfaceLight,
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [
      BoxShadow(
        color: ColorConstants.neutral300,
        blurRadius: elevationSmall,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  static BoxDecoration cardDecorationDark = BoxDecoration(
    color: ColorConstants.surfaceDark,
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [
      BoxShadow(
        color: ColorConstants.neutral800,
        blurRadius: elevationSmall,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  // ===========================================
  // ESTILOS DE BOTÃO PREDEFINIDOS
  // ===========================================
  
  static ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: ColorConstants.primary,
    foregroundColor: Colors.white,
    elevation: elevationSmall,
    shadowColor: ColorConstants.primary.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingM,
    ),
    textStyle: button,
  );
  
  static ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: ColorConstants.surfaceLight,
    foregroundColor: ColorConstants.primary,
    elevation: elevationSmall,
    shadowColor: ColorConstants.neutral300,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      side: const BorderSide(color: ColorConstants.primary),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingM,
    ),
    textStyle: button.copyWith(color: ColorConstants.primary),
  );
  
  static ButtonStyle successButton = ElevatedButton.styleFrom(
    backgroundColor: ColorConstants.success,
    foregroundColor: Colors.white,
    elevation: elevationSmall,
    shadowColor: ColorConstants.success.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingM,
    ),
    textStyle: button,
  );
  
  static ButtonStyle errorButton = ElevatedButton.styleFrom(
    backgroundColor: ColorConstants.error,
    foregroundColor: Colors.white,
    elevation: elevationSmall,
    shadowColor: ColorConstants.error.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingL,
      vertical: spacingM,
    ),
    textStyle: button,
  );
  
  // ===========================================
  // ESTILOS DE INPUT PREDEFINIDOS
  // ===========================================
  
  static InputDecoration inputDecoration = InputDecoration(
    filled: true,
    fillColor: ColorConstants.surfaceLight,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: const BorderSide(color: ColorConstants.neutral300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: const BorderSide(color: ColorConstants.neutral300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: const BorderSide(color: ColorConstants.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
      borderSide: const BorderSide(color: ColorConstants.error, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: spacingM,
      vertical: spacingM,
    ),
  );
  
  // ===========================================
  // ESTILOS DE GRADIENTE PREDEFINIDOS
  // ===========================================
  
  static const LinearGradient primaryGradient = AppTheme.primaryGradient;
  static const LinearGradient mathGradient = AppTheme.mathGradient;
  static const LinearGradient portugueseGradient = AppTheme.portugueseGradient;
  static const LinearGradient scienceGradient = AppTheme.scienceGradient;
  static const LinearGradient historyGradient = AppTheme.historyGradient;
  static const LinearGradient geographyGradient = AppTheme.geographyGradient;
  static const LinearGradient essayGradient = AppTheme.essayGradient;
  static const LinearGradient gamificationGradient = AppTheme.gamificationGradient;
  
  // ===========================================
  // MÉTODOS UTILITÁRIOS
  // ===========================================
  
  /// Retorna o estilo de card para uma matéria específica
  static BoxDecoration getSubjectCardDecoration(String subject, {bool isDark = false}) {
    final color = ColorConstants.getSubjectColor(subject);
    return BoxDecoration(
      color: isDark ? ColorConstants.surfaceDark : ColorConstants.surfaceLight,
      borderRadius: BorderRadius.circular(radiusLarge),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: elevationMedium,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  /// Retorna o estilo de botão para uma matéria específica
  static ButtonStyle getSubjectButtonStyle(String subject) {
    final color = ColorConstants.getSubjectColor(subject);
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      elevation: elevationSmall,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMedium),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: spacingL,
        vertical: spacingM,
      ),
      textStyle: button,
    );
  }
}
