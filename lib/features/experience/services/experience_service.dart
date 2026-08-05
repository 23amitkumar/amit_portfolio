import '../../../core/models/portfolio_models.dart';

/// Experience data service.
class ExperienceService {
  List<ExperienceModel> getExperiences() => const [
        ExperienceModel(
          company: 'Cqlsys Technologies',
          role: 'Senior Flutter Developer',
          duration: 'April 2023 - Present',
          location: 'Mohali, Punjab',
          type: 'Full-time',
          responsibilities: [
            'Lead the architecture, development, and deployment of multiple Flutter applications.',
            'Design scalable mobile applications using Clean Architecture and MVVM.',
            'Implement real-time communication using Socket.io.',
            'Improve app performance, reducing loading time by approximately 30%.',
            'Integrate Firebase Authentication, Cloud Firestore, Analytics, and Crash Reporting.',
            'Implement Google Maps, live tracking, push notifications, localization, and deep linking.',
            'Integrate Stripe, Razorpay, and Tap payment gateways.',
            'Publish and maintain Android and iOS applications.',
            'Review code, mentor junior developers, and collaborate with cross-functional teams.',
          ],
          technologies: [
            'Flutter', 'Dart', 'GetX', 'Firebase', 'Stripe', 'Razorpay', 'Tap',
            'Google Maps', 'Socket.io', 'Clean Architecture', 'MVVM'
          ],
          achievements: [
            'Employee of the Month — September 2024',
            'Rising Star Award — September 2023',
          ],
        ),
        ExperienceModel(
          company: 'Promatics Technologies',
          role: 'Flutter Developer',
          duration: 'February 2022 - April 2023',
          location: 'Ludhiana, Punjab',
          type: 'Full-time',
          responsibilities: [
            'Developed production-ready Flutter applications for Android and iOS.',
            'Built reusable widgets and responsive user interfaces.',
            'Integrated REST APIs and Firebase services.',
            'Implemented multilingual support and localization.',
            'Collaborated with backend developers to improve API performance.',
            'Fixed bugs, optimized application performance, and participated in production releases.',
          ],
          technologies: [
            'Flutter', 'Dart', 'Provider', 'Firebase', 'REST APIs',
          ],
          achievements: [
            'Employee of the Month — July 2022',
          ],
        ),
      ];
}
