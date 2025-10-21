import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../domain/entities/math_game.dart';
import '../../../../data/datasources/simple_database.dart';

class AdditionGameScreen extends StatefulWidget {
  final MathGame game;

  const AdditionGameScreen({
    super.key,
    required this.game,
  });

  @override
  State<AdditionGameScreen> createState() => _AdditionGameScreenState();
}

class _AdditionGameScreenState extends State<AdditionGameScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _questionController;
  late Animation<double> _questionAnimation;

  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeRemaining = 0;
  String? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;
  bool _gameCompleted = false;

  final List<MathQuestion> _questions = [
    MathQuestion(
      id: '1',
      question: 'Quanto é 5 + 3?',
      options: ['6', '7', '8', '9'],
      correctAnswer: '8',
      explanation: '5 + 3 = 8. Você soma 5 e 3 para obter 8.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.addition,
    ),
    MathQuestion(
      id: '2',
      question: 'Quanto é 7 + 4?',
      options: ['10', '11', '12', '13'],
      correctAnswer: '11',
      explanation: '7 + 4 = 11. Você soma 7 e 4 para obter 11.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.addition,
    ),
    MathQuestion(
      id: '3',
      question: 'Quanto é 9 + 6?',
      options: ['14', '15', '16', '17'],
      correctAnswer: '15',
      explanation: '9 + 6 = 15. Você soma 9 e 6 para obter 15.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.addition,
    ),
    MathQuestion(
      id: '4',
      question: 'Quanto é 12 + 8?',
      options: ['18', '19', '20', '21'],
      correctAnswer: '20',
      explanation: '12 + 8 = 20. Você soma 12 e 8 para obter 20.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.addition,
    ),
    MathQuestion(
      id: '5',
      question: 'Quanto é 15 + 7?',
      options: ['20', '21', '22', '23'],
      correctAnswer: '22',
      explanation: '15 + 7 = 22. Você soma 15 e 7 para obter 22.',
      timeLimit: 30,
      points: 10,
      type: MathGameType.addition,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.game.timeLimit;
    _setupAnimations();
    _startTimer();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _questionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _questionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _questionController,
      curve: Curves.elasticOut,
    ));

    _questionController.forward();
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

  @override
  void dispose() {
    _progressController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gameCompleted) {
      return _buildGameCompleted();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.title),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitDialog(),
        ),
      ),
      body: Column(
        children: [
          // Header com progresso e tempo
          _buildHeader(),

          // Pergunta atual
          Expanded(
            child: _buildQuestion(),
          ),

          // Opções de resposta
          _buildAnswerOptions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Progresso
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pergunta ${_currentQuestionIndex + 1} de ${_questions.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Timer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                '$_timeRemaining',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    final question = _questions[_currentQuestionIndex];

    return AnimatedBuilder(
      animation: _questionAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _questionAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ícone do jogo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      '➕',
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Pergunta
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Explicação (se respondida)
                if (_isAnswered)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isCorrect
                          ? AppTheme.secondaryColor.withOpacity(0.1)
                          : AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _isCorrect
                            ? AppTheme.secondaryColor
                            : AppTheme.errorColor,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      question.explanation,
                      style: TextStyle(
                        fontSize: 16,
                        color: _isCorrect
                            ? AppTheme.secondaryColor
                            : AppTheme.errorColor,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerOptions() {
    final question = _questions[_currentQuestionIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Opções de resposta
          ...question.options.map((option) {
            final isSelected = _selectedAnswer == option;
            final isCorrect = option == question.correctAnswer;
            final showResult = _isAnswered;

            Color backgroundColor = Colors.white;
            Color borderColor = Colors.grey[300]!;
            Color textColor = Colors.black87;

            if (showResult) {
              if (isCorrect) {
                backgroundColor = AppTheme.secondaryColor.withOpacity(0.1);
                borderColor = AppTheme.secondaryColor;
                textColor = AppTheme.secondaryColor;
              } else if (isSelected && !isCorrect) {
                backgroundColor = AppTheme.errorColor.withOpacity(0.1);
                borderColor = AppTheme.errorColor;
                textColor = AppTheme.errorColor;
              }
            } else if (isSelected) {
              backgroundColor = AppTheme.primaryColor.withOpacity(0.1);
              borderColor = AppTheme.primaryColor;
              textColor = AppTheme.primaryColor;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: _isAnswered ? null : () => _selectAnswer(option),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: showResult && isCorrect
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : showResult && isSelected && !isCorrect
                                  ? const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          const SizedBox(height: 20),

          // Botão de próxima pergunta
          if (_isAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? 'Próxima Pergunta'
                      : 'Ver Resultado',
                  style: const TextStyle(
                    fontSize: 16,
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
      appBar: AppBar(
        title: const Text('Jogo Concluído!'),
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone de sucesso
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
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
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Você concluiu o jogo de Soma Básica!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Estatísticas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.primaryColor.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  _buildStatRow('Pontos', '$_score', AppTheme.primaryColor),
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
                    onPressed: () => context.go(AppRoutes.home),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Voltar aos Jogos'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Reiniciar o jogo
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
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
            color: Colors.black54,
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

      if (_isCorrect) {
        _score += _questions[_currentQuestionIndex].points;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
        _isCorrect = false;
        _timeRemaining = widget.game.timeLimit;
      });

      _questionController.reset();
      _questionController.forward();
      _startTimer();
    } else {
      _completeGame();
    }
  }

  void _completeGame() async {
    // Calcular estatísticas finais
    final accuracy = (_score / (_questions.length * 10)) * 100;
    final xpEarned = _score;

    // Salvar resultado no banco de dados
    final result = {
      'gameId': widget.game.id,
      'correctAnswers': _score ~/ 10, // Assumindo 10 pontos por acerto
      'totalQuestions': _questions.length,
      'timeSpent': widget.game.timeLimit - _timeRemaining,
      'xpEarned': xpEarned,
      'pointsEarned': _score,
      'accuracy': accuracy / 100,
      'completedAt': DateTime.now().toIso8601String(),
      'achievements': [],
    };

    await SimpleDatabase.saveGameResult(result);
    await SimpleDatabase.updateUserXP(xpEarned);
    await SimpleDatabase.markGameCompleted(widget.game.id);

    setState(() {
      _gameCompleted = true;
    });
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair do Jogo'),
        content: const Text(
            'Tem certeza que deseja sair? Seu progresso será perdido.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRoutes.home);
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }
}
