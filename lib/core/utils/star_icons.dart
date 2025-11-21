import 'package:flutter/material.dart';

/// Sistema de estrelas e moeda estudantil
class StarIcons {
  // Estrelas
  static const String starEmpty = '☆'; // Estrela vazia
  static const String starFull = '⭐'; // Estrela cheia
  static const String starGold = '🌟'; // Estrela dourada
  static const String starSparkle = '✨'; // Estrela brilhante

  // Moeda estudantil (equivalente ao XP)
  static const String coin = '🪙'; // Moeda
  static const String medal = '🏅'; // Medalha
  static const String trophy = '🏆'; // Troféu
  static const String badge = '🎖️'; // Insígnia

  /// Converte XP para quantidade de estrelas
  ///
  /// - 10 XP = 1 estrela
  /// - 50 XP = 5 estrelas
  static int xpToStars(int xp) {
    return (xp / 10).floor();
  }

  /// Converte XP para quantidade de moedas
  ///
  /// - 1 XP = 1 moeda
  static int xpToCoins(int xp) {
    return xp;
  }

  /// Retorna widget de estrelas baseado no XP
  static Widget buildStarsFromXP(int xp, {double size = 20.0}) {
    final stars = xpToStars(xp);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (index) => Text(
          index < stars ? starFull : starEmpty,
          style: TextStyle(fontSize: size),
        ),
      ),
    );
  }

  /// Retorna widget de moedas baseado no XP
  static Widget buildCoinsFromXP(int xp, {double size = 20.0}) {
    final coins = xpToCoins(xp);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          coin,
          style: TextStyle(fontSize: size),
        ),
        const SizedBox(width: 4),
        Text(
          coins.toString(),
          style: TextStyle(
            fontSize: size * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Widget para exibir estrelas
class StarWidget extends StatelessWidget {
  final int filledStars;
  final int totalStars;
  final double size;

  const StarWidget({
    super.key,
    required this.filledStars,
    this.totalStars = 5,
    this.size = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalStars,
        (index) => Text(
          index < filledStars ? StarIcons.starFull : StarIcons.starEmpty,
          style: TextStyle(fontSize: size),
        ),
      ),
    );
  }
}

/// Widget para exibir moedas estudantis
class CoinWidget extends StatelessWidget {
  final int amount;
  final double size;

  const CoinWidget({
    super.key,
    required this.amount,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          StarIcons.coin,
          style: TextStyle(fontSize: size),
        ),
        const SizedBox(width: 4),
        Text(
          amount.toString(),
          style: TextStyle(
            fontSize: size * 0.8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
