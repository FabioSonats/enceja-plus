import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:encceja_plus/data/repositories/auth_repository.dart';
import 'package:encceja_plus/data/services/auth_service.dart';
import 'package:encceja_plus/presentation/blocs/auth_bloc.dart';
import 'package:encceja_plus/data/models/user_model.dart';

// Gerar mocks
@GenerateMocks([AuthService, AuthRepository, User])
void main() {
  group('AuthBloc Tests', () {
    late AuthBloc authBloc;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    group('AuthCheckRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthAuthenticated when user is logged in',
        build: () {
          when(mockAuthRepository.currentUser).thenReturn(
            UserModel(
              uid: 'test-uid',
              email: 'test@example.com',
              displayName: 'Test User',
            ),
          );
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [
          AuthAuthenticated(
            user: UserModel(
              uid: 'test-uid',
              email: 'test@example.com',
              displayName: 'Test User',
            ),
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthUnauthenticated when user is not logged in',
        build: () {
          when(mockAuthRepository.currentUser).thenReturn(null);
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthCheckRequested()),
        expect: () => [
          AuthUnauthenticated(),
        ],
      );
    });

    group('AuthSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthLoading then AuthAuthenticated on successful login',
        build: () {
          when(mockAuthRepository.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'password123',
          )).thenAnswer((_) async => UserModel(
            uid: 'test-uid',
            email: 'test@example.com',
            displayName: 'Test User',
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthSignInRequested(
          email: 'test@example.com',
          password: 'password123',
        )),
        expect: () => [
          AuthLoading(),
          AuthAuthenticated(
            user: UserModel(
              uid: 'test-uid',
              email: 'test@example.com',
              displayName: 'Test User',
            ),
          ),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits AuthLoading then AuthError on failed login',
        build: () {
          when(mockAuthRepository.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'wrongpassword',
          )).thenThrow(Exception('Invalid credentials'));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthSignInRequested(
          email: 'test@example.com',
          password: 'wrongpassword',
        )),
        expect: () => [
          AuthLoading(),
          AuthError(message: 'Exception: Invalid credentials'),
        ],
      );
    });

    group('AuthSignUpRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthLoading then AuthAuthenticated on successful signup',
        build: () {
          when(mockAuthRepository.createUserWithEmailAndPassword(
            email: 'newuser@example.com',
            password: 'password123',
          )).thenAnswer((_) async => UserModel(
            uid: 'new-uid',
            email: 'newuser@example.com',
            displayName: 'New User',
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthSignUpRequested(
          email: 'newuser@example.com',
          password: 'password123',
        )),
        expect: () => [
          AuthLoading(),
          AuthAuthenticated(
            user: UserModel(
              uid: 'new-uid',
              email: 'newuser@example.com',
              displayName: 'New User',
            ),
          ),
        ],
      );
    });

    group('AuthGoogleSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthLoading then AuthAuthenticated on successful Google login',
        build: () {
          when(mockAuthRepository.signInWithGoogle()).thenAnswer((_) async => UserModel(
            uid: 'google-uid',
            email: 'google@example.com',
            displayName: 'Google User',
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthGoogleSignInRequested()),
        expect: () => [
          AuthLoading(),
          AuthAuthenticated(
            user: UserModel(
              uid: 'google-uid',
              email: 'google@example.com',
              displayName: 'Google User',
            ),
          ),
        ],
      );
    });

    group('AuthAnonymousSignInRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthLoading then AuthAuthenticated on successful anonymous login',
        build: () {
          when(mockAuthRepository.signInAnonymously()).thenAnswer((_) async => UserModel(
            uid: 'anonymous-uid',
            isAnonymous: true,
          ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthAnonymousSignInRequested()),
        expect: () => [
          AuthLoading(),
          AuthAuthenticated(
            user: UserModel(
              uid: 'anonymous-uid',
              isAnonymous: true,
            ),
          ),
        ],
      );
    });

    group('AuthSignOutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthLoading then AuthUnauthenticated on successful logout',
        build: () {
          when(mockAuthRepository.signOut()).thenAnswer((_) async {});
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthSignOutRequested()),
        expect: () => [
          AuthLoading(),
          AuthUnauthenticated(),
        ],
      );
    });

    group('AuthPasswordResetRequested', () {
      blocTest<AuthBloc, AuthState>(
        'emits AuthLoading then AuthPasswordResetSent on successful password reset',
        build: () {
          when(mockAuthRepository.sendPasswordResetEmail('test@example.com'))
              .thenAnswer((_) async {});
          return authBloc;
        },
        act: (bloc) => bloc.add(AuthPasswordResetRequested(email: 'test@example.com')),
        expect: () => [
          AuthLoading(),
          AuthPasswordResetSent(email: 'test@example.com'),
        ],
      );
    });
  });
}
