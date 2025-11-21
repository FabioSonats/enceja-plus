import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../blocs/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, double> _progressData = {};

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Início',
      route: AppRoutes.home,
    ),
    NavigationItem(
      icon: Icons.library_books,
      label: 'Biblioteca',
      route: AppRoutes.library,
    ),
    NavigationItem(
      icon: Icons.person,
      label: 'Perfil',
      route: AppRoutes.profile,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadProgressData();
    _updateSelectedIndexFromRoute();
  }

  void _updateSelectedIndexFromRoute() {
    // Sincronizar índice do bottom bar com a rota atual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final router = GoRouter.of(context);
      final currentPath = router.routerDelegate.currentConfiguration.uri.path;
      
      if (currentPath == AppRoutes.home || currentPath == '/') {
        if (_selectedIndex != 0) {
          setState(() => _selectedIndex = 0);
        }
      } else if (currentPath == AppRoutes.library) {
        if (_selectedIndex != 1) {
          setState(() => _selectedIndex = 1);
        }
      } else if (currentPath == AppRoutes.profile) {
        if (_selectedIndex != 2) {
          setState(() => _selectedIndex = 2);
        }
      }
    });
  }

  Future<void> _loadProgressData() async {
    // Simular carregamento do Firebase
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _progressData = {
        'matematica': 0.75,
        'portugues': 0.60,
        'ciencias': 0.30,
        'historia': 0.45,
        'geografia': 0.20,
        'redacao': 0.10,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ENCCEJA+'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          _buildStudyContent(),
          _buildQuizContent(),
          _buildCalendarContent(),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 ? _buildEnrollmentFAB() : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceLight,
          border: Border(
            top: BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: AppTheme.surfaceLight,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            
            // Navegar para a rota correspondente
            final router = GoRouter.of(context);
            final currentPath = router.routerDelegate.currentConfiguration.uri.path;
            
            switch (index) {
              case 0:
                // Home
                if (currentPath != AppRoutes.home && currentPath != '/') {
                  router.go(AppRoutes.home);
                }
                break;
              case 1:
                // Biblioteca
                if (currentPath != AppRoutes.library) {
                  router.go(AppRoutes.library);
                }
                break;
              case 2:
                // Perfil
                if (currentPath != AppRoutes.profile) {
                  router.go(AppRoutes.profile);
                }
                break;
            }
          },
          selectedItemColor: AppTheme.primaryColor, // Azul para item selecionado
          unselectedItemColor: AppTheme.textSecondaryLight, // Cinza para item não selecionado
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: _navigationItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.backgroundLight, AppTheme.surfaceLight],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header simples
            _buildSimpleHeader(),
            const SizedBox(height: 32),

            // Matérias principais
            _buildSubjectsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, Estudante! 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textLight,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Escolha uma matéria para estudar',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.school,
            size: 60,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final maxWidth = isDesktop ? 800.0 : double.infinity;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Matérias',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textLight,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final subjects = [
                        {
                          'title': 'Matemática',
                          'icon': '🧮',
                          'color': AppTheme.primaryColor,
                          'route': AppRoutes.mathGames
                        },
                        {
                          'title': 'Português',
                          'icon': '📚',
                          'color': AppTheme.secondaryColor,
                          'route': AppRoutes.portuguese
                        },
                        {
                          'title': 'História',
                          'icon': '🏛️',
                          'color': AppTheme.accentColor,
                          'route': AppRoutes.history
                        },
                        {
                          'title': 'Ciências',
                          'icon': '🔬',
                          'color': AppTheme.infoColor,
                          'route': AppRoutes.science
                        },
                        {
                          'title': 'Geografia',
                          'icon': '🌍',
                          'color': AppTheme.xpColor,
                          'route': AppRoutes.geography
                        },
                        {
                          'title': 'Biblioteca',
                          'icon': '📖',
                          'color': AppTheme.levelColor,
                          'route': AppRoutes.library
                        },
                      ];

                      final subject = subjects[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildSubjectCard(
                          subject['title'] as String,
                          subject['icon'] as String,
                          subject['color'] as Color,
                          () => context.go(subject['route'] as String),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSubjectCard(
      String title, String icon, Color color, VoidCallback onTap) {
    final progress =
        _progressData[title.toLowerCase().replaceAll('ç', 'c')] ?? 0.0;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 130, // Aumentei a altura
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white, // Fundo branco para máximo contraste
            border: Border.all(
              color: color,
              width: 3, // Borda mais grossa
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Ícone
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 32), // Reduzi um pouco
                  ),
                ),
              ),
              // Conteúdo
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20, // Reduzi um pouco
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Preto para máximo contraste
                      ),
                    ),
                    const SizedBox(height: 6), // Reduzi o espaçamento
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progresso',
                          style: TextStyle(
                            fontSize: 14, // Reduzi um pouco
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6, // Reduzi o padding
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: color, width: 1),
                          ),
                          child: Text(
                            '${(progress * 100).round()}%',
                            style: TextStyle(
                              fontSize: 14, // Reduzi um pouco
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4), // Reduzi o espaçamento
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[300], // Fundo claro
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 6, // Reduzi um pouco
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 600;
        final maxWidth = isDesktop ? 800.0 : double.infinity;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: EdgeInsets.all(isDesktop ? 24 : 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.primaryColor.withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá, Estudante! 👋',
                          style: TextStyle(
                            fontSize: isDesktop ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pronto para mais uma jornada de aprendizado?',
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildStatCard('Nível', '5', AppTheme.levelColor),
                            const SizedBox(width: 12),
                            _buildStatCard('XP', '1,250', AppTheme.xpColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.emoji_events,
                    size: isDesktop ? 70 : 60,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seu Progresso',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                      'Matemática', 0.7, AppTheme.primaryColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProgressItem(
                      'Português', 0.5, AppTheme.secondaryColor),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child:
                      _buildProgressItem('História', 0.3, AppTheme.accentColor),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProgressItem('Geografia', 0.6, AppTheme.xpColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String subject, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subject,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
        const SizedBox(height: 4),
        Text(
          '${(progress * 100).toInt()}%',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ações Rápidas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Continuar Estudo',
                Icons.play_arrow,
                AppTheme.primaryColor,
                () => context.go(AppRoutes.home),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Fazer Simulado',
                Icons.quiz,
                AppTheme.secondaryColor,
                () => context.go(AppRoutes.simulated),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Ver Agenda',
                Icons.calendar_today,
                AppTheme.accentColor,
                () => context.go(AppRoutes.calendar),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Meu Perfil',
                Icons.person,
                AppTheme.xpColor,
                () => context.go(AppRoutes.profile),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Atividades Recentes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildActivityItem(
                'Completou lição de Matemática',
                'Há 2 horas',
                Icons.check_circle,
                AppTheme.secondaryColor,
              ),
              _buildActivityItem(
                'Ganhou 50 XP',
                'Há 3 horas',
                Icons.star,
                AppTheme.xpColor,
              ),
              _buildActivityItem(
                'Desbloqueou conquista "Primeiro Passo"',
                'Ontem',
                Icons.emoji_events,
                AppTheme.achievementColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
      String title, String time, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(time),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair da Conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                Navigator.pop(context);
                context.go(AppRoutes.login);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
            builder: (context, state) {
              return TextButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        context.read<AuthBloc>().add(AuthSignOutRequested());
                      },
                child: state is AuthLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sair'),
              );
            },
          ),
        ],
      ),
    );
  }

  // Placeholder content for other tabs
  Widget _buildStudyContent() {
    return const Center(
      child: Text('Tela de Estudos - Em desenvolvimento'),
    );
  }

  Widget _buildQuizContent() {
    return const Center(
      child: Text('Tela de Simulados - Em desenvolvimento'),
    );
  }

  Widget _buildCalendarContent() {
    return const Center(
      child: Text('Tela de Agenda - Em desenvolvimento'),
    );
  }

  Widget _buildEnrollmentFAB() {
    return Container(
      width: 180,
      height: 56,
      child: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.enrollment),
        backgroundColor: AppTheme.accentColor,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        icon: const Icon(Icons.school, size: 20),
        label: const Text(
          'Inscrição ENCCEJA',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

