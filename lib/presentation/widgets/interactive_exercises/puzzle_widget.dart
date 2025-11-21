import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

class PuzzleWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(String) onAnswer;
  final Function() onComplete;

  const PuzzleWidget({
    super.key,
    required this.data,
    required this.onAnswer,
    required this.onComplete,
  });

  @override
  State<PuzzleWidget> createState() => _PuzzleWidgetState();
}

class _PuzzleWidgetState extends State<PuzzleWidget> {
  String? _selectedAnswer;
  bool _isCompleted = false;
  String _correctAnswer = '';
  List<Map<String, dynamic>> _pieces = [];

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
  }

  void _initializePuzzle() {
    _pieces = List<Map<String, dynamic>>.from(widget.data['pieces']);
    _calculateCorrectAnswer();
  }

  void _calculateCorrectAnswer() {
    final numbers = _pieces
        .where((p) => p['text'] != '?' && p['text'] != '+' && p['text'] != '=')
        .map((p) => int.tryParse(p['text']) ?? 0)
        .toList();

    if (numbers.length >= 2) {
      _correctAnswer = (numbers[0] + numbers[1]).toString();
    }
  }

  void _selectAnswer(String answer) {
    if (_isCompleted) return;

    setState(() {
      _selectedAnswer = answer;
    });
    HapticFeedback.lightImpact();
  }

  void _checkAnswer() {
    if (_isCompleted || _selectedAnswer == null) return;

    setState(() {
      _isCompleted = true;
    });

    if (_selectedAnswer == _correctAnswer) {
      HapticFeedback.heavyImpact();
      widget.onAnswer('Correto! ✅');
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          widget.onComplete();
        }
      });
    } else {
      HapticFeedback.vibrate();
      widget.onAnswer('Incorreto. Tente novamente! ❌');
    }
  }

  List<String> _generateAnswerOptions() {
    final options = <String>[];
    options.add(_correctAnswer);

    final wrongOptions = [
      int.parse(_correctAnswer) + 1,
      int.parse(_correctAnswer) - 1,
      int.parse(_correctAnswer) + 2,
      int.parse(_correctAnswer) - 2,
    ].where((n) => n > 0 && n.toString() != _correctAnswer).take(3).toList();

    options.addAll(wrongOptions.map((n) => n.toString()));
    options.shuffle();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        Text(
          widget.data['question'] ?? 'Complete a sequência:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLight,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // Sequência dinâmica baseada nos dados
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _pieces.map((piece) {
              final isQuestionMark = piece['text'] == '?';
              final isRevealed = piece['isRevealed'] == true;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _buildNumberBox(
                  isRevealed
                      ? _correctAnswer
                      : (isQuestionMark ? '?' : piece['text']),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 30),

        Text(
          'Qual número completa a sequência?',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textLight,
          ),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _generateAnswerOptions().map((option) {
            final isSelected = _selectedAnswer == option;
            return GestureDetector(
              onTap: _isCompleted ? null : () => _selectAnswer(option),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.primaryColor : AppTheme.surfaceLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppTheme.textLight,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 30),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedAnswer = null;
                  _isCompleted = false;
                });
                widget.onAnswer('Quebra-cabeça reiniciado.');
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed:
                  _selectedAnswer == null || _isCompleted ? null : _checkAnswer,
              icon: const Icon(Icons.check),
              label: const Text('Verificar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberBox(String text) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: text == '?'
            ? Colors.grey.withOpacity(0.1)
            : AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: text == '?' ? Colors.grey : AppTheme.primaryColor,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: text == '?' ? Colors.white : Colors.white,
          ),
        ),
      ),
    );
  }
}
