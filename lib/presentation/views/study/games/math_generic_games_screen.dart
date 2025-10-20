import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../domain/entities/math_generic_game.dart';
import '../../../widgets/game_exercises/generic_game_widget.dart';

class MathGenericGamesScreen extends StatefulWidget {
  const MathGenericGamesScreen({super.key});

  @override
  State<MathGenericGamesScreen> createState() => _MathGenericGamesScreenState();
}

class _MathGenericGamesScreenState extends State<MathGenericGamesScreen> {
  List<MathGenericGame> _games = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  void _loadGames() {
    setState(() {
      _games = [
        MathGameBuilder.createAdditionGame(),
        MathGameBuilder.createSubtractionGame(),
        MathGameBuilder.createMultiplicationGame(),
        MathGameBuilder.createFractionsGame(),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matemática Interativa'),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
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
                _buildHeader(),
                _buildGamesList(),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '🧮',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Matemática Interativa',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Aprenda matemática com exercícios variados e interativos',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textLight.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('Jogos', '${_games.length}', Icons.games),
              const SizedBox(width: 16),
              _buildStatCard('XP', '0', Icons.star),
              const SizedBox(width: 16),
              _buildStatCard('Nível', '1', Icons.trending_up),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return _buildGameCard(context, game);
        },
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, MathGenericGame game) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                            _buildDifficultyChip('Fácil'),
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

  Widget _buildDifficultyChip(String difficulty) {
    Color color;
    switch (difficulty) {
      case 'Fácil':
        color = AppTheme.successColor;
        break;
      case 'Médio':
        color = AppTheme.warningColor;
        break;
      case 'Difícil':
        color = AppTheme.errorColor;
        break;
      default:
        color = AppTheme.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        difficulty,
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
        color: AppTheme.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.infoColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: AppTheme.infoColor, size: 12),
          const SizedBox(width: 4),
          Text(
            '${timeLimit}s',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.infoColor,
              fontWeight: FontWeight.bold,
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
        border: Border.all(color: AppTheme.xpColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: AppTheme.xpColor, size: 12),
          const SizedBox(width: 4),
          Text(
            '+$xpReward XP',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.xpColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _startGame(MathGenericGame game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenericGameWidget(
          game: game,
          onGameComplete: (result) {
            // TODO: Salvar resultado e atualizar progresso
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Parabéns! Você ganhou ${result.xpEarned} XP!'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            Navigator.pop(context);
          },
          onAnswerGiven: (questionId, answer, isCorrect) {
            // TODO: Salvar resposta individual
          },
        ),
      ),
    );
  }
}
