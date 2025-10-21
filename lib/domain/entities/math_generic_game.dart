import 'game_interface.dart';
import 'math_game.dart';

/// Jogo de matemática genérico implementando GameInterface
/// Segue o princípio SOLID - Single Responsibility
class MathGenericGame implements GameInterface {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String icon;
  @override
  final int timeLimit;
  @override
  final int xpReward;
  @override
  final bool isUnlocked;
  @override
  final bool isCompleted;
  @override
  final List<GameQuestion> questions;

  const MathGenericGame({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.timeLimit,
    required this.xpReward,
    required this.isUnlocked,
    required this.isCompleted,
    required this.questions,
  });

  @override
  bool validateAnswer(String questionId, String answer) {
    final question = questions.firstWhere((q) => q.id == questionId);
    return question.correctAnswer == answer;
  }

  @override
  int calculateScore(String questionId, String answer, int timeSpent) {
    final question = questions.firstWhere((q) => q.id == questionId);
    final isCorrect = validateAnswer(questionId, answer);

    if (!isCorrect) return 0;

    // Pontuação baseada no tempo restante
    final timeBonus = (question.timeLimit - timeSpent) ~/ 5;
    return question.points + timeBonus;
  }

  @override
  String getExplanation(String questionId) {
    final question = questions.firstWhere((q) => q.id == questionId);
    return question.explanation;
  }

  /// Converte MathGame para MathGenericGame
  factory MathGenericGame.fromMathGame(MathGame mathGame) {
    return MathGenericGame(
      id: mathGame.id,
      title: mathGame.title,
      description: mathGame.description,
      icon: mathGame.icon,
      timeLimit: mathGame.timeLimit,
      xpReward: mathGame.xpReward,
      isUnlocked: mathGame.isUnlocked,
      isCompleted: mathGame.isCompleted,
      questions: mathGame.questions
          .map((q) => GameQuestion(
                id: q.id,
                question: q.question,
                imageUrl: null,
                options: q.options,
                correctAnswer: q.correctAnswer,
                explanation: q.explanation,
                timeLimit: q.timeLimit,
                points: q.points,
                exerciseType: _getExerciseTypeFromMathType(q.type),
                metadata: {
                  'mathType': q.type.name,
                  'difficulty': mathGame.difficulty.name,
                },
              ))
          .toList(),
    );
  }

  static String _getExerciseTypeFromMathType(MathGameType type) {
    switch (type) {
      case MathGameType.addition:
      case MathGameType.subtraction:
      case MathGameType.multiplication:
      case MathGameType.division:
        return 'multipleChoice';
      case MathGameType.fractions:
        return 'fillBlank';
      case MathGameType.geometry:
        return 'puzzle';
      case MathGameType.wordProblems:
        return 'multipleChoice';
      case MathGameType.algebra:
        return 'multipleChoice';
      case MathGameType.puzzle:
        return 'puzzle';
      case MathGameType.crossword:
        return 'crossword';
    }
  }
}

/// Classe para criar jogos de matemática específicos
class MathGameBuilder {
  /// Cria jogo de soma com múltipla escolha
  static MathGenericGame createAdditionGame() {
    return MathGenericGame(
      id: 'addition_generic',
      title: 'Soma Interativa',
      description: 'Aprenda a somar com exercícios variados',
      icon: '➕',
      timeLimit: 60,
      xpReward: 50,
      isUnlocked: true,
      isCompleted: false,
      questions: [
        GameQuestion(
          id: 'add_gen_1',
          question: 'Quanto é 5 + 3?',
          options: ['6', '7', '8', '9'],
          correctAnswer: '8',
          explanation: '5 + 3 = 8. Você soma 5 e 3 para obter 8.',
          timeLimit: 30,
          points: 10,
          exerciseType: 'multipleChoice',
          metadata: {'difficulty': 'easy', 'topic': 'addition'},
        ),
        GameQuestion(
          id: 'add_gen_2',
          question: 'Complete: 12 + ___ = 19',
          options: ['5', '6', '7', '8'],
          correctAnswer: '7',
          explanation:
              '12 + 7 = 19. Para encontrar o número, faça 19 - 12 = 7.',
          timeLimit: 30,
          points: 10,
          exerciseType: 'multipleChoice',
          metadata: {'difficulty': 'medium', 'topic': 'addition'},
        ),
        GameQuestion(
          id: 'add_gen_3',
          question:
              'Maria tem 15 reais e ganha mais 8 reais. Quanto ela tem agora?',
          options: ['21', '22', '23', '24'],
          correctAnswer: '23',
          explanation: '15 + 8 = 23 reais.',
          timeLimit: 45,
          points: 15,
          exerciseType: 'multipleChoice',
          metadata: {'difficulty': 'medium', 'topic': 'word_problems'},
        ),
      ],
    );
  }

  /// Cria jogo de subtração com verdadeiro/falso
  static MathGenericGame createSubtractionGame() {
    return MathGenericGame(
      id: 'subtraction_generic',
      title: 'Subtração Interativa',
      description: 'Aprenda a subtrair com exercícios variados',
      icon: '➖',
      timeLimit: 60,
      xpReward: 50,
      isUnlocked: true,
      isCompleted: false,
      questions: [
        GameQuestion(
          id: 'sub_gen_1',
          question: '10 - 4 = 6',
          options: ['Verdadeiro', 'Falso'],
          correctAnswer: 'Verdadeiro',
          explanation: '10 - 4 = 6. A subtração está correta.',
          timeLimit: 30,
          points: 10,
          exerciseType: 'trueFalse',
          metadata: {'difficulty': 'easy', 'topic': 'subtraction'},
        ),
        GameQuestion(
          id: 'sub_gen_2',
          question: '15 - 8 = 6',
          options: ['Verdadeiro', 'Falso'],
          correctAnswer: 'Falso',
          explanation: '15 - 8 = 7, não 6.',
          timeLimit: 30,
          points: 10,
          exerciseType: 'trueFalse',
          metadata: {'difficulty': 'easy', 'topic': 'subtraction'},
        ),
        GameQuestion(
          id: 'sub_gen_3',
          question: 'Complete: 20 - ___ = 12',
          options: ['6', '7', '8', '9'],
          correctAnswer: '8',
          explanation:
              '20 - 8 = 12. Para encontrar o número, faça 20 - 12 = 8.',
          timeLimit: 30,
          points: 10,
          exerciseType: 'multipleChoice',
          metadata: {'difficulty': 'medium', 'topic': 'subtraction'},
        ),
      ],
    );
  }

  /// Cria jogo de multiplicação com complete a frase
  static MathGenericGame createMultiplicationGame() {
    return MathGenericGame(
      id: 'multiplication_generic',
      title: 'Multiplicação Interativa',
      description: 'Aprenda a multiplicar com exercícios variados',
      icon: '✖️',
      timeLimit: 90,
      xpReward: 75,
      isUnlocked: false,
      isCompleted: false,
      questions: [
        GameQuestion(
          id: 'mult_gen_1',
          question: 'Complete: 7 × 3 = ___',
          options: ['20', '21', '22', '23'],
          correctAnswer: '21',
          explanation: '7 × 3 = 21. Multiplicação básica.',
          timeLimit: 45,
          points: 15,
          exerciseType: 'fillBlank',
          metadata: {'difficulty': 'medium', 'topic': 'multiplication'},
        ),
        GameQuestion(
          id: 'mult_gen_2',
          question: 'Complete: 6 × ___ = 24',
          options: ['3', '4', '5', '6'],
          correctAnswer: '4',
          explanation: '6 × 4 = 24. Para encontrar o número, faça 24 ÷ 6 = 4.',
          timeLimit: 45,
          points: 15,
          exerciseType: 'multipleChoice',
          metadata: {'difficulty': 'medium', 'topic': 'multiplication'},
        ),
        GameQuestion(
          id: 'mult_gen_3',
          question:
              'João tem 4 caixas com 8 lápis cada. Quantos lápis ele tem?',
          options: ['28', '30', '32', '34'],
          correctAnswer: '32',
          explanation: '4 × 8 = 32 lápis.',
          timeLimit: 60,
          points: 20,
          exerciseType: 'multipleChoice',
          metadata: {'difficulty': 'hard', 'topic': 'word_problems'},
        ),
      ],
    );
  }

  /// Cria jogo de frações com quebra-cabeça
  static MathGenericGame createFractionsGame() {
    return MathGenericGame(
      id: 'fractions_generic',
      title: 'Frações Interativas',
      description: 'Aprenda frações com exercícios visuais',
      icon: '🔢',
      timeLimit: 120,
      xpReward: 100,
      isUnlocked: false,
      isCompleted: false,
      questions: [
        GameQuestion(
          id: 'frac_gen_1',
          question: 'Qual fração representa metade?',
          options: ['1/3', '1/2', '2/3', '3/4'],
          correctAnswer: '1/2',
          explanation: '1/2 representa metade de um todo.',
          timeLimit: 60,
          points: 20,
          exerciseType: 'multipleChoice',
          metadata: {'difficulty': 'medium', 'topic': 'fractions'},
        ),
        GameQuestion(
          id: 'frac_gen_2',
          question: 'Complete: 1/2 + 1/2 = ___',
          options: ['1/4', '1/2', '1', '2'],
          correctAnswer: '1',
          explanation: '1/2 + 1/2 = 2/2 = 1.',
          timeLimit: 60,
          points: 20,
          exerciseType: 'fillBlank',
          metadata: {'difficulty': 'hard', 'topic': 'fractions'},
        ),
        GameQuestion(
          id: 'frac_gen_3',
          question: 'Qual é maior: 1/3 ou 1/4?',
          options: ['1/3', '1/4', 'São iguais', 'Não sei'],
          correctAnswer: '1/3',
          explanation:
              '1/3 é maior que 1/4. Quanto menor o denominador, maior a fração.',
          timeLimit: 60,
          points: 20,
          exerciseType: 'multipleChoice',
          metadata: {'difficulty': 'hard', 'topic': 'fractions'},
        ),
      ],
    );
  }
}
