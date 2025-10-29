import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  // Stream do usuário atual
  Stream<UserModel?> get authStateChanges {
    return _authService.authStateChanges.map((user) {
      return user != null ? UserModel.fromFirebaseUser(user) : null;
    });
  }

  // Usuário atual
  UserModel? get currentUser {
    final user = _authService.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  // Login com email e senha
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result?.user != null 
          ? UserModel.fromFirebaseUser(result!.user!)
          : null;
    } catch (e) {
      rethrow;
    }
  }

  // Registro com email e senha
  Future<UserModel?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result?.user != null 
          ? UserModel.fromFirebaseUser(result!.user!)
          : null;
    } catch (e) {
      rethrow;
    }
  }

  // Login com Google
  Future<UserModel?> signInWithGoogle() async {
    try {
      final result = await _authService.signInWithGoogle();
      return result?.user != null 
          ? UserModel.fromFirebaseUser(result!.user!)
          : null;
    } catch (e) {
      rethrow;
    }
  }

  // Login anônimo
  Future<UserModel?> signInAnonymously() async {
    try {
      final result = await _authService.signInAnonymously();
      return result?.user != null 
          ? UserModel.fromFirebaseUser(result!.user!)
          : null;
    } catch (e) {
      rethrow;
    }
  }

  // Enviar email de verificação
  Future<void> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
    } catch (e) {
      rethrow;
    }
  }

  // Resetar senha
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Atualizar perfil do usuário
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      await _authService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Deletar conta
  Future<void> deleteAccount() async {
    try {
      await _authService.deleteAccount();
    } catch (e) {
      rethrow;
    }
  }

  // Verificar se o usuário está logado
  bool get isLoggedIn => currentUser != null;

  // Verificar se o email foi verificado
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  // Obter nome do usuário
  String get userName {
    final user = currentUser;
    if (user == null) return 'Usuário';
    return user.displayName ?? user.email?.split('@').first ?? 'Usuário';
  }

  // Obter email do usuário
  String? get userEmail => currentUser?.email;

  // Obter foto do usuário
  String? get userPhoto => currentUser?.photoURL;
}
