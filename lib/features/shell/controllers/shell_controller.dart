import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/portfolio_models.dart';
import '../../../core/routes/app_routes.dart';

/// Shell navigation controller managing routes and scroll state.
class ShellController extends GetxController {
  final currentIndex = 0.obs;
  final scrollProgress = 0.0.obs;
  final showBackToTop = false.obs;

  final navItems = const [
    NavItemModel(label: AppStrings.home, route: AppRoutes.home, icon: Icons.home_rounded),
    NavItemModel(label: AppStrings.about, route: AppRoutes.about, icon: Icons.person_rounded),
    NavItemModel(label: AppStrings.skills, route: AppRoutes.skills, icon: Icons.code_rounded),
    NavItemModel(
      label: AppStrings.services,
      route: AppRoutes.services,
      icon: Icons.design_services_rounded,
    ),
    NavItemModel(
      label: AppStrings.projects,
      route: AppRoutes.projects,
      icon: Icons.folder_rounded,
    ),
    NavItemModel(
      label: AppStrings.experience,
      route: AppRoutes.experience,
      icon: Icons.work_rounded,
    ),
    NavItemModel(
      label: AppStrings.testimonials,
      route: AppRoutes.testimonials,
      icon: Icons.format_quote_rounded,
    ),
    NavItemModel(
      label: AppStrings.achievements,
      route: AppRoutes.achievements,
      icon: Icons.emoji_events_rounded,
    ),
    NavItemModel(
      label: AppStrings.contact,
      route: AppRoutes.contact,
      icon: Icons.mail_rounded,
    ),
  ];

  void navigateTo(int index) {
    currentIndex.value = index;
  }

  void updateScrollProgress(double progress) {
    scrollProgress.value = progress.clamp(0.0, 1.0);
    showBackToTop.value = progress > 0.15;
  }

  void syncIndexFromRoute(String? route) {
    if (route == null) return;
    final idx = navItems.indexWhere((item) => item.route == route);
    if (idx >= 0) currentIndex.value = idx;
  }
}
