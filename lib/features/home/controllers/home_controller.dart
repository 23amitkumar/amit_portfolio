import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/home_service.dart';
import '../../shell/controllers/shell_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';

class HomeController extends GetxController {
  HomeController({HomeService? homeService})
      : _homeService = homeService ?? Get.find<HomeService>();

  final HomeService _homeService;

  final isLoading = false.obs;

  String get developerName => _homeService.getDeveloperName();
  String get developerRole => _homeService.getDeveloperRole();
  String get location => _homeService.getLocation();
  String get aboutSnippet => _homeService.getAboutSnippet();
  List get stats => _homeService.getStats();

  void navigateToContact() => Get.find<ShellController>().navigateTo(8);
  void navigateToProjects() => Get.find<ShellController>().navigateTo(4);

  Future<void> downloadResume() async {
    const resumePath = 'assets/resume/Amit_Kumar_Resume.pdf';
    
    if (kIsWeb) {
      final url = Uri.base.resolve(resumePath);
      try {
        await launchUrl(url);
      } catch (e) {
        Get.snackbar('Error', 'Could not open resume.');
      }
    } else {
      try {
        final byteData = await rootBundle.load(resumePath);
        final tempDir = await getTemporaryDirectory();
        final file = File('${tempDir.path}/Amit_Kumar_Resume.pdf');
        await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);
        
        await Share.shareXFiles([XFile(file.path)], text: 'Amit Kumar - Senior Flutter Developer Resume');
      } catch (e) {
        Get.snackbar('Error', 'Could not share resume: $e');
      }
    }
  }
}
