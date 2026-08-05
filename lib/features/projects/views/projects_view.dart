import 'package:flutter/material.dart';
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
          ),
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
    final columns = Responsive.value(context: context, mobile: 1, tablet: 2, desktop: 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: Responsive.isMobile(context) ? 0.72 : 0.85,
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
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: widget.project.gradientColors.map((c) => Color(c)).toList(),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: Matrix4.translationValues(0.0, _hovered ? -8.0 : 0.0, 0.0),
        child: GlassCard(
          padding: EdgeInsets.zero,
          hoverEffect: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        widget.project.icon,
                        style: TextStyle(
                          fontSize: 64,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.project.category,
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.project.name, style: context.textTheme.titleLarge),
                      8.verticalSpace,
                      Text(
                        widget.project.description,
                        style: context.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      12.verticalSpace,
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
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: AppColors.primary),
                          4.horizontalSpace,
                          Text(widget.project.duration, style: context.textTheme.labelSmall),
                          16.horizontalSpace,
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
                      16.verticalSpace,
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
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
