import '../../../core/constants/app_constants.dart';
import '../../../core/models/portfolio_models.dart';

/// Home screen data service.
class HomeService {
  List<StatModel> getStats() => const [
        StatModel(value: 4.5, suffix: '+', label: 'Years Experience'),
        StatModel(value: 25, suffix: '+', label: 'Apps Delivered'),
        StatModel(value: 100, suffix: '%', label: 'Client Satisfaction'),
        StatModel(value: 24, suffix: '/7', label: 'Support Available'),
      ];

  String getAboutSnippet() =>
      'I am a Flutter developer with 4.5+ years of experience building scalable, '
      'production-ready mobile applications for Android and iOS. I specialize in clean '
      'architecture, beautiful UI, optimized performance, real-time applications, maps, '
      'payment gateways, Firebase integrations, and complex business logic.';

  String getDeveloperName() => AppConstants.developerName;
  String getDeveloperRole() => AppConstants.developerRole;
  String getLocation() => AppConstants.developerLocation;
}
