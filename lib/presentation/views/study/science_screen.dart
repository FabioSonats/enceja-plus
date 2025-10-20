import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';

class ScienceScreen extends StatefulWidget {
  const ScienceScreen({super.key});

  @override
  State<ScienceScreen> createState() => _ScienceScreenState();
}

class _ScienceScreenState extends State<ScienceScreen> {
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Simular carregamento de dados
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _exercises = [
        {
          'id': 'human_body',
          'title': 'Corpo Humano',
          'description': 'Aprenda sobre os sistemas do corpo humano',
          'icon': '🧬',
          'difficulty': 'Fácil',
          'timeLimit': '20 min',
          'xpReward': 50,
          'isLocked': false,
        },
        {
          'id': 'ecosystem',
          'title': 'Ecossistemas',
          'description': 'Entenda como funcionam os ecossistemas',
          'icon': '🌱',
          'difficulty': 'Médio',
          'timeLimit': '25 min',
          'xpReward': 75,
          'isLocked': false,
        },
        {
          'id': 'solar_system',
          'title': 'Sistema Solar',
          'description': 'Explore o sistema solar e o universo',
          'icon': '🌍',
          'difficulty': 'Médio',
          'timeLimit': '30 min',
          'xpReward': 75,
          'isLocked': false,
        },
        {
          'id': 'chemistry_basics',
          'title': 'Química Básica',
          'description': 'Aprenda os fundamentos da química',
          'icon': '⚗️',
          'difficulty': 'Difícil',
          'timeLimit': '35 min',
          'xpReward': 100,
          'isLocked': true,
        },
        {
          'id': 'physics_basics',
          'title': 'Física Básica',
          'description': 'Entenda os conceitos básicos da física',
          'icon': '⚡',
          'difficulty': 'Difícil',
          'timeLimit': '40 min',
          'xpReward': 100,
          'isLocked': true,
        },
        {
          'id': 'environmental_science',
          'title': 'Ciências Ambientais',
          'description': 'Estude a preservação do meio ambiente',
          'icon': '🌿',
          'difficulty': 'Médio',
          'timeLimit': '25 min',
          'xpReward': 75,
          'isLocked': true,
        },
        {
          'id': 'health_science',
          'title': 'Ciências da Saúde',
          'description': 'Aprenda sobre saúde e bem-estar',
          'icon': '🏥',
          'difficulty': 'Médio',
          'timeLimit': '30 min',
          'xpReward': 75,
          'isLocked': true,
        },
        {
          'id': 'technology_science',
          'title': 'Ciência e Tecnologia',
          'description': 'Conheça a relação entre ciência e tecnologia',
          'icon': '🔬',
          'difficulty': 'Difícil',
          'timeLimit': '35 min',
          'xpReward': 100,
          'isLocked': true,
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      appBar: AppBar(
        title: const Text('Ciências'),
        centerTitle: true,
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.study),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.secondaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header com estatísticas
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.secondaryColor.withOpacity(0.2),
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
                                'Ciências da Natureza',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.secondaryColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Explore o mundo da ciência e da natureza',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textLight,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildStatCard('Exercícios', '8'),
                                  const SizedBox(width: 16),
                                  _buildStatCard('XP Total', '600'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: const Center(
                            child: Text(
                              '🔬',
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Lista de exercícios
                  const Text(
                    'Exercícios de Ciências:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.builder(
                      itemCount: _exercises.length,
                      itemBuilder: (context, index) {
                        final exercise = _exercises[index];
                        return _buildExerciseCard(context, exercise);
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.secondaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.secondaryColor,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
      BuildContext context, Map<String, dynamic> exercise) {
    final isLocked = exercise['isLocked'] as bool;
    final iconColor = isLocked ? Colors.grey : AppTheme.secondaryColor;
    final textColor = isLocked ? Colors.grey[600] : AppTheme.textLight;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _startExercise(exercise),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.surfaceLight,
            border: Border.all(
              color: AppTheme.secondaryColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    exercise['icon'],
                    style: TextStyle(fontSize: 24, color: iconColor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      exercise['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildDifficultyChip(exercise['difficulty']),
                        _buildTimeChip(exercise['timeLimit']),
                        _buildXPChip(exercise['xpReward']),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (isLocked)
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
                    isLocked ? 'Bloqueado' : 'Jogar',
                    style: TextStyle(
                      fontSize: 12,
                      color: isLocked ? Colors.grey : AppTheme.secondaryColor,
                      fontWeight: FontWeight.w500,
                    ),
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
        color = AppTheme.secondaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.infoColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.infoColor.withOpacity(0.3)),
      ),
      child: Text(
        time,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.infoColor,
        ),
      ),
    );
  }

  Widget _buildXPChip(int xp) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.xpColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.xpColor.withOpacity(0.3)),
      ),
      child: Text(
        '+$xp XP',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppTheme.xpColor,
        ),
      ),
    );
  }

  void _startExercise(Map<String, dynamic> exercise) {
    if (exercise['isLocked']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${exercise['title']} está bloqueado. Complete os exercícios anteriores!'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    // Navegar para o exercício específico
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${exercise['title']} em breve!'),
        backgroundColor: AppTheme.secondaryColor,
      ),
    );
  }
}
