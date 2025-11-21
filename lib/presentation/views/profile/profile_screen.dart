import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/routes/app_routes.dart';
import '../../widgets/mascot/app_mascot.dart';
import '../../widgets/mascot/mascot_helper.dart';
import '../../blocs/auth_bloc.dart';
import '../../../data/services/profile_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/repositories/auth_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final StorageService _storageService = StorageService();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoading = true;

  // Dados do usuário
  String _userName = 'Carregando...';
  String _userEmail = '';
  String? _userPhotoURL;
  String? _userPhone;

  // Dados de progresso
  Map<String, double> _subjectProgress = {
    'matematica': 0.0,
    'portugues': 0.0,
    'historia': 0.0,
    'ciencias': 0.0,
  };

  double _overallProgress = 0.0;
  int _totalStudyTime = 0;
  int _streakDays = 0;
  int _completedLessons = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _isLoading = true);

    try {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;

      if (authState is AuthAuthenticated) {
        final uid = authState.user.uid;
        final email = authState.user.email ?? '';
        final displayName = authState.user.displayName;
        final photoURL = authState.user.photoURL;

        // Carregar dados do Firestore
        final profileData = await _profileService.getUserProfile(uid);
        final progressData = await _profileService.getUserProgress(uid);

        setState(() {
          _userEmail = email;
          _userName = displayName ?? email.split('@').first;
          _userPhotoURL = photoURL;

          // Carregar dados do Firestore (telefone, etc)
          if (profileData != null) {
            _userName = profileData['displayName'] ?? _userName;
            _userPhotoURL = profileData['photoURL'] ?? photoURL;
            _userPhone = profileData['phone'];
          }

          // Se não tem perfil criado, criar um inicial
          if (profileData == null && uid.isNotEmpty) {
            _profileService.createInitialProfile(
              uid: uid,
              email: email,
              displayName: displayName,
            );
          }

          // Carregar progresso
          if (progressData != null) {
            final subjectProgress = progressData['subjectProgress'] as Map?;
            if (subjectProgress != null) {
              _subjectProgress = Map<String, double>.from(
                subjectProgress.map(
                  (key, value) =>
                      MapEntry(key.toString(), (value as num).toDouble()),
                ),
              );
            }

            _overallProgress =
                (progressData['overallProgress'] as num?)?.toDouble() ?? 0.0;
            _totalStudyTime = (progressData['totalStudyTime'] as int?) ?? 0;
            _streakDays = (progressData['streakDays'] as int?) ?? 0;
            _completedLessons = (progressData['completedLessons'] as int?) ?? 0;
          }

          _isLoading = false;
        });
      } else {
        // Se não está autenticado, redirecionar para login
        if (mounted) {
          context.go(AppRoutes.login);
        }
      }
    } catch (e) {
      print('Erro ao carregar perfil: $e');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundLight,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: _loadProfileData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 24),
                      _buildOverallProgress(),
                      const SizedBox(height: 24),
                      _buildSubjectProgress(),
                      const SizedBox(height: 24),
                      _buildStudyStats(),
                      const SizedBox(height: 24),
                      _buildAchievements(),
                      const SizedBox(height: 24),
                      _buildSettingsMenu(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _userName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _showEditProfileDialog(),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _userEmail,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (_userPhone != null && _userPhone!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        _userPhone!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => _showPhotoOptions(),
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: _userPhotoURL != null && _userPhotoURL!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(38),
                              child: Image.network(
                                _userPhotoURL!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      _userName.isNotEmpty
                                          ? _userName[0].toUpperCase()
                                          : '👨‍🎓',
                                      style: const TextStyle(fontSize: 40),
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Text(
                                _userName.isNotEmpty
                                    ? _userName[0].toUpperCase()
                                    : '👨‍🎓',
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progresso Geral',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${(_overallProgress * 100).round()}% Concluído',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Continue estudando para completar o curso',
                      style: TextStyle(
                        color: Colors.grey[300],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: _overallProgress,
                      backgroundColor: Colors.grey[600],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryColor,
                      ),
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${(_overallProgress * 100).round()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectProgress() {
    final subjects = [
      {
        'name': 'Matemática',
        'key': 'matematica',
        'icon': '🧮',
        'color': AppTheme.primaryColor,
        'route': AppRoutes.mathGames
      },
      {
        'name': 'Português',
        'key': 'portugues',
        'icon': '📚',
        'color': AppTheme.secondaryColor,
        'route': AppRoutes.portuguese
      },
      {
        'name': 'História',
        'key': 'historia',
        'icon': '🏛️',
        'color': AppTheme.accentColor,
        'route': AppRoutes.history
      },
      {
        'name': 'Ciências',
        'key': 'ciencias',
        'icon': '🔬',
        'color': AppTheme.infoColor,
        'route': AppRoutes.science
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progresso por Matéria',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ...subjects.map((subject) {
            final progress = _subjectProgress[subject['key'] as String] ?? 0.0;
            final subjectColor = subject['color'] as Color;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                onTap: () => context.go(subject['route'] as String),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: subjectColor.withOpacity(0.4),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: subjectColor.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: subjectColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: subjectColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            subject['icon'] as String,
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
                              subject['name'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Progresso',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[600],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(subjectColor),
                              minHeight: 10,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: subjectColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: subjectColor,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          '${(progress * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: subjectColor.withOpacity(0.8),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStudyStats() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estatísticas de Estudo',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Tempo Total',
                  '$_totalStudyTime h',
                  Icons.access_time,
                  AppTheme.xpColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Sequência',
                  '$_streakDays dias',
                  Icons.local_fire_department,
                  AppTheme.achievementColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Aulas',
                  '$_completedLessons',
                  Icons.school,
                  AppTheme.levelColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 28,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {
        'title': 'Primeira Aula',
        'icon': '🎓',
        'color': AppTheme.primaryColor,
        'earned': _completedLessons > 0
      },
      {
        'title': 'Simulado Finalizado',
        'icon': '🏆',
        'color': AppTheme.achievementColor,
        'earned': _completedLessons >= 5
      },
      {
        'title': 'Nota Máxima',
        'icon': '⭐',
        'color': AppTheme.xpColor,
        'earned': _overallProgress >= 0.8
      },
      {
        'title': '7 Dias Seguidos',
        'icon': '🔥',
        'color': AppTheme.accentColor,
        'earned': _streakDays >= 7
      },
      {
        'title': 'Matemática Completa',
        'icon': '🧮',
        'color': AppTheme.primaryColor,
        'earned': _subjectProgress['matematica']! >= 1.0
      },
      {
        'title': 'Estudante Dedicado',
        'icon': '📚',
        'color': AppTheme.secondaryColor,
        'earned': _totalStudyTime >= 100
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Conquistas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: achievements.length,
            itemBuilder: (context, index) {
              final achievement = achievements[index];
              final isEarned = achievement['earned'] as bool;

              return Container(
                decoration: BoxDecoration(
                  color: isEarned
                      ? (achievement['color'] as Color).withOpacity(0.1)
                      : AppTheme.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isEarned
                        ? (achievement['color'] as Color).withOpacity(0.3)
                        : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      achievement['icon'] as String,
                      style: TextStyle(
                        fontSize: 32,
                        color: isEarned
                            ? achievement['color'] as Color
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      achievement['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isEarned ? AppTheme.textLight : Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenu() {
    final settingsItems = [
      {
        'title': 'Configurações',
        'icon': Icons.settings,
        'route': AppRoutes.settings
      },
      {'title': 'Alterar Senha', 'icon': Icons.lock, 'route': null},
      {'title': 'Ajuda e Suporte', 'icon': Icons.help, 'route': null},
      {'title': 'Sair', 'icon': Icons.logout, 'route': null},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Configurações e Ações',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textLight,
            ),
          ),
          const SizedBox(height: 16),
          ...settingsItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _handleSettingsAction(
                    item['title'] as String, item['route']),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: AppTheme.textLight,
                        size: 24,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.textLight.withOpacity(0.7),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    final phoneController = TextEditingController(text: _userPhone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLight,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone (opcional)',
                labelStyle: TextStyle(color: Colors.grey),
                hintText: '(11) 99999-9999',
                hintStyle: TextStyle(color: Colors.grey),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.primaryColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                await _updateProfile(
                  nameController.text.trim(),
                  phoneController.text.trim().isEmpty
                      ? null
                      : phoneController.text.trim(),
                );
                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProfile(String newName, String? newPhone) async {
    setState(() => _isLoading = true);

    try {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;

      if (authState is AuthAuthenticated) {
        final uid = authState.user.uid;

        // Atualizar no Firebase Auth
        final authRepo = AuthRepository();
        await authRepo.updateUserProfile(displayName: newName);

        // Atualizar no Firestore
        await _profileService.saveUserProfile(
          uid: uid,
          displayName: newName,
          phone: newPhone,
        );

        setState(() {
          _userName = newName;
          _userPhone = newPhone;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil atualizado com sucesso!')),
          );
        }
      }
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLight,
        title: const Text(
          'Alterar Foto',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text('Tirar Foto',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text('Escolher da Galeria',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_userPhotoURL != null && _userPhotoURL!.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remover Foto',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _removePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      print('📷 Selecionando imagem da fonte: $source');
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        print('✅ Imagem selecionada: ${image.path}');
        await _uploadPhoto(image);
      } else {
        print('ℹ️ Nenhuma imagem selecionada');
      }
    } catch (e, stackTrace) {
      print('❌ Erro ao selecionar imagem:');
      print('   Erro: $e');
      print('   StackTrace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao selecionar imagem: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _uploadPhoto(XFile imageFile) async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    // Mostrar diálogo de loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLight,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text(
              'Enviando foto...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    try {
      print('📤 Iniciando upload da foto...');
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;

      if (authState is! AuthAuthenticated) {
        throw 'Usuário não autenticado';
      }

      final uid = authState.user.uid;
      print('👤 UID do usuário: $uid');

      // Upload para Firebase Storage
      print('☁️ Fazendo upload para Firebase Storage...');
      final photoURL = await _storageService.uploadProfilePhoto(
        uid: uid,
        imageFile: imageFile,
      );
      print('✅ URL obtida: $photoURL');

      // Atualizar no Firebase Auth
      print('🔐 Atualizando Firebase Auth...');
      final authRepo = AuthRepository();
      await authRepo.updateUserProfile(photoURL: photoURL);
      print('✅ Firebase Auth atualizado');

      // Atualizar no Firestore
      print('📝 Atualizando Firestore...');
      await _profileService.saveUserProfile(
        uid: uid,
        photoURL: photoURL,
      );
      print('✅ Firestore atualizado');

      if (mounted) {
        setState(() {
          _userPhotoURL = photoURL;
        });

        // Fechar diálogo de loading
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Erro completo no upload:');
      print('   Erro: $e');
      print('   Tipo: ${e.runtimeType}');
      print('   StackTrace: $stackTrace');

      if (mounted) {
        // Fechar diálogo de loading
        Navigator.of(context).pop();

        String errorMessage = 'Erro ao fazer upload';
        if (e.toString().contains('permission-denied')) {
          errorMessage = 'Permissão negada. Verifique as regras do Storage.';
        } else if (e.toString().contains('Storage') ||
            e.toString().contains('bucket')) {
          errorMessage =
              'Storage não configurado. Faça upgrade do plano Firebase.';
        } else if (e.toString().contains('Timeout')) {
          errorMessage = 'Upload demorou muito. Verifique sua conexão.';
        } else {
          errorMessage = 'Erro: ${e.toString()}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _removePhoto() async {
    setState(() => _isLoading = true);

    try {
      final authBloc = context.read<AuthBloc>();
      final authState = authBloc.state;

      if (authState is AuthAuthenticated) {
        final uid = authState.user.uid;

        // Deletar do Storage
        await _storageService.deleteProfilePhoto(uid);

        // Atualizar no Firebase Auth
        final authRepo = AuthRepository();
        await authRepo.updateUserProfile(photoURL: '');

        // Atualizar no Firestore
        await _profileService.saveUserProfile(
          uid: uid,
          photoURL: null,
        );

        setState(() {
          _userPhotoURL = null;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto removida com sucesso!')),
          );
        }
      }
    } catch (e) {
      print('Erro ao remover foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao remover foto: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleSettingsAction(String action, dynamic route) {
    switch (action) {
      case 'Configurações':
        if (route != null) {
          context.go(route);
        }
        break;
      case 'Alterar Senha':
        _showChangePasswordDialog();
        break;
      case 'Ajuda e Suporte':
        _showHelpDialog();
        break;
      case 'Sair':
        _showLogoutDialog();
        break;
    }
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLight,
        title: const Text(
          'Alterar Senha',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Senha Atual',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                labelStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade em desenvolvimento'),
                ),
              );
            },
            child: const Text('Alterar'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceLight,
        title: const Text(
          'Ajuda e Suporte',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Entre em contato conosco através do email: suporte@enccejaplus.com',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pop();
            context.go(AppRoutes.login);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Erro ao sair: ${state.message}'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: AlertDialog(
          backgroundColor: AppTheme.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              MascotHelper.dialogMascot(MascotEmotion.curious),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Sair da Conta',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Tem certeza que deseja sair da sua conta? Você precisará fazer login novamente para continuar estudando.',
            style: TextStyle(
              color: AppTheme.textLight,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(color: AppTheme.textSecondaryLight),
              ),
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.login);
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao sair: ${state.message}'),
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
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.red,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppMascot(
                              emotion: MascotEmotion.sad,
                              size: 24.0,
                              animated: false,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Sair',
                              style: TextStyle(
                                color: AppTheme.errorColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
