import 'package:get/get.dart';

import '../../../core/models/portfolio_models.dart';

/// Services screen view model controller.
class ServicesController extends GetxController {
  final services = <ServiceModel>[
    const ServiceModel(
      title: 'Mobile App Development',
      description:
          'End-to-end Flutter app development from concept to App Store deployment with premium UI/UX.',
      icon: '📱',
      features: ['Custom UI/UX', 'Cross-platform', 'App Store deployment', 'Performance optimized'],
    ),
    const ServiceModel(
      title: 'Flutter Consultation',
      description:
          'Architecture review, code audit, and technical guidance for your Flutter projects.',
      icon: '💡',
      features: ['Architecture review', 'Code audit', 'Best practices', 'Team mentoring'],
    ),
    const ServiceModel(
      title: 'App Maintenance',
      description:
          'Ongoing support, updates, and feature enhancements for existing Flutter applications.',
      icon: '🔧',
      features: ['Bug fixes', 'Feature updates', 'OS compatibility', 'Performance monitoring'],
    ),
    const ServiceModel(
      title: 'Bug Fixing',
      description:
          'Quick turnaround on critical bugs and performance issues in production apps.',
      icon: '🐛',
      features: ['Crash analysis', 'Memory leaks', 'UI glitches', 'API issues'],
    ),
    const ServiceModel(
      title: 'API Integration',
      description:
          'Seamless REST API integration with proper error handling, caching, and offline support.',
      icon: '🔗',
      features: ['REST APIs', 'GraphQL', 'WebSocket', 'Offline sync'],
    ),
    const ServiceModel(
      title: 'Firebase Integration',
      description:
          'Complete Firebase setup including Auth, Firestore, Storage, Analytics, and Cloud Functions.',
      icon: '🔥',
      features: ['Authentication', 'Firestore', 'Cloud Storage', 'Push notifications'],
    ),
    const ServiceModel(
      title: 'Payment Gateway',
      description:
          'Secure payment integration with Stripe, Razorpay, PayPal, and in-app purchases.',
      icon: '💳',
      features: ['Stripe', 'Razorpay', 'In-app purchases', 'Subscriptions'],
    ),
    const ServiceModel(
      title: 'Google Maps',
      description:
          'Advanced maps integration with custom markers, routes, geofencing, and live tracking.',
      icon: '🗺️',
      features: ['Live tracking', 'Route optimization', 'Geofencing', 'Custom markers'],
    ),
    const ServiceModel(
      title: 'Performance Optimization',
      description:
          'App profiling, memory optimization, and startup time reduction for smoother UX.',
      icon: '⚡',
      features: ['Startup optimization', 'Memory profiling', 'Frame rate analysis', 'Bundle size reduction'],
    ),
    const ServiceModel(
      title: 'App Publishing',
      description:
          'Complete App Store and Play Store submission with ASO optimization and compliance.',
      icon: '🚀',
      features: ['Store submission', 'ASO optimization', 'Compliance review', 'Release management'],
    ),
  ].obs;
}
