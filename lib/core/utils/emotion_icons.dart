import 'package:flutter/material.dart';

/// Sistema de ícones de emoções para feedback do usuário
class EmotionIcons {
  // Emoções básicas
  static const String sad = '😢'; // Triste
  static const String neutral = '😐'; // Normal/Neutro
  static const String happy = '😊'; // Alegre
  static const String veryHappy = '😄'; // Feliz
  static const String excited = '🤩'; // Muito feliz/Animado

  // Emoções adicionais para contexto educacional
  static const String curious = '🤔'; // Curioso/Pensando
  static const String proud = '😎'; // Orgulhoso/Confiante
  static const String surprised = '😮'; // Surpreso
  static const String worried = '😟'; // Preocupado
  static const String determined = '💪'; // Determinado
  static const String celebrating = '🎉'; // Comemorando

  /// Retorna o ícone de emoção baseado no resultado
  ///
  /// - accuracy < 0.5: Triste
  /// - accuracy < 0.7: Normal
  /// - accuracy < 0.9: Alegre
  /// - accuracy >= 0.9: Muito feliz
  static String getEmotionByAccuracy(double accuracy) {
    if (accuracy < 0.5) return sad;
    if (accuracy < 0.7) return neutral;
    if (accuracy < 0.9) return happy;
    return veryHappy;
  }

  /// Retorna o ícone de emoção baseado no XP ganho
  static String getEmotionByXP(int xp) {
    if (xp < 10) return neutral;
    if (xp < 20) return happy;
    if (xp < 50) return veryHappy;
    return excited;
  }

  /// Retorna o ícone de emoção baseado no nível
  static String getEmotionByLevel(int level) {
    if (level < 3) return neutral;
    if (level < 5) return happy;
    if (level < 7) return veryHappy;
    return excited;
  }
}

/// Widget para exibir ícone de emoção com tamanho customizável
class EmotionIcon extends StatelessWidget {
  final String emotion;
  final double size;

  const EmotionIcon({
    super.key,
    required this.emotion,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      emotion,
      style: TextStyle(fontSize: size),
    );
  }
}
