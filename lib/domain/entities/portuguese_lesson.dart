enum PortugueseLessonType {
  grammar,
  reading,
  writing,
  vocabulary,
  textInterpretation,
  literature,
  languageVariations,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
  expert,
}

class PortugueseLesson {
  final String id;
  final String title;
  final String description;
  final PortugueseLessonType type;
  final DifficultyLevel difficulty;
  final int timeLimit; // em segundos
  final int xpReward;
  final String icon;
  final List<PortugueseQuestion> questions;
  final bool isUnlocked;
  final bool isCompleted;

  const PortugueseLesson({
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

  PortugueseLesson copyWith({
    String? id,
    String? title,
    String? description,
    PortugueseLessonType? type,
    DifficultyLevel? difficulty,
    int? timeLimit,
    int? xpReward,
    String? icon,
    List<PortugueseQuestion>? questions,
    bool? isUnlocked,
    bool? isCompleted,
  }) {
    return PortugueseLesson(
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

  factory PortugueseLesson.fromJson(Map<String, dynamic> json) {
    return PortugueseLesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: PortugueseLessonType.values[json['type']],
      difficulty: DifficultyLevel.values[json['difficulty']],
      timeLimit: json['timeLimit'],
      xpReward: json['xpReward'],
      icon: json['icon'],
      questions: (json['questions'] as List)
          .map((q) => PortugueseQuestion.fromJson(q))
          .toList(),
      isUnlocked: json['isUnlocked'],
      isCompleted: json['isCompleted'],
    );
  }
}

class PortugueseQuestion {
  final String id;
  final String question;
  final String? imageUrl;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final int timeLimit; // em segundos
  final int points;
  final PortugueseLessonType type;

  const PortugueseQuestion({
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

  factory PortugueseQuestion.fromJson(Map<String, dynamic> json) {
    return PortugueseQuestion(
      id: json['id'],
      question: json['question'],
      imageUrl: json['imageUrl'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correctAnswer'],
      explanation: json['explanation'],
      timeLimit: json['timeLimit'],
      points: json['points'],
      type: PortugueseLessonType.values[json['type']],
    );
  }
}

// Lições pré-definidas de português baseadas no ENCCEJA
class PredefinedPortugueseLessons {
  static final List<PortugueseLesson> lessons = [
    // NÍVEL 1 - GRAMÁTICA BÁSICA
    PortugueseLesson(
      id: 'grammar_basics',
      title: 'Gramática Básica',
      description: 'Aprenda os fundamentos da gramática portuguesa',
      type: PortugueseLessonType.grammar,
      difficulty: DifficultyLevel.easy,
      timeLimit: 90,
      xpReward: 50,
      icon: '📚',
      questions: [
        PortugueseQuestion(
          id: 'gram_1',
          question: 'Qual é o substantivo na frase: "O gato dorme no sofá"?',
          options: ['O', 'gato', 'dorme', 'no'],
          correctAnswer: 'gato',
          explanation:
              'Substantivo é a palavra que nomeia seres, objetos, lugares, etc.',
          timeLimit: 45,
          points: 10,
          type: PortugueseLessonType.grammar,
        ),
        PortugueseQuestion(
          id: 'gram_2',
          question: 'Qual é o verbo na frase: "Maria estuda muito"?',
          options: ['Maria', 'estuda', 'muito', 'todos'],
          correctAnswer: 'estuda',
          explanation: 'Verbo é a palavra que indica ação, estado ou fenômeno.',
          timeLimit: 45,
          points: 10,
          type: PortugueseLessonType.grammar,
        ),
        PortugueseQuestion(
          id: 'gram_3',
          question: 'Qual é o adjetivo na frase: "A casa bonita é grande"?',
          options: ['A', 'casa', 'bonita', 'é'],
          correctAnswer: 'bonita',
          explanation: 'Adjetivo é a palavra que qualifica o substantivo.',
          timeLimit: 45,
          points: 10,
          type: PortugueseLessonType.grammar,
        ),
        PortugueseQuestion(
          id: 'gram_4',
          question: 'Qual palavra é um substantivo próprio?',
          options: ['casa', 'Brasil', 'bonito', 'correr'],
          correctAnswer: 'Brasil',
          explanation:
              'Substantivo próprio é o nome específico de pessoas, lugares, etc.',
          timeLimit: 45,
          points: 10,
          type: PortugueseLessonType.grammar,
        ),
        PortugueseQuestion(
          id: 'gram_5',
          question: 'Qual é o artigo na frase: "O menino joga futebol"?',
          options: ['O', 'menino', 'joga', 'futebol'],
          correctAnswer: 'O',
          explanation: 'Artigo é a palavra que acompanha o substantivo.',
          timeLimit: 45,
          points: 10,
          type: PortugueseLessonType.grammar,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 2 - INTERPRETAÇÃO DE TEXTO
    PortugueseLesson(
      id: 'text_interpretation',
      title: 'Interpretação de Texto',
      description: 'Aprenda a interpretar e compreender textos',
      type: PortugueseLessonType.textInterpretation,
      difficulty: DifficultyLevel.medium,
      timeLimit: 120,
      xpReward: 75,
      icon: '📖',
      questions: [
        PortugueseQuestion(
          id: 'interp_1',
          question:
              'No texto: "O sol brilha forte hoje. As pessoas procuram sombra." Qual é a ideia principal?',
          options: [
            'Está chovendo',
            'O sol está forte',
            'As pessoas estão felizes',
            'É noite'
          ],
          correctAnswer: 'O sol está forte',
          explanation:
              'A ideia principal é que o sol está forte, por isso as pessoas procuram sombra.',
          timeLimit: 60,
          points: 15,
          type: PortugueseLessonType.textInterpretation,
        ),
        PortugueseQuestion(
          id: 'interp_2',
          question:
              'No texto: "Maria adora ler livros. Ela passa horas na biblioteca." O que podemos concluir sobre Maria?',
          options: [
            'Ela não gosta de ler',
            'Ela gosta muito de ler',
            'Ela tem medo de livros',
            'Ela não vai à biblioteca'
          ],
          correctAnswer: 'Ela gosta muito de ler',
          explanation:
              'O texto mostra que Maria adora ler e passa horas na biblioteca.',
          timeLimit: 60,
          points: 15,
          type: PortugueseLessonType.textInterpretation,
        ),
        PortugueseQuestion(
          id: 'interp_3',
          question:
              'No texto: "O cachorro late muito. Os vizinhos reclamam do barulho." Qual é a consequência do latido?',
          options: [
            'Os vizinhos gostam',
            'Os vizinhos reclamam',
            'O cachorro para de latir',
            'Não há problema'
          ],
          correctAnswer: 'Os vizinhos reclamam',
          explanation:
              'A consequência do latido é que os vizinhos reclamam do barulho.',
          timeLimit: 60,
          points: 15,
          type: PortugueseLessonType.textInterpretation,
        ),
        PortugueseQuestion(
          id: 'interp_4',
          question:
              'No texto: "João estudou muito para a prova. Ele conseguiu uma boa nota." Qual é a relação entre estudar e a nota?',
          options: [
            'Não há relação',
            'Estudar não ajuda',
            'Estudar trouxe boa nota',
            'A nota foi ruim'
          ],
          correctAnswer: 'Estudar trouxe boa nota',
          explanation:
              'O texto mostra que estudar muito resultou em uma boa nota.',
          timeLimit: 60,
          points: 15,
          type: PortugueseLessonType.textInterpretation,
        ),
        PortugueseQuestion(
          id: 'interp_5',
          question:
              'No texto: "A chuva caiu forte. As ruas ficaram alagadas." Qual é a causa do alagamento?',
          options: ['O sol forte', 'A chuva forte', 'O vento', 'O frio'],
          correctAnswer: 'A chuva forte',
          explanation: 'A chuva forte foi a causa do alagamento das ruas.',
          timeLimit: 60,
          points: 15,
          type: PortugueseLessonType.textInterpretation,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 3 - VOCABULÁRIO E SINÔNIMOS
    PortugueseLesson(
      id: 'vocabulary_synonyms',
      title: 'Vocabulário e Sinônimos',
      description: 'Expanda seu vocabulário e aprenda sinônimos',
      type: PortugueseLessonType.vocabulary,
      difficulty: DifficultyLevel.medium,
      timeLimit: 90,
      xpReward: 75,
      icon: '📝',
      questions: [
        PortugueseQuestion(
          id: 'vocab_1',
          question: 'Qual é o sinônimo de "bonito"?',
          options: ['feio', 'belo', 'ruim', 'pequeno'],
          correctAnswer: 'belo',
          explanation: 'Belo é sinônimo de bonito.',
          timeLimit: 45,
          points: 15,
          type: PortugueseLessonType.vocabulary,
        ),
        PortugueseQuestion(
          id: 'vocab_2',
          question: 'Qual é o sinônimo de "grande"?',
          options: ['pequeno', 'enorme', 'baixo', 'curto'],
          correctAnswer: 'enorme',
          explanation: 'Enorme é sinônimo de grande.',
          timeLimit: 45,
          points: 15,
          type: PortugueseLessonType.vocabulary,
        ),
        PortugueseQuestion(
          id: 'vocab_3',
          question: 'Qual é o sinônimo de "rápido"?',
          options: ['lento', 'veloz', 'parado', 'quieto'],
          correctAnswer: 'veloz',
          explanation: 'Veloz é sinônimo de rápido.',
          timeLimit: 45,
          points: 15,
          type: PortugueseLessonType.vocabulary,
        ),
        PortugueseQuestion(
          id: 'vocab_4',
          question: 'Qual é o sinônimo de "feliz"?',
          options: ['triste', 'alegre', 'bravo', 'cansado'],
          correctAnswer: 'alegre',
          explanation: 'Alegre é sinônimo de feliz.',
          timeLimit: 45,
          points: 15,
          type: PortugueseLessonType.vocabulary,
        ),
        PortugueseQuestion(
          id: 'vocab_5',
          question: 'Qual é o sinônimo de "inteligente"?',
          options: ['burro', 'esperto', 'lento', 'quieto'],
          correctAnswer: 'esperto',
          explanation: 'Esperto é sinônimo de inteligente.',
          timeLimit: 45,
          points: 15,
          type: PortugueseLessonType.vocabulary,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 4 - ESCRITA E REDAÇÃO
    PortugueseLesson(
      id: 'writing_composition',
      title: 'Escrita e Redação',
      description: 'Aprenda a escrever textos bem estruturados',
      type: PortugueseLessonType.writing,
      difficulty: DifficultyLevel.hard,
      timeLimit: 150,
      xpReward: 100,
      icon: '✍️',
      questions: [
        PortugueseQuestion(
          id: 'write_1',
          question: 'Qual é a melhor forma de começar uma redação?',
          options: [
            'Com uma pergunta',
            'Com uma afirmação',
            'Com uma introdução clara',
            'Todas as anteriores'
          ],
          correctAnswer: 'Todas as anteriores',
          explanation:
              'Uma redação pode começar de várias formas, desde que seja clara e interessante.',
          timeLimit: 75,
          points: 20,
          type: PortugueseLessonType.writing,
        ),
        PortugueseQuestion(
          id: 'write_2',
          question: 'O que é essencial em um parágrafo?',
          options: [
            'Uma ideia principal',
            'Muitas palavras',
            'Frases longas',
            'Pontuação complexa'
          ],
          correctAnswer: 'Uma ideia principal',
          explanation:
              'Cada parágrafo deve ter uma ideia principal bem desenvolvida.',
          timeLimit: 75,
          points: 20,
          type: PortugueseLessonType.writing,
        ),
        PortugueseQuestion(
          id: 'write_3',
          question: 'Qual é a função da conclusão em um texto?',
          options: [
            'Repetir tudo',
            'Fechar as ideias',
            'Introduzir novos temas',
            'Confundir o leitor'
          ],
          correctAnswer: 'Fechar as ideias',
          explanation:
              'A conclusão deve fechar e sintetizar as ideias apresentadas.',
          timeLimit: 75,
          points: 20,
          type: PortugueseLessonType.writing,
        ),
        PortugueseQuestion(
          id: 'write_4',
          question: 'O que torna um texto mais interessante?',
          options: [
            'Frases muito longas',
            'Vocabulário variado',
            'Muitos erros',
            'Ideias confusas'
          ],
          correctAnswer: 'Vocabulário variado',
          explanation:
              'Um vocabulário variado torna o texto mais rico e interessante.',
          timeLimit: 75,
          points: 20,
          type: PortugueseLessonType.writing,
        ),
        PortugueseQuestion(
          id: 'write_5',
          question: 'Qual é a importância da revisão de um texto?',
          options: [
            'Não é importante',
            'Corrigir erros',
            'Melhorar a clareza',
            'B e C estão corretas'
          ],
          correctAnswer: 'B e C estão corretas',
          explanation:
              'A revisão serve para corrigir erros e melhorar a clareza do texto.',
          timeLimit: 75,
          points: 20,
          type: PortugueseLessonType.writing,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 5 - LITERATURA BRASILEIRA
    PortugueseLesson(
      id: 'brazilian_literature',
      title: 'Literatura Brasileira',
      description:
          'Conheça os principais autores e obras da literatura brasileira',
      type: PortugueseLessonType.literature,
      difficulty: DifficultyLevel.hard,
      timeLimit: 120,
      xpReward: 100,
      icon: '📚',
      questions: [
        PortugueseQuestion(
          id: 'lit_1',
          question: 'Quem escreveu "O Cortiço"?',
          options: [
            'Machado de Assis',
            'Aluísio Azevedo',
            'José de Alencar',
            'Castro Alves'
          ],
          correctAnswer: 'Aluísio Azevedo',
          explanation: 'Aluísio Azevedo é o autor de "O Cortiço".',
          timeLimit: 60,
          points: 20,
          type: PortugueseLessonType.literature,
        ),
        PortugueseQuestion(
          id: 'lit_2',
          question: 'Qual é a obra mais famosa de Machado de Assis?',
          options: [
            'Dom Casmurro',
            'O Guarani',
            'Casa-Grande & Senzala',
            'Vidas Secas'
          ],
          correctAnswer: 'Dom Casmurro',
          explanation:
              'Dom Casmurro é uma das obras mais famosas de Machado de Assis.',
          timeLimit: 60,
          points: 20,
          type: PortugueseLessonType.literature,
        ),
        PortugueseQuestion(
          id: 'lit_3',
          question: 'Quem escreveu "Vidas Secas"?',
          options: [
            'Graciliano Ramos',
            'José Lins do Rego',
            'Rachel de Queiroz',
            'Jorge Amado'
          ],
          correctAnswer: 'Graciliano Ramos',
          explanation: 'Graciliano Ramos é o autor de "Vidas Secas".',
          timeLimit: 60,
          points: 20,
          type: PortugueseLessonType.literature,
        ),
        PortugueseQuestion(
          id: 'lit_4',
          question:
              'Qual movimento literário teve como principal representante Castro Alves?',
          options: ['Romantismo', 'Realismo', 'Naturalismo', 'Modernismo'],
          correctAnswer: 'Romantismo',
          explanation:
              'Castro Alves foi um dos principais poetas do Romantismo brasileiro.',
          timeLimit: 60,
          points: 20,
          type: PortugueseLessonType.literature,
        ),
        PortugueseQuestion(
          id: 'lit_5',
          question: 'Quem escreveu "Capitães da Areia"?',
          options: [
            'Jorge Amado',
            'Érico Veríssimo',
            'José Lins do Rego',
            'Rachel de Queiroz'
          ],
          correctAnswer: 'Jorge Amado',
          explanation: 'Jorge Amado é o autor de "Capitães da Areia".',
          timeLimit: 60,
          points: 20,
          type: PortugueseLessonType.literature,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),

    // NÍVEL 6 - VARIAÇÕES LINGUÍSTICAS
    PortugueseLesson(
      id: 'language_variations',
      title: 'Variações Linguísticas',
      description: 'Entenda as diferentes formas de falar português no Brasil',
      type: PortugueseLessonType.languageVariations,
      difficulty: DifficultyLevel.expert,
      timeLimit: 120,
      xpReward: 125,
      icon: '🗣️',
      questions: [
        PortugueseQuestion(
          id: 'var_1',
          question: 'O que são variações linguísticas?',
          options: [
            'Erros de português',
            'Diferentes formas de falar',
            'Línguas estrangeiras',
            'Gírias apenas'
          ],
          correctAnswer: 'Diferentes formas de falar',
          explanation:
              'Variações linguísticas são as diferentes formas de falar uma língua.',
          timeLimit: 60,
          points: 25,
          type: PortugueseLessonType.languageVariations,
        ),
        PortugueseQuestion(
          id: 'var_2',
          question: 'Qual é um exemplo de variação regional?',
          options: [
            'Falar "você" ou "tu"',
            'Usar gírias',
            'Falar rápido',
            'Falar devagar'
          ],
          correctAnswer: 'Falar "você" ou "tu"',
          explanation:
              'O uso de "você" ou "tu" varia conforme a região do Brasil.',
          timeLimit: 60,
          points: 25,
          type: PortugueseLessonType.languageVariations,
        ),
        PortugueseQuestion(
          id: 'var_3',
          question: 'O que é linguagem formal?',
          options: [
            'Gírias',
            'Linguagem culta',
            'Linguagem popular',
            'Linguagem coloquial'
          ],
          correctAnswer: 'Linguagem culta',
          explanation:
              'Linguagem formal é a linguagem culta, usada em situações oficiais.',
          timeLimit: 60,
          points: 25,
          type: PortugueseLessonType.languageVariations,
        ),
        PortugueseQuestion(
          id: 'var_4',
          question: 'O que é linguagem informal?',
          options: [
            'Linguagem culta',
            'Linguagem coloquial',
            'Linguagem técnica',
            'Linguagem acadêmica'
          ],
          correctAnswer: 'Linguagem coloquial',
          explanation:
              'Linguagem informal é a linguagem coloquial, usada no dia a dia.',
          timeLimit: 60,
          points: 25,
          type: PortugueseLessonType.languageVariations,
        ),
        PortugueseQuestion(
          id: 'var_5',
          question: 'Por que é importante conhecer as variações linguísticas?',
          options: [
            'Para julgar as pessoas',
            'Para respeitar a diversidade',
            'Para falar igual a todos',
            'Para evitar diferenças'
          ],
          correctAnswer: 'Para respeitar a diversidade',
          explanation:
              'Conhecer as variações linguísticas ajuda a respeitar a diversidade cultural.',
          timeLimit: 60,
          points: 25,
          type: PortugueseLessonType.languageVariations,
        ),
      ],
      isUnlocked: true,
      isCompleted: false,
    ),
  ];
}
