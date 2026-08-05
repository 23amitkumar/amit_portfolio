import 'package:get/get.dart';

import '../../../core/models/portfolio_models.dart';

/// Achievements screen view model controller.
class AchievementsController extends GetxController {
  final achievements = <AchievementModel>[
    const AchievementModel(
      title: '25+ Projects',
      description: 'Successfully delivered mobile applications across diverse industries',
      icon: '🏆',
      color: 0xFF6366F1,
    ),
    const AchievementModel(
      title: '4.5 Years Experience',
      description: 'Deep expertise in Flutter development and mobile architecture',
      icon: '⭐',
      color: 0xFFF59E0B,
    ),
    const AchievementModel(
      title: 'Fast Delivery',
      description: 'Consistent on-time delivery with agile development practices',
      icon: '🚀',
      color: 0xFF06B6D4,
    ),
    const AchievementModel(
      title: 'Clean Code',
      description: 'SOLID principles, clean architecture, and maintainable codebase',
      icon: '💎',
      color: 0xFF8B5CF6,
    ),
    const AchievementModel(
      title: '100% Responsive',
      description: 'Pixel-perfect UI across all screen sizes and platforms',
      icon: '📐',
      color: 0xFF22C55E,
    ),
    const AchievementModel(
      title: 'Production Ready',
      description: 'Battle-tested apps deployed to App Store and Play Store',
      icon: '✅',
      color: 0xFFEC4899,
    ),
  ].obs;
}
