class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category; // 'study', 'quiz', 'time', 'streak'
  final int xpReward;
  final Map<String, dynamic> requirements;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.xpReward,
    required this.requirements,
    required this.isUnlocked,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    String? category,
    int? xpReward,
    Map<String, dynamic>? requirements,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      xpReward: xpReward ?? this.xpReward,
      requirements: requirements ?? this.requirements,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}

// Conquistas pré-definidas
class PredefinedAchievements {
  static const List<Achievement> achievements = [
    Achievement(
      id: 'first_lesson',
      title: 'Primeiro Passo',
      description: 'Complete sua primeira lição',
      icon: '🎯',
      category: 'study',
      xpReward: 50,
      requirements: {'lessons_completed': 1},
      isUnlocked: false,
    ),
    Achievement(
      id: 'math_master',
      title: 'Mestre da Matemática',
      description: 'Complete 10 lições de Matemática',
      icon: '🧮',
      category: 'study',
      xpReward: 100,
      requirements: {'subject': 'Matemática', 'lessons_completed': 10},
      isUnlocked: false,
    ),
    Achievement(
      id: 'perfect_score',
      title: 'Nota 10',
      description: 'Acerte 100% das questões em um quiz',
      icon: '💯',
      category: 'quiz',
      xpReward: 75,
      requirements: {'accuracy': 1.0},
      isUnlocked: false,
    ),
    Achievement(
      id: 'streak_7',
      title: 'Sete Dias de Fogo',
      description: 'Estude por 7 dias consecutivos',
      icon: '🔥',
      category: 'streak',
      xpReward: 200,
      requirements: {'streak_days': 7},
      isUnlocked: false,
    ),
    Achievement(
      id: 'speed_demon',
      title: 'Velocidade da Luz',
      description: 'Complete um quiz em menos de 30 segundos',
      icon: '⚡',
      category: 'time',
      xpReward: 150,
      requirements: {'max_time': 30},
      isUnlocked: false,
    ),
  ];
}
