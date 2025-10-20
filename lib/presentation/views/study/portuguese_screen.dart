import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/portuguese_lesson.dart';
import '../../../data/datasources/simple_database.dart';

class PortugueseScreen extends StatefulWidget {
  const PortugueseScreen({super.key});

  @override
  State<PortugueseScreen> createState() => _PortugueseScreenState();
}

class _PortugueseScreenState extends State<PortugueseScreen> {
  String _selectedDifficulty = 'all';
  List<PortugueseLesson> _lessons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final lessons = await SimpleDatabase.getPortugueseLessons();
    setState(() {
      _lessons = lessons;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Português'),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              // TODO: Navegar para conquistas
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.secondaryColor,
              ),
            )
          : Column(
              children: [
                // Header com estatísticas
                _buildHeader(),

                // Filtro de dificuldade
                _buildDifficultyFilter(),

                // Lista de exercícios
                _buildExerciseList(),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bem-vindo ao Português!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pratique gramática, interpretação e redação:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard('Exercícios', '12', Colors.white),
                const SizedBox(width: 12),
                _buildStatCard('XP', '0', AppTheme.xpColor),
                const SizedBox(width: 12),
                _buildStatCard('Nível', '1', AppTheme.levelColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            'all',
            'easy',
            'medium',
            'hard',
          ].map((level) {
            final levelName = level == 'all' ? 'Todos' : level.capitalize();
            final isSelected = _selectedDifficulty == level;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(
                  levelName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppTheme.secondaryColor,
                onSelected: (selected) {
                  setState(() {
                    _selectedDifficulty = selected ? level : 'all';
                  });
                },
                backgroundColor: AppTheme.secondaryColor.withOpacity(0.1),
                side:
                    BorderSide(color: AppTheme.secondaryColor.withOpacity(0.5)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    final filteredLessons = _selectedDifficulty == 'all'
        ? _lessons
        : _lessons
            .where((lesson) =>
                _getDifficultyString(lesson.difficulty) == _selectedDifficulty)
            .toList();

    if (filteredLessons.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum exercício encontrado para esta dificuldade.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredLessons.length,
        itemBuilder: (context, index) {
          final lesson = filteredLessons[index];
          return _buildLessonCard(context, lesson);
        },
      ),
    );
  }

  String _getDifficultyString(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 'Fácil';
      case DifficultyLevel.medium:
        return 'Médio';
      case DifficultyLevel.hard:
        return 'Difícil';
      case DifficultyLevel.expert:
        return 'Expert';
    }
  }

  Widget _buildLessonCard(BuildContext context, PortugueseLesson lesson) {
    final isLocked = !lesson.isUnlocked;
    final iconColor = isLocked ? Colors.grey : AppTheme.secondaryColor;
    final textColor = isLocked ? Colors.grey[600] : AppTheme.textLight;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _startLesson(lesson),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.surfaceLight,
            border: Border.all(
              color: AppTheme.secondaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    lesson.icon,
                    style: TextStyle(fontSize: 28, color: iconColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildDifficultyChip(
                            _getDifficultyString(lesson.difficulty)),
                        _buildTimeChip(lesson.timeLimit ~/ 60),
                        _buildXPChip(lesson.xpReward),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (lesson.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.successColor,
                      size: 24,
                    )
                  else if (isLocked)
                    const Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 24,
                    )
                  else
                    const Icon(
                      Icons.play_arrow,
                      color: AppTheme.secondaryColor,
                      size: 24,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.isCompleted
                        ? 'Concluído'
                        : isLocked
                            ? 'Bloqueado'
                            : 'Jogar',
                    style: TextStyle(
                      fontSize: 12,
                      color: isLocked ? Colors.grey : AppTheme.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, Map<String, dynamic> exercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _startExercise(exercise),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.surfaceLight,
            border: Border.all(
              color: AppTheme.secondaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    exercise['icon'],
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['title'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise['description'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildDifficultyChip(exercise['difficulty']),
                        _buildTimeChip(exercise['timeLimit']),
                        _buildXPChip(exercise['xpReward']),
                      ],
                    ),
                  ],
                ),
              ),
              // Status do exercício
              Column(
                children: [
                  if (exercise['isCompleted'])
                    const Icon(
                      Icons.check_circle,
                      color: AppTheme.secondaryColor,
                      size: 24,
                    )
                  else if (exercise['isLocked'])
                    const Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 24,
                    )
                  else
                    const Icon(
                      Icons.play_arrow,
                      color: AppTheme.secondaryColor,
                      size: 24,
                    ),
                  const SizedBox(height: 4),
                  Text(
                    exercise['isCompleted']
                        ? 'Concluído'
                        : exercise['isLocked']
                            ? 'Bloqueado'
                            : 'Iniciar',
                    style: TextStyle(
                      fontSize: 12,
                      color: exercise['isUnlocked']
                          ? AppTheme.secondaryColor
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String difficulty) {
    Color color;
    String text;

    switch (difficulty) {
      case 'easy':
        color = AppTheme.successColor;
        text = 'Fácil';
        break;
      case 'medium':
        color = AppTheme.warningColor;
        text = 'Médio';
        break;
      case 'hard':
        color = AppTheme.errorColor;
        text = 'Difícil';
        break;
      default:
        color = AppTheme.infoColor;
        text = 'Todos';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimeChip(int timeLimit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.infoColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: AppTheme.infoColor, size: 12),
          const SizedBox(width: 4),
          Text(
            '${timeLimit}min',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.infoColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPChip(int xpReward) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.xpColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.xpColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: AppTheme.xpColor, size: 12),
          const SizedBox(width: 4),
          Text(
            '+$xpReward XP',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.xpColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _startLesson(PortugueseLesson lesson) {
    if (!lesson.isUnlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${lesson.title} está bloqueado. Complete as lições anteriores!'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    // Navegar para a lição específica
    if (lesson.id == 'grammar_basics') {
      context.go(AppRoutes.grammarBasicsExplanation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${lesson.title} em breve!'),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
    }
  }

  void _startExercise(Map<String, dynamic> exercise) {
    if (exercise['isLocked']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${exercise['title']} está bloqueado. Complete os exercícios anteriores!'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    // Navegar para o exercício específico
    if (exercise['id'] == 'grammar_basics') {
      context.go(AppRoutes.grammarBasicsExplanation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${exercise['title']} em breve!'),
          backgroundColor: AppTheme.secondaryColor,
        ),
      );
    }
  }

  List<Map<String, dynamic>> _getPortugueseExercises() {
    return [
      {
        'id': 'grammar_basics',
        'title': 'Gramática Básica',
        'description': 'Substantivos, adjetivos e verbos',
        'icon': '📝',
        'difficulty': 'easy',
        'timeLimit': 15,
        'xpReward': 25,
        'isCompleted': false,
        'isLocked': false,
        'isUnlocked': true,
      },
      {
        'id': 'sentence_structure',
        'title': 'Estrutura de Frases',
        'description': 'Sujeito, predicado e complementos',
        'icon': '🔗',
        'difficulty': 'easy',
        'timeLimit': 20,
        'xpReward': 30,
        'isCompleted': false,
        'isLocked': false,
        'isUnlocked': true,
      },
      {
        'id': 'verb_conjugation',
        'title': 'Conjugação Verbal',
        'description': 'Tempos verbais e modos',
        'icon': '🔄',
        'difficulty': 'medium',
        'timeLimit': 25,
        'xpReward': 40,
        'isCompleted': false,
        'isLocked': false,
        'isUnlocked': true,
      },
      {
        'id': 'text_interpretation',
        'title': 'Interpretação de Texto',
        'description': 'Compreensão e análise textual',
        'icon': '📖',
        'difficulty': 'medium',
        'timeLimit': 30,
        'xpReward': 50,
        'isCompleted': false,
        'isLocked': false,
        'isUnlocked': true,
      },
      {
        'id': 'essay_writing',
        'title': 'Redação',
        'description': 'Estrutura e desenvolvimento de textos',
        'icon': '✍️',
        'difficulty': 'hard',
        'timeLimit': 45,
        'xpReward': 75,
        'isCompleted': false,
        'isLocked': false,
        'isUnlocked': true,
      },
      {
        'id': 'literature',
        'title': 'Literatura',
        'description': 'Movimentos literários e autores',
        'icon': '📚',
        'difficulty': 'hard',
        'timeLimit': 40,
        'xpReward': 60,
        'isCompleted': false,
        'isLocked': true,
        'isUnlocked': false,
      },
    ];
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
