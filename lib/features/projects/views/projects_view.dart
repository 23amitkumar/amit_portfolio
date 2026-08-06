import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/portfolio_models.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/shared_widgets.dart';
import '../../shell/controllers/shell_controller.dart';
import '../controllers/projects_controller.dart';

/// Projects showcase with filtering and carousel.
class ProjectsView extends GetView<ProjectsController> {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    final shellController = Get.find<ShellController>();

    return PageScaffold(
      onScroll: shellController.updateScrollProgress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Featured Projects',
            subtitle: 'Production-ready apps across diverse industries',
          ),
          TextField(
            onChanged: controller.updateSearch,
            decoration: InputDecoration(
              hintText: 'Search projects...',
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: context.isDarkMode ? AppColors.darkCard : AppColors.lightCard,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.08, end: 0, duration: 400.ms),
          24.verticalSpace,
          Obx(
            () => FilterChips(
              items: controller.categories,
              selected: controller.selectedCategory.value,
              onSelected: controller.selectCategory,
            ),
          ),
          32.verticalSpace,
          Obx(() {
            final projects = controller.filteredProjects;
            if (projects.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(48),
                  child: Text('No projects found', style: context.textTheme.bodyLarge),
                ),
              );
            }
            return _ProjectsGrid(projects: projects);
          }),
        ],
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  const _ProjectsGrid({required this.projects});

  final List<ProjectModel> projects;

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isDesktop(context)) {
      return Column(
        children: projects.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: entry.key < projects.length - 1 ? 16 : 0),
            child: StaggerItem(
              index: entry.key,
              child: _ProjectCard(project: entry.value),
            ),
          );
        }).toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        mainAxisExtent: 460,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return StaggerItem(
          index: index,
          child: _ProjectCard(project: projects[index]),
        );
      },
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({required this.project});

  final ProjectModel project;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  Future<void> _launch(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: widget.project.gradientColors.map((c) => Color(c)).toList(),
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: isMobile ? 100 : 130,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Text(
                  widget.project.icon,
                  style: TextStyle(
                    fontSize: isMobile ? 44 : 52,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .moveY(begin: -3, end: 3, duration: 2200.ms, curve: Curves.easeInOut),
              ),
              Positioned(
                top: isMobile ? 10 : 12,
                right: isMobile ? 10 : 12,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 10,
                    vertical: isMobile ? 4 : 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.project.category,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 10 : 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(isMobile ? 14 : 16),
          child: _buildDetails(context, isMobile),
        ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0.0, _hovered ? -8.0 : 0.0, 0.0),
        child: GlassCard(
          padding: EdgeInsets.zero,
          hoverEffect: false,
          child: content,
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.project.name,
          style: isMobile ? context.textTheme.titleMedium : context.textTheme.titleLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        6.verticalSpace,
        Text(
          widget.project.description,
          style: context.textTheme.bodySmall,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        10.verticalSpace,
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: widget.project.techStack.take(4).map((tech) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(tech, style: context.textTheme.labelSmall),
            );
          }).toList(),
        ),
        10.verticalSpace,
        Row(
          children: [
            Icon(Icons.schedule, size: 14, color: AppColors.primary),
            4.horizontalSpace,
            Text(widget.project.duration, style: context.textTheme.labelSmall),
            12.horizontalSpace,
            Icon(Icons.person_outline, size: 14, color: AppColors.primary),
            4.horizontalSpace,
            Expanded(
              child: Text(
                widget.project.role,
                style: context.textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        10.verticalSpace,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (widget.project.playStoreUrl != null)
              _LinkButton(
                icon: Icons.android_rounded,
                label: 'Play Store',
                onTap: () => _launch(widget.project.playStoreUrl),
              ),
            if (widget.project.appStoreUrl != null)
              _LinkButton(
                icon: Icons.apple_rounded,
                label: 'App Store',
                onTap: () => _launch(widget.project.appStoreUrl),
              ),
            if (widget.project.githubUrl != null)
              _LinkButton(
                icon: Icons.code_rounded,
                label: 'GitHub',
                onTap: () => _launch(widget.project.githubUrl),
              ),
            if (widget.project.caseStudyUrl != null)
              _LinkButton(
                icon: Icons.article_outlined,
                label: 'Case Study',
                onTap: () => _launch(widget.project.caseStudyUrl),
              ),
          ],
        ),
      ],
    );
  }
}

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
            color: context.isDarkMode ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14),
            4.horizontalSpace,
            Text(label, style: context.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
