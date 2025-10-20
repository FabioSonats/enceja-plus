import '../../../core/constants/app_constants.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String educationLevel; // 'Fundamental' ou 'Médio'
  final int xp;
  final int level;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final List<String> achievements;
  final Map<String, int> subjectProgress; // Progresso por matéria

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.educationLevel,
    required this.xp,
    required this.level,
    required this.createdAt,
    required this.lastLoginAt,
    required this.achievements,
    required this.subjectProgress,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? educationLevel,
    int? xp,
    int? level,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    List<String>? achievements,
    Map<String, int>? subjectProgress,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      educationLevel: educationLevel ?? this.educationLevel,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      achievements: achievements ?? this.achievements,
      subjectProgress: subjectProgress ?? this.subjectProgress,
    );
  }

  // Calcula o nível baseado no XP
  int calculateLevel(int xp) {
    for (int i = 0; i < AppConstants.levelThresholds.length - 1; i++) {
      if (xp >= AppConstants.levelThresholds[i] &&
          xp < AppConstants.levelThresholds[i + 1]) {
        return i + 1;
      }
    }
    return AppConstants.levelThresholds.length;
  }

  // XP necessário para o próximo nível
  int xpToNextLevel() {
    if (level >= AppConstants.levelThresholds.length) return 0;
    return AppConstants.levelThresholds[level] - xp;
  }

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'educationLevel': educationLevel,
      'xp': xp,
      'level': level,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'achievements': achievements,
      'subjectProgress': subjectProgress,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      educationLevel: json['educationLevel'],
      xp: json['xp'],
      level: json['level'],
      createdAt: DateTime.parse(json['createdAt']),
      lastLoginAt: DateTime.parse(json['lastLoginAt']),
      achievements: List<String>.from(json['achievements']),
      subjectProgress: Map<String, int>.from(json['subjectProgress']),
    );
  }
}
