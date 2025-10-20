import 'package:flutter/material.dart';
import '../../../domain/entities/game_interface.dart';

/// Exercício de Múltipla Escolha
class MultipleChoiceExercise implements ExerciseType {
  @override
  String get typeName => 'Múltipla Escolha';

  @override
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer) {
    return MultipleChoiceWidget(
      question: question,
      onAnswer: onAnswer,
    );
  }

  @override
  bool validateAnswer(GameQuestion question, String answer) {
    return question.correctAnswer == answer;
  }
}

/// Exercício de Verdadeiro/Falso
class TrueFalseExercise implements ExerciseType {
  @override
  String get typeName => 'Verdadeiro/Falso';

  @override
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer) {
    return TrueFalseWidget(
      question: question,
      onAnswer: onAnswer,
    );
  }

  @override
  bool validateAnswer(GameQuestion question, String answer) {
    return question.correctAnswer == answer;
  }
}

/// Exercício de Complete a Frase
class FillBlankExercise implements ExerciseType {
  @override
  String get typeName => 'Complete a Frase';

  @override
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer) {
    return FillBlankWidget(
      question: question,
      onAnswer: onAnswer,
    );
  }

  @override
  bool validateAnswer(GameQuestion question, String answer) {
    return question.correctAnswer.toLowerCase() == answer.toLowerCase();
  }
}

/// Exercício de Quebra-cabeça
class PuzzleExercise implements ExerciseType {
  @override
  String get typeName => 'Quebra-cabeça';

  @override
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer) {
    return PuzzleWidget(
      question: question,
      onAnswer: onAnswer,
    );
  }

  @override
  bool validateAnswer(GameQuestion question, String answer) {
    return question.correctAnswer == answer;
  }
}

/// Exercício de Arrastar e Soltar
class DragDropExercise implements ExerciseType {
  @override
  String get typeName => 'Arrastar e Soltar';

  @override
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer) {
    return DragDropWidget(
      question: question,
      onAnswer: onAnswer,
    );
  }

  @override
  bool validateAnswer(GameQuestion question, String answer) {
    return question.correctAnswer == answer;
  }
}

/// Exercício de Associar
class MatchingExercise implements ExerciseType {
  @override
  String get typeName => 'Associar';

  @override
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer) {
    return MatchingWidget(
      question: question,
      onAnswer: onAnswer,
    );
  }

  @override
  bool validateAnswer(GameQuestion question, String answer) {
    return question.correctAnswer == answer;
  }
}

/// Exercício de Ordenar
class OrderingExercise implements ExerciseType {
  @override
  String get typeName => 'Ordenar';

  @override
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer) {
    return OrderingWidget(
      question: question,
      onAnswer: onAnswer,
    );
  }

  @override
  bool validateAnswer(GameQuestion question, String answer) {
    return question.correctAnswer == answer;
  }
}

/// Exercício de Digitação
class TypingExercise implements ExerciseType {
  @override
  String get typeName => 'Digitação';

  @override
  Widget buildQuestionWidget(GameQuestion question, Function(String) onAnswer) {
    return TypingWidget(
      question: question,
      onAnswer: onAnswer,
    );
  }

  @override
  bool validateAnswer(GameQuestion question, String answer) {
    return question.correctAnswer.toLowerCase() == answer.toLowerCase();
  }
}
