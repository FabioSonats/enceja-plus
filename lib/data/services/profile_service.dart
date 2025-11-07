import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _usersCollection = 'users';
  static const String _progressCollection = 'progress';

  /// Salvar ou atualizar perfil do usuário
  Future<void> saveUserProfile({
    required String uid,
    String? displayName,
    String? email,
    String? photoURL,
    String? phone,
  }) async {
    try {
      final userData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) {
        userData['displayName'] = displayName;
      }
      if (email != null) {
        userData['email'] = email;
      }
      if (photoURL != null) {
        userData['photoURL'] = photoURL;
      }
      if (phone != null) {
        userData['phone'] = phone;
      }

      // Criar ou atualizar documento do usuário
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .set(userData, SetOptions(merge: true));
    } catch (e) {
      throw 'Erro ao salvar perfil: $e';
    }
  }

  /// Buscar perfil do usuário
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar perfil: $e';
    }
  }

  /// Salvar progresso do usuário
  Future<void> saveProgress({
    required String uid,
    required Map<String, double> subjectProgress,
    required double overallProgress,
    required int totalStudyTime,
    required int streakDays,
    required int completedLessons,
  }) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .collection(_progressCollection)
          .doc('current')
          .set({
        'subjectProgress': subjectProgress.map(
          (key, value) => MapEntry(key, value),
        ),
        'overallProgress': overallProgress,
        'totalStudyTime': totalStudyTime,
        'streakDays': streakDays,
        'completedLessons': completedLessons,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw 'Erro ao salvar progresso: $e';
    }
  }

  /// Buscar progresso do usuário
  Future<Map<String, dynamic>?> getUserProgress(String uid) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .collection(_progressCollection)
          .doc('current')
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw 'Erro ao buscar progresso: $e';
    }
  }

  /// Stream de progresso do usuário (para atualizações em tempo real)
  Stream<Map<String, dynamic>?> getUserProgressStream(String uid) {
    return _firestore
        .collection(_usersCollection)
        .doc(uid)
        .collection(_progressCollection)
        .doc('current')
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

  /// Criar perfil inicial quando usuário se cadastra
  Future<void> createInitialProfile({
    required String uid,
    required String email,
    String? displayName,
    String? phone,
  }) async {
    try {
      final profileData = {
        'email': email,
        'displayName': displayName ?? email.split('@').first,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (phone != null && phone.isNotEmpty) {
        profileData['phone'] = phone;
      }
      
      await _firestore.collection(_usersCollection).doc(uid).set(profileData);

      // Criar progresso inicial
      await _firestore
          .collection(_usersCollection)
          .doc(uid)
          .collection(_progressCollection)
          .doc('current')
          .set({
        'subjectProgress': {
          'matematica': 0.0,
          'portugues': 0.0,
          'historia': 0.0,
          'ciencias': 0.0,
          'geografia': 0.0,
        },
        'overallProgress': 0.0,
        'totalStudyTime': 0,
        'streakDays': 0,
        'completedLessons': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Erro ao criar perfil inicial: $e';
    }
  }

  /// Atualizar progresso de uma matéria específica
  Future<void> updateSubjectProgress({
    required String uid,
    required String subject,
    required double progress,
  }) async {
    try {
      final progressDoc = await getUserProgress(uid);
      if (progressDoc != null) {
        final subjectProgress =
            Map<String, dynamic>.from(progressDoc['subjectProgress'] ?? {});
        subjectProgress[subject] = progress;

        // Calcular progresso geral
        final values = subjectProgress.values
            .where((v) => v is num)
            .map((v) => (v as num).toDouble())
            .toList();
        final overallProgress =
            values.isEmpty ? 0.0 : values.reduce((a, b) => a + b) / values.length;

        await saveProgress(
          uid: uid,
          subjectProgress: subjectProgress.map(
            (key, value) => MapEntry(key, value as double),
          ),
          overallProgress: overallProgress,
          totalStudyTime: progressDoc['totalStudyTime'] ?? 0,
          streakDays: progressDoc['streakDays'] ?? 0,
          completedLessons: progressDoc['completedLessons'] ?? 0,
        );
      }
    } catch (e) {
      throw 'Erro ao atualizar progresso da matéria: $e';
    }
  }
}

