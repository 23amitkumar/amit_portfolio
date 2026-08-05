import 'package:get/get.dart';

import '../theme/theme_controller.dart';
import '../../features/about/controllers/about_controller.dart';
import '../../features/achievements/controllers/achievements_controller.dart';
import '../../features/contact/controllers/contact_controller.dart';
import '../../features/experience/controllers/experience_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/projects/controllers/projects_controller.dart';
import '../../features/services/controllers/services_controller.dart';
import '../../features/shell/controllers/shell_controller.dart';
import '../../features/skills/controllers/skills_controller.dart';
import '../../features/testimonials/controllers/testimonials_controller.dart';
import '../../features/about/services/about_service.dart';
import '../../features/experience/services/experience_service.dart';
import '../../features/home/services/home_service.dart';
import '../../features/projects/services/projects_service.dart';
import '../../features/skills/services/skills_service.dart';
import '../../features/testimonials/services/testimonials_service.dart';

/// Initial dependency injection binding.
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThemeController>(() => ThemeController(), fenix: true);

    // Services
    Get.lazyPut<HomeService>(() => HomeService(), fenix: true);
    Get.lazyPut<AboutService>(() => AboutService(), fenix: true);
    Get.lazyPut<SkillsService>(() => SkillsService(), fenix: true);
    Get.lazyPut<ProjectsService>(() => ProjectsService(), fenix: true);
    Get.lazyPut<ExperienceService>(() => ExperienceService(), fenix: true);
    Get.lazyPut<TestimonialsService>(() => TestimonialsService(), fenix: true);

    // Controllers
    Get.lazyPut<ShellController>(() => ShellController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<AboutController>(() => AboutController(), fenix: true);
    Get.lazyPut<SkillsController>(() => SkillsController(), fenix: true);
    Get.lazyPut<ServicesController>(() => ServicesController(), fenix: true);
    Get.lazyPut<ProjectsController>(() => ProjectsController(), fenix: true);
    Get.lazyPut<ExperienceController>(() => ExperienceController(), fenix: true);
    Get.lazyPut<TestimonialsController>(() => TestimonialsController(), fenix: true);
    Get.lazyPut<AchievementsController>(() => AchievementsController(), fenix: true);
    Get.lazyPut<ContactController>(() => ContactController(), fenix: true);
  }
}
