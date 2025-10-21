import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../data/datasources/simple_database.dart';
import '../../../widgets/celebration_widget.dart';
import '../../../widgets/retry_widget.dart';

class GrammarBasicsGameScreen extends StatefulWidget {
  const GrammarBasicsGameScreen({super.key});

  @override
  State<GrammarBasicsGameScreen> createState() =>
      _GrammarBasicsGameScreenState();
}

class _GrammarBasicsGameScreenState extends State<GrammarBasicsGameScreen>
    with TickerProviderStateMixin {
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

  final List<Map<String, dynamic>> _questions = [
    {
      'id': '1',
      'question': 'Qual é a classe gramatical da palavra "CASA"?',
      'options': ['Substantivo', 'Adjetivo', 'Verbo', 'Advérbio'],
      'correctAnswer': 'Substantivo',
      'explanation':
          'CASA é um substantivo, pois nomeia um lugar onde se mora.',
      'timeLimit': 30,
      'points': 10,
    },
    {
      'id': '2',
      'question': 'Qual é a classe gramatical da palavra "BONITO"?',
      'options': ['Substantivo', 'Adjetivo', 'Verbo', 'Advérbio'],
      'correctAnswer': 'Adjetivo',
      'explanation': 'BONITO é um adjetivo, pois qualifica um substantivo.',
      'timeLimit': 30,
      'points': 10,
    },
    {
      'id': '3',
      'question': 'Qual é a classe gramatical da palavra "CORRER"?',
      'options': ['Substantivo', 'Adjetivo', 'Verbo', 'Advérbio'],
      'correctAnswer': 'Verbo',
      'explanation': 'CORRER é um verbo, pois indica uma ação.',
      'timeLimit': 30,
      'points': 10,
    },
    {
      'id': '4',
      'question': 'Qual é a classe gramatical da palavra "RAPIDAMENTE"?',
      'options': ['Substantivo', 'Adjetivo', 'Verbo', 'Advérbio'],
      'correctAnswer': 'Advérbio',
      'explanation': 'RAPIDAMENTE é um advérbio, pois modifica um verbo.',
      'timeLimit': 30,
      'points': 10,
    },
    {
      'id': '5',
      'question': 'Qual é a classe gramatical da palavra "FELICIDADE"?',
      'options': ['Substantivo', 'Adjetivo', 'Verbo', 'Advérbio'],
      'correctAnswer': 'Substantivo',
      'explanation':
          'FELICIDADE é um substantivo abstrato, pois nomeia um sentimento.',
      'timeLimit': 30,
      'points': 10,
    },
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
      appBar: AppBar(
        title: const Text('Gramática Básica'),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.portuguese),
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
                        context.go(AppRoutes.portuguese);
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
                color: Colors.white,
                size: 24,
              ),
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
                    color: AppTheme.secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.secondaryColor,
                      width: 2,
                    ),
                  ),
                  child: const Text(
                    '📝 Gramática Básica',
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
                              Expanded(
                                child: Text(
                                  question['explanation'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _isCorrect
                                        ? AppTheme.secondaryColor
                                        : AppTheme.errorColor,
                                    fontWeight: FontWeight.w500,
                                  ),
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

  Widget _buildVisualQuestion(Map<String, dynamic> question) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.secondaryColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Pergunta
          Text(
            question['question'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.textLight,
            ),
          ),

          const SizedBox(height: 20),

          // Ícone representativo
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppTheme.secondaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: AppTheme.secondaryColor,
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.school,
              size: 40,
              color: AppTheme.secondaryColor,
            ),
          ),
        ],
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
            itemCount: question['options'].length,
            itemBuilder: (context, index) {
              final option = question['options'][index];
              final isSelected = _selectedAnswer == option;
              final isCorrect = option == question['correctAnswer'];
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
                        Expanded(
                          child: Text(
                            option,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
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
                'Você concluiu o jogo de Gramática Básica!',
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
                      onPressed: () => context.go(AppRoutes.portuguese),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.white),
                      ),
                      child: const Text(
                        'Voltar ao Português',
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
      _isCorrect = answer == _questions[_currentQuestionIndex]['correctAnswer'];
      _showFeedback = true;

      if (_isCorrect) {
        _score += _questions[_currentQuestionIndex]['points'] as int;
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
      'gameId': 'grammar_basics',
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
        achievement: 'Mestre da Gramática! 🏆',
        onComplete: () {
          Navigator.of(context).pop();
          context.go(AppRoutes.portuguese);
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
          context.go(AppRoutes.portuguese);
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
