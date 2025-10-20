class AppConstants {
  // App Info
  static const String appName = 'ENCCEJA+';
  static const String appVersion = '1.0.0';

  // Gamificação
  static const int xpPerLesson = 10;
  static const int xpPerQuiz = 20;
  static const int xpPerSimulated = 50;
  static const int xpPerAchievement = 100;

  // Níveis
  static const List<int> levelThresholds = [
    0,
    100,
    250,
    500,
    750,
    1000,
    1500,
    2000,
    3000,
    5000
  ];

  // Matérias ENCCEJA
  static const List<String> subjects = [
    'Matemática',
    'Português',
    'História',
    'Geografia',
    'Ciências',
    'Redação'
  ];

  // Níveis de ensino
  static const String fundamentalLevel = 'Fundamental';
  static const String medioLevel = 'Médio';

  // URLs e configurações
  static const String firebaseProjectId = 'encceja-plus';
  static const String privacyPolicyUrl = 'https://encceja-plus.com/privacy';
  static const String termsOfServiceUrl = 'https://encceja-plus.com/terms';

  // Tempos
  static const int quizTimeLimit = 30; // segundos
  static const int simulatedTimeLimit = 180; // 3 minutos
  static const int lessonTimeLimit = 600; // 10 minutos
}
