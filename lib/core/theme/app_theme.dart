import 'package:flutter/material.dart';

class AppTheme {
  // ===========================================
  // CORES PRINCIPAIS DO SISTEMA
  // ===========================================

  // Cores primárias - Paleta principal (tons azuis baseados no onboarding)
  static const Color primaryColor =
      Color(0xFF4A90E2); // Azul principal (onboarding)
  static const Color secondaryColor =
      Color(0xFF5AC8FA); // Azul claro secundário
  static const Color accentColor = Color(0xFF2196F3); // Azul médio de destaque
  static const Color backgroundMedium =
      Color(0xFF2E4A6B); // Azul opaco intensidade média

  // Cores de status
  static const Color errorColor = Color(0xFFFF3B30); // Vermelho de erro
  static const Color warningColor = Color(0xFFFF9500); // Laranja de aviso
  static const Color successColor = Color(0xFF7ED321); // Verde de sucesso
  static const Color infoColor = Color(0xFF5AC8FA); // Azul de informação
  static const Color goldLight = Color(0xFFFFE135); // Dourado claro

  // ===========================================
  // CORES POR MATÉRIA - SISTEMA TEMÁTICO
  // ===========================================

  // Matemática - Azul e tons relacionados
  static const Color mathColor = Color(0xFF4A90E2);
  static const Color mathLight = Color(0xFFE3F2FD);
  static const Color mathDark = Color(0xFF1976D2);

  // Português - Verde e tons relacionados
  static const Color portugueseColor = Color(0xFF7ED321);
  static const Color portugueseLight = Color(0xFFE8F5E8);
  static const Color portugueseDark = Color(0xFF4CAF50);

  // Ciências - Roxo e tons relacionados
  static const Color scienceColor = Color(0xFF9C27B0);
  static const Color scienceLight = Color(0xFFF3E5F5);
  static const Color scienceDark = Color(0xFF7B1FA2);

  // História - Laranja e tons relacionados
  static const Color historyColor = Color(0xFFFF9800);
  static const Color historyLight = Color(0xFFFFF3E0);
  static const Color historyDark = Color(0xFFF57C00);

  // Geografia - Verde-azulado e tons relacionados
  static const Color geographyColor = Color(0xFF00BCD4);
  static const Color geographyLight = Color(0xFFE0F2F1);
  static const Color geographyDark = Color(0xFF0097A7);

  // Redação - Vermelho e tons relacionados
  static const Color essayColor = Color(0xFFE91E63);
  static const Color essayLight = Color(0xFFFCE4EC);
  static const Color essayDark = Color(0xFFC2185B);

  // ===========================================
  // CORES DE GAMIFICAÇÃO
  // ===========================================

  // Cores de gamificação - Tons azuis
  static const Color xpColor = Color(0xFF4A90E2); // Azul principal para XP
  static const Color levelColor = Color(0xFF2196F3); // Azul médio para nível
  static const Color achievementColor =
      Color(0xFF1976D2); // Azul escuro para conquista
  static const Color progressColor =
      Color(0xFF5AC8FA); // Azul claro para progresso
  static const Color streakColor =
      Color(0xFF0D47A1); // Azul muito escuro para sequência

  // ===========================================
  // CORES DE FUNDO E SUPERFÍCIE
  // ===========================================

  // Modo claro - Tons azuis suaves
  static const Color backgroundLight = Color(0xFF0D1B2A); // Azul muito escuro
  static const Color surfaceLight = Color(0xFFFFFFFF); // Branco
  static const Color surfaceVariantLight = Color(0xFFE8F4FD); // Azul bem claro
  static const Color textLight =
      Color(0xFF1A1A1A); // Preto suave para legibilidade
  static const Color textSecondaryLight =
      Color(0xFF4A5568); // Cinza azulado escuro

  // Modo escuro
  static const Color backgroundDark = Color(0xFF1C1C1E);
  static const Color surfaceDark = Color(0xFF2C2C2E);
  static const Color surfaceVariantDark = Color(0xFF3A3A3C);
  static const Color textDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF8E8E93);

  // ===========================================
  // CORES NEUTRAS E AUXILIARES
  // ===========================================

  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // ===========================================
  // MÉTODOS UTILITÁRIOS PARA CORES
  // ===========================================

  /// Retorna a cor da matéria especificada
  static Color getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'matemática':
      case 'matematica':
        return mathColor;
      case 'português':
      case 'portugues':
        return portugueseColor;
      case 'ciências':
      case 'ciencias':
        return scienceColor;
      case 'história':
      case 'historia':
        return historyColor;
      case 'geografia':
        return geographyColor;
      case 'redação':
      case 'redacao':
        return essayColor;
      default:
        return primaryColor;
    }
  }

  /// Retorna a cor clara da matéria especificada
  static Color getSubjectLightColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'matemática':
      case 'matematica':
        return mathLight;
      case 'português':
      case 'portugues':
        return portugueseLight;
      case 'ciências':
      case 'ciencias':
        return scienceLight;
      case 'história':
      case 'historia':
        return historyLight;
      case 'geografia':
        return geographyLight;
      case 'redação':
      case 'redacao':
        return essayLight;
      default:
        return neutral100;
    }
  }

  /// Retorna a cor escura da matéria especificada
  static Color getSubjectDarkColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'matemática':
      case 'matematica':
        return mathDark;
      case 'português':
      case 'portugues':
        return portugueseDark;
      case 'ciências':
      case 'ciencias':
        return scienceDark;
      case 'história':
      case 'historia':
        return historyDark;
      case 'geografia':
        return geographyDark;
      case 'redação':
      case 'redacao':
        return essayDark;
      default:
        return primaryColor;
    }
  }

  // ===========================================
  // GRADIENTES PREDEFINIDOS
  // ===========================================

  /// Gradiente principal do app - Tons azuis
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de matemática
  static const LinearGradient mathGradient = LinearGradient(
    colors: [mathColor, mathDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de português
  static const LinearGradient portugueseGradient = LinearGradient(
    colors: [portugueseColor, portugueseDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de ciências
  static const LinearGradient scienceGradient = LinearGradient(
    colors: [scienceColor, scienceDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de história
  static const LinearGradient historyGradient = LinearGradient(
    colors: [historyColor, historyDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de geografia
  static const LinearGradient geographyGradient = LinearGradient(
    colors: [geographyColor, geographyDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de redação
  static const LinearGradient essayGradient = LinearGradient(
    colors: [essayColor, essayDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de gamificação
  static const LinearGradient gamificationGradient = LinearGradient(
    colors: [xpColor, achievementColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradiente de fundo escuro
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [backgroundDark, surfaceDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Gradiente de fundo claro
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [backgroundLight, surfaceLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ===========================================
  // TEMAS DO MATERIAL DESIGN
  // ===========================================

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        surface: surfaceLight,
        background: backgroundLight,
        error: errorColor,
        onError: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      scaffoldBackgroundColor: backgroundLight,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: surfaceLight,
        shadowColor: neutral300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: neutral200, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: Colors.white70,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        surface: surfaceDark,
        background: backgroundDark,
        error: errorColor,
        onError: Colors.white,
        onSurface: textDark,
        onBackground: textDark,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceDark,
        foregroundColor: textDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        color: surfaceDark,
        shadowColor: neutral800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: neutral700, width: 1),
        ),
        margin: const EdgeInsets.all(8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neutral600),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: neutral600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textDark,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textDark,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: textDark,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: textDark,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: textDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: textDark,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: textDark,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: textDark,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: textDark,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: textSecondaryDark,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          color: textDark,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: textDark,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: textSecondaryDark,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
