import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Constantes de cores organizadas por categoria para facilitar o uso
class ColorConstants {
  // ===========================================
  // CORES PRINCIPAIS
  // ===========================================
  
  static const Color primary = AppTheme.primaryColor;
  static const Color secondary = AppTheme.secondaryColor;
  static const Color accent = AppTheme.accentColor;
  
  // ===========================================
  // CORES DE STATUS
  // ===========================================
  
  static const Color success = AppTheme.successColor;
  static const Color error = AppTheme.errorColor;
  static const Color warning = AppTheme.warningColor;
  static const Color info = AppTheme.infoColor;
  
  // ===========================================
  // CORES POR MATÉRIA
  // ===========================================
  
  static const Color math = AppTheme.mathColor;
  static const Color portuguese = AppTheme.portugueseColor;
  static const Color science = AppTheme.scienceColor;
  static const Color history = AppTheme.historyColor;
  static const Color geography = AppTheme.geographyColor;
  static const Color essay = AppTheme.essayColor;
  
  // ===========================================
  // CORES DE GAMIFICAÇÃO
  // ===========================================
  
  static const Color xp = AppTheme.xpColor;
  static const Color level = AppTheme.levelColor;
  static const Color achievement = AppTheme.achievementColor;
  static const Color progress = AppTheme.progressColor;
  static const Color streak = AppTheme.streakColor;
  
  // ===========================================
  // CORES DE FUNDO
  // ===========================================
  
  static const Color backgroundLight = AppTheme.backgroundLight;
  static const Color backgroundDark = AppTheme.backgroundDark;
  static const Color surfaceLight = AppTheme.surfaceLight;
  static const Color surfaceDark = AppTheme.surfaceDark;
  
  // ===========================================
  // CORES DE TEXTO
  // ===========================================
  
  static const Color textLight = AppTheme.textLight;
  static const Color textDark = AppTheme.textDark;
  static const Color textSecondaryLight = AppTheme.textSecondaryLight;
  static const Color textSecondaryDark = AppTheme.textSecondaryDark;
  
  // ===========================================
  // CORES NEUTRAS
  // ===========================================
  
  static const Color neutral50 = AppTheme.neutral50;
  static const Color neutral100 = AppTheme.neutral100;
  static const Color neutral200 = AppTheme.neutral200;
  static const Color neutral300 = AppTheme.neutral300;
  static const Color neutral400 = AppTheme.neutral400;
  static const Color neutral500 = AppTheme.neutral500;
  static const Color neutral600 = AppTheme.neutral600;
  static const Color neutral700 = AppTheme.neutral700;
  static const Color neutral800 = AppTheme.neutral800;
  static const Color neutral900 = AppTheme.neutral900;
  
  // ===========================================
  // MÉTODOS UTILITÁRIOS
  // ===========================================
  
  /// Retorna a cor da matéria
  static Color getSubjectColor(String subject) => AppTheme.getSubjectColor(subject);
  
  /// Retorna a cor clara da matéria
  static Color getSubjectLightColor(String subject) => AppTheme.getSubjectLightColor(subject);
  
  /// Retorna a cor escura da matéria
  static Color getSubjectDarkColor(String subject) => AppTheme.getSubjectDarkColor(subject);
  
  /// Retorna o gradiente da matéria
  static LinearGradient getSubjectGradient(String subject) {
    switch (subject.toLowerCase()) {
      case 'matemática':
      case 'matematica':
        return AppTheme.mathGradient;
      case 'português':
      case 'portugues':
        return AppTheme.portugueseGradient;
      case 'ciências':
      case 'ciencias':
        return AppTheme.scienceGradient;
      case 'história':
      case 'historia':
        return AppTheme.historyGradient;
      case 'geografia':
        return AppTheme.geographyGradient;
      case 'redação':
      case 'redacao':
        return AppTheme.essayGradient;
      default:
        return AppTheme.primaryGradient;
    }
  }
  
  /// Retorna cor com opacidade
  static Color withOpacity(Color color, double opacity) => color.withOpacity(opacity);
  
  /// Retorna cor mais clara
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
  
  /// Retorna cor mais escura
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
