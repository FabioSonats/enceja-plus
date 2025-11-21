import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Estados emocionais do mascote
enum MascotEmotion {
  happy, // Feliz
  sad, // Triste
  curious, // Curioso
  excited, // Animado
  neutral, // Neutro
  proud, // Orgulhoso
  thinking, // Pensando
  celebrating, // Comemorando
}

/// Widget principal do mascote do app
class AppMascot extends StatelessWidget {
  final MascotEmotion emotion;
  final double size;
  final bool animated;

  const AppMascot({
    super.key,
    this.emotion = MascotEmotion.happy,
    this.size = 120.0,
    this.animated = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: MascotPainter(
          emotion: emotion,
          animated: animated,
        ),
      ),
    );
  }
}

/// Painter customizado para desenhar o mascote
class MascotPainter extends CustomPainter {
  final MascotEmotion emotion;
  final bool animated;

  MascotPainter({
    required this.emotion,
    this.animated = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Cores baseadas na emoção
    final colors = _getColorsForEmotion(emotion);

    // Desenhar cabeça (círculo principal)
    _drawHead(canvas, center, radius, colors);

    // Desenhar rosto baseado na emoção
    _drawFace(canvas, center, radius, emotion, colors);

    // Desenhar corpo (livro/caderno)
    _drawBody(canvas, center, radius, colors);

    // Desenhar detalhes adicionais baseados na emoção
    _drawEmotionDetails(canvas, center, radius, emotion, colors);
  }

  void _drawHead(
      Canvas canvas, Offset center, double radius, MascotColors colors) {
    // Cabeça principal
    final headPaint = Paint()
      ..color = colors.primaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.4, headPaint);

    // Contorno da cabeça
    final outlinePaint = Paint()
      ..color = colors.outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius * 0.4, outlinePaint);
  }

  void _drawFace(Canvas canvas, Offset center, double radius,
      MascotEmotion emotion, MascotColors colors) {
    final eyeY = center.dy - radius * 0.1;
    final eyeSpacing = radius * 0.15;
    final leftEye = Offset(center.dx - eyeSpacing, eyeY);
    final rightEye = Offset(center.dx + eyeSpacing, eyeY);

    // Olhos
    switch (emotion) {
      case MascotEmotion.happy:
      case MascotEmotion.excited:
      case MascotEmotion.celebrating:
        // Olhos fechados (feliz)
        _drawHappyEyes(canvas, leftEye, rightEye, radius, colors);
        break;
      case MascotEmotion.sad:
        // Olhos tristes
        _drawSadEyes(canvas, leftEye, rightEye, radius, colors);
        break;
      case MascotEmotion.curious:
      case MascotEmotion.thinking:
        // Olhos curiosos/pensativos
        _drawCuriousEyes(canvas, leftEye, rightEye, radius, colors);
        break;
      case MascotEmotion.proud:
        // Olhos orgulhosos
        _drawProudEyes(canvas, leftEye, rightEye, radius, colors);
        break;
      default:
        // Olhos neutros
        _drawNeutralEyes(canvas, leftEye, rightEye, radius, colors);
    }

    // Boca
    _drawMouth(canvas, center, radius, emotion, colors);
  }

  void _drawHappyEyes(Canvas canvas, Offset leftEye, Offset rightEye,
      double radius, MascotColors colors) {
    final eyePaint = Paint()
      ..color = colors.eyeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Olhos fechados (linhas curvas)
    canvas.drawArc(
      Rect.fromCircle(center: leftEye, radius: radius * 0.08),
      -0.5,
      1.0,
      false,
      eyePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: rightEye, radius: radius * 0.08),
      -0.5,
      1.0,
      false,
      eyePaint,
    );
  }

  void _drawSadEyes(Canvas canvas, Offset leftEye, Offset rightEye,
      double radius, MascotColors colors) {
    final eyePaint = Paint()
      ..color = colors.eyeColor
      ..style = PaintingStyle.fill;

    // Olhos abertos com lágrimas
    canvas.drawCircle(leftEye, radius * 0.06, eyePaint);
    canvas.drawCircle(rightEye, radius * 0.06, eyePaint);

    // Lágrimas
    final tearPaint = Paint()
      ..color = colors.accentColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(leftEye.dx, leftEye.dy + radius * 0.1),
      radius * 0.03,
      tearPaint,
    );
    canvas.drawCircle(
      Offset(rightEye.dx, rightEye.dy + radius * 0.1),
      radius * 0.03,
      tearPaint,
    );
  }

  void _drawCuriousEyes(Canvas canvas, Offset leftEye, Offset rightEye,
      double radius, MascotColors colors) {
    final eyePaint = Paint()
      ..color = colors.eyeColor
      ..style = PaintingStyle.fill;

    // Olhos grandes e arredondados
    canvas.drawCircle(leftEye, radius * 0.08, eyePaint);
    canvas.drawCircle(rightEye, radius * 0.08, eyePaint);

    // Brilho nos olhos
    final shinePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(leftEye.dx - radius * 0.02, leftEye.dy - radius * 0.02),
      radius * 0.02,
      shinePaint,
    );
    canvas.drawCircle(
      Offset(rightEye.dx - radius * 0.02, rightEye.dy - radius * 0.02),
      radius * 0.02,
      shinePaint,
    );
  }

  void _drawProudEyes(Canvas canvas, Offset leftEye, Offset rightEye,
      double radius, MascotColors colors) {
    final eyePaint = Paint()
      ..color = colors.eyeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Olhos semi-fechados (orgulhosos)
    canvas.drawArc(
      Rect.fromCircle(center: leftEye, radius: radius * 0.07),
      -0.3,
      0.6,
      false,
      eyePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: rightEye, radius: radius * 0.07),
      -0.3,
      0.6,
      false,
      eyePaint,
    );
  }

  void _drawNeutralEyes(Canvas canvas, Offset leftEye, Offset rightEye,
      double radius, MascotColors colors) {
    final eyePaint = Paint()
      ..color = colors.eyeColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(leftEye, radius * 0.06, eyePaint);
    canvas.drawCircle(rightEye, radius * 0.06, eyePaint);
  }

  void _drawMouth(Canvas canvas, Offset center, double radius,
      MascotEmotion emotion, MascotColors colors) {
    final mouthY = center.dy + radius * 0.15;
    final mouthPaint = Paint()
      ..color = colors.mouthColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    switch (emotion) {
      case MascotEmotion.happy:
      case MascotEmotion.excited:
      case MascotEmotion.celebrating:
        // Boca feliz (arco para cima)
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY),
            width: radius * 0.3,
            height: radius * 0.2,
          ),
          0,
          math.pi,
          false,
          mouthPaint,
        );
        break;
      case MascotEmotion.sad:
        // Boca triste (arco para baixo)
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, mouthY + radius * 0.1),
            width: radius * 0.3,
            height: radius * 0.2,
          ),
          math.pi,
          math.pi,
          false,
          mouthPaint,
        );
        break;
      case MascotEmotion.curious:
      case MascotEmotion.thinking:
        // Boca "O" (curioso)
        canvas.drawCircle(
          Offset(center.dx, mouthY),
          radius * 0.05,
          Paint()
            ..color = colors.mouthColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );
        break;
      default:
        // Boca neutra (linha reta)
        canvas.drawLine(
          Offset(center.dx - radius * 0.15, mouthY),
          Offset(center.dx + radius * 0.15, mouthY),
          mouthPaint,
        );
    }
  }

  void _drawBody(
      Canvas canvas, Offset center, double radius, MascotColors colors) {
    // Corpo: livro/caderno aberto
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * 0.5),
        width: radius * 0.6,
        height: radius * 0.4,
      ),
      const Radius.circular(8),
    );

    final bodyPaint = Paint()
      ..color = colors.bodyColor
      ..style = PaintingStyle.fill;

    canvas.drawRRect(bodyRect, bodyPaint);

    // Contorno do corpo
    final outlinePaint = Paint()
      ..color = colors.outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(bodyRect, outlinePaint);

    // Linhas do caderno
    final linePaint = Paint()
      ..color = colors.accentColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 3; i++) {
      final lineY = center.dy + radius * 0.4 + (i * radius * 0.08);
      canvas.drawLine(
        Offset(center.dx - radius * 0.25, lineY),
        Offset(center.dx + radius * 0.25, lineY),
        linePaint,
      );
    }
  }

  void _drawEmotionDetails(Canvas canvas, Offset center, double radius,
      MascotEmotion emotion, MascotColors colors) {
    switch (emotion) {
      case MascotEmotion.excited:
      case MascotEmotion.celebrating:
        // Estrelas ao redor
        _drawStars(canvas, center, radius, colors);
        break;
      case MascotEmotion.thinking:
        // Linhas de pensamento
        _drawThoughtLines(canvas, center, radius, colors);
        break;
      default:
        break;
    }
  }

  void _drawStars(
      Canvas canvas, Offset center, double radius, MascotColors colors) {
    final starPaint = Paint()
      ..color = colors.accentColor
      ..style = PaintingStyle.fill;

    // Estrelas pequenas ao redor
    final positions = [
      Offset(center.dx - radius * 0.5, center.dy - radius * 0.3),
      Offset(center.dx + radius * 0.5, center.dy - radius * 0.2),
      Offset(center.dx - radius * 0.4, center.dy + radius * 0.1),
    ];

    for (final pos in positions) {
      _drawStar(canvas, pos, radius * 0.05, starPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawThoughtLines(
      Canvas canvas, Offset center, double radius, MascotColors colors) {
    final thoughtPaint = Paint()
      ..color = colors.outlineColor.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Círculos de pensamento
    final thoughtCenter =
        Offset(center.dx + radius * 0.3, center.dy - radius * 0.4);
    canvas.drawCircle(thoughtCenter, radius * 0.08, thoughtPaint);
    canvas.drawCircle(
      Offset(thoughtCenter.dx + radius * 0.1, thoughtCenter.dy - radius * 0.1),
      radius * 0.06,
      thoughtPaint,
    );
    canvas.drawCircle(
      Offset(
          thoughtCenter.dx + radius * 0.15, thoughtCenter.dy - radius * 0.15),
      radius * 0.04,
      thoughtPaint,
    );
  }

  MascotColors _getColorsForEmotion(MascotEmotion emotion) {
    switch (emotion) {
      case MascotEmotion.happy:
      case MascotEmotion.excited:
      case MascotEmotion.celebrating:
        return MascotColors(
          primaryColor: AppTheme.primaryColor,
          bodyColor: AppTheme.surfaceLight,
          eyeColor: Colors.black,
          mouthColor: Colors.black,
          accentColor: AppTheme.goldLight,
          outlineColor: AppTheme.primaryColor.withOpacity(0.8),
        );
      case MascotEmotion.sad:
        return MascotColors(
          primaryColor: AppTheme.primaryColor.withOpacity(0.7),
          bodyColor: AppTheme.surfaceLight.withOpacity(0.8),
          eyeColor: Colors.black,
          mouthColor: Colors.black,
          accentColor: AppTheme.errorColor,
          outlineColor: AppTheme.primaryColor.withOpacity(0.6),
        );
      case MascotEmotion.curious:
      case MascotEmotion.thinking:
        return MascotColors(
          primaryColor: AppTheme.primaryColor,
          bodyColor: AppTheme.surfaceLight,
          eyeColor: Colors.black,
          mouthColor: Colors.black,
          accentColor: AppTheme.infoColor,
          outlineColor: AppTheme.primaryColor.withOpacity(0.8),
        );
      case MascotEmotion.proud:
        return MascotColors(
          primaryColor: AppTheme.primaryColor,
          bodyColor: AppTheme.surfaceLight,
          eyeColor: Colors.black,
          mouthColor: Colors.black,
          accentColor: AppTheme.goldLight,
          outlineColor: AppTheme.primaryColor.withOpacity(0.8),
        );
      default:
        return MascotColors(
          primaryColor: AppTheme.primaryColor,
          bodyColor: AppTheme.surfaceLight,
          eyeColor: Colors.black,
          mouthColor: Colors.black,
          accentColor: AppTheme.secondaryColor,
          outlineColor: AppTheme.primaryColor.withOpacity(0.8),
        );
    }
  }

  @override
  bool shouldRepaint(MascotPainter oldDelegate) {
    return oldDelegate.emotion != emotion || oldDelegate.animated != animated;
  }
}

/// Cores do mascote
class MascotColors {
  final Color primaryColor;
  final Color bodyColor;
  final Color eyeColor;
  final Color mouthColor;
  final Color accentColor;
  final Color outlineColor;

  MascotColors({
    required this.primaryColor,
    required this.bodyColor,
    required this.eyeColor,
    required this.mouthColor,
    required this.accentColor,
    required this.outlineColor,
  });
}
