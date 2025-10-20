import 'package:flutter/material.dart';
import '../../../domain/entities/game_interface.dart';
import '../../../core/theme/app_theme.dart';

class TypingWidget extends StatefulWidget {
  final GameQuestion question;
  final Function(String) onAnswer;

  const TypingWidget({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  State<TypingWidget> createState() => _TypingWidgetState();
}

class _TypingWidgetState extends State<TypingWidget> {
  final TextEditingController _textController = TextEditingController();
  String? _userAnswer;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            widget.question.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 20),
          // Campo de texto
          TextField(
            controller: _textController,
            onChanged: (value) {
              setState(() {
                _userAnswer = value;
              });
              widget.onAnswer(value);
            },
            decoration: InputDecoration(
              hintText: 'Digite sua resposta aqui...',
              hintStyle: TextStyle(
                color: AppTheme.textLight.withOpacity(0.6),
              ),
              filled: true,
              fillColor: AppTheme.backgroundLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppTheme.primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryColor,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(
              fontSize: 16,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 16),
          // Botão de verificar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _userAnswer != null && _userAnswer!.isNotEmpty
                  ? () {
                      // Lógica de verificação será implementada
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Verificar Resposta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
