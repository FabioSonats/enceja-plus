class Lesson {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String educationLevel;
  final int order;
  final int estimatedTime; // em minutos
  final List<Question> questions;
  final bool isCompleted;
  final int xpReward;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.educationLevel,
    required this.order,
    required this.estimatedTime,
    required this.questions,
    required this.isCompleted,
    required this.xpReward,
  });
}

class Question {
  final String id;
  final String question;
  final String type; // 'multiple_choice', 'true_false', 'text'
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final int timeLimit; // em segundos

  const Question({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.timeLimit,
  });
}

class QuizResult {
  final String lessonId;
  final int correctAnswers;
  final int totalQuestions;
  final int timeSpent; // em segundos
  final int xpEarned;
  final DateTime completedAt;

  const QuizResult({
    required this.lessonId,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.timeSpent,
    required this.xpEarned,
    required this.completedAt,
  });

  double get accuracy => correctAnswers / totalQuestions;
}
