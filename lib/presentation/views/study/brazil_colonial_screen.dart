import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/history_lesson.dart';
import '../../../data/datasources/simple_database.dart';
import '../../widgets/celebration_widget.dart';

class BrazilColonialScreen extends StatefulWidget {
  const BrazilColonialScreen({super.key});

  @override
  State<BrazilColonialScreen> createState() => _BrazilColonialScreenState();
}

class _BrazilColonialScreenState extends State<BrazilColonialScreen> {
  HistoryLesson? _lesson;
  bool _isLoading = true;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  int _correctAnswers = 0;
  int _totalQuestions = 0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  Future<void> _loadLesson() async {
    final lessons = await SimpleDatabase.getHistoryLessons();
    final lesson = lessons.firstWhere(
      (l) => l.id == 'brazil_colonial',
      orElse: () => lessons.first,
    );

    setState(() {
      _lesson = lesson;
      _totalQuestions = lesson.questions.length;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Brasil Colonial'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppTheme.primaryColor,
          ),
        ),
      );
    }

    if (_lesson == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Brasil Colonial'),
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Lição não encontrada'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brasil Colonial'),
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
              context.go(AppRoutes.history);
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
      body: _isCompleted ? _buildCompletionScreen() : _buildQuizScreen(),
    );
  }

  Widget _buildQuizScreen() {
    final question = _lesson!.questions[_currentQuestionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header da lição
          _buildLessonHeader(),

          const SizedBox(height: 24),

          // Progresso
          _buildProgressIndicator(),

          const SizedBox(height: 24),

          // Questão atual
          _buildQuestionCard(question),

          const SizedBox(height: 24),

          // Opções de resposta
          _buildAnswerOptions(question),

          const SizedBox(height: 24),

          // Botão de resposta
          _buildAnswerButton(question),

          if (_showResult) ...[
            const SizedBox(height: 24),
            _buildResultCard(question),
            const SizedBox(height: 24),
            _buildNextButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildLessonHeader() {
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                _lesson!.icon,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _lesson!.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _lesson!.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.access_time,
                      '${(_lesson!.timeLimit / 60).round()} min',
                      Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.star,
                      '${_lesson!.xpReward} XP',
                      Colors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    final progress = (_currentQuestionIndex + 1) / _totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Questão ${_currentQuestionIndex + 1} de $_totalQuestions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor:
              const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildQuestionCard(HistoryQuestion question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.quiz,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pergunta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions(HistoryQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Escolha sua resposta:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 12),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;
          final isSelected = _selectedAnswer == option;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _showResult ? null : () => _selectAnswer(option),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getOptionColor(option, isSelected),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getOptionBorderColor(option, isSelected),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _getOptionIconColor(option, isSelected),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: TextStyle(
                              color: _getOptionTextColor(option, isSelected),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: _getOptionTextColor(option, isSelected),
                          ),
                        ),
                      ),
                      if (_showResult && option == question.correctAnswer)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 24,
                        ),
                      if (_showResult &&
                          isSelected &&
                          option != question.correctAnswer)
                        const Icon(
                          Icons.cancel,
                          color: Colors.red,
                          size: 24,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getOptionColor(String option, bool isSelected) {
    if (!_showResult) {
      return isSelected
          ? AppTheme.primaryColor.withOpacity(0.15)
          : Colors.white;
    }

    if (option == _lesson!.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.green.withOpacity(0.15);
    }

    if (isSelected &&
        option != _lesson!.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.red.withOpacity(0.15);
    }

    return Colors.white;
  }

  Color _getOptionBorderColor(String option, bool isSelected) {
    if (!_showResult) {
      return isSelected ? AppTheme.primaryColor : Colors.grey[400]!;
    }

    if (option == _lesson!.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.green;
    }

    if (isSelected &&
        option != _lesson!.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.red;
    }

    return Colors.grey[400]!;
  }

  Color _getOptionIconColor(String option, bool isSelected) {
    if (!_showResult) {
      return isSelected ? AppTheme.primaryColor : Colors.grey[400]!;
    }

    if (option == _lesson!.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.green;
    }

    if (isSelected &&
        option != _lesson!.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.red;
    }

    return Colors.grey[400]!;
  }

  Color _getOptionTextColor(String option, bool isSelected) {
    if (!_showResult) {
      return isSelected ? AppTheme.primaryColor : Colors.black87;
    }

    if (option == _lesson!.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.green[800]!;
    }

    if (isSelected &&
        option != _lesson!.questions[_currentQuestionIndex].correctAnswer) {
      return Colors.red[800]!;
    }

    return Colors.black87;
  }

  Widget _buildAnswerButton(HistoryQuestion question) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedAnswer == null || _showResult ? null : _checkAnswer,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _showResult ? 'Continuar' : 'Responder',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(HistoryQuestion question) {
    final isCorrect = _selectedAnswer == question.correctAnswer;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? Colors.green : Colors.red,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isCorrect ? Colors.green : Colors.red).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green[700] : Colors.red[700],
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correto!' : 'Incorreto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green[800] : Colors.red[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Resposta correta: ${question.correctAnswer}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nextQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _currentQuestionIndex < _totalQuestions - 1
              ? 'Próxima Questão'
              : 'Finalizar',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionScreen() {
    final accuracy = (_correctAnswers / _totalQuestions) * 100;
    final xpEarned = (accuracy / 100 * _lesson!.xpReward).round();

    return Stack(
      children: [
        // Conteúdo principal
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: Colors.green, width: 3),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.green,
                  size: 60,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Parabéns!',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Você completou a lição!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Resultado Final',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem('Acertos',
                            '$_correctAnswers/$_totalQuestions', Colors.green),
                        _buildStatItem(
                            'Precisão', '${accuracy.round()}%', Colors.blue),
                        _buildStatItem('XP Ganho', '$xpEarned', Colors.amber),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _finishLesson,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Voltar para História',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Widget de celebração (apenas se aprovado)
        if (accuracy >= 70)
          CelebrationWidget(
            xpGained: xpEarned,
            achievement: 'Brasil Colonial Concluído!',
            onComplete: () {
              // A celebração termina automaticamente
            },
          ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
    });
  }

  void _checkAnswer() {
    final question = _lesson!.questions[_currentQuestionIndex];
    final isCorrect = _selectedAnswer == question.correctAnswer;

    if (isCorrect) {
      _correctAnswers++;
    }

    setState(() {
      _showResult = true;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      setState(() {
        _isCompleted = true;
      });
    }
  }

  void _finishLesson() async {
    // Marcar lição como concluída
    await SimpleDatabase.markHistoryLessonCompleted(_lesson!.id);

    // Adicionar XP
    final accuracy = (_correctAnswers / _totalQuestions) * 100;
    final xpEarned = (accuracy / 100 * _lesson!.xpReward).round();
    await SimpleDatabase.updateUserXP(xpEarned);

    // Navegar de volta
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.history);
    }
  }
}
