import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class CelebrationWidget extends StatefulWidget {
  final int xpGained;
  final String achievement;
  final VoidCallback onComplete;

  const CelebrationWidget({
    super.key,
    required this.xpGained,
    required this.achievement,
    required this.onComplete,
  });

  @override
  State<CelebrationWidget> createState() => _CelebrationWidgetState();
}

class _CelebrationWidgetState extends State<CelebrationWidget>
    with TickerProviderStateMixin {
  late AnimationController _fireworksController;
  late AnimationController _trophyController;
  late AnimationController _xpController;
  late AnimationController _fadeController;

  late Animation<double> _fireworksAnimation;
  late Animation<double> _trophyAnimation;
  late Animation<double> _xpAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _fireworksController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _trophyController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _xpController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fireworksAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fireworksController,
      curve: Curves.easeOut,
    ));

    _trophyAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _trophyController,
      curve: Curves.elasticOut,
    ));

    _xpAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _xpController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _startCelebration();
  }

  void _startCelebration() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _fireworksController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _trophyController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _xpController.forward();
    
    await Future.delayed(const Duration(seconds: 3));
    widget.onComplete();
  }

  @override
  void dispose() {
    _fireworksController.dispose();
    _trophyController.dispose();
    _xpController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                // Fogos de artifício
                _buildFireworks(),
                
                // Conteúdo principal
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Troféu
                      AnimatedBuilder(
                        animation: _trophyAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _trophyAnimation.value,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppTheme.xpColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.xpColor.withOpacity(0.5),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Título de parabéns
                      const Text(
                        '🎉 PARABÉNS! 🎉',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Conquista
                      Text(
                        widget.achievement,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.xpColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // XP ganho
                      AnimatedBuilder(
                        animation: _xpAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _xpAnimation.value,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryColor,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.secondaryColor.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+${widget.xpGained} XP',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFireworks() {
    return AnimatedBuilder(
      animation: _fireworksAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(8, (index) {
            final angle = (index * 45.0) * (pi / 180);
            final distance = 150.0 * _fireworksAnimation.value;
            final x = MediaQuery.of(context).size.width / 2 + 
                     distance * cos(angle);
            final y = MediaQuery.of(context).size.height / 2 + 
                     distance * sin(angle);
            
            return Positioned(
              left: x - 20,
              top: y - 20,
              child: Opacity(
                opacity: (1.0 - _fireworksAnimation.value).clamp(0.0, 1.0),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: [
                      AppTheme.xpColor,
                      AppTheme.secondaryColor,
                      AppTheme.accentColor,
                      AppTheme.primaryColor,
                    ][index % 4],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

