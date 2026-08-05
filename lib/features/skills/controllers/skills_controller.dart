import 'package:get/get.dart';

import '../../../core/models/portfolio_models.dart';
import '../services/skills_service.dart';

/// Skills screen view model controller.
class SkillsController extends GetxController {
  SkillsController({SkillsService? skillsService})
      : _skillsService = skillsService ?? Get.find<SkillsService>();

  final SkillsService _skillsService;

  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;

  List<String> get categories => _skillsService.getCategories();
  List<SkillModel> get allSkills => _skillsService.getAllSkills();

  List<SkillModel> get filteredSkills {
    var skills = allSkills;
    if (selectedCategory.value != 'All') {
      skills = skills.where((s) => s.category == selectedCategory.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      skills = skills
          .where(
            (s) =>
                s.name.toLowerCase().contains(q) ||
                s.description.toLowerCase().contains(q),
          )
          .toList();
    }
    return skills;
  }

  void selectCategory(String category) => selectedCategory.value = category;
  void updateSearch(String query) => searchQuery.value = query;
}
