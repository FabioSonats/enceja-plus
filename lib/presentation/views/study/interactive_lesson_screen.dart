import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/interactive_math_lesson.dart';

class InteractiveLessonScreen extends StatefulWidget {
  final InteractiveMathLesson lesson;
  final Widget exerciseWidget;

  const InteractiveLessonScreen({
    super.key,
    required this.lesson,
    required this.exerciseWidget,
  });

  @override
  State<InteractiveLessonScreen> createState() =>
      _InteractiveLessonScreenState();
}

class _InteractiveLessonScreenState extends State<InteractiveLessonScreen> {
  int _currentExerciseIndex = 0;
  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelp(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header com informações da lição
          _buildLessonHeader(),

          // Exercício atual
          Expanded(
            child: widget.exerciseWidget,
          ),

          // Navegação entre exercícios (se houver múltiplos)
          if (widget.lesson.exercises.length > 1) _buildExerciseNavigation(),
        ],
      ),
    );
  }

  Widget _buildLessonHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    widget.lesson.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.lesson.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.lesson.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(
                'Dificuldade',
                _getDifficultyText(widget.lesson.difficulty),
                _getDifficultyColor(widget.lesson.difficulty),
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                'Tempo',
                '${widget.lesson.estimatedTime}min',
                AppTheme.accentColor,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                'XP',
                '${widget.lesson.xpReward}',
                AppTheme.xpColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseNavigation() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: _currentExerciseIndex > 0 ? _previousExercise : null,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Anterior'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              foregroundColor: Colors.white,
            ),
          ),
          Text(
            'Exercício ${_currentExerciseIndex + 1} de ${widget.lesson.exercises.length}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.textLight,
            ),
          ),
          ElevatedButton.icon(
            onPressed:
                _currentExerciseIndex < widget.lesson.exercises.length - 1
                    ? _nextExercise
                    : _completeLesson,
            icon: Icon(
                _currentExerciseIndex < widget.lesson.exercises.length - 1
                    ? Icons.arrow_forward
                    : Icons.check),
            label: Text(
                _currentExerciseIndex < widget.lesson.exercises.length - 1
                    ? 'Próximo'
                    : 'Concluir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _previousExercise() {
    if (_currentExerciseIndex > 0) {
      setState(() {
        _currentExerciseIndex--;
      });
    }
  }

  void _nextExercise() {
    if (_currentExerciseIndex < widget.lesson.exercises.length - 1) {
      setState(() {
        _currentExerciseIndex++;
      });
    }
  }

  void _completeLesson() {
    setState(() {
      _isCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Parabéns! ${widget.lesson.title} concluída!'),
        backgroundColor: AppTheme.xpColor,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Como jogar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.lesson.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.lesson.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dicas:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '• Leia as instruções com atenção\n'
              '• Use os botões de ajuda se necessário\n'
              '• Complete todos os exercícios para ganhar XP\n'
              '• Não tenha pressa, aprenda no seu ritmo',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Fácil';
      case 2:
        return 'Médio';
      case 3:
        return 'Difícil';
      case 4:
        return 'Expert';
      case 5:
        return 'Mestre';
      default:
        return 'Médio';
    }
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}
