import 'package:get/get.dart';

import '../services/testimonials_service.dart';

/// Testimonials screen view model controller.
class TestimonialsController extends GetxController {
  TestimonialsController({TestimonialsService? testimonialsService})
      : _testimonialsService = testimonialsService ?? Get.find<TestimonialsService>();

  final TestimonialsService _testimonialsService;

  final currentIndex = 0.obs;

  List get testimonials => _testimonialsService.getTestimonials();

  void next() {
    if (currentIndex.value < testimonials.length - 1) {
      currentIndex.value++;
    } else {
      currentIndex.value = 0;
    }
  }

  void previous() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    } else {
      currentIndex.value = testimonials.length - 1;
    }
  }

  void goTo(int index) => currentIndex.value = index;
}
