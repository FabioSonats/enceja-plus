import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/views/onboarding/splash_screen.dart';
import '../../presentation/views/onboarding/onboarding_screen.dart';
import '../../presentation/views/auth/login_screen.dart';
import '../../presentation/views/home/home_screen.dart';
import '../../presentation/views/study/math_games_screen.dart';
import '../../presentation/views/study/games/math_generic_games_screen.dart';
import '../../presentation/views/study/interactive_math_lessons_screen.dart';
import '../../presentation/views/study/portuguese_screen.dart';
import '../../presentation/views/study/history_screen.dart';
import '../../presentation/views/study/science_screen.dart';
import '../../presentation/views/study/geography_screen.dart';
import '../../presentation/views/study/games/grammar_basics_game_screen.dart';
import '../../presentation/views/library/library_screen.dart';
import '../../presentation/views/enrollment/enrollment_screen.dart';
import '../../presentation/views/study/lesson_explanation_screen.dart';
import '../../presentation/views/study/games/visual_addition_game_screen.dart';
import '../../presentation/views/study/games/visual_subtraction_game_screen.dart';
import '../../presentation/views/profile/profile_screen.dart';
import '../../domain/entities/math_game.dart';
import '../../core/theme/app_theme.dart';
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

      // Study routes (removed - using direct navigation from home)
      GoRoute(
        path: AppRoutes.mathGames,
        builder: (context, state) => const MathGamesScreen(),
      ),
      GoRoute(
        path: AppRoutes.mathGenericGames,
        builder: (context, state) => const MathGenericGamesScreen(),
      ),
      GoRoute(
        path: AppRoutes.interactiveMathLessons,
        builder: (context, state) => const InteractiveMathLessonsScreen(),
      ),
      GoRoute(
        path: AppRoutes.portuguese,
        builder: (context, state) => const PortugueseScreen(),
      ),
      GoRoute(
        path: AppRoutes.portugueseGames,
        builder: (context, state) => const PortugueseScreen(),
      ),
      GoRoute(
        path: AppRoutes.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.historyGames,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: AppRoutes.science,
        builder: (context, state) => const ScienceScreen(),
      ),
      GoRoute(
        path: AppRoutes.scienceGames,
        builder: (context, state) => const ScienceScreen(),
      ),
      GoRoute(
        path: AppRoutes.geography,
        builder: (context, state) => const GeographyScreen(),
      ),
      GoRoute(
        path: AppRoutes.geographyGames,
        builder: (context, state) => const GeographyScreen(),
      ),
      GoRoute(
        path: AppRoutes.essayGames,
        builder: (context, state) => const PortugueseScreen(),
      ),
      GoRoute(
        path: AppRoutes.grammarBasicsExplanation,
        builder: (context, state) {
          return LessonExplanationScreen(
            lessonId: 'grammar_basics',
            lessonTitle: 'Gramática Básica',
            lessonDescription: 'Aprenda os fundamentos da gramática portuguesa',
            nextRoute: AppRoutes.grammarBasics,
            lessonData: {
              'icon': Icons.menu_book,
              'explanations': [
                'A gramática é o conjunto de regras que organizam uma língua.',
                'Ela nos ajuda a falar e escrever corretamente em português.',
                'Você vai aprender sobre substantivos, verbos, adjetivos e muito mais!',
                'Cada conceito será explicado de forma simples e prática.',
                'Lembre-se: a gramática é a base para uma boa comunicação.',
              ],
              'objectives': [
                'Compreender o que é gramática',
                'Identificar substantivos, verbos e adjetivos',
                'Aplicar regras básicas de concordância',
                'Melhorar a comunicação escrita e falada',
              ],
              'tips': [
                'Leia bastante para ver a gramática em ação',
                'Pratique escrevendo pequenos textos',
                'Preste atenção na fala das pessoas ao seu redor',
                'Não tenha medo de errar - é assim que aprendemos!',
              ],
              'examples': [
                {
                  'title': 'Exemplo 1: Substantivo',
                  'description':
                      'Palavra que nomeia pessoas, lugares, coisas ou ideias.',
                  'solution': 'Exemplos: casa, gato, amor, Brasil',
                },
                {
                  'title': 'Exemplo 2: Verbo',
                  'description': 'Palavra que indica ação, estado ou fenômeno.',
                  'solution': 'Exemplos: correr, ser, chover, estudar',
                },
                {
                  'title': 'Exemplo 3: Adjetivo',
                  'description':
                      'Palavra que caracteriza ou qualifica o substantivo.',
                  'solution': 'Exemplos: bonito, grande, inteligente, feliz',
                },
              ],
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.grammarBasics,
        builder: (context, state) => const GrammarBasicsGameScreen(),
      ),
      GoRoute(
        path: AppRoutes.additionExplanation,
        builder: (context, state) {
          return LessonExplanationScreen(
            lessonId: 'addition_basics',
            lessonTitle: 'Soma Básica',
            lessonDescription: 'Aprenda a somar números de 1 a 20',
            nextRoute: AppRoutes.additionGame,
            lessonData: {
              'icon': Icons.add,
              'explanations': [
                'A soma é uma das quatro operações básicas da matemática.',
                'Ela representa a ideia de "juntar" ou "adicionar" quantidades.',
                'Quando somamos, estamos combinando dois ou mais números para obter um total.',
                'Por exemplo: se você tem 3 maçãs e ganha mais 2, você terá 3 + 2 = 5 maçãs.',
                'A soma é comutativa, ou seja, 3 + 2 = 2 + 3 = 5.',
              ],
              'objectives': [
                'Compreender o conceito de adição',
                'Identificar números de 1 a 20',
                'Realizar somas simples mentalmente',
                'Aplicar a soma em situações do dia a dia',
              ],
              'tips': [
                'Use objetos reais (dedos, lápis) para visualizar a soma',
                'Pratique contando de 1 em 1',
                'Lembre-se: soma é "juntar" quantidades',
                'Se errar, não desista! A prática leva à perfeição',
              ],
              'examples': [
                {
                  'title': 'Exemplo 1: Contando objetos',
                  'description':
                      'Se você tem 4 brinquedos e ganha mais 3, quantos terá?',
                  'solution': '4 + 3 = 7 brinquedos',
                },
                {
                  'title': 'Exemplo 2: Dinheiro',
                  'description':
                      'Você tem R\$ 5,00 e ganha mais R\$ 2,00. Quanto terá?',
                  'solution': 'R\$ 5,00 + R\$ 2,00 = R\$ 7,00',
                },
                {
                  'title': 'Exemplo 3: Idade',
                  'description':
                      'João tem 8 anos. Em 3 anos, quantos anos terá?',
                  'solution': '8 + 3 = 11 anos',
                },
              ],
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.additionGame,
        builder: (context, state) {
          // Get the addition game from predefined games
          final additionGame = PredefinedMathGames.games.firstWhere(
            (game) => game.id == 'addition_basics',
          );
          return VisualAdditionGameScreen(game: additionGame);
        },
      ),
      GoRoute(
        path: AppRoutes.subtractionExplanation,
        builder: (context, state) {
          return LessonExplanationScreen(
            lessonId: 'subtraction_basics',
            lessonTitle: 'Subtração Básica',
            lessonDescription: 'Aprenda a subtrair números de 1 a 20',
            nextRoute: AppRoutes.subtractionGame,
            lessonData: {
              'icon': Icons.remove,
              'explanations': [
                'A subtração é uma das quatro operações básicas da matemática.',
                'Ela representa a ideia de "retirar" ou "diminuir" quantidades.',
                'Quando subtraímos, estamos "tirando" uma quantidade de outra.',
                'Por exemplo: se você tem 8 balas e come 3, restarão 8 - 3 = 5 balas.',
                'A subtração NÃO é comutativa, ou seja, 8 - 3 ≠ 3 - 8.',
              ],
              'objectives': [
                'Compreender o conceito de subtração',
                'Identificar números de 1 a 20',
                'Realizar subtrações simples mentalmente',
                'Aplicar a subtração em situações do dia a dia',
              ],
              'tips': [
                'Use objetos reais para visualizar a subtração',
                'Pense em "quanto sobra" ou "quanto falta"',
                'Lembre-se: subtração é "tirar" quantidades',
                'Se errar, não desista! A prática leva à perfeição',
              ],
              'examples': [
                {
                  'title': 'Exemplo 1: Comendo doces',
                  'description': 'Você tem 10 doces e come 4. Quantos sobram?',
                  'solution': '10 - 4 = 6 doces',
                },
                {
                  'title': 'Exemplo 2: Dinheiro gasto',
                  'description':
                      'Você tinha R\$ 15,00 e gastou R\$ 7,00. Quanto sobrou?',
                  'solution': 'R\$ 15,00 - R\$ 7,00 = R\$ 8,00',
                },
                {
                  'title': 'Exemplo 3: Idade',
                  'description':
                      'Maria tem 12 anos. Há 5 anos, quantos anos tinha?',
                  'solution': '12 - 5 = 7 anos',
                },
              ],
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.subtractionGame,
        builder: (context, state) {
          // Get the subtraction game from predefined games
          final subtractionGame = PredefinedMathGames.games.firstWhere(
            (game) => game.id == 'subtraction_basics',
          );
          return VisualSubtractionGameScreen(game: subtractionGame);
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
        path: AppRoutes.library,
        builder: (context, state) => const LibraryScreen(),
      ),
      GoRoute(
        path: AppRoutes.enrollment,
        builder: (context, state) => const EnrollmentScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
        ),
      ),
      body: SingleChildScrollView(
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
              () => context.go(AppRoutes.portuguese),
            ),

            const SizedBox(height: 16),

            // História
            _buildSubjectCard(
              context,
              'História',
              '🏛️',
              'História do Brasil e do mundo',
              AppTheme.accentColor,
              () => context.go(AppRoutes.history),
            ),

            const SizedBox(height: 16),

            // Ciências
            _buildSubjectCard(
              context,
              'Ciências',
              '🔬',
              'Ciências da natureza e biologia',
              AppTheme.secondaryColor,
              () => context.go(AppRoutes.science),
            ),

            const SizedBox(height: 16),

            // Geografia
            _buildSubjectCard(
              context,
              'Geografia',
              '🌍',
              'Geografia física e humana',
              AppTheme.xpColor,
              () => context.go(AppRoutes.geography),
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
            color: AppTheme.surfaceLight,
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
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
