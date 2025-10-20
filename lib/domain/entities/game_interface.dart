import 'package:flutter/material.dart';

/// Interface base para todos os tipos de jogos
/// Segue o princípio SOLID - Interface Segregation
abstract class GameInterface {
  String get id;
  String get title;
  String get description;
  String get icon;
  int get timeLimit;
  int get xpReward;
  bool get isUnlocked;
  bool get isCompleted;
  
  List<GameQuestion> get questions;
  
  /// Valida se a resposta está correta
  bool validateAnswer(String questionId, String answer);
  
  /// Calcula a pontuação baseada na resposta
  int calculateScore(String questionId, String answer, int timeSpent);
  
  /// Retorna a explicação da resposta
  String getExplanation(String questionId);
}

/// Interface para diferentes tipos de exercícios
abstract class ExerciseType {
  String get typeName;
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer);
  bool validateAnswer(GameQuestion question, String answer);
}

/// Classe base para questões de jogo
class GameQuestion {
  final String id;
  final String question;
  final String? imageUrl;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final int timeLimit;
  final int points;
  final String exerciseType;
  final Map<String, dynamic>? metadata;

  const GameQuestion({
    required this.id,
    required this.question,
    this.imageUrl,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.timeLimit,
    required this.points,
    required this.exerciseType,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'imageUrl': imageUrl,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'timeLimit': timeLimit,
      'points': points,
      'exerciseType': exerciseType,
      'metadata': metadata,
    };
  }

  factory GameQuestion.fromJson(Map<String, dynamic> json) {
    return GameQuestion(
      id: json['id'],
      question: json['question'],
      imageUrl: json['imageUrl'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      timeLimit: json['timeLimit'],
      points: json['points'],
      exerciseType: json['exerciseType'],
      metadata: json['metadata'],
    );
  }
}

/// Enum para tipos de exercícios
enum ExerciseTypeEnum {
  multipleChoice('Múltipla Escolha'),
  trueFalse('Verdadeiro/Falso'),
  fillBlank('Complete a Frase'),
  puzzle('Quebra-cabeça'),
  dragDrop('Arrastar e Soltar'),
  matching('Associar'),
  ordering('Ordenar'),
  typing('Digitação');

  const ExerciseTypeEnum(this.displayName);
  final String displayName;
}

/// Resultado de um jogo
class GameResult {
  final String gameId;
  final int correctAnswers;
  final int totalQuestions;
  final int timeSpent;
  final int xpEarned;
  final int pointsEarned;
  final double accuracy;
  final DateTime completedAt;
  final List<String> achievements;

  const GameResult({
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

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'correctAnswers': correctAnswers,
      'totalQuestions': totalQuestions,
      'timeSpent': timeSpent,
      'xpEarned': xpEarned,
      'pointsEarned': pointsEarned,
      'accuracy': accuracy,
      'completedAt': completedAt.toIso8601String(),
      'achievements': achievements,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      gameId: json['gameId'],
      correctAnswers: json['correctAnswers'],
      totalQuestions: json['totalQuestions'],
      timeSpent: json['timeSpent'],
      xpEarned: json['xpEarned'],
      pointsEarned: json['pointsEarned'],
      accuracy: json['accuracy'].toDouble(),
      completedAt: DateTime.parse(json['completedAt']),
      achievements: List<String>.from(json['achievements']),
    );
  }
}
