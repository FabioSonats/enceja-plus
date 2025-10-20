import '../../../core/constants/app_constants.dart';

enum MathGameType {
  addition,
  subtraction,
  multiplication,
  division,
  fractions,
  geometry,
  algebra,
  wordProblems,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
  expert,
}

class MathGame {
  final String id;
  final String title;
  final String description;
  final MathGameType type;
  final DifficultyLevel difficulty;
  final int timeLimit; // em segundos
  final int xpReward;
  final String icon;
  final List<MathQuestion> questions;
  final bool isUnlocked;
  final bool isCompleted;

  const MathGame({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.difficulty,
    required this.timeLimit,
    required this.xpReward,
    required this.icon,
    required this.questions,
    required this.isUnlocked,
    required this.isCompleted,
  });

  MathGame copyWith({
    String? id,
    String? title,
    String? description,
    MathGameType? type,
    DifficultyLevel? difficulty,
    int? timeLimit,
    int? xpReward,
    String? icon,
    List<MathQuestion>? questions,
    bool? isUnlocked,
    bool? isCompleted,
  }) {
    return MathGame(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      timeLimit: timeLimit ?? this.timeLimit,
      xpReward: xpReward ?? this.xpReward,
      icon: icon ?? this.icon,
      questions: questions ?? this.questions,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class MathQuestion {
  final String id;
  final String question;
  final String? imageUrl;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final int timeLimit; // em segundos
  final int points;
  final MathGameType type;

  const MathQuestion({
    required this.id,
    required this.question,
    this.imageUrl,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.timeLimit,
    required this.points,
    required this.type,
  });
}

class MathGameResult {
  final String gameId;
  final int correctAnswers;
  final int totalQuestions;
  final int timeSpent; // em segundos
  final int xpEarned;
  final int pointsEarned;
  final double accuracy;
  final DateTime completedAt;
  final List<String> achievements;

  const MathGameResult({
    required this.gameId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
    required this.xpEarned,
    required this.pointsEarned,
    required this.accuracy,
    required this.completedAt,
    required this.achievements,
  });
}

// Jogos pré-definidos de matemática
class PredefinedMathGames {
  static const List<MathGame> games = [
    MathGame(
      id: 'addition_basics',
      title: 'Soma Básica',
      description: 'Aprenda a somar números de 1 a 20',
      type: MathGameType.addition,
      difficulty: DifficultyLevel.easy,
      timeLimit: 60,
      xpReward: 50,
      icon: '➕',
      questions: [],
      isUnlocked: true,
      isCompleted: false,
    ),
    MathGame(
      id: 'subtraction_basics',
      title: 'Subtração Básica',
      description: 'Aprenda a subtrair números de 1 a 20',
      type: MathGameType.subtraction,
      difficulty: DifficultyLevel.easy,
      timeLimit: 60,
      xpReward: 50,
      icon: '➖',
      questions: [],
      isUnlocked: true,
      isCompleted: false,
    ),
    MathGame(
      id: 'multiplication_tables',
      title: 'Tabuada',
      description: 'Pratique as tabuadas de 1 a 10',
      type: MathGameType.multiplication,
      difficulty: DifficultyLevel.medium,
      timeLimit: 90,
      xpReward: 75,
      icon: '✖️',
      questions: [],
      isUnlocked: false,
      isCompleted: false,
    ),
    MathGame(
      id: 'division_basics',
      title: 'Divisão Básica',
      description: 'Aprenda a dividir números simples',
      type: MathGameType.division,
      difficulty: DifficultyLevel.medium,
      timeLimit: 90,
      xpReward: 75,
      icon: '➗',
      questions: [],
      isUnlocked: false,
      isCompleted: false,
    ),
    MathGame(
      id: 'fractions_intro',
      title: 'Frações',
      description: 'Introdução às frações básicas',
      type: MathGameType.fractions,
      difficulty: DifficultyLevel.hard,
      timeLimit: 120,
      xpReward: 100,
      icon: '🔢',
      questions: [],
      isUnlocked: false,
      isCompleted: false,
    ),
    MathGame(
      id: 'geometry_shapes',
      title: 'Formas Geométricas',
      description: 'Identifique e calcule áreas de formas',
      type: MathGameType.geometry,
      difficulty: DifficultyLevel.hard,
      timeLimit: 120,
      xpReward: 100,
      icon: '📐',
      questions: [],
      isUnlocked: false,
      isCompleted: false,
    ),
    MathGame(
      id: 'word_problems',
      title: 'Problemas de Palavras',
      description: 'Resolva problemas matemáticos do mundo real',
      type: MathGameType.wordProblems,
      difficulty: DifficultyLevel.expert,
      timeLimit: 180,
      xpReward: 150,
      icon: '📝',
      questions: [],
      isUnlocked: false,
      isCompleted: false,
    ),
  ];
}
