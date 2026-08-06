import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../about/views/about_view.dart';
import '../../achievements/views/achievements_view.dart';
import '../../contact/views/contact_view.dart';
import '../../experience/views/experience_view.dart';
import '../../home/views/home_view.dart';
import '../../projects/views/projects_view.dart';
import '../../services/views/services_view.dart';
import '../../skills/views/skills_view.dart';
import '../../testimonials/views/testimonials_view.dart';
import '../controllers/shell_controller.dart';

/// Main app shell with responsive navigation.
class ShellView extends GetView<ShellController> {
  const ShellView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    return CustomCursor(
      child: Scaffold(
        key: controller.scaffoldKey,
        drawer: isMobile ? _MobileDrawer(controller: controller) : null,
        body: SafeArea(
          child: Stack(
          children: [
            Row(
              children: [
                if (isDesktop) _SideNav(controller: controller),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(themeController: themeController),
                      Expanded(
                        child: Obx(
                          () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 450),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            transitionBuilder: (child, animation) {
                              final slide = Tween<Offset>(
                                begin: const Offset(0, 0.04),
                                end: Offset.zero,
                              ).animate(CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOutCubic,
                              ));
                              return FadeTransition(
                                opacity: animation,
                                child: SlideTransition(position: slide, child: child),
                              );
                            },
                            child: _getPage(controller.navItems[controller.currentIndex.value].route),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(
              () => ScrollProgressBar(progress: controller.scrollProgress.value),
            ),
          ],
        )),
        bottomNavigationBar: isMobile ? _BottomNav(controller: controller) : null,
        floatingActionButton: Obx(
          () => BackToTopButton(
            visible: controller.showBackToTop.value,
            onPressed: controller.scrollToTop,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _getPage(String route) {
    switch (route) {
      case AppRoutes.home:
        return const HomeView(key: ValueKey('home'));
      case AppRoutes.about:
        return const AboutView(key: ValueKey('about'));
      case AppRoutes.skills:
        return const SkillsView(key: ValueKey('skills'));
      case AppRoutes.services:
        return const ServicesView(key: ValueKey('services'));
      case AppRoutes.projects:
        return const ProjectsView(key: ValueKey('projects'));
      case AppRoutes.experience:
        return const ExperienceView(key: ValueKey('experience'));
      case AppRoutes.testimonials:
        return const TestimonialsView(key: ValueKey('testimonials'));
      case AppRoutes.achievements:
        return const AchievementsView(key: ValueKey('achievements'));
      case AppRoutes.contact:
        return const ContactView(key: ValueKey('contact'));
      default:
        return const HomeView(key: ValueKey('home'));
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.themeController});

  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? AppColors.darkSurface.withValues(alpha: 0.8)
            : AppColors.lightSurface.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: context.isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Row(
        children: [
          if (isMobile)
            IconButton(
              onPressed: () => Get.find<ShellController>().scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu_rounded),
              tooltip: 'Menu',
            ),
          if (isMobile) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Text(
                AppConstants.developerName,
                style: context.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            Text(AppConstants.appName, style: context.textTheme.titleLarge),
          const Spacer(),
          Obx(
            () => IconButton(
              onPressed: themeController.toggleTheme,
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  themeController.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  key: ValueKey(themeController.isDarkMode),
                ),
              ),
              tooltip: 'Toggle theme',
            ),
          ),
          GradientButton(
            label: AppStrings.hireMe,
            icon: Icons.rocket_launch_rounded,
            onPressed: () => Get.find<ShellController>().navigateTo(8),
          ),
        ],
      ),
    );
  }
}

class _SideNav extends StatelessWidget {
  const _SideNav({required this.controller});

  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          right: BorderSide(
            color: context.isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppConstants.developerName, style: context.textTheme.titleMedium),
                      Text(AppConstants.developerRole, style: context.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(
              () {
                final currentIndex = controller.currentIndex.value;
                return ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  children: List.generate(
                    controller.navItems.length,
                    (index) {
                      final item = controller.navItems[index];
                      final isSelected = currentIndex == index;
                      return _NavTile(
                        item: item,
                        isSelected: isSelected,
                        onTap: () => controller.navigateTo(index),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final dynamic item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: widget.isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : _hovered
                  ? AppColors.primary.withValues(alpha: 0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: widget.isSelected
              ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
              : null,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            leading: Icon(
            widget.item.icon,
            color: widget.isSelected ? AppColors.primary : null,
            size: 22,
          ),
          title: Text(
            widget.item.label,
            style: TextStyle(
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
              color: widget.isSelected ? AppColors.primary : null,
              fontSize: 14,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onTap: widget.onTap,
          dense: true,
          visualDensity: VisualDensity.compact,
        ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.controller});

  final ShellController controller;

  static const _primaryItems = [0, 1, 4, 8]; // Home, About, Projects, Contact

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final current = controller.currentIndex.value;
        final isPrimary = _primaryItems.contains(current);

        return NavigationBar(
          selectedIndex: isPrimary ? _primaryItems.indexOf(current) : 4,
          onDestinationSelected: (i) {
            if (i == 4) {
              controller.scaffoldKey.currentState?.openDrawer();
              return;
            }
            controller.navigateTo(_primaryItems[i]);
          },
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person_rounded), label: 'About'),
            NavigationDestination(icon: Icon(Icons.folder_outlined), selectedIcon: Icon(Icons.folder_rounded), label: 'Projects'),
            NavigationDestination(icon: Icon(Icons.mail_outline), selectedIcon: Icon(Icons.mail_rounded), label: 'Contact'),
            NavigationDestination(icon: Icon(Icons.apps_rounded), selectedIcon: Icon(Icons.apps_rounded), label: 'More'),
          ],
        );
      },
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({required this.controller});

  final ShellController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('AK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppConstants.developerName, style: context.textTheme.titleMedium),
                        Text(AppConstants.developerRole, style: context.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Obx(
                () {
                  final currentIndex = controller.currentIndex.value;
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    children: List.generate(controller.navItems.length, (index) {
                      final item = controller.navItems[index];
                      final isSelected = currentIndex == index;
                      return StaggerItem(
                        index: index,
                        baseDelay: 50,
                        child: ListTile(
                          leading: Icon(
                            item.icon,
                            color: isSelected ? AppColors.primary : null,
                            size: 22,
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? AppColors.primary : null,
                            ),
                          ),
                          selected: isSelected,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          onTap: () {
                            Navigator.pop(context);
                            controller.navigateTo(index);
                          },
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
