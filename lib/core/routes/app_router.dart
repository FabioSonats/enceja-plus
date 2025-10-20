import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/views/onboarding/splash_screen.dart';
import '../../presentation/views/onboarding/onboarding_screen.dart';
import '../../presentation/views/auth/login_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/study/math_games_screen.dart';
import '../../presentation/views/study/games/addition_game_screen.dart';
import '../../domain/entities/math_game.dart';
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

      // Study routes
      GoRoute(
        path: AppRoutes.study,
        builder: (context, state) => const _StudyScreen(),
      ),
      GoRoute(
        path: AppRoutes.mathGames,
        builder: (context, state) => const MathGamesScreen(),
      ),
      GoRoute(
        path: AppRoutes.additionGame,
        builder: (context, state) {
          // Get the addition game from predefined games
          final additionGame = PredefinedMathGames.games.firstWhere(
            (game) => game.id == 'addition_basics',
          );
          return AdditionGameScreen(game: additionGame);
        },
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

class _StudyScreen extends StatelessWidget {
  const _StudyScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudos'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Escolha uma matéria para estudar:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            
            // Matemática
            _buildSubjectCard(
              context,
              'Matemática',
              '🧮',
              'Jogos e exercícios de matemática',
              AppTheme.primaryColor,
              () => context.go(AppRoutes.mathGames),
            ),
            
            const SizedBox(height: 16),
            
            // Português
            _buildSubjectCard(
              context,
              'Português',
              '📚',
              'Gramática e interpretação de texto',
              AppTheme.secondaryColor,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Em breve!')),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // História
            _buildSubjectCard(
              context,
              'História',
              '🏛️',
              'História do Brasil e do mundo',
              AppTheme.accentColor,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Em breve!')),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Geografia
            _buildSubjectCard(
              context,
              'Geografia',
              '🌍',
              'Geografia física e humana',
              AppTheme.xpColor,
              () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Em breve!')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    String title,
    String icon,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.white,
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
