import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/math_game.dart';
import '../../domain/entities/portuguese_lesson.dart';
import '../../domain/entities/history_lesson.dart';

class SimpleDatabase {
  static const String _userKey = 'current_user';
  static const String _gamesKey = 'math_games';
  static const String _portugueseLessonsKey = 'portuguese_lessons';
  static const String _historyLessonsKey = 'history_lessons';
  static const String _achievementsKey = 'achievements';
  static const String _gameResultsKey = 'game_results';

  // User Management
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson == null) return null;

    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    return User.fromJson(userMap);
  }

  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<void> updateUserXP(int xp) async {
    final user = await getCurrentUser();
    if (user != null) {
      final updatedUser = user.copyWith(
        xp: user.xp + xp,
        level: _calculateLevel(user.xp + xp),
      );
      await saveUser(updatedUser);
    }
  }

  static int _calculateLevel(int xp) {
    if (xp < 100) return 1;
    if (xp < 300) return 2;
    if (xp < 600) return 3;
    if (xp < 1000) return 4;
    if (xp < 1500) return 5;
    return 6;
  }

  // Math Games Management
  static Future<List<MathGame>> getMathGames() async {
    final prefs = await SharedPreferences.getInstance();
    final gamesJson = prefs.getString(_gamesKey);

    if (gamesJson == null) {
      // Inicializar com jogos padrão
      final games = PredefinedMathGames.games;
      await saveMathGames(games);
      return games;
    }

    final List<dynamic> gamesList = jsonDecode(gamesJson);
    return gamesList.map((json) => MathGame.fromJson(json)).toList();
  }

  static Future<void> saveMathGames(List<MathGame> games) async {
    final prefs = await SharedPreferences.getInstance();
    final gamesJson = jsonEncode(games.map((game) => game.toJson()).toList());
    await prefs.setString(_gamesKey, gamesJson);
  }

  static Future<void> markGameCompleted(String gameId) async {
    final games = await getMathGames();
    final updatedGames = games.map((game) {
      if (game.id == gameId) {
        return game.copyWith(isCompleted: true);
      }
      return game;
    }).toList();

    await saveMathGames(updatedGames);
  }

  // Game Results Management
  static Future<List<Map<String, dynamic>>> getGameResults() async {
    final prefs = await SharedPreferences.getInstance();
    final resultsJson = prefs.getString(_gameResultsKey);

    if (resultsJson == null) return [];

    final List<dynamic> resultsList = jsonDecode(resultsJson);
    return resultsList.cast<Map<String, dynamic>>();
  }

  static Future<void> saveGameResult(Map<String, dynamic> result) async {
    final results = await getGameResults();
    results.add(result);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_gameResultsKey, jsonEncode(results));

    // Verificar se deve desbloquear próxima lição
    await _checkAndUnlockNextLesson(result['gameId'], result['accuracy']);
  }

  static Future<void> _checkAndUnlockNextLesson(
      String gameId, double accuracy) async {
    // Se a precisão for >= 70%, desbloquear próxima lição
    if (accuracy >= 0.7) {
      final games = await getMathGames();
      final updatedGames = games.map((game) {
        // Lógica para desbloquear próxima lição baseada no gameId atual
        if (gameId == 'addition_basics' && game.id == 'subtraction_basics') {
          return game.copyWith(isUnlocked: true);
        }
        // Adicione mais lógicas de desbloqueio aqui
        return game;
      }).toList();
      await saveMathGames(updatedGames);
    }
  }

  // Initialize with mock data
  static Future<void> initializeMockData() async {
    await _initializeMockUser();
    await _initializeMockMathGames();
    await _initializeMockAchievements();
  }

  static Future<void> _initializeMockUser() async {
    final existingUser = await getCurrentUser();
    if (existingUser != null) return; // Já existe usuário

    final user = User(
      id: 'user_001',
      name: 'João Silva',
      email: 'joao@example.com',
      photoUrl: null,
      educationLevel: 'Médio',
      xp: 250,
      level: 3,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastLoginAt: DateTime.now(),
      achievements: ['first_lesson', 'math_beginner'],
      subjectProgress: {
        'Matemática': 70,
        'Português': 50,
        'História': 30,
        'Geografia': 60,
      },
    );
    await saveUser(user);
  }

  static Future<void> _initializeMockMathGames() async {
    final existingGames = await getMathGames();
    if (existingGames.isNotEmpty) return; // Já existem jogos

    final games = PredefinedMathGames.games;
    await saveMathGames(games);
  }

  static Future<void> _initializeMockAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = prefs.getString(_achievementsKey);

    if (achievementsJson != null) return; // Já existem conquistas

    final achievements = [
      {
        'id': 'first_lesson',
        'title': 'Primeira Lição',
        'description': 'Complete sua primeira lição',
        'icon': '🎓',
        'category': 'study',
        'xpReward': 25,
        'isUnlocked': true,
        'unlockedAt':
            DateTime.now().subtract(const Duration(days: 25)).toIso8601String(),
      },
      {
        'id': 'math_beginner',
        'title': 'Iniciante em Matemática',
        'description': 'Complete 5 jogos de matemática',
        'icon': '🧮',
        'category': 'study',
        'xpReward': 50,
        'isUnlocked': true,
        'unlockedAt':
            DateTime.now().subtract(const Duration(days: 20)).toIso8601String(),
      },
      {
        'id': 'math_expert',
        'title': 'Expert em Matemática',
        'description': 'Complete 20 jogos de matemática',
        'icon': '🏆',
        'category': 'study',
        'xpReward': 100,
        'isUnlocked': false,
        'unlockedAt': null,
      },
    ];

    await prefs.setString(_achievementsKey, jsonEncode(achievements));
  }

  // Portuguese Lessons Management
  static Future<List<PortugueseLesson>> getPortugueseLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final lessonsJson = prefs.getString(_portugueseLessonsKey);

    if (lessonsJson == null) {
      // Initialize with predefined lessons
      await _initializePortugueseLessons();
      return getPortugueseLessons();
    }

    final lessonsList = jsonDecode(lessonsJson) as List;
    return lessonsList
        .map((lesson) => PortugueseLesson.fromJson(lesson))
        .toList();
  }

  static Future<void> savePortugueseLessons(
      List<PortugueseLesson> lessons) async {
    final prefs = await SharedPreferences.getInstance();
    final lessonsJson =
        jsonEncode(lessons.map((lesson) => lesson.toJson()).toList());
    await prefs.setString(_portugueseLessonsKey, lessonsJson);
  }

  static Future<void> _initializePortugueseLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final lessons = PredefinedPortugueseLessons.lessons;
    await prefs.setString(_portugueseLessonsKey,
        jsonEncode(lessons.map((lesson) => lesson.toJson()).toList()));
  }

  static Future<void> markPortugueseLessonCompleted(String lessonId) async {
    final lessons = await getPortugueseLessons();
    final updatedLessons = lessons.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(isCompleted: true);
      }
      return lesson;
    }).toList();
    await savePortugueseLessons(updatedLessons);
  }

  static Future<void> unlockPortugueseLesson(String lessonId) async {
    final lessons = await getPortugueseLessons();
    final updatedLessons = lessons.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(isUnlocked: true);
      }
      return lesson;
    }).toList();
    await savePortugueseLessons(updatedLessons);
  }

  // History Lessons Management
  static Future<List<HistoryLesson>> getHistoryLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final lessonsJson = prefs.getString(_historyLessonsKey);

    if (lessonsJson == null) {
      // Initialize with predefined lessons
      await _initializeHistoryLessons();
      return getHistoryLessons();
    }

    final lessonsList = jsonDecode(lessonsJson) as List;
    return lessonsList.map((lesson) => HistoryLesson.fromJson(lesson)).toList();
  }

  static Future<void> saveHistoryLessons(List<HistoryLesson> lessons) async {
    final prefs = await SharedPreferences.getInstance();
    final lessonsJson =
        jsonEncode(lessons.map((lesson) => lesson.toJson()).toList());
    await prefs.setString(_historyLessonsKey, lessonsJson);
  }

  static Future<void> _initializeHistoryLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final lessons = PredefinedHistoryLessons.lessons;
    await prefs.setString(_historyLessonsKey,
        jsonEncode(lessons.map((lesson) => lesson.toJson()).toList()));
  }

  static Future<void> markHistoryLessonCompleted(String lessonId) async {
    final lessons = await getHistoryLessons();
    final updatedLessons = lessons.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(isCompleted: true);
      }
      return lesson;
    }).toList();
    await saveHistoryLessons(updatedLessons);
  }

  static Future<void> unlockHistoryLesson(String lessonId) async {
    final lessons = await getHistoryLessons();
    final updatedLessons = lessons.map((lesson) {
      if (lesson.id == lessonId) {
        return lesson.copyWith(isUnlocked: true);
      }
      return lesson;
    }).toList();
    await saveHistoryLessons(updatedLessons);
  }
}
