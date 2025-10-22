import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/interactive_math_lesson.dart';
import 'interactive_lesson_screen.dart';
import '../../widgets/interactive_exercises/puzzle_widget.dart';
import '../../widgets/interactive_exercises/crossword_widget.dart';
import '../../widgets/interactive_exercises/fill_blank_widget.dart';
import '../../widgets/celebration_widget.dart';

class InteractiveMathLessonsScreen extends StatefulWidget {
  const InteractiveMathLessonsScreen({super.key});

  @override
  State<InteractiveMathLessonsScreen> createState() =>
      _InteractiveMathLessonsScreenState();
}

class _InteractiveMathLessonsScreenState
    extends State<InteractiveMathLessonsScreen> {
  List<InteractiveMathLesson> _lessons = [];
  String _selectedTopic = 'all';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  Future<void> _loadLessons() async {
    final lessons = PredefinedInteractiveLessons.lessons;
    setState(() {
      _lessons = lessons;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matemática Interativa'),
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
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
                color: AppTheme.primaryColor,
              ),
            )
          : Column(
              children: [
                // Header e filtros fixos
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(),
                      const SizedBox(height: 20),

                      // Filtros
                      _buildTopicFilter(),
                    ],
                  ),
                ),

                // Lista de lições rolável
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildLessonsList(),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Matemática Interativa',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aprenda matemática de forma divertida e interativa!',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard('Lições', '${_lessons.length}',
                        AppTheme.secondaryColor),
                    const SizedBox(width: 12),
                    _buildStatCard(
                        'XP Total',
                        '${_lessons.fold(0, (sum, lesson) => sum + lesson.xpReward)}',
                        AppTheme.xpColor),
                    const SizedBox(width: 12),
                    _buildStatCard(
                        'Tipos',
                        '${InteractiveLessonType.values.length}',
                        AppTheme.levelColor),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                '🎮',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicFilter() {
    final topics = ['all', ...MathTopic.values.map((e) => e.name)];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: topics.map((topic) {
          final isSelected = _selectedTopic == topic;
          final displayName =
              topic == 'all' ? 'Todos' : _getTopicDisplayName(topic);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(displayName),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTopic = topic;
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textLight,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getTopicDisplayName(String topic) {
    switch (topic) {
      case 'counting':
        return 'Contagem';
      case 'numbers':
        return 'Números';
      case 'operations':
        return 'Operações';
      case 'geometry':
        return 'Geometria';
      case 'time':
        return 'Tempo';
      case 'measurement':
        return 'Medidas';
      case 'fractions':
        return 'Frações';
      case 'wordProblems':
        return 'Problemas';
      default:
        return topic;
    }
  }

  Widget _buildLessonsList() {
    final filteredLessons = _selectedTopic == 'all'
        ? _lessons
        : _lessons
            .where((lesson) => lesson.topic.name == _selectedTopic)
            .toList();

    if (filteredLessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 64,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma lição encontrada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente selecionar um tópico diferente',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredLessons.length,
      itemBuilder: (context, index) {
        final lesson = filteredLessons[index];
        return _buildLessonCard(lesson);
      },
    );
  }

  Widget _buildLessonCard(InteractiveMathLesson lesson) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: lesson.isUnlocked ? () => _startLesson(lesson) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color:
                lesson.isUnlocked ? Colors.white : Colors.grey.withOpacity(0.3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: lesson.isUnlocked
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        lesson.icon,
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
                          lesson.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: lesson.isUnlocked
                                ? AppTheme.textLight
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: lesson.isUnlocked
                                ? AppTheme.textLight.withOpacity(0.7)
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!lesson.isUnlocked)
                    const Icon(
                      Icons.lock,
                      color: Colors.grey,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildDifficultyChip(lesson.difficulty),
                  const SizedBox(width: 8),
                  _buildTypeChip(lesson.type),
                  const SizedBox(width: 8),
                  _buildTimeChip(lesson.estimatedTime),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppTheme.xpColor,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.xpReward} XP',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.xpColor,
                        ),
                      ),
                    ],
                  ),
                  if (lesson.isUnlocked)
                    ElevatedButton(
                      onPressed: () => _startLesson(lesson),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Começar'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(int difficulty) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    final labels = ['Fácil', 'Médio', 'Difícil', 'Expert', 'Mestre'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors[difficulty - 1].withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors[difficulty - 1].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        labels[difficulty - 1],
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: colors[difficulty - 1],
        ),
      ),
    );
  }

  Widget _buildTypeChip(InteractiveLessonType type) {
    final typeLabels = {
      InteractiveLessonType.puzzle: 'Quebra-cabeça',
      InteractiveLessonType.crossword: 'Palavras cruzadas',
      InteractiveLessonType.fillBlank: 'Completar',
      InteractiveLessonType.matching: 'Ligar',
      InteractiveLessonType.ordering: 'Ordenar',
      InteractiveLessonType.dragDrop: 'Arrastar',
      InteractiveLessonType.multipleChoice: 'Múltipla escolha',
      InteractiveLessonType.trueFalse: 'Verdadeiro/Falso',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.secondaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        typeLabels[type] ?? type.name,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.secondaryColor,
        ),
      ),
    );
  }

  Widget _buildTimeChip(int minutes) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.access_time,
            size: 12,
            color: AppTheme.accentColor,
          ),
          const SizedBox(width: 4),
          Text(
            '${minutes}min',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  void _startLesson(InteractiveMathLesson lesson) {
    // Navegar para a tela da lição interativa baseada no tipo
    switch (lesson.type) {
      case InteractiveLessonType.puzzle:
        _startPuzzleLesson(lesson);
        break;
      case InteractiveLessonType.crossword:
        _startCrosswordLesson(lesson);
        break;
      case InteractiveLessonType.fillBlank:
        _startFillBlankLesson(lesson);
        break;
      case InteractiveLessonType.matching:
        _startMatchingLesson(lesson);
        break;
      case InteractiveLessonType.ordering:
        _startOrderingLesson(lesson);
        break;
      case InteractiveLessonType.dragDrop:
        _startDragDropLesson(lesson);
        break;
      case InteractiveLessonType.multipleChoice:
        _startMultipleChoiceLesson(lesson);
        break;
      case InteractiveLessonType.trueFalse:
        _startTrueFalseLesson(lesson);
        break;
    }
  }

  void _startPuzzleLesson(InteractiveMathLesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _PuzzleLessonFlow(
          lesson: lesson,
          onComplete: () {
            Navigator.pop(context);
            // Mostrar celebração final aqui
            _showFinalCelebration(lesson);
          },
        ),
      ),
    );
  }

  void _showFinalCelebration(InteractiveMathLesson lesson) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationWidget(
        xpGained: lesson.xpReward,
        achievement: '${lesson.title} Completa!',
        onComplete: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Parabéns! ${lesson.title} concluída!'),
              backgroundColor: AppTheme.xpColor,
            ),
          );
        },
      ),
    );
  }

  void _startCrosswordLesson(InteractiveMathLesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InteractiveLessonScreen(
          lesson: lesson,
          exerciseWidget: CrosswordWidget(
            data: lesson.exercises.first.data,
            onAnswer: (answer) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(answer),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            onComplete: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Parabéns! ${lesson.title} concluída!'),
                  backgroundColor: AppTheme.xpColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _startFillBlankLesson(InteractiveMathLesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InteractiveLessonScreen(
          lesson: lesson,
          exerciseWidget: FillBlankWidget(
            data: lesson.exercises.first.data,
            onAnswer: (answer) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(answer),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            onComplete: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Parabéns! ${lesson.title} concluída!'),
                  backgroundColor: AppTheme.xpColor,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _startMatchingLesson(InteractiveMathLesson lesson) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lição de correspondência em desenvolvimento!'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }

  void _startOrderingLesson(InteractiveMathLesson lesson) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lição de ordenação em desenvolvimento!'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }

  void _startDragDropLesson(InteractiveMathLesson lesson) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lição de arrastar e soltar em desenvolvimento!'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }

  void _startMultipleChoiceLesson(InteractiveMathLesson lesson) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lição de múltipla escolha em desenvolvimento!'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }

  void _startTrueFalseLesson(InteractiveMathLesson lesson) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lição de verdadeiro/falso em desenvolvimento!'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }
}

// Widget para gerenciar o fluxo de todas as questões do puzzle
class _PuzzleLessonFlow extends StatefulWidget {
  final InteractiveMathLesson lesson;
  final VoidCallback onComplete;

  const _PuzzleLessonFlow({
    required this.lesson,
    required this.onComplete,
  });

  @override
  State<_PuzzleLessonFlow> createState() => _PuzzleLessonFlowState();
}

class _PuzzleLessonFlowState extends State<_PuzzleLessonFlow> {
  int _currentExerciseIndex = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_currentExerciseIndex >= widget.lesson.exercises.length) {
      // Todas as questões foram respondidas
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onComplete();
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
              '${widget.lesson.title} (${_currentExerciseIndex + 1}/${widget.lesson.exercises.length})'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
              SizedBox(height: 20),
              Text(
                'Carregando próxima questão...',
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentExercise = widget.lesson.exercises[_currentExerciseIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.lesson.title} (${_currentExerciseIndex + 1}/${widget.lesson.exercises.length})'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: PuzzleWidget(
        data: currentExercise.data,
        onAnswer: (answer) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(answer),
              backgroundColor: AppTheme.primaryColor,
              duration: const Duration(seconds: 1),
            ),
          );
        },
        onComplete: () {
          print('Questão ${_currentExerciseIndex + 1} completada!');
          setState(() {
            _currentExerciseIndex++;
            _isLoading = true;
          });
          print('Próxima questão: $_currentExerciseIndex');

          // Mostrar loading por 1 segundo antes da próxima questão
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          });
        },
      ),
    );
  }
}
