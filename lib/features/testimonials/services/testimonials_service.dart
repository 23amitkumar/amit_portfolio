import '../../../core/models/portfolio_models.dart';

/// Testimonials data service.
class TestimonialsService {
  List<TestimonialModel> getTestimonials() => const [
        TestimonialModel(
          name: 'Sarah Johnson',
          role: 'CEO',
          company: 'HealthTech Solutions',
          quote:
              'Amit delivered our healthcare app ahead of schedule with exceptional quality. His attention to UI detail and clean architecture made future updates seamless. Highly recommended!',
          rating: 5.0,
          avatarInitials: 'SJ',
        ),
        TestimonialModel(
          name: 'Michael Chen',
          role: 'Product Manager',
          company: 'RideShare Global',
          quote:
              'Working with Amit on our taxi app was a game-changer. He implemented complex real-time tracking and payment features flawlessly. A true Flutter expert.',
          rating: 5.0,
          avatarInitials: 'MC',
        ),
        TestimonialModel(
          name: 'Emily Rodriguez',
          role: 'Founder',
          company: 'FoodieStart',
          quote:
              'Amit transformed our food delivery concept into a polished, production-ready app. His communication and technical skills are outstanding. Will hire again!',
          rating: 5.0,
          avatarInitials: 'ER',
        ),
        TestimonialModel(
          name: 'David Park',
          role: 'CTO',
          company: 'FitLife Inc',
          quote:
              'Exceptional developer! Amit built our fitness app with beautiful animations and smooth performance. He proactively suggested improvements that enhanced the user experience.',
          rating: 5.0,
          avatarInitials: 'DP',
        ),
        TestimonialModel(
          name: 'Lisa Thompson',
          role: 'Marketing Director',
          company: 'EventPro',
          quote:
              'Our event booking app exceeded expectations thanks to Amit. Fast delivery, clean code, and premium UI. He is our go-to Flutter developer for all mobile projects.',
          rating: 5.0,
          avatarInitials: 'LT',
        ),
      ];
}
