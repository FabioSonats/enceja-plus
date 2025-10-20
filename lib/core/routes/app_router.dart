import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/views/onboarding/splash_screen.dart';
import '../../presentation/views/onboarding/onboarding_screen.dart';
import '../../presentation/views/auth/login_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Authentication
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Home
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // Placeholder routes for other screens
      GoRoute(
        path: AppRoutes.study,
        builder: (context, state) => const _PlaceholderScreen(title: 'Estudos'),
      ),
      GoRoute(
        path: AppRoutes.quiz,
        builder: (context, state) => const _PlaceholderScreen(title: 'Quiz'),
      ),
      GoRoute(
        path: AppRoutes.simulated,
        builder: (context, state) =>
            const _PlaceholderScreen(title: 'Simulados'),
      ),
      GoRoute(
        path: AppRoutes.calendar,
        builder: (context, state) => const _PlaceholderScreen(title: 'Agenda'),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const _PlaceholderScreen(title: 'Perfil'),
      ),
    ],
  );

  static GoRouter get router => _router;
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              '$title - Em Desenvolvimento',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Esta funcionalidade será implementada em breve!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Voltar ao Início'),
            ),
          ],
        ),
      ),
    );
  }
}
