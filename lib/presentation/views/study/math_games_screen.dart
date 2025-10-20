import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/math_game.dart';
import '../../../domain/entities/user.dart';
import '../../../data/datasources/simple_database.dart';

class MathGamesScreen extends StatefulWidget {
  const MathGamesScreen({super.key});

  @override
  State<MathGamesScreen> createState() => _MathGamesScreenState();
}

class _MathGamesScreenState extends State<MathGamesScreen> {
  List<MathGame> _games = [];
  String _selectedDifficulty = 'all';
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final games = await SimpleDatabase.getMathGames();
    final user = await SimpleDatabase.getCurrentUser();

    setState(() {
      _games = games;
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogos de Matemática'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.study),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              // TODO: Navegar para conquistas
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header com estatísticas
          _buildHeader(),

          // Filtros de dificuldade
          _buildDifficultyFilter(),

          // Lista de jogos
          Expanded(
            child: _buildGamesList(),
          ),
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
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🧮 Jogos de Matemática',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aprenda matemática de forma divertida!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                        'Jogos', '${_games.length}', AppTheme.secondaryColor),
                    const SizedBox(width: 12),
                    _buildStatCard(
                        'XP', '${_currentUser?.xp ?? 0}', AppTheme.xpColor),
                    const SizedBox(width: 12),
                    _buildStatCard('Nível', '${_currentUser?.level ?? 1}',
                        AppTheme.levelColor),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.calculate,
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

  Widget _buildDifficultyFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filtrar por Dificuldade',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todos', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Fácil', 'easy'),
                const SizedBox(width: 8),
                _buildFilterChip('Médio', 'medium'),
                const SizedBox(width: 8),
                _buildFilterChip('Difícil', 'hard'),
                const SizedBox(width: 8),
                _buildFilterChip('Expert', 'expert'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedDifficulty == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDifficulty = value;
        });
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  Widget _buildGamesList() {
    final filteredGames = _selectedDifficulty == 'all'
        ? _games
        : _games.where((game) {
            switch (_selectedDifficulty) {
              case 'easy':
                return game.difficulty == DifficultyLevel.easy;
              case 'medium':
                return game.difficulty == DifficultyLevel.medium;
              case 'hard':
                return game.difficulty == DifficultyLevel.hard;
              case 'expert':
                return game.difficulty == DifficultyLevel.expert;
              default:
                return true;
            }
          }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredGames.length,
      itemBuilder: (context, index) {
        final game = filteredGames[index];
        return _buildGameCard(game);
      },
    );
  }

  Widget _buildGameCard(MathGame game) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: game.isUnlocked ? () => _startGame(game) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: game.isUnlocked ? AppTheme.surfaceLight : Colors.grey[300]!,
            border: Border.all(
              color: game.isUnlocked
                  ? AppTheme.primaryColor.withOpacity(0.2)
                  : Colors.grey[400]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Ícone do jogo
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: game.isUnlocked
                          ? AppTheme.primaryColor.withOpacity(0.1)
                          : Colors.grey[400],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        game.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Informações do jogo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: game.isUnlocked
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: game.isUnlocked
                                ? Colors.black54
                                : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildDifficultyChip(game.difficulty),
                            _buildTimeChip(game.timeLimit),
                            _buildXPChip(game.xpReward),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status do jogo
                  Column(
                    children: [
                      if (game.isCompleted)
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.secondaryColor,
                          size: 24,
                        )
                      else if (!game.isUnlocked)
                        const Icon(
                          Icons.lock,
                          color: Colors.grey,
                          size: 24,
                        )
                      else
                        const Icon(
                          Icons.play_arrow,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      const SizedBox(height: 4),
                      Text(
                        game.isCompleted
                            ? 'Concluído'
                            : game.isUnlocked
                                ? 'Jogar'
                                : 'Bloqueado',
                        style: TextStyle(
                          fontSize: 12,
                          color: game.isUnlocked
                              ? AppTheme.primaryColor
                              : Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(DifficultyLevel difficulty) {
    Color color;
    String label;

    switch (difficulty) {
      case DifficultyLevel.easy:
        color = AppTheme.secondaryColor;
        label = 'Fácil';
        break;
      case DifficultyLevel.medium:
        color = AppTheme.accentColor;
        label = 'Médio';
        break;
      case DifficultyLevel.hard:
        color = AppTheme.warningColor;
        label = 'Difícil';
        break;
      case DifficultyLevel.expert:
        color = AppTheme.errorColor;
        label = 'Expert';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTimeChip(int timeLimit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.timer,
            size: 12,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            '${timeLimit}s',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPChip(int xpReward) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.xpColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.xpColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 12,
            color: AppTheme.xpColor,
          ),
          const SizedBox(width: 4),
          Text(
            '+$xpReward XP',
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.xpColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _startGame(MathGame game) {
    if (game.id == 'addition_basics') {
      context.go(AppRoutes.additionExplanation);
    } else if (game.id == 'subtraction_basics') {
      context.go(AppRoutes.subtractionExplanation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${game.title} em breve!'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }
}
