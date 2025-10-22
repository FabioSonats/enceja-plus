enum InteractiveLessonType {
  puzzle, // Quebra-cabeça
  crossword, // Palavras cruzadas
  fillBlank, // Completar lacunas
  matching, // Ligar correspondências
  ordering, // Ordenar sequências
  dragDrop, // Arrastar e soltar
  multipleChoice, // Múltipla escolha
  trueFalse, // Verdadeiro ou falso
}

enum MathTopic {
  counting, // Contagem
  numbers, // Números
  operations, // Operações
  geometry, // Geometria
  time, // Tempo
  measurement, // Medidas
  fractions, // Frações
  wordProblems, // Problemas
}

class InteractiveMathLesson {
  final String id;
  final String title;
  final String description;
  final MathTopic topic;
  final InteractiveLessonType type;
  final int difficulty; // 1-5
  final int estimatedTime; // em minutos
  final String icon;
  final List<InteractiveExercise> exercises;
  final bool isUnlocked;
  final bool isCompleted;
  final int xpReward;

  const InteractiveMathLesson({
    required this.id,
    required this.title,
    required this.description,
    required this.topic,
    required this.type,
    required this.difficulty,
    required this.estimatedTime,
    required this.icon,
    required this.exercises,
    required this.isUnlocked,
    required this.isCompleted,
    required this.xpReward,
  });

  InteractiveMathLesson copyWith({
    String? id,
    String? title,
    String? description,
    MathTopic? topic,
    InteractiveLessonType? type,
    int? difficulty,
    int? estimatedTime,
    String? icon,
    List<InteractiveExercise>? exercises,
    bool? isUnlocked,
    bool? isCompleted,
    int? xpReward,
  }) {
    return InteractiveMathLesson(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      topic: topic ?? this.topic,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      icon: icon ?? this.icon,
      exercises: exercises ?? this.exercises,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCompleted: isCompleted ?? this.isCompleted,
      xpReward: xpReward ?? this.xpReward,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'topic': topic.name,
      'type': type.name,
      'difficulty': difficulty,
      'estimatedTime': estimatedTime,
      'icon': icon,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'isUnlocked': isUnlocked,
      'isCompleted': isCompleted,
      'xpReward': xpReward,
    };
  }

  factory InteractiveMathLesson.fromJson(Map<String, dynamic> json) {
    return InteractiveMathLesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      topic: MathTopic.values.firstWhere((e) => e.name == json['topic']),
      type: InteractiveLessonType.values
          .firstWhere((e) => e.name == json['type']),
      difficulty: json['difficulty'],
      estimatedTime: json['estimatedTime'],
      icon: json['icon'],
      exercises: (json['exercises'] as List)
          .map((e) => InteractiveExercise.fromJson(e))
          .toList(),
      isUnlocked: json['isUnlocked'],
      isCompleted: json['isCompleted'],
      xpReward: json['xpReward'],
    );
  }
}

class InteractiveExercise {
  final String id;
  final String question;
  final InteractiveLessonType type;
  final Map<String, dynamic> data; // Dados específicos do tipo de exercício
  final String explanation;
  final int points;
  final int timeLimit; // em segundos

  const InteractiveExercise({
    required this.id,
    required this.question,
    required this.type,
    required this.data,
    required this.explanation,
    required this.points,
    required this.timeLimit,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'type': type.name,
      'data': data,
      'explanation': explanation,
      'points': points,
      'timeLimit': timeLimit,
    };
  }

  factory InteractiveExercise.fromJson(Map<String, dynamic> json) {
    return InteractiveExercise(
      id: json['id'],
      question: json['question'],
      type: InteractiveLessonType.values
          .firstWhere((e) => e.name == json['type']),
      data: json['data'],
      explanation: json['explanation'],
      points: json['points'],
      timeLimit: json['timeLimit'],
    );
  }
}

class PredefinedInteractiveLessons {
  static List<InteractiveMathLesson> get lessons => [
        // LIÇÃO 1: CONTAGEM AVANÇADA
        InteractiveMathLesson(
          id: 'counting_puzzle',
          title: 'Desafio da Contagem',
          description:
              'Resolva problemas de contagem com diferentes bases numéricas',
          topic: MathTopic.counting,
          type: InteractiveLessonType.puzzle,
          difficulty: 4,
          estimatedTime: 8,
          icon: '🧩',
          exercises: [
            // Exercício 1: 2 + 4 = ?
            InteractiveExercise(
              id: 'addition_puzzle_1',
              question: 'Resolva a operação matemática:',
              type: InteractiveLessonType.puzzle,
              data: {
                'pieces': [
                  {'text': '2', 'position': 1},
                  {'text': '+', 'position': 2},
                  {'text': '4', 'position': 3},
                  {'text': '=', 'position': 4},
                  {'text': '?', 'position': 5},
                ],
                'correctAnswer': '6',
                'hint': 'Some os dois números'
              },
              explanation: '2 + 4 = 6. Simples adição!',
              points: 20,
              timeLimit: 60,
            ),
            // Exercício 2: 5 + 6 = ?
            InteractiveExercise(
              id: 'addition_puzzle_2',
              question: 'Resolva a operação matemática:',
              type: InteractiveLessonType.puzzle,
              data: {
                'pieces': [
                  {'text': '5', 'position': 1},
                  {'text': '+', 'position': 2},
                  {'text': '6', 'position': 3},
                  {'text': '=', 'position': 4},
                  {'text': '?', 'position': 5},
                ],
                'correctAnswer': '11',
                'hint': 'Some os dois números'
              },
              explanation: '5 + 6 = 11. Simples adição!',
              points: 20,
              timeLimit: 60,
            ),
            // Exercício 3: 7 + 8 = ?
            InteractiveExercise(
              id: 'addition_puzzle_3',
              question: 'Resolva a operação matemática:',
              type: InteractiveLessonType.puzzle,
              data: {
                'pieces': [
                  {'text': '7', 'position': 1},
                  {'text': '+', 'position': 2},
                  {'text': '8', 'position': 3},
                  {'text': '=', 'position': 4},
                  {'text': '?', 'position': 5},
                ],
                'correctAnswer': '15',
                'hint': 'Some os dois números'
              },
              explanation: '7 + 8 = 15. Simples adição!',
              points: 20,
              timeLimit: 60,
            ),
            // Exercício 4: 3 + 9 = ?
            InteractiveExercise(
              id: 'addition_puzzle_4',
              question: 'Resolva a operação matemática:',
              type: InteractiveLessonType.puzzle,
              data: {
                'pieces': [
                  {'text': '3', 'position': 1},
                  {'text': '+', 'position': 2},
                  {'text': '9', 'position': 3},
                  {'text': '=', 'position': 4},
                  {'text': '?', 'position': 5},
                ],
                'correctAnswer': '12',
                'hint': 'Some os dois números'
              },
              explanation: '3 + 9 = 12. Simples adição!',
              points: 20,
              timeLimit: 60,
            ),
            // Exercício 5: 6 + 7 = ?
            InteractiveExercise(
              id: 'addition_puzzle_5',
              question: 'Resolva a operação matemática:',
              type: InteractiveLessonType.puzzle,
              data: {
                'pieces': [
                  {'text': '6', 'position': 1},
                  {'text': '+', 'position': 2},
                  {'text': '7', 'position': 3},
                  {'text': '=', 'position': 4},
                  {'text': '?', 'position': 5},
                ],
                'correctAnswer': '13',
                'hint': 'Some os dois números'
              },
              explanation: '6 + 7 = 13. Simples adição!',
              points: 20,
              timeLimit: 60,
            ),
          ],
          isUnlocked: true,
          isCompleted: false,
          xpReward: 80,
        ),

        // LIÇÃO 2: HISTÓRIA DA MATEMÁTICA
        InteractiveMathLesson(
          id: 'math_crossword',
          title: 'História da Matemática',
          description: 'Descubra os grandes matemáticos e conceitos históricos',
          topic: MathTopic.numbers,
          type: InteractiveLessonType.crossword,
          difficulty: 5,
          estimatedTime: 12,
          icon: '📚',
          exercises: [
            InteractiveExercise(
              id: 'crossword_1',
              question:
                  'Complete as palavras cruzadas sobre a história da matemática:',
              type: InteractiveLessonType.crossword,
              data: {
                'grid': [
                  {
                    'position': [0, 0],
                    'letter': 'P',
                    'hint': 'Matemático grego'
                  },
                  {
                    'position': [0, 1],
                    'letter': 'I',
                    'hint': 'Matemático grego'
                  },
                  {
                    'position': [0, 2],
                    'letter': 'T',
                    'hint': 'Matemático grego'
                  },
                  {
                    'position': [0, 3],
                    'letter': 'A',
                    'hint': 'Matemático grego'
                  },
                  {
                    'position': [0, 4],
                    'letter': 'G',
                    'hint': 'Matemático grego'
                  },
                  {
                    'position': [0, 5],
                    'letter': 'O',
                    'hint': 'Matemático grego'
                  },
                  {
                    'position': [0, 6],
                    'letter': 'R',
                    'hint': 'Matemático grego'
                  },
                  {
                    'position': [0, 7],
                    'letter': 'A',
                    'hint': 'Matemático grego'
                  },
                  {
                    'position': [0, 8],
                    'letter': 'S',
                    'hint': 'Matemático grego'
                  },
                ],
                'words': [
                  {
                    'word': 'PITAGORAS',
                    'clue':
                        'Matemático grego famoso pelo teorema do triângulo retângulo (9 letras)'
                  },
                  {
                    'word': 'EUCLIDES',
                    'clue': 'Geômetra grego, pai da geometria (8 letras)'
                  },
                  {
                    'word': 'ARQUIMEDES',
                    'clue':
                        'Matemático grego que descobriu o valor de π (10 letras)'
                  },
                  {
                    'word': 'FIBONACCI',
                    'clue': 'Matemático italiano da sequência famosa (9 letras)'
                  },
                  {
                    'word': 'ZERO',
                    'clue': 'Número inventado pelos hindus (4 letras)'
                  },
                  {
                    'word': 'ALGARISMO',
                    'clue': 'Sistema de numeração hindu-árabe (9 letras)'
                  },
                ]
              },
              explanation:
                  'PITÁGORAS criou o famoso teorema. EUCLIDES é o pai da geometria. ARQUIMEDES calculou π. FIBONACCI criou a sequência. ZERO foi inventado pelos hindus. ALGARISMO é nosso sistema numérico.',
              points: 50,
              timeLimit: 180,
            ),
            InteractiveExercise(
              id: 'crossword_2',
              question: 'Complete com conceitos matemáticos históricos:',
              type: InteractiveLessonType.crossword,
              data: {
                'grid': [
                  {
                    'position': [0, 0],
                    'letter': 'G',
                    'hint': 'Ramo da matemática'
                  },
                  {
                    'position': [0, 1],
                    'letter': 'E',
                    'hint': 'Ramo da matemática'
                  },
                  {
                    'position': [0, 2],
                    'letter': 'O',
                    'hint': 'Ramo da matemática'
                  },
                  {
                    'position': [0, 3],
                    'letter': 'M',
                    'hint': 'Ramo da matemática'
                  },
                  {
                    'position': [0, 4],
                    'letter': 'E',
                    'hint': 'Ramo da matemática'
                  },
                  {
                    'position': [0, 5],
                    'letter': 'T',
                    'hint': 'Ramo da matemática'
                  },
                  {
                    'position': [0, 6],
                    'letter': 'R',
                    'hint': 'Ramo da matemática'
                  },
                  {
                    'position': [0, 7],
                    'letter': 'I',
                    'hint': 'Ramo da matemática'
                  },
                  {
                    'position': [0, 8],
                    'letter': 'A',
                    'hint': 'Ramo da matemática'
                  },
                ],
                'words': [
                  {
                    'word': 'GEOMETRIA',
                    'clue':
                        'Ramo da matemática que estuda formas e espaços (9 letras)'
                  },
                  {
                    'word': 'ALGEBRA',
                    'clue': 'Ramo da matemática com letras e números (7 letras)'
                  },
                  {
                    'word': 'ARITMETICA',
                    'clue':
                        'Ramo da matemática das operações básicas (10 letras)'
                  },
                  {
                    'word': 'TRIGONOMETRIA',
                    'clue': 'Ramo que estuda triângulos e ângulos (13 letras)'
                  },
                  {
                    'word': 'CALCULO',
                    'clue': 'Ramo criado por Newton e Leibniz (7 letras)'
                  },
                ]
              },
              explanation:
                  'GEOMETRIA estuda formas. ÁLGEBRA usa letras. ARITMÉTICA são as operações básicas. TRIGONOMETRIA estuda triângulos. CÁLCULO foi criado por Newton e Leibniz.',
              points: 60,
              timeLimit: 200,
            ),
          ],
          isUnlocked: false,
          isCompleted: false,
          xpReward: 100,
        ),

        // LIÇÃO 3: COMPLETAR LACUNAS - OPERAÇÕES
        InteractiveMathLesson(
          id: 'operations_fill_blank',
          title: 'Complete as Operações',
          description: 'Complete as lacunas com os números corretos',
          topic: MathTopic.operations,
          type: InteractiveLessonType.fillBlank,
          difficulty: 2,
          estimatedTime: 6,
          icon: '✏️',
          exercises: [
            InteractiveExercise(
              id: 'fill_blank_1',
              question: 'Complete as operações:',
              type: InteractiveLessonType.fillBlank,
              data: {
                'sentences': [
                  '2 + 3 = ___',
                  '5 - 2 = ___',
                  '4 × 2 = ___',
                  '8 ÷ 2 = ___',
                ],
                'answers': ['5', '3', '8', '4'],
                'hint': 'Use os dedos para contar se necessário'
              },
              explanation: '2 + 3 = 5, 5 - 2 = 3, 4 × 2 = 8, 8 ÷ 2 = 4.',
              points: 25,
              timeLimit: 90,
            ),
          ],
          isUnlocked: false,
          isCompleted: false,
          xpReward: 60,
        ),

        // LIÇÃO 4: LIGAR CORRESPONDÊNCIAS - GEOMETRIA
        InteractiveMathLesson(
          id: 'geometry_matching',
          title: 'Ligue as Formas',
          description: 'Ligue cada forma geométrica com seu nome',
          topic: MathTopic.geometry,
          type: InteractiveLessonType.matching,
          difficulty: 2,
          estimatedTime: 5,
          icon: '🔗',
          exercises: [
            InteractiveExercise(
              id: 'matching_1',
              question: 'Ligue cada forma com seu nome:',
              type: InteractiveLessonType.matching,
              data: {
                'leftItems': [
                  {'id': 'circle', 'text': '●', 'description': 'Forma redonda'},
                  {
                    'id': 'square',
                    'text': '■',
                    'description': 'Forma com 4 lados iguais'
                  },
                  {
                    'id': 'triangle',
                    'text': '▲',
                    'description': 'Forma com 3 lados'
                  },
                ],
                'rightItems': [
                  {'id': 'circle', 'text': 'Círculo'},
                  {'id': 'square', 'text': 'Quadrado'},
                  {'id': 'triangle', 'text': 'Triângulo'},
                ],
                'correctMatches': [
                  {'left': 'circle', 'right': 'circle'},
                  {'left': 'square', 'right': 'square'},
                  {'left': 'triangle', 'right': 'triangle'},
                ]
              },
              explanation: '● é um círculo, ■ é um quadrado, ▲ é um triângulo.',
              points: 20,
              timeLimit: 60,
            ),
          ],
          isUnlocked: false,
          isCompleted: false,
          xpReward: 40,
        ),

        // LIÇÃO 5: ORDENAR SEQUÊNCIAS - TEMPO
        InteractiveMathLesson(
          id: 'time_ordering',
          title: 'Ordene o Tempo',
          description: 'Coloque os eventos em ordem cronológica',
          topic: MathTopic.time,
          type: InteractiveLessonType.ordering,
          difficulty: 3,
          estimatedTime: 7,
          icon: '⏰',
          exercises: [
            InteractiveExercise(
              id: 'ordering_1',
              question: 'Ordene os eventos do dia:',
              type: InteractiveLessonType.ordering,
              data: {
                'items': [
                  {'id': 'lunch', 'text': 'Almoço', 'time': '12:00'},
                  {'id': 'breakfast', 'text': 'Café da manhã', 'time': '07:00'},
                  {'id': 'dinner', 'text': 'Jantar', 'time': '19:00'},
                  {'id': 'snack', 'text': 'Lanche', 'time': '15:00'},
                ],
                'correctOrder': ['breakfast', 'lunch', 'snack', 'dinner'],
                'hint': 'Pense na ordem das refeições do dia'
              },
              explanation:
                  'A ordem correta é: Café da manhã (07:00), Almoço (12:00), Lanche (15:00), Jantar (19:00).',
              points: 30,
              timeLimit: 90,
            ),
          ],
          isUnlocked: false,
          isCompleted: false,
          xpReward: 65,
        ),
      ];
}
