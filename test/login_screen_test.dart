import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import 'package:encceja_plus/presentation/views/auth/login_screen.dart';
import 'package:encceja_plus/presentation/blocs/auth_bloc.dart';
import 'package:encceja_plus/data/repositories/auth_repository.dart';
import 'package:encceja_plus/data/models/user_model.dart';
import 'package:encceja_plus/core/routes/app_routes.dart';

import 'auth_test.mocks.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    late MockAuthRepository mockAuthRepository;
    late AuthBloc authBloc;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      authBloc = AuthBloc(authRepository: mockAuthRepository);
    });

    tearDown(() {
      authBloc.close();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: BlocProvider<AuthBloc>(
          create: (context) => authBloc,
          child: const LoginScreen(),
        ),
      );
    }

    testWidgets('should display login form elements', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verificar se os elementos principais estão presentes
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Digite seu email'), findsOneWidget);
      expect(find.text('Digite sua senha'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should toggle between login and signup', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verificar se está no modo login inicialmente
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Não tem uma conta?'), findsOneWidget);

      // Clicar no botão para alternar para cadastro
      await tester.tap(find.text('Criar conta'));
      await tester.pump();

      // Verificar se mudou para modo cadastro
      expect(find.text('Criar Conta'), findsOneWidget);
      expect(find.text('Já tem uma conta?'), findsOneWidget);
    });

    testWidgets('should show password visibility toggle', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Encontrar o campo de senha
      final passwordField = find.byType(TextFormField).last;
      expect(passwordField, findsOneWidget);

      // Encontrar o botão de visibilidade
      final visibilityButton = find.byIcon(Icons.visibility);
      expect(visibilityButton, findsOneWidget);

      // Clicar no botão de visibilidade
      await tester.tap(visibilityButton);
      await tester.pump();

      // Verificar se o ícone mudou
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });

    testWidgets('should validate email field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tentar submeter formulário vazio
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verificar se aparece mensagem de erro
      expect(find.text('Digite seu email'), findsOneWidget);
    });

    testWidgets('should validate password field', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Preencher email válido
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      
      // Tentar submeter formulário sem senha
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verificar se aparece mensagem de erro de senha
      expect(find.text('Digite sua senha'), findsOneWidget);
    });

    testWidgets('should show social login buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Verificar se os botões sociais estão presentes
      expect(find.text('Continuar com Google'), findsOneWidget);
      expect(find.text('Continuar sem conta'), findsOneWidget);
      expect(find.text('Testar Conexão Firebase'), findsOneWidget);
    });

    testWidgets('should show loading state when authenticating', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Preencher formulário
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Mock do estado de loading
      when(mockAuthRepository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async {
        // Simular delay para mostrar loading
        await Future.delayed(const Duration(seconds: 1));
        return null;
      });

      // Submeter formulário
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Verificar se está em loading (botão desabilitado)
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('should show error message on authentication failure', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Mock do erro de autenticação
      when(mockAuthRepository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'wrongpassword',
      )).thenThrow(Exception('Invalid credentials'));

      // Preencher formulário com credenciais inválidas
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'wrongpassword');

      // Submeter formulário
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verificar se aparece mensagem de erro
      expect(find.text('Erro: Exception: Invalid credentials'), findsOneWidget);
    });

    testWidgets('should show success message on authentication success', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Mock do sucesso de autenticação
      when(mockAuthRepository.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => UserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        displayName: 'Test User',
      ));

      // Preencher formulário
      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      await tester.enterText(find.byType(TextFormField).last, 'password123');

      // Submeter formulário
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verificar se aparece mensagem de sucesso
      expect(find.text('Login realizado com sucesso!'), findsOneWidget);
    });

    testWidgets('should show forgot password dialog', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Clicar em "Esqueci minha senha"
      await tester.tap(find.text('Esqueci minha senha'));
      await tester.pumpAndSettle();

      // Verificar se o dialog aparece
      expect(find.text('Recuperar Senha'), findsOneWidget);
      expect(find.text('Digite seu email para receber o link de recuperação:'), findsOneWidget);
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Enviar'), findsOneWidget);
    });
  });
}
