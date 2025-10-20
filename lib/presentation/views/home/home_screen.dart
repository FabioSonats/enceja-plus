import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.home,
      label: 'Início',
      route: AppRoutes.home,
    ),
    NavigationItem(
      icon: Icons.school,
      label: 'Estudos',
      route: AppRoutes.study,
    ),
    NavigationItem(
      icon: Icons.quiz,
      label: 'Simulados',
      route: AppRoutes.simulated,
    ),
    NavigationItem(
      icon: Icons.calendar_today,
      label: 'Agenda',
      route: AppRoutes.calendar,
    ),
    NavigationItem(
      icon: Icons.person,
      label: 'Perfil',
      route: AppRoutes.profile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          _buildStudyContent(),
          _buildQuizContent(),
          _buildCalendarContent(),
          _buildProfileContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: _navigationItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header com saudação
          _buildHeader(),
          const SizedBox(height: 24),

          // Progress card
          _buildProgressCard(),
          const SizedBox(height: 24),

          // Quick actions
          _buildQuickActions(),
          const SizedBox(height: 24),

          // Recent activities
          _buildRecentActivities(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
                const Text(
                  'Olá, Estudante! 👋',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pronto para mais uma jornada de aprendizado?',
                  style: TextStyle(
                    fontSize: 16,
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
          const Icon(
            Icons.emoji_events,
            size: 60,
            color: Colors.white,
          ),
        ],
      ),
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
                () => context.go(AppRoutes.study),
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

  Widget _buildProfileContent() {
    return const Center(
      child: Text('Tela de Perfil - Em desenvolvimento'),
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
