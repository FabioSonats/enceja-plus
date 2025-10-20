
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

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.index,
      'difficulty': difficulty.index,
      'timeLimit': timeLimit,
      'xpReward': xpReward,
      'icon': icon,
      'questions': questions.map((q) => q.toJson()).toList(),
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
    };
  }

  factory MathGame.fromJson(Map<String, dynamic> json) {
    return MathGame(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: MathGameType.values[json['type']],
      difficulty: DifficultyLevel.values[json['difficulty']],
      timeLimit: json['timeLimit'],
      xpReward: json['xpReward'],
      icon: json['icon'],
      questions: (json['questions'] as List)
          .map((q) => MathQuestion.fromJson(q))
          .toList(),
      isUnlocked: json['isUnlocked'],
      isCompleted: json['isCompleted'],
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

  // JSON serialization
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
      'type': type.index,
    };
  }

  factory MathQuestion.fromJson(Map<String, dynamic> json) {
    return MathQuestion(
      id: json['id'],
      question: json['question'],
      imageUrl: json['imageUrl'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      timeLimit: json['timeLimit'],
      points: json['points'],
      type: MathGameType.values[json['type']],
    );
  }
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
  static final List<MathGame> games = [
    // NÍVEL 1 - OPERAÇÕES BÁSICAS
    MathGame(
      id: 'addition_basics',
      title: 'Soma Básica',
      description: 'Aprenda a somar números de 1 a 20',
      type: MathGameType.addition,
      difficulty: DifficultyLevel.easy,
      timeLimit: 60,
      xpReward: 50,
      icon: '➕',
      questions: [
        MathQuestion(
          id: 'add_1',
          question: 'Quanto é 5 + 3?',
          options: ['7', '8', '9', '10'],
          correctAnswer: '8',
          explanation: '5 + 3 = 8',
          timeLimit: 30,
          points: 10,
          type: MathGameType.addition,
        ),
        MathQuestion(
          id: 'add_2',
          question: 'Quanto é 12 + 7?',
          options: ['18', '19', '20', '21'],
          correctAnswer: '19',
          explanation: '12 + 7 = 19',
          timeLimit: 30,
          points: 10,
          type: MathGameType.addition,
        ),
        MathQuestion(
          id: 'add_3',
          question: 'Quanto é 15 + 4?',
          options: ['18', '19', '20', '21'],
          correctAnswer: '19',
          explanation: '15 + 4 = 19',
          timeLimit: 30,
          points: 10,
          type: MathGameType.addition,
        ),
        MathQuestion(
          id: 'add_4',
          question: 'Quanto é 8 + 9?',
          options: ['16', '17', '18', '19'],
          correctAnswer: '17',
          explanation: '8 + 9 = 17',
          timeLimit: 30,
          points: 10,
          type: MathGameType.addition,
        ),
        MathQuestion(
          id: 'add_5',
          question: 'Quanto é 11 + 6?',
          options: ['16', '17', '18', '19'],
          correctAnswer: '17',
          explanation: '11 + 6 = 17',
          timeLimit: 30,
          points: 10,
          type: MathGameType.addition,
        ),
      ],
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
      questions: [
        MathQuestion(
          id: 'sub_1',
          question: 'Quanto é 10 - 4?',
          options: ['5', '6', '7', '8'],
          correctAnswer: '6',
          explanation: '10 - 4 = 6',
          timeLimit: 30,
          points: 10,
          type: MathGameType.subtraction,
        ),
        MathQuestion(
          id: 'sub_2',
          question: 'Quanto é 15 - 8?',
          options: ['6', '7', '8', '9'],
          correctAnswer: '7',
          explanation: '15 - 8 = 7',
          timeLimit: 30,
          points: 10,
          type: MathGameType.subtraction,
        ),
        MathQuestion(
          id: 'sub_3',
          question: 'Quanto é 18 - 9?',
          options: ['8', '9', '10', '11'],
          correctAnswer: '9',
          explanation: '18 - 9 = 9',
          timeLimit: 30,
          points: 10,
          type: MathGameType.subtraction,
        ),
        MathQuestion(
          id: 'sub_4',
          question: 'Quanto é 14 - 6?',
          options: ['7', '8', '9', '10'],
          correctAnswer: '8',
          explanation: '14 - 6 = 8',
          timeLimit: 30,
          points: 10,
          type: MathGameType.subtraction,
        ),
        MathQuestion(
          id: 'sub_5',
          question: 'Quanto é 20 - 12?',
          options: ['7', '8', '9', '10'],
          correctAnswer: '8',
          explanation: '20 - 12 = 8',
          timeLimit: 30,
          points: 10,
          type: MathGameType.subtraction,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 2 - MULTIPLICAÇÃO E DIVISÃO
    MathGame(
      id: 'multiplication_tables',
      title: 'Tabuada',
      description: 'Pratique as tabuadas de 1 a 10',
      type: MathGameType.multiplication,
      difficulty: DifficultyLevel.medium,
      timeLimit: 90,
      xpReward: 75,
      icon: '✖️',
      questions: [
        MathQuestion(
          id: 'mult_1',
          question: 'Quanto é 7 × 3?',
          options: ['20', '21', '22', '23'],
          correctAnswer: '21',
          explanation: '7 × 3 = 21',
          timeLimit: 45,
          points: 15,
          type: MathGameType.multiplication,
        ),
        MathQuestion(
          id: 'mult_2',
          question: 'Quanto é 6 × 4?',
          options: ['22', '23', '24', '25'],
          correctAnswer: '24',
          explanation: '6 × 4 = 24',
          timeLimit: 45,
          points: 15,
          type: MathGameType.multiplication,
        ),
        MathQuestion(
          id: 'mult_3',
          question: 'Quanto é 8 × 5?',
          options: ['38', '39', '40', '41'],
          correctAnswer: '40',
          explanation: '8 × 5 = 40',
          timeLimit: 45,
          points: 15,
          type: MathGameType.multiplication,
        ),
        MathQuestion(
          id: 'mult_4',
          question: 'Quanto é 9 × 6?',
          options: ['52', '53', '54', '55'],
          correctAnswer: '54',
          explanation: '9 × 6 = 54',
          timeLimit: 45,
          points: 15,
          type: MathGameType.multiplication,
        ),
        MathQuestion(
          id: 'mult_5',
          question: 'Quanto é 7 × 8?',
          options: ['54', '55', '56', '57'],
          correctAnswer: '56',
          explanation: '7 × 8 = 56',
          timeLimit: 45,
          points: 15,
          type: MathGameType.multiplication,
        ),
      ],
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
      questions: [
        MathQuestion(
          id: 'div_1',
          question: 'Quanto é 24 ÷ 6?',
          options: ['3', '4', '5', '6'],
          correctAnswer: '4',
          explanation: '24 ÷ 6 = 4',
          timeLimit: 45,
          points: 15,
          type: MathGameType.division,
        ),
        MathQuestion(
          id: 'div_2',
          question: 'Quanto é 35 ÷ 7?',
          options: ['4', '5', '6', '7'],
          correctAnswer: '5',
          explanation: '35 ÷ 7 = 5',
          timeLimit: 45,
          points: 15,
          type: MathGameType.division,
        ),
        MathQuestion(
          id: 'div_3',
          question: 'Quanto é 48 ÷ 8?',
          options: ['5', '6', '7', '8'],
          correctAnswer: '6',
          explanation: '48 ÷ 8 = 6',
          timeLimit: 45,
          points: 15,
          type: MathGameType.division,
        ),
        MathQuestion(
          id: 'div_4',
          question: 'Quanto é 63 ÷ 9?',
          options: ['6', '7', '8', '9'],
          correctAnswer: '7',
          explanation: '63 ÷ 9 = 7',
          timeLimit: 45,
          points: 15,
          type: MathGameType.division,
        ),
        MathQuestion(
          id: 'div_5',
          question: 'Quanto é 42 ÷ 6?',
          options: ['6', '7', '8', '9'],
          correctAnswer: '7',
          explanation: '42 ÷ 6 = 7',
          timeLimit: 45,
          points: 15,
          type: MathGameType.division,
        ),
      ],
      isUnlocked: false,
      isCompleted: false,
    ),

    // NÍVEL 3 - FRAÇÕES E GEOMETRIA
    MathGame(
      id: 'fractions_intro',
      title: 'Frações Básicas',
      description: 'Introdução às frações básicas',
      type: MathGameType.fractions,
      difficulty: DifficultyLevel.hard,
      timeLimit: 120,
      xpReward: 100,
      icon: '🔢',
      questions: [
        MathQuestion(
          id: 'frac_1',
          question: 'Qual fração representa metade?',
          options: ['1/3', '1/2', '2/3', '3/4'],
          correctAnswer: '1/2',
          explanation: '1/2 representa metade',
          timeLimit: 60,
          points: 20,
          type: MathGameType.fractions,
        ),
        MathQuestion(
          id: 'frac_2',
          question: 'Qual é o resultado de 1/2 + 1/2?',
          options: ['1/4', '1/2', '1', '2'],
          correctAnswer: '1',
          explanation: '1/2 + 1/2 = 2/2 = 1',
          timeLimit: 60,
          points: 20,
          type: MathGameType.fractions,
        ),
        MathQuestion(
          id: 'frac_3',
          question: 'Qual fração é maior: 1/3 ou 1/4?',
          options: ['1/3', '1/4', 'São iguais', 'Não sei'],
          correctAnswer: '1/3',
          explanation: '1/3 é maior que 1/4',
          timeLimit: 60,
          points: 20,
          type: MathGameType.fractions,
        ),
        MathQuestion(
          id: 'frac_4',
          question: 'Quanto é 3/4 de 8?',
          options: ['4', '5', '6', '7'],
          correctAnswer: '6',
          explanation: '3/4 de 8 = (3 × 8) ÷ 4 = 24 ÷ 4 = 6',
          timeLimit: 60,
          points: 20,
          type: MathGameType.fractions,
        ),
        MathQuestion(
          id: 'frac_5',
          question: 'Qual é o equivalente a 2/4?',
          options: ['1/2', '1/3', '1/4', '2/3'],
          correctAnswer: '1/2',
          explanation: '2/4 = 1/2 (simplificando)',
          timeLimit: 60,
          points: 20,
          type: MathGameType.fractions,
        ),
      ],
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
      questions: [
        MathQuestion(
          id: 'geo_1',
          question: 'Quantos lados tem um triângulo?',
          options: ['2', '3', '4', '5'],
          correctAnswer: '3',
          explanation: 'Um triângulo tem 3 lados',
          timeLimit: 60,
          points: 20,
          type: MathGameType.geometry,
        ),
        MathQuestion(
          id: 'geo_2',
          question: 'Qual é a área de um quadrado com lado 4?',
          options: ['12', '14', '16', '18'],
          correctAnswer: '16',
          explanation: 'Área = lado × lado = 4 × 4 = 16',
          timeLimit: 60,
          points: 20,
          type: MathGameType.geometry,
        ),
        MathQuestion(
          id: 'geo_3',
          question: 'Qual é o perímetro de um retângulo 5×3?',
          options: ['14', '15', '16', '17'],
          correctAnswer: '16',
          explanation: 'Perímetro = 2×(5+3) = 2×8 = 16',
          timeLimit: 60,
          points: 20,
          type: MathGameType.geometry,
        ),
        MathQuestion(
          id: 'geo_4',
          question: 'Quantos graus tem um ângulo reto?',
          options: ['45°', '90°', '180°', '360°'],
          correctAnswer: '90°',
          explanation: 'Um ângulo reto tem 90 graus',
          timeLimit: 60,
          points: 20,
          type: MathGameType.geometry,
        ),
        MathQuestion(
          id: 'geo_5',
          question: 'Qual é a área de um retângulo 6×4?',
          options: ['20', '22', '24', '26'],
          correctAnswer: '24',
          explanation: 'Área = comprimento × largura = 6 × 4 = 24',
          timeLimit: 60,
          points: 20,
          type: MathGameType.geometry,
        ),
      ],
      isUnlocked: false,
      isCompleted: false,
    ),

    // NÍVEL 4 - PROBLEMAS DE PALAVRAS
    MathGame(
      id: 'word_problems',
      title: 'Problemas de Palavras',
      description: 'Resolva problemas matemáticos do mundo real',
      type: MathGameType.wordProblems,
      difficulty: DifficultyLevel.expert,
      timeLimit: 180,
      xpReward: 150,
      icon: '📝',
      questions: [
        MathQuestion(
          id: 'word_1',
          question: 'João tem 15 reais e gastou 8 reais. Quanto sobrou?',
          options: ['6', '7', '8', '9'],
          correctAnswer: '7',
          explanation: '15 - 8 = 7 reais',
          timeLimit: 90,
          points: 30,
          type: MathGameType.wordProblems,
        ),
        MathQuestion(
          id: 'word_2',
          question:
              'Maria comprou 3 cadernos por R\$ 12,00 cada. Quanto gastou?',
          options: ['R\$ 30', 'R\$ 32', 'R\$ 34', 'R\$ 36'],
          correctAnswer: 'R\$ 36',
          explanation: '3 × 12 = 36 reais',
          timeLimit: 90,
          points: 30,
          type: MathGameType.wordProblems,
        ),
        MathQuestion(
          id: 'word_3',
          question: 'Uma turma tem 24 alunos. Se 1/3 faltou, quantos vieram?',
          options: ['14', '15', '16', '17'],
          correctAnswer: '16',
          explanation: '1/3 de 24 = 8 faltaram. 24 - 8 = 16 vieram',
          timeLimit: 90,
          points: 30,
          type: MathGameType.wordProblems,
        ),
        MathQuestion(
          id: 'word_4',
          question:
              'Pedro tem 18 anos. Sua irmã tem 3 anos a menos. Quantos anos tem a irmã?',
          options: ['14', '15', '16', '17'],
          correctAnswer: '15',
          explanation: '18 - 3 = 15 anos',
          timeLimit: 90,
          points: 30,
          type: MathGameType.wordProblems,
        ),
        MathQuestion(
          id: 'word_5',
          question:
              'Uma pizza foi dividida em 8 pedaços iguais. Ana comeu 3 pedaços. Que fração da pizza ela comeu?',
          options: ['3/8', '1/3', '3/4', '1/8'],
          correctAnswer: '3/8',
          explanation: 'Ana comeu 3 de 8 pedaços = 3/8',
          timeLimit: 90,
          points: 30,
          type: MathGameType.wordProblems,
        ),
      ],
      isUnlocked: false,
      isCompleted: false,
    ),

    // NÍVEL 5 - MEDIDAS E PROPORCIONALIDADE
    MathGame(
      id: 'measurements',
      title: 'Medidas e Proporções',
      description: 'Trabalhe com medidas e proporcionalidade',
      type: MathGameType.wordProblems,
      difficulty: DifficultyLevel.expert,
      timeLimit: 150,
      xpReward: 125,
      icon: '📏',
      questions: [
        MathQuestion(
          id: 'meas_1',
          question: 'Quantos metros tem 1 quilômetro?',
          options: ['100', '1000', '10000', '100000'],
          correctAnswer: '1000',
          explanation: '1 km = 1000 metros',
          timeLimit: 75,
          points: 25,
          type: MathGameType.wordProblems,
        ),
        MathQuestion(
          id: 'meas_2',
          question: 'Se 1 kg de açúcar custa R\$ 4,00, quanto custam 3 kg?',
          options: ['R\$ 10', 'R\$ 11', 'R\$ 12', 'R\$ 13'],
          correctAnswer: 'R\$ 12',
          explanation: '3 × 4 = 12 reais',
          timeLimit: 75,
          points: 25,
          type: MathGameType.wordProblems,
        ),
        MathQuestion(
          id: 'meas_3',
          question: 'Quantos litros tem 1 metro cúbico?',
          options: ['100', '1000', '10000', '100000'],
          correctAnswer: '1000',
          explanation: '1 m³ = 1000 litros',
          timeLimit: 75,
          points: 25,
          type: MathGameType.wordProblems,
        ),
        MathQuestion(
          id: 'meas_4',
          question:
              'Se 2 operários fazem um trabalho em 6 dias, quantos dias 4 operários levam?',
          options: ['2', '3', '4', '5'],
          correctAnswer: '3',
          explanation: 'Mais operários = menos dias. 2×6÷4 = 3 dias',
          timeLimit: 75,
          points: 25,
          type: MathGameType.wordProblems,
        ),
        MathQuestion(
          id: 'meas_5',
          question: 'Quantos centímetros tem 2 metros?',
          options: ['100', '200', '300', '400'],
          correctAnswer: '200',
          explanation: '2 m = 200 cm',
          timeLimit: 75,
          points: 25,
          type: MathGameType.wordProblems,
        ),
      ],
      isUnlocked: false,
      isCompleted: false,
    ),
  ];
}
