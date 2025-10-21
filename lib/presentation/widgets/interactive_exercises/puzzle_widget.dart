import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../celebration_widget.dart';

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
  List<Map<String, dynamic>> _pieces = [];
  String? _selectedAnswer;
  bool _isCompleted = false;
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
  }

  void _initializePuzzle() {
    _pieces = List<Map<String, dynamic>>.from(widget.data['pieces']);
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
    });
    // Som de seleção
    HapticFeedback.lightImpact();
  }

  void _playSuccessSound() {
    // Simular som de sucesso com vibração
    HapticFeedback.heavyImpact();
  }

  void _playErrorSound() {
    // Simular som de erro com vibração
    HapticFeedback.vibrate();
  }

  void _checkAnswer() {
    // Lógica mais interessante: soma dos números anteriores
    final correctAnswer = _calculateCorrectAnswer();

    if (_selectedAnswer == correctAnswer.toString()) {
      _playSuccessSound();
      setState(() {
        _isCompleted = true;
        _showCelebration = true;
      });

      // Revelar o número correto
      for (int i = 0; i < _pieces.length; i++) {
        if (_pieces[i]['text'] == '?') {
          _pieces[i]['text'] = correctAnswer.toString();
          _pieces[i]['isRevealed'] = true;
          break;
        }
      }

      widget.onAnswer('Parabéns! Resposta correta!');

      // Mostrar celebração e completar
      Future.delayed(const Duration(seconds: 2), () {
        widget.onComplete();
      });
    } else {
      _playErrorSound();
      widget.onAnswer('Resposta incorreta. Tente novamente!');
    }
  }

  int _calculateCorrectAnswer() {
    // Lógica: soma dos dois números da operação (2 + 3 = 5)
    final numbers = _pieces
        .where((p) => p['text'] != '?' && p['text'] != '+' && p['text'] != '=')
        .map((p) => int.tryParse(p['text']) ?? 0)
        .toList();
    if (numbers.length >= 2) {
      return numbers[0] + numbers[1]; // Primeiro número + segundo número
    }
    return 0;
  }

  List<String> _generateAnswerOptions() {
    final correctAnswer = _calculateCorrectAnswer();
    final options = <String>[];

    // Adicionar a resposta correta
    options.add(correctAnswer.toString());

    // Adicionar opções incorretas (números próximos)
    final wrongOptions = [
      correctAnswer + 1,
      correctAnswer - 1,
      correctAnswer + 2,
      correctAnswer - 2,
      correctAnswer * 2,
      correctAnswer ~/ 2,
    ].where((n) => n > 0 && n != correctAnswer).take(3).toList();

    options.addAll(wrongOptions.map((n) => n.toString()));

    // Embaralhar as opções
    options.shuffle();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    if (_showCelebration) {
      return CelebrationWidget(
        xpGained: 30,
        achievement: 'Quebra-cabeça Completo!',
        onComplete: () {
          setState(() {
            _showCelebration = false;
          });
          widget.onComplete();
        },
      );
    }

    return Column(
      children: [
        // Título
        Text(
          widget.data['question'] ?? 'Complete a sequência:',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textDark,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),

        // Sequência simples: [1] [2] [3] [4] [?]
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _pieces.map((piece) {
              final isQuestionMark = piece['text'] == '?';
              final isRevealed = piece['isRevealed'] == true;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isRevealed
                      ? AppTheme.xpColor.withOpacity(0.2)
                      : isQuestionMark
                          ? Colors.grey.withOpacity(0.1)
                          : AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isRevealed
                        ? AppTheme.xpColor
                        : isQuestionMark
                            ? Colors.grey
                            : AppTheme.primaryColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    isRevealed
                        ? piece['text']
                        : (isQuestionMark ? '?' : piece['text']),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isRevealed
                          ? AppTheme.xpColor
                          : isQuestionMark
                              ? Colors.white
                              : Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 30),

        // Opções de resposta simples
        Text(
          'Qual número completa a sequência?',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 16),

        // Opções em linha simples
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: _generateAnswerOptions().map((option) {
            final isSelected = _selectedAnswer == option;
            return GestureDetector(
              onTap: () => _selectAnswer(option),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.primaryColor : AppTheme.surfaceDark,
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppTheme.textDark,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 30),

        // Botões simples
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedAnswer = null;
                  _isCompleted = false;
                  _showCelebration = false;
                  _initializePuzzle();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reiniciar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                foregroundColor: Colors.white,
              ),
            ),
            ElevatedButton.icon(
              onPressed: _selectedAnswer == null ? null : _checkAnswer,
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
}
