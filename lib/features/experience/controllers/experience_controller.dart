import 'package:get/get.dart';

import '../services/experience_service.dart';

/// Experience screen view model controller.
class ExperienceController extends GetxController {
  ExperienceController({ExperienceService? experienceService})
      : _experienceService = experienceService ?? Get.find<ExperienceService>();

  final ExperienceService _experienceService;

  List get experiences => _experienceService.getExperiences();
}
