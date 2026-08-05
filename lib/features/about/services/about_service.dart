import '../../../core/models/portfolio_models.dart';

/// About screen data service.
class AboutService {
  String getIntroduction() =>
      'I am Amit Kumar, a Senior Flutter Developer based in Mohali, Punjab, India with 4+ years of '
      'experience building scalable, high-performance cross-platform mobile applications for Android and iOS. '
      'I have strong expertise in Flutter, Dart, Firebase, REST APIs, Clean Architecture, MVVM, GetX, BLoC, '
      'Google Maps, Socket.io, Push Notifications, and Payment Gateway Integration. '
      'I am passionate about writing clean, maintainable code and delivering seamless user experiences.';

  List<TimelineModel> getJourney() => const [
        TimelineModel(
          title: 'Senior Flutter Developer',
          subtitle: 'Cqlsys Technologies | Mohali, Punjab',
          period: 'April 2023 - Present',
          description:
              'Lead the architecture, development, and deployment of multiple Flutter applications. '
              'Design scalable apps using Clean Architecture and MVVM. Integrate Stripe, Razorpay, Socket.io and Firebase.',
          isHighlighted: true,
        ),
        TimelineModel(
          title: 'Flutter Developer',
          subtitle: 'Promatics Technologies | Ludhiana, Punjab',
          period: 'February 2022 - April 2023',
          description:
              'Developed production-ready Flutter applications for Android and iOS. '
              'Integrated REST APIs and Firebase services. Implemented multilingual support and optimized performance.',
          isHighlighted: false,
        ),
      ];

  List<TimelineModel> getEducation() => const [
        TimelineModel(
          title: 'Bachelor of Technology (B.Tech)',
          subtitle: 'Computer Science & Engineering',
          period: '2016 - 2020',
          description:
              'Gulzar Group of Institutes, Ludhiana',
        ),
      ];
}
