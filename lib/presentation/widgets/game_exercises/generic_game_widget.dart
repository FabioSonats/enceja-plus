import 'package:flutter/material.dart';
import '../../../domain/entities/game_interface.dart';
import '../../../core/theme/app_theme.dart';
import 'exercise_factory.dart';

/// Widget genérico para jogos
/// Segue o princípio SOLID - Single Responsibility
class GenericGameWidget extends StatefulWidget {
  final GameInterface game;
  final Function(GameResult) onGameComplete;
  final Function(String, String, bool) onAnswerGiven;

  const GenericGameWidget({
    super.key,
    required this.game,
    required this.onGameComplete,
    required this.onAnswerGiven,
  });

  @override
  State<GenericGameWidget> createState() => _GenericGameWidgetState();
}

class _GenericGameWidgetState extends State<GenericGameWidget>
    with TickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeRemaining = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;
  bool _gameCompleted = false;
  bool _showFeedback = false;
  List<Map<String, dynamic>> _answers = [];

  late AnimationController _questionController;
  late AnimationController _timerController;
  late AnimationController _feedbackController;
  late Animation<double> _questionAnimation;
  late Animation<double> _timerAnimation;
  late Animation<double> _feedbackAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startGame();
  }

  void _initializeAnimations() {
    _questionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _timerController = AnimationController(
      duration: Duration(seconds: widget.game.timeLimit),
      vsync: this,
    );
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _questionAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _questionController, curve: Curves.easeInOut),
    );
    _timerAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _timerController, curve: Curves.linear),
    );
    _feedbackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeInOut),
    );
  }

  void _startGame() {
    _timeRemaining = widget.game.timeLimit;
    _questionController.forward();
    _timerController.forward();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_gameCompleted) {
        setState(() {
          _timeRemaining--;
        });
        if (_timeRemaining > 0) {
          _startTimer();
        } else {
          _nextQuestion();
        }
      }
    });
  }

  void _onAnswerSelected(String answer) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
      _isCorrect = widget.game.validateAnswer(
        widget.game.questions[_currentQuestionIndex].id,
        answer,
      );
    });

    // Salvar resposta
    _answers.add({
      'questionId': widget.game.questions[_currentQuestionIndex].id,
      'answer': answer,
      'isCorrect': _isCorrect,
      'timeSpent': widget.game.timeLimit - _timeRemaining,
    });

    // Notificar callback
    widget.onAnswerGiven(
      widget.game.questions[_currentQuestionIndex].id,
      answer,
      _isCorrect,
    );

    // Mostrar feedback
    _showFeedback = true;
    _feedbackController.forward();

    // Calcular pontuação
    final points = widget.game.calculateScore(
      widget.game.questions[_currentQuestionIndex].id,
      answer,
      widget.game.timeLimit - _timeRemaining,
    );
    _score += points;

    // Próxima pergunta após delay
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.game.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _timeRemaining = widget.game.timeLimit;
        _selectedAnswer = null;
        _isAnswered = false;
        _isCorrect = false;
        _showFeedback = false;
      });

      _questionController.reset();
      _timerController.reset();
      _feedbackController.reset();

      _questionController.forward();
      _timerController.forward();
      _startTimer();
    } else {
      _completeGame();
    }
  }

  void _completeGame() {
    setState(() {
      _gameCompleted = true;
    });

    final correctAnswers = _answers.where((a) => a['isCorrect']).length;
    final accuracy = correctAnswers / widget.game.questions.length;
    final xpEarned = _score;

    final result = GameResult(
      gameId: widget.game.id,
      correctAnswers: correctAnswers,
      totalQuestions: widget.game.questions.length,
      timeSpent: widget.game.timeLimit - _timeRemaining,
      xpEarned: xpEarned,
      pointsEarned: _score,
      accuracy: accuracy,
      completedAt: DateTime.now(),
      achievements: [],
    );

    widget.onGameComplete(result);
  }

  @override
  void dispose() {
    _questionController.dispose();
    _timerController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameCompleted) {
      return _buildGameCompleted();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildQuestionArea(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Progresso
          Row(
            children: [
              Text(
                'Pergunta ${_currentQuestionIndex + 1} de ${widget.game.questions.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                'Pontos: $_score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progresso
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.game.questions.length,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 12),
          // Timer
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: AnimatedBuilder(
                  animation: _timerAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _timerAnimation.value,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _timeRemaining > 10
                            ? Colors.white
                            : Colors.red,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_timeRemaining',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionArea() {
    final question = widget.game.questions[_currentQuestionIndex];

    return AnimatedBuilder(
      animation: _questionAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _questionAnimation.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Widget do exercício
                ExerciseFactory.createExerciseWidget(
                  question,
                  _onAnswerSelected,
                ),
                
                const SizedBox(height: 20),
                
                // Feedback
                if (_showFeedback)
                  AnimatedBuilder(
                    animation: _feedbackAnimation,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _feedbackAnimation,
                        child: _buildFeedbackSection(question),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackSection(GameQuestion question) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect
            ? AppTheme.successColor.withOpacity(0.1)
            : AppTheme.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isCorrect
              ? AppTheme.successColor
              : AppTheme.errorColor,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.cancel,
                color: _isCorrect
                    ? AppTheme.successColor
                    : AppTheme.errorColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _isCorrect ? 'Correto!' : 'Incorreto',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isCorrect
                      ? AppTheme.successColor
                      : AppTheme.errorColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            question.explanation,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCompleted() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events,
            size: 80,
            color: AppTheme.xpColor,
          ),
          const SizedBox(height: 20),
          const Text(
            'Parabéns!',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Você completou ${widget.game.title}!',
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.textLight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Pontuação: $_score',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.xpColor,
            ),
          ),
        ],
      ),
    );
  }
}
