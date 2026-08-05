import 'package:get/get.dart';

import '../../features/about/bindings/about_binding.dart';
import '../../features/about/views/about_view.dart';
import '../../features/achievements/bindings/achievements_binding.dart';
import '../../features/achievements/views/achievements_view.dart';
import '../../features/contact/bindings/contact_binding.dart';
import '../../features/contact/views/contact_view.dart';
import '../../features/experience/bindings/experience_binding.dart';
import '../../features/experience/views/experience_view.dart';
import '../../features/home/bindings/home_binding.dart';
import '../../features/home/views/home_view.dart';
import '../../features/projects/bindings/projects_binding.dart';
import '../../features/projects/views/projects_view.dart';
import '../../features/services/bindings/services_binding.dart';
import '../../features/services/views/services_view.dart';
import '../../features/shell/bindings/shell_binding.dart';
import '../../features/shell/views/shell_view.dart';
import '../../features/skills/bindings/skills_binding.dart';
import '../../features/skills/views/skills_view.dart';
import '../../features/testimonials/bindings/testimonials_binding.dart';
import '../../features/testimonials/views/testimonials_view.dart';
import 'app_routes.dart';

/// GetX route configuration with bindings and transitions.
class AppPages {
  AppPages._();

  static const initial = AppRoutes.shell;

  static final routes = <GetPage>[
    GetPage(
      name: AppRoutes.shell,
      page: () => const ShellView(),
      binding: ShellBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 400),
      children: [
        GetPage(
          name: AppRoutes.home,
          page: () => const HomeView(),
          binding: HomeBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: AppRoutes.about,
          page: () => const AboutView(),
          binding: AboutBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: AppRoutes.skills,
          page: () => const SkillsView(),
          binding: SkillsBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: AppRoutes.services,
          page: () => const ServicesView(),
          binding: ServicesBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: AppRoutes.projects,
          page: () => const ProjectsView(),
          binding: ProjectsBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: AppRoutes.experience,
          page: () => const ExperienceView(),
          binding: ExperienceBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: AppRoutes.testimonials,
          page: () => const TestimonialsView(),
          binding: TestimonialsBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: AppRoutes.achievements,
          page: () => const AchievementsView(),
          binding: AchievementsBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
        GetPage(
          name: AppRoutes.contact,
          page: () => const ContactView(),
          binding: ContactBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
        ),
      ],
    ),
  ];
}
