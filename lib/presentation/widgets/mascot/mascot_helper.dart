import 'package:flutter/material.dart';
import 'app_mascot.dart';

/// Helper para facilitar o uso do mascote em diferentes contextos
class MascotHelper {
  /// Retorna a emoção apropriada para diálogos de confirmação
  static MascotEmotion getEmotionForConfirmation() {
    return MascotEmotion.curious;
  }

  /// Retorna a emoção apropriada para desistências/cancelamentos
  static MascotEmotion getEmotionForQuit() {
    return MascotEmotion.sad;
  }

  /// Retorna a emoção apropriada para sucessos
  static MascotEmotion getEmotionForSuccess() {
    return MascotEmotion.happy;
  }

  /// Retorna a emoção apropriada para celebrações
  static MascotEmotion getEmotionForCelebration() {
    return MascotEmotion.celebrating;
  }

  /// Retorna a emoção apropriada para erros
  static MascotEmotion getEmotionForError() {
    return MascotEmotion.sad;
  }

  /// Retorna a emoção apropriada baseada no XP ganho
  static MascotEmotion getEmotionByXP(int xp) {
    if (xp < 10) return MascotEmotion.neutral;
    if (xp < 20) return MascotEmotion.happy;
    if (xp < 50) return MascotEmotion.excited;
    return MascotEmotion.celebrating;
  }

  /// Retorna a emoção apropriada baseada na precisão
  static MascotEmotion getEmotionByAccuracy(double accuracy) {
    if (accuracy < 0.5) return MascotEmotion.sad;
    if (accuracy < 0.7) return MascotEmotion.neutral;
    if (accuracy < 0.9) return MascotEmotion.happy;
    return MascotEmotion.excited;
  }

  /// Widget do mascote para diálogos
  static Widget dialogMascot(MascotEmotion emotion) {
    return const AppMascot(
      emotion: MascotEmotion.curious,
      size: 80.0,
      animated: true,
    );
  }

  /// Widget do mascote para tela de sucesso
  static Widget successMascot() {
    return const AppMascot(
      emotion: MascotEmotion.celebrating,
      size: 150.0,
      animated: true,
    );
  }

  /// Widget do mascote para tela de erro
  static Widget errorMascot() {
    return const AppMascot(
      emotion: MascotEmotion.sad,
      size: 120.0,
      animated: true,
    );
  }
}

