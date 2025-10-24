enum HistoryLessonType {
  brazilHistory,
  worldHistory,
  contemporaryHistory,
  culture,
  geography,
  politics,
  economy,
  socialMovements,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
  expert,
}

class HistoryLesson {
  final String id;
  final String title;
  final String description;
  final HistoryLessonType type;
  final DifficultyLevel difficulty;
  final int timeLimit; // em segundos
  final int xpReward;
  final String icon;
  final List<HistoryQuestion> questions;
  final bool isUnlocked;
  final bool isCompleted;

  const HistoryLesson({
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

  HistoryLesson copyWith({
    String? id,
    String? title,
    String? description,
    HistoryLessonType? type,
    DifficultyLevel? difficulty,
    int? timeLimit,
    int? xpReward,
    String? icon,
    List<HistoryQuestion>? questions,
    bool? isUnlocked,
    bool? isCompleted,
  }) {
    return HistoryLesson(
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

  factory HistoryLesson.fromJson(Map<String, dynamic> json) {
    return HistoryLesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: HistoryLessonType.values[json['type']],
      difficulty: DifficultyLevel.values[json['difficulty']],
      timeLimit: json['timeLimit'],
      xpReward: json['xpReward'],
      icon: json['icon'],
      questions: (json['questions'] as List)
          .map((q) => HistoryQuestion.fromJson(q))
          .toList(),
      isUnlocked: json['isUnlocked'],
      isCompleted: json['isCompleted'],
    );
  }
}

class HistoryQuestion {
  final String id;
  final String question;
  final String? imageUrl;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final int timeLimit; // em segundos
  final int points;
  final HistoryLessonType type;

  const HistoryQuestion({
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

  factory HistoryQuestion.fromJson(Map<String, dynamic> json) {
    return HistoryQuestion(
      id: json['id'],
      question: json['question'],
      imageUrl: json['imageUrl'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      timeLimit: json['timeLimit'],
      points: json['points'],
      type: HistoryLessonType.values[json['type']],
    );
  }
}

// Lições pré-definidas de história baseadas no ENCCEJA
class PredefinedHistoryLessons {
  static final List<HistoryLesson> lessons = [
    // NÍVEL 1 - HISTÓRIA DO BRASIL COLONIAL
    HistoryLesson(
      id: 'brazil_colonial',
      title: 'Brasil Colonial',
      description:
          'Entenda o período de colonização portuguesa e seus impactos nos povos indígenas',
      type: HistoryLessonType.brazilHistory,
      difficulty: DifficultyLevel.easy,
      timeLimit: 120,
      xpReward: 50,
      icon: '🏛️',
      questions: [
        HistoryQuestion(
          id: 'hist_1',
          question:
              'Em que ano os portugueses chegaram ao território que hoje é o Brasil?',
          options: ['1498', '1500', '1502', '1504'],
          correctAnswer: '1500',
          explanation:
              'Os portugueses chegaram em 22 de abril de 1500. É importante lembrar que o território já era habitado por povos indígenas há milênios.',
          timeLimit: 45,
          points: 10,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'hist_2',
          question:
              'Qual foi o primeiro sistema econômico implantado pelos portugueses no Brasil colonial?',
          options: ['Cana-de-açúcar', 'Café', 'Mineração', 'Pecuária'],
          correctAnswer: 'Cana-de-açúcar',
          explanation:
              'O açúcar foi o primeiro produto de exportação do Brasil colonial, baseado na exploração do trabalho indígena e posteriormente africano.',
          timeLimit: 45,
          points: 10,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'hist_3',
          question:
              'Quem foi o primeiro governador-geral nomeado pela Coroa portuguesa no Brasil?',
          options: [
            'Tomé de Sousa',
            'Duarte da Costa',
            'Mem de Sá',
            'Salvador de Sá'
          ],
          correctAnswer: 'Tomé de Sousa',
          explanation:
              'Tomé de Sousa foi o primeiro governador-geral nomeado pela Coroa portuguesa em 1549, para administrar a colônia.',
          timeLimit: 45,
          points: 10,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'hist_4',
          question:
              'Qual foi a primeira capital administrativa estabelecida pelos portugueses no Brasil?',
          options: ['Rio de Janeiro', 'São Paulo', 'Salvador', 'Recife'],
          correctAnswer: 'Salvador',
          explanation:
              'Salvador foi a primeira capital administrativa estabelecida pelos portugueses no Brasil de 1549 a 1763.',
          timeLimit: 45,
          points: 10,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'hist_5',
          question:
              'Qual foi o principal produto explorado pelos portugueses no Brasil colonial durante o século XVIII?',
          options: ['Açúcar', 'Ouro', 'Café', 'Algodão'],
          correctAnswer: 'Ouro',
          explanation:
              'O ouro foi o principal produto explorado pelos portugueses em Minas Gerais no século XVIII, baseado no trabalho escravo.',
          timeLimit: 45,
          points: 10,
          type: HistoryLessonType.brazilHistory,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 2 - INDEPENDÊNCIA DO BRASIL
    HistoryLesson(
      id: 'brazil_independence',
      title: 'Independência do Brasil',
      description: 'Conheça o processo de independência do Brasil',
      type: HistoryLessonType.brazilHistory,
      difficulty: DifficultyLevel.medium,
      timeLimit: 150,
      xpReward: 75,
      icon: '🇧🇷',
      questions: [
        HistoryQuestion(
          id: 'indep_1',
          question: 'Em que ano o Brasil se tornou independente?',
          options: ['1820', '1821', '1822', '1823'],
          correctAnswer: '1822',
          explanation:
              'A independência foi proclamada em 7 de setembro de 1822.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'indep_2',
          question: 'Quem proclamou a independência do Brasil?',
          options: [
            'José Bonifácio',
            'Dom Pedro I',
            'Dom João VI',
            'Marquês de Pombal'
          ],
          correctAnswer: 'Dom Pedro I',
          explanation:
              'Dom Pedro I proclamou a independência às margens do Ipiranga.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'indep_3',
          question: 'Qual foi o grito da independência?',
          options: [
            'Independência ou Morte!',
            'Liberdade ou Morte!',
            'Brasil Livre!',
            'Independência Total!'
          ],
          correctAnswer: 'Independência ou Morte!',
          explanation:
              'O famoso grito foi "Independência ou Morte!" no Ipiranga.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'indep_4',
          question: 'Qual foi a primeira constituição do Brasil?',
          options: [
            'Constituição de 1824',
            'Constituição de 1891',
            'Constituição de 1934',
            'Constituição de 1946'
          ],
          correctAnswer: 'Constituição de 1824',
          explanation:
              'A primeira constituição foi outorgada em 1824 por Dom Pedro I.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'indep_5',
          question:
              'Qual foi o sistema de governo adotado após a independência?',
          options: ['República', 'Monarquia', 'Confederação', 'Império'],
          correctAnswer: 'Monarquia',
          explanation:
              'O Brasil se tornou um império monárquico com Dom Pedro I como imperador.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 3 - ABOLIÇÃO DA ESCRAVIDÃO
    HistoryLesson(
      id: 'slavery_abolition',
      title: 'Abolição da Escravidão',
      description: 'Entenda o processo de abolição da escravidão no Brasil',
      type: HistoryLessonType.brazilHistory,
      difficulty: DifficultyLevel.medium,
      timeLimit: 150,
      xpReward: 75,
      icon: '⛓️',
      questions: [
        HistoryQuestion(
          id: 'abol_1',
          question: 'Em que ano foi assinada a Lei Áurea?',
          options: ['1887', '1888', '1889', '1890'],
          correctAnswer: '1888',
          explanation:
              'A Lei Áurea foi assinada em 13 de maio de 1888 pela princesa Isabel.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'abol_2',
          question: 'Quem assinou a Lei Áurea?',
          options: [
            'Dom Pedro II',
            'Princesa Isabel',
            'José do Patrocínio',
            'Joaquim Nabuco'
          ],
          correctAnswer: 'Princesa Isabel',
          explanation:
              'A princesa Isabel assinou a Lei Áurea em 13 de maio de 1888.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'abol_3',
          question: 'Qual foi a primeira lei que limitou a escravidão?',
          options: [
            'Lei Áurea',
            'Lei do Ventre Livre',
            'Lei Eusébio de Queirós',
            'Lei dos Sexagenários'
          ],
          correctAnswer: 'Lei Eusébio de Queirós',
          explanation:
              'A Lei Eusébio de Queirós (1850) proibiu o tráfico de escravos.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'abol_4',
          question: 'Qual foi a lei que libertou os filhos de escravos?',
          options: [
            'Lei Áurea',
            'Lei do Ventre Livre',
            'Lei Eusébio de Queirós',
            'Lei dos Sexagenários'
          ],
          correctAnswer: 'Lei do Ventre Livre',
          explanation:
              'A Lei do Ventre Livre (1871) libertou os filhos de escravos nascidos a partir daquela data.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'abol_5',
          question:
              'Qual foi a lei que libertou os escravos com mais de 60 anos?',
          options: [
            'Lei Áurea',
            'Lei do Ventre Livre',
            'Lei Eusébio de Queirós',
            'Lei dos Sexagenários'
          ],
          correctAnswer: 'Lei dos Sexagenários',
          explanation:
              'A Lei dos Sexagenários (1885) libertou escravos com mais de 60 anos.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 4 - PROCLAMAÇÃO DA REPÚBLICA
    HistoryLesson(
      id: 'republic_proclamation',
      title: 'Proclamação da República',
      description: 'Aprenda sobre o fim do Império e início da República',
      type: HistoryLessonType.brazilHistory,
      difficulty: DifficultyLevel.medium,
      timeLimit: 150,
      xpReward: 75,
      icon: '🏛️',
      questions: [
        HistoryQuestion(
          id: 'rep_1',
          question: 'Em que ano foi proclamada a República no Brasil?',
          options: ['1888', '1889', '1890', '1891'],
          correctAnswer: '1889',
          explanation: 'A República foi proclamada em 15 de novembro de 1889.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'rep_2',
          question: 'Quem liderou o golpe que proclamou a República?',
          options: [
            'Deodoro da Fonseca',
            'Floriano Peixoto',
            'Prudente de Morais',
            'Rui Barbosa'
          ],
          correctAnswer: 'Deodoro da Fonseca',
          explanation:
              'Marechal Deodoro da Fonseca liderou o golpe militar de 15 de novembro.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'rep_3',
          question: 'Qual foi o primeiro presidente da República?',
          options: [
            'Deodoro da Fonseca',
            'Floriano Peixoto',
            'Prudente de Morais',
            'Campos Sales'
          ],
          correctAnswer: 'Deodoro da Fonseca',
          explanation:
              'Deodoro da Fonseca foi o primeiro presidente da República (1889-1891).',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'rep_4',
          question: 'Qual foi a primeira constituição republicana?',
          options: [
            'Constituição de 1891',
            'Constituição de 1934',
            'Constituição de 1946',
            'Constituição de 1988'
          ],
          correctAnswer: 'Constituição de 1891',
          explanation:
              'A primeira constituição republicana foi promulgada em 1891.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'rep_5',
          question: 'Qual foi o sistema de governo adotado na República?',
          options: [
            'Monarquia',
            'República Federativa',
            'Confederação',
            'Império'
          ],
          correctAnswer: 'República Federativa',
          explanation:
              'O Brasil se tornou uma República Federativa com estados autônomos.',
          timeLimit: 60,
          points: 15,
          type: HistoryLessonType.brazilHistory,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 5 - ERA VARGAS
    HistoryLesson(
      id: 'vargas_era',
      title: 'Era Vargas',
      description: 'Conheça o período de Getúlio Vargas no poder',
      type: HistoryLessonType.brazilHistory,
      difficulty: DifficultyLevel.hard,
      timeLimit: 180,
      xpReward: 100,
      icon: '👨‍💼',
      questions: [
        HistoryQuestion(
          id: 'vargas_1',
          question:
              'Em que ano Getúlio Vargas assumiu a presidência pela primeira vez?',
          options: ['1929', '1930', '1931', '1932'],
          correctAnswer: '1930',
          explanation: 'Getúlio Vargas assumiu após a Revolução de 1930.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'vargas_2',
          question: 'Qual foi o período do Estado Novo?',
          options: ['1930-1937', '1937-1945', '1945-1950', '1951-1954'],
          correctAnswer: '1937-1945',
          explanation: 'O Estado Novo foi o período ditatorial de 1937 a 1945.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'vargas_3',
          question: 'Qual foi a principal criação trabalhista de Vargas?',
          options: ['CLT', 'INSS', 'FGTS', 'PIS'],
          correctAnswer: 'CLT',
          explanation:
              'A CLT (Consolidação das Leis do Trabalho) foi criada em 1943.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'vargas_4',
          question: 'Como Getúlio Vargas morreu?',
          options: ['Doença', 'Acidente', 'Suicídio', 'Assassinato'],
          correctAnswer: 'Suicídio',
          explanation: 'Getúlio Vargas se suicidou em 24 de agosto de 1954.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.brazilHistory,
        ),
        HistoryQuestion(
          id: 'vargas_5',
          question: 'Qual foi o lema de Getúlio Vargas?',
          options: [
            'Ordem e Progresso',
            'Trabalho e Justiça',
            'Pão, Terra e Liberdade',
            'Brasil Grande'
          ],
          correctAnswer: 'Trabalho e Justiça',
          explanation: 'O lema de Vargas era "Trabalho e Justiça".',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.brazilHistory,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 6 - HISTÓRIA MUNDIAL - SEGUNDA GUERRA
    HistoryLesson(
      id: 'world_war_ii',
      title: 'Segunda Guerra Mundial',
      description: 'Aprenda sobre a Segunda Guerra Mundial e seus impactos',
      type: HistoryLessonType.worldHistory,
      difficulty: DifficultyLevel.hard,
      timeLimit: 180,
      xpReward: 100,
      icon: '🌍',
      questions: [
        HistoryQuestion(
          id: 'ww2_1',
          question: 'Em que ano começou a Segunda Guerra Mundial?',
          options: ['1938', '1939', '1940', '1941'],
          correctAnswer: '1939',
          explanation:
              'A Segunda Guerra começou em 1º de setembro de 1939 com a invasão da Polônia.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.worldHistory,
        ),
        HistoryQuestion(
          id: 'ww2_2',
          question: 'Qual foi o evento que marcou o fim da Segunda Guerra?',
          options: [
            'Bombardeio de Hiroshima',
            'Bombardeio de Nagasaki',
            'Rendição da Alemanha',
            'Bombardeio de Tóquio'
          ],
          correctAnswer: 'Bombardeio de Hiroshima',
          explanation:
              'O bombardeio de Hiroshima em 6 de agosto de 1945 marcou o fim da guerra.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.worldHistory,
        ),
        HistoryQuestion(
          id: 'ww2_3',
          question: 'Quais foram os países do Eixo?',
          options: [
            'Alemanha, Itália, Japão',
            'EUA, Reino Unido, França',
            'URSS, China, Brasil',
            'Alemanha, URSS, Itália'
          ],
          correctAnswer: 'Alemanha, Itália, Japão',
          explanation: 'O Eixo era formado pela Alemanha, Itália e Japão.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.worldHistory,
        ),
        HistoryQuestion(
          id: 'ww2_4',
          question: 'Qual foi o campo de concentração mais famoso?',
          options: ['Dachau', 'Auschwitz', 'Buchenwald', 'Treblinka'],
          correctAnswer: 'Auschwitz',
          explanation:
              'Auschwitz foi o maior e mais famoso campo de concentração nazista.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.worldHistory,
        ),
        HistoryQuestion(
          id: 'ww2_5',
          question: 'Em que ano terminou a Segunda Guerra Mundial?',
          options: ['1944', '1945', '1946', '1947'],
          correctAnswer: '1945',
          explanation: 'A Segunda Guerra terminou em 2 de setembro de 1945.',
          timeLimit: 90,
          points: 20,
          type: HistoryLessonType.worldHistory,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 7 - HISTÓRIA CONTEMPORÂNEA
    HistoryLesson(
      id: 'contemporary_history',
      title: 'História Contemporânea',
      description: 'Conheça os principais eventos do século XX e XXI',
      type: HistoryLessonType.contemporaryHistory,
      difficulty: DifficultyLevel.expert,
      timeLimit: 200,
      xpReward: 125,
      icon: '📅',
      questions: [
        HistoryQuestion(
          id: 'cont_1',
          question: 'Em que ano foi criada a ONU?',
          options: ['1944', '1945', '1946', '1947'],
          correctAnswer: '1945',
          explanation: 'A ONU foi criada em 24 de outubro de 1945.',
          timeLimit: 120,
          points: 25,
          type: HistoryLessonType.contemporaryHistory,
        ),
        HistoryQuestion(
          id: 'cont_2',
          question: 'Qual foi o primeiro país a enviar um homem ao espaço?',
          options: ['EUA', 'URSS', 'China', 'Alemanha'],
          correctAnswer: 'URSS',
          explanation: 'A URSS enviou Yuri Gagarin ao espaço em 1961.',
          timeLimit: 120,
          points: 25,
          type: HistoryLessonType.contemporaryHistory,
        ),
        HistoryQuestion(
          id: 'cont_3',
          question: 'Em que ano caiu o Muro de Berlim?',
          options: ['1987', '1988', '1989', '1990'],
          correctAnswer: '1989',
          explanation: 'O Muro de Berlim caiu em 9 de novembro de 1989.',
          timeLimit: 120,
          points: 25,
          type: HistoryLessonType.contemporaryHistory,
        ),
        HistoryQuestion(
          id: 'cont_4',
          question: 'Qual foi o primeiro presidente negro dos EUA?',
          options: [
            'Jesse Jackson',
            'Barack Obama',
            'Colin Powell',
            'Condoleezza Rice'
          ],
          correctAnswer: 'Barack Obama',
          explanation: 'Barack Obama foi eleito presidente dos EUA em 2008.',
          timeLimit: 120,
          points: 25,
          type: HistoryLessonType.contemporaryHistory,
        ),
        HistoryQuestion(
          id: 'cont_5',
          question: 'Em que ano foi criada a internet?',
          options: ['1960', '1969', '1975', '1980'],
          correctAnswer: '1969',
          explanation: 'A internet foi criada em 1969 com a ARPANET.',
          timeLimit: 120,
          points: 25,
          type: HistoryLessonType.contemporaryHistory,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),
  ];
}
