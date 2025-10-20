import 'package:flutter/material.dart';
import '../../../domain/entities/game_interface.dart';
import '../../../core/theme/app_theme.dart';

class DragDropWidget extends StatefulWidget {
  final GameQuestion question;
  final Function(String) onAnswer;

  const DragDropWidget({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  State<DragDropWidget> createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget> {
  String? _selectedAnswer;

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
          // Placeholder para drag and drop
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppTheme.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                'Arrastar e Soltar em desenvolvimento',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textLight,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Opções de resposta
          ...widget.question.options.map((option) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedAnswer = option;
                  });
                  widget.onAnswer(option);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedAnswer == option
                        ? AppTheme.primaryColor.withOpacity(0.1)
                        : AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _selectedAnswer == option
                          ? AppTheme.primaryColor
                          : AppTheme.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      color: _selectedAnswer == option
                          ? AppTheme.primaryColor
                          : AppTheme.textLight,
                      fontWeight: _selectedAnswer == option
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
