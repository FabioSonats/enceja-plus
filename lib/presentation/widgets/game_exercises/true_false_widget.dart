import 'package:flutter/material.dart';
import '../../../domain/entities/game_interface.dart';
import '../../../core/theme/app_theme.dart';

class TrueFalseWidget extends StatefulWidget {
  final GameQuestion question;
  final Function(String) onAnswer;

  const TrueFalseWidget({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  State<TrueFalseWidget> createState() => _TrueFalseWidgetState();
}

class _TrueFalseWidgetState extends State<TrueFalseWidget>
    with SingleTickerProviderStateMixin {
  String? _selectedAnswer;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pergunta
                Text(
                  widget.question.question,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textLight,
                  ),
                ),

                const SizedBox(height: 30),

                // Botões Verdadeiro/Falso
                Row(
                  children: [
                    Expanded(
                      child: _buildAnswerButton(
                        'Verdadeiro',
                        'V',
                        Icons.check_circle,
                        AppTheme.successColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildAnswerButton(
                        'Falso',
                        'F',
                        Icons.cancel,
                        AppTheme.errorColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerButton(
      String text, String letter, IconData icon, Color color) {
    final isSelected = _selectedAnswer == text;
    final isCorrect = text == widget.question.correctAnswer;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedAnswer = text;
        });
        widget.onAnswer(text);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? (isCorrect
                  ? color.withOpacity(0.1)
                  : AppTheme.errorColor.withOpacity(0.1))
              : AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (isCorrect ? color : AppTheme.errorColor)
                : color.withOpacity(0.3),
            width: 3,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? (isCorrect ? color : AppTheme.errorColor)
                    : color.withOpacity(0.3),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? (isCorrect ? color : AppTheme.errorColor)
                    : AppTheme.textLight,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color:
                      isCorrect ? AppTheme.successColor : AppTheme.errorColor,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
