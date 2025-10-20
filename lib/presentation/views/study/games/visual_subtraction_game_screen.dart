import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../domain/entities/math_game.dart';
import '../../../../data/datasources/simple_database.dart';
import '../../../widgets/celebration_widget.dart';
import '../../../widgets/retry_widget.dart';

class VisualSubtractionGameScreen extends StatefulWidget {
  final MathGame game;

  const VisualSubtractionGameScreen({
    super.key,
    required this.game,
  });

  @override
  State<VisualSubtractionGameScreen> createState() =>
      _VisualSubtractionGameScreenState();
}

class _VisualSubtractionGameScreenState
    extends State<VisualSubtractionGameScreen> with TickerProviderStateMixin {
  late AnimationController _questionController;
  late AnimationController _timerController;
  late AnimationController _feedbackController;
  late Animation<double> _questionAnimation;
  late Animation<double> _timerAnimation;
  late Animation<double> _feedbackAnimation;

  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeRemaining = 30;
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;
  bool _gameCompleted = false;
  bool _showFeedback = false;

  final List<MathQuestion> _questions = [
    MathQuestion(
      id: '1',
      question: '8 - 3 = ?',
      options: ['4', '5', '6', '7'],
      correctAnswer: '5',
      explanation: '8 - 3 = 5. Você subtrai 3 de 8 para obter 5.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.subtraction,
    ),
    MathQuestion(
      id: '2',
      question: '12 - 7 = ?',
      options: ['4', '5', '6', '7'],
      correctAnswer: '5',
      explanation: '12 - 7 = 5. Você subtrai 7 de 12 para obter 5.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.subtraction,
    ),
    MathQuestion(
      id: '3',
      question: '15 - 9 = ?',
      options: ['5', '6', '7', '8'],
      correctAnswer: '6',
      explanation: '15 - 9 = 6. Você subtrai 9 de 15 para obter 6.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.subtraction,
    ),
    MathQuestion(
      id: '4',
      question: '20 - 8 = ?',
      options: ['10', '11', '12', '13'],
      correctAnswer: '12',
      explanation: '20 - 8 = 12. Você subtrai 8 de 20 para obter 12.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.subtraction,
    ),
    MathQuestion(
      id: '5',
      question: '18 - 6 = ?',
      options: ['10', '11', '12', '13'],
      correctAnswer: '12',
      explanation: '18 - 6 = 12. Você subtrai 6 de 18 para obter 12.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.subtraction,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startTimer();
  }

  void _setupAnimations() {
    _questionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _timerController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );

    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _questionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _questionController,
      curve: Curves.elasticOut,
    ));

    _timerAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _timerController,
      curve: Curves.linear,
    ));

    _feedbackAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.bounceOut,
    ));

    _questionController.forward();
    _timerController.forward();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_gameCompleted && !_isAnswered) {
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
      appBar: AppBar(
        title: const Text('Subtração Básica'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.mathGames),
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Desistir da Lição'),
                  content: const Text(
                      'Tem certeza que deseja desistir desta lição? Seu progresso será salvo.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continuar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go(AppRoutes.mathGames);
                      },
                      child: const Text('Desistir'),
                    ),
                  ],
                ),
              );
            },
            child: const Text(
              'Desistir',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header com timer e progresso
            _buildHeader(),

            // Pergunta principal
            Expanded(
              child: _buildQuestionArea(),
            ),

            // Opções de resposta
            _buildAnswerOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Timer visual
          Row(
            children: [
              const Icon(
                Icons.timer,
                color: AppTheme.textLight,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnimatedBuilder(
                  animation: _timerAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _timerAnimation.value,
                      backgroundColor: AppTheme.secondaryColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _timeRemaining > 10
                            ? AppTheme.secondaryColor
                            : AppTheme.errorColor,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$_timeRemaining',
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progresso
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pergunta ${_currentQuestionIndex + 1} de ${_questions.length}',
                style: const TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 16,
                ),
              ),
              Text(
                'Pontos: $_score',
                style: const TextStyle(
                  color: AppTheme.xpColor,
                  fontSize: 16,
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
    final question = _questions[_currentQuestionIndex];

    return AnimatedBuilder(
      animation: _questionAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _questionAnimation.value,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Título do jogo
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.secondaryColor,
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    '➖ Subtração Básica',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Pergunta visual
                _buildVisualQuestion(question),

                const SizedBox(height: 20),

                // Feedback se respondida
                if (_showFeedback)
                  AnimatedBuilder(
                    animation: _feedbackAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _feedbackAnimation.value,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _isCorrect
                                ? AppTheme.secondaryColor.withOpacity(0.2)
                                : AppTheme.errorColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isCorrect
                                  ? AppTheme.secondaryColor
                                  : AppTheme.errorColor,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isCorrect ? Icons.check_circle : Icons.cancel,
                                color: _isCorrect
                                    ? AppTheme.secondaryColor
                                    : AppTheme.errorColor,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                question.explanation,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: _isCorrect
                                      ? AppTheme.secondaryColor
                                      : AppTheme.errorColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _buildVisualQuestion(MathQuestion question) {
    // Extrair números da pergunta (ex: "8 - 3 = ?")
    final parts = question.question.split(' ');
    final num1 = parts[0];
    final num2 = parts[2];

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Números grandes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNumberBox(num1),
              const SizedBox(width: 12),
              const Text(
                '-',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(width: 12),
              _buildNumberBox(num2),
              const SizedBox(width: 12),
              const Text(
                '=',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              _buildNumberBox('?'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberBox(String number) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerOptions() {
    final question = _questions[_currentQuestionIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Grid de opções
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: question.options.length,
            itemBuilder: (context, index) {
              final option = question.options[index];
              final isSelected = _selectedAnswer == option;
              final isCorrect = option == question.correctAnswer;
              final showResult = _isAnswered;

              Color backgroundColor = AppTheme.surfaceLight;
              Color borderColor = AppTheme.secondaryColor.withOpacity(0.3);
              Color textColor = AppTheme.textLight;

              if (showResult) {
                if (isCorrect) {
                  backgroundColor = AppTheme.secondaryColor.withOpacity(0.2);
                  borderColor = AppTheme.secondaryColor;
                  textColor = AppTheme.secondaryColor;
                } else if (isSelected && !isCorrect) {
                  backgroundColor = AppTheme.errorColor.withOpacity(0.2);
                  borderColor = AppTheme.errorColor;
                  textColor = AppTheme.errorColor;
                }
              } else if (isSelected) {
                backgroundColor = AppTheme.secondaryColor.withOpacity(0.2);
                borderColor = AppTheme.secondaryColor;
                textColor = AppTheme.secondaryColor;
              }

              return GestureDetector(
                onTap: _isAnswered ? null : () => _selectAnswer(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: borderColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showResult && isCorrect)
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.secondaryColor,
                            size: 24,
                          )
                        else if (showResult && isSelected && !isCorrect)
                          const Icon(
                            Icons.cancel,
                            color: AppTheme.errorColor,
                            size: 24,
                          ),
                        if (showResult) const SizedBox(width: 8),
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Botão de próxima pergunta
          if (_isAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? 'Próxima Pergunta'
                      : 'Ver Resultado',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameCompleted() {
    final accuracy = (_score / (_questions.length * 10)) * 100;
    final xpEarned = _score;

    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone de sucesso
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(
                    color: AppTheme.secondaryColor,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 60,
                  color: AppTheme.secondaryColor,
                ),
              ),

              const SizedBox(height: 24),

              // Título
              const Text(
                'Parabéns!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Você concluiu o jogo de Subtração Básica!',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Estatísticas
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _buildStatRow('Pontos', '$_score', AppTheme.secondaryColor),
                    const SizedBox(height: 12),
                    _buildStatRow('Precisão', '${accuracy.toStringAsFixed(1)}%',
                        AppTheme.secondaryColor),
                    const SizedBox(height: 12),
                    _buildStatRow('XP Ganho', '+$xpEarned', AppTheme.xpColor),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Botões de ação
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go(AppRoutes.study),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text(
                        'Voltar aos Jogos',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Reiniciar o jogo
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Jogar Novamente',
                        style: TextStyle(color: Colors.white),
                      ),
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

  Widget _buildStatRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _selectAnswer(String answer) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
      _isCorrect = answer == _questions[_currentQuestionIndex].correctAnswer;
      _showFeedback = true;

      if (_isCorrect) {
        _score += _questions[_currentQuestionIndex].points;
      }
    });

    _feedbackController.forward();
  }

  void _nextQuestion() async {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
        _isCorrect = false;
        _showFeedback = false;
        _timeRemaining = 30;
      });

      _questionController.reset();
      _timerController.reset();
      _feedbackController.reset();

      _questionController.forward();
      _timerController.forward();
      _startTimer();
    } else {
      await _completeGame();
    }
  }

  Future<void> _completeGame() async {
    // Calcular estatísticas finais
    final correctAnswers = _score ~/ 10; // Assumindo 10 pontos por acerto
    final accuracy = correctAnswers / _questions.length;
    final xpEarned = _score;

    // Salvar resultado no banco de dados
    final result = {
      'gameId': widget.game.id,
      'correctAnswers': correctAnswers,
      'totalQuestions': _questions.length,
      'timeSpent': 30 - _timeRemaining,
      'xpEarned': xpEarned,
      'pointsEarned': _score,
      'accuracy': accuracy,
      'completedAt': DateTime.now().toIso8601String(),
      'achievements': [],
    };

    await SimpleDatabase.saveGameResult(result);
    await SimpleDatabase.updateUserXP(xpEarned);
    await SimpleDatabase.markGameCompleted(widget.game.id);

    setState(() {
      _gameCompleted = true;
    });

    // Mostrar celebração ou retry baseado na precisão
    if (accuracy >= 0.7) {
      _showCelebration(xpEarned);
    } else {
      _showRetry(accuracy);
    }
  }

  void _showCelebration(int xpEarned) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CelebrationWidget(
        xpGained: xpEarned,
        achievement: 'Mestre da Subtração! 🏆',
        onComplete: () {
          Navigator.of(context).pop();
          context.go(AppRoutes.mathGames);
        },
      ),
    );
  }

  void _showRetry(double accuracy) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RetryWidget(
        accuracy: accuracy,
        onRetry: () {
          Navigator.of(context).pop();
          _restartGame();
        },
        onGoBack: () {
          Navigator.of(context).pop();
          context.go(AppRoutes.mathGames);
        },
      ),
    );
  }

  void _restartGame() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _timeRemaining = 30;
      _selectedAnswer = null;
      _isAnswered = false;
      _isCorrect = false;
      _showFeedback = false;
      _gameCompleted = false;
    });

    _questionController.reset();
    _timerController.reset();
    _feedbackController.reset();

    _questionController.forward();
    _timerController.forward();
    _startTimer();
  }
}
