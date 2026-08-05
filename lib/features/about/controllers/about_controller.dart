import 'package:get/get.dart';

import '../services/about_service.dart';

/// About screen view model controller.
class AboutController extends GetxController {
  AboutController({AboutService? aboutService})
      : _aboutService = aboutService ?? Get.find<AboutService>();

  final AboutService _aboutService;

  String get introduction => _aboutService.getIntroduction();
  List get journey => _aboutService.getJourney();
  List get education => _aboutService.getEducation();
}
