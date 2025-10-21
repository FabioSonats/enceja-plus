import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../../domain/entities/math_game.dart';
import '../../../domain/entities/math_generic_game.dart';
import '../../../domain/entities/user.dart';
import '../../../data/datasources/simple_database.dart';
import '../../widgets/game_exercises/generic_game_widget.dart';

class MathGamesScreen extends StatefulWidget {
  const MathGamesScreen({super.key});

  @override
  State<MathGamesScreen> createState() => _MathGamesScreenState();
}

class _MathGamesScreenState extends State<MathGamesScreen> {
  List<MathGame> _games = [];
  List<MathGenericGame> _genericGames = [];
  String _selectedDifficulty = 'all';
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final games = await SimpleDatabase.getMathGames();
    final user = await SimpleDatabase.getCurrentUser();

    // Carregar jogos genéricos
    final genericGames = [
      MathGameBuilder.createAdditionGame(),
      MathGameBuilder.createSubtractionGame(),
      MathGameBuilder.createMultiplicationGame(),
      MathGameBuilder.createFractionsGame(),
    ];

    setState(() {
      _games = games;
      _genericGames = genericGames;
      _currentUser = user;
      _isLoading = false;
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.home),
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            )
          : Column(
              children: [
                // Header fixo
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header com estatísticas
                      _buildHeader(),

                      const SizedBox(height: 20),

                      // Botão para lições interativas
                      _buildInteractiveLessonsButton(),

                      const SizedBox(height: 20),

                      // Filtros de dificuldade
                      _buildDifficultyFilter(),
                    ],
                  ),
                ),

                // Lista de jogos rolável
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
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jogos de Matemática',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Aprenda matemática de forma divertida!',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textLight,
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

  Widget _buildInteractiveLessonsButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => context.go(AppRoutes.interactiveMathLessons),
        icon: const Icon(Icons.extension, size: 24),
        label: const Text(
          'Lições Interativas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
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
      itemCount: filteredGames.length + _genericGames.length,
      itemBuilder: (context, index) {
        if (index < filteredGames.length) {
          final game = filteredGames[index];
          return _buildGameCard(game);
        } else {
          final genericIndex = index - filteredGames.length;
          final genericGame = _genericGames[genericIndex];
          return _buildGenericGameCard(genericGame);
        }
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

  Widget _buildDifficultyChipWithColor(String label, Color color) {
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
          fontWeight: FontWeight.bold,
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

  Widget _buildGenericGameCard(MathGenericGame game) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: game.isUnlocked ? () => _startGenericGame(game) : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: game.isUnlocked ? AppTheme.surfaceLight : Colors.grey[300]!,
            border: Border.all(
              color: game.isUnlocked
                  ? AppTheme.secondaryColor.withOpacity(0.2)
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
                          ? AppTheme.secondaryColor.withOpacity(0.1)
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
                                ? AppTheme.textLight
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: game.isUnlocked
                                ? AppTheme.textLight
                                : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _buildDifficultyChipWithColor(
                                'Interativo', AppTheme.secondaryColor),
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
                          color: AppTheme.secondaryColor,
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
                              ? AppTheme.secondaryColor
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

  void _startGenericGame(MathGenericGame game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenericGameWidget(
          game: game,
          onGameComplete: (result) async {
            // Salvar resultado no banco de dados
            await SimpleDatabase.saveGameResult({
              'gameId': game.id,
              'score': result.correctAnswers,
              'totalQuestions': result.totalQuestions,
              'timeSpent': result.timeSpent,
              'xpEarned': result.xpEarned,
              'accuracy': result.accuracy,
            });

            // Atualizar XP do usuário
            if (_currentUser != null) {
              final newXp = _currentUser!.xp + result.xpEarned;
              final newLevel = _currentUser!.calculateLevel(newXp);
              _currentUser = _currentUser!.copyWith(
                xp: newXp,
                level: newLevel,
              );
              await SimpleDatabase.saveUser(_currentUser!);
            }

            // Mostrar resultado
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Parabéns! Você ganhou ${result.xpEarned} XP!'),
                backgroundColor: AppTheme.successColor,
              ),
            );

            // Voltar para a tela anterior
            Navigator.pop(context);

            // Recarregar dados
            _loadData();
          },
          onAnswerGiven: (questionId, answer, isCorrect) {
            // Salvar resposta individual (opcional)
            print('Resposta: $answer, Correta: $isCorrect');
          },
        ),
      ),
    );
  }
}
