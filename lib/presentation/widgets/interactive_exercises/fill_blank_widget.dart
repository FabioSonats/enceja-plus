import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FillBlankWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(String) onAnswer;
  final Function() onComplete;

  const FillBlankWidget({
    super.key,
    required this.data,
    required this.onAnswer,
    required this.onComplete,
  });

  @override
  State<FillBlankWidget> createState() => _FillBlankWidgetState();
}

class _FillBlankWidgetState extends State<FillBlankWidget> {
  List<TextEditingController> _controllers = [];
  List<String> _userAnswers = [];
  List<String> _correctAnswers = [];
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializeFillBlank();
  }

  void _initializeFillBlank() {
    final sentences = List<String>.from(widget.data['sentences'] ?? []);
    final answers = List<String>.from(widget.data['answers'] ?? []);

    _correctAnswers = answers;
    _userAnswers = List.filled(answers.length, '');
    _controllers = List.generate(
      answers.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Título
          Text(
            'Complete as Operações',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Instruções
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.data['hint'] ??
                        'Complete as lacunas com os números corretos',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Exercícios
          _buildExercises(),

          const SizedBox(height: 20),

          // Botões
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _resetAnswers,
                icon: const Icon(Icons.refresh),
                label: const Text('Reiniciar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _checkAnswers,
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
      ),
    );
  }

  Widget _buildExercises() {
    final sentences = List<String>.from(widget.data['sentences'] ?? []);

    return Column(
      children: sentences.asMap().entries.map((entry) {
        final index = entry.key;
        final sentence = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: _buildSentenceWithBlank(sentence, index),
        );
      }).toList(),
    );
  }

  Widget _buildSentenceWithBlank(String sentence, int index) {
    final parts = sentence.split('___');

    return Row(
      children: [
        // Texto antes da lacuna
        Expanded(
          child: Text(
            parts[0],
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textLight,
            ),
          ),
        ),

        // Campo de entrada
        Container(
          width: 60,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: _controllers[index],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
            decoration: InputDecoration(
              hintText: '?',
              hintStyle: TextStyle(
                color: AppTheme.primaryColor.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _userAnswers[index] = value;
              });
            },
          ),
        ),

        // Texto após a lacuna
        if (parts.length > 1)
          Expanded(
            child: Text(
              parts[1],
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textLight,
              ),
            ),
          ),
      ],
    );
  }

  void _resetAnswers() {
    setState(() {
      for (final controller in _controllers) {
        controller.clear();
      }
      _userAnswers = List.filled(_correctAnswers.length, '');
      _isCompleted = false;
    });
  }

  void _checkAnswers() {
    int correctCount = 0;
    List<String> feedback = [];

    for (int i = 0; i < _correctAnswers.length; i++) {
      final userAnswer = _userAnswers[i].trim();
      final correctAnswer = _correctAnswers[i];

      if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
        correctCount++;
        feedback.add('✓ Correto!');
      } else {
        feedback.add('✗ Incorreto. A resposta correta é: $correctAnswer');
      }
    }

    final percentage = (correctCount / _correctAnswers.length * 100).round();

    if (correctCount == _correctAnswers.length) {
      widget.onAnswer('Parabéns! Você acertou todas as operações!');
      widget.onComplete();
    } else {
      widget.onAnswer(
          'Você acertou $correctCount de ${_correctAnswers.length} operações ($percentage%). Tente novamente!');
    }
  }
}
