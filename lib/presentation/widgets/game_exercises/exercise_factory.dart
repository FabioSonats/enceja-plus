import 'package:flutter/material.dart';
import '../../../domain/entities/game_interface.dart';
import 'exercise_types.dart';
import 'multiple_choice_widget.dart';
import 'true_false_widget.dart';
import 'fill_blank_widget.dart';

/// Factory para criar widgets de exercícios
/// Segue o princípio SOLID - Dependency Inversion
class ExerciseFactory {
  static ExerciseType createExerciseType(ExerciseTypeEnum type) {
    switch (type) {
      case ExerciseTypeEnum.multipleChoice:
        return MultipleChoiceExercise();
      case ExerciseTypeEnum.trueFalse:
        return TrueFalseExercise();
      case ExerciseTypeEnum.fillBlank:
        return FillBlankExercise();
      case ExerciseTypeEnum.puzzle:
        return PuzzleExercise();
      case ExerciseTypeEnum.dragDrop:
        return DragDropExercise();
      case ExerciseTypeEnum.matching:
        return MatchingExercise();
      case ExerciseTypeEnum.ordering:
        return OrderingExercise();
      case ExerciseTypeEnum.typing:
        return TypingExercise();
    }
  }

  static Widget createExerciseWidget(
    GameQuestion question,
    Function(String) onAnswer,
  ) {
    final exerciseType = ExerciseTypeEnum.values.firstWhere(
      (type) => type.name == question.exerciseType,
      orElse: () => ExerciseTypeEnum.multipleChoice,
    );

    final exercise = createExerciseType(exerciseType);
    return exercise.buildQuestionWidget(question, onAnswer);
  }
}

/// Classe para gerenciar diferentes tipos de exercícios
class ExerciseManager {
  static final Map<ExerciseTypeEnum, ExerciseType> _exerciseTypes = {
    ExerciseTypeEnum.multipleChoice: MultipleChoiceExercise(),
    ExerciseTypeEnum.trueFalse: TrueFalseExercise(),
    ExerciseTypeEnum.fillBlank: FillBlankExercise(),
    ExerciseTypeEnum.puzzle: PuzzleExercise(),
    ExerciseTypeEnum.dragDrop: DragDropExercise(),
    ExerciseTypeEnum.matching: MatchingExercise(),
    ExerciseTypeEnum.ordering: OrderingExercise(),
    ExerciseTypeEnum.typing: TypingExercise(),
  };

  static ExerciseType getExerciseType(ExerciseTypeEnum type) {
    return _exerciseTypes[type] ?? MultipleChoiceExercise();
  }

  static List<ExerciseTypeEnum> getAvailableTypes() {
    return ExerciseTypeEnum.values;
  }

  static String getTypeDisplayName(ExerciseTypeEnum type) {
    return type.displayName;
  }
}

/// Classe para criar questões de diferentes tipos
class QuestionBuilder {
  static GameQuestion createMultipleChoice({
    required String id,
    required String question,
    required List<String> options,
    required String correctAnswer,
    required String explanation,
    int timeLimit = 30,
    int points = 10,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return GameQuestion(
      id: id,
      question: question,
      imageUrl: imageUrl,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
      timeLimit: timeLimit,
      points: points,
      exerciseType: ExerciseTypeEnum.multipleChoice.name,
      metadata: metadata,
    );
  }

  static GameQuestion createTrueFalse({
    required String id,
    required String question,
    required String correctAnswer,
    required String explanation,
    int timeLimit = 30,
    int points = 10,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return GameQuestion(
      id: id,
      question: question,
      imageUrl: imageUrl,
      options: ['Verdadeiro', 'Falso'],
      correctAnswer: correctAnswer,
      explanation: explanation,
      timeLimit: timeLimit,
      points: points,
      exerciseType: ExerciseTypeEnum.trueFalse.name,
      metadata: metadata,
    );
  }

  static GameQuestion createFillBlank({
    required String id,
    required String question,
    required String correctAnswer,
    required String explanation,
    List<String> options = const [],
    int timeLimit = 30,
    int points = 10,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return GameQuestion(
      id: id,
      question: question,
      imageUrl: imageUrl,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
      timeLimit: timeLimit,
      points: points,
      exerciseType: ExerciseTypeEnum.fillBlank.name,
      metadata: metadata,
    );
  }

  static GameQuestion createPuzzle({
    required String id,
    required String question,
    required String correctAnswer,
    required String explanation,
    List<String> options = const [],
    int timeLimit = 60,
    int points = 15,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return GameQuestion(
      id: id,
      question: question,
      imageUrl: imageUrl,
      options: options,
      correctAnswer: correctAnswer,
      explanation: explanation,
      timeLimit: timeLimit,
      points: points,
      exerciseType: ExerciseTypeEnum.puzzle.name,
      metadata: metadata,
    );
  }
}
