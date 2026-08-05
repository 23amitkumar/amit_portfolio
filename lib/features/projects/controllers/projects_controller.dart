import 'package:get/get.dart';

import '../../../core/models/portfolio_models.dart';
import '../services/projects_service.dart';

/// Projects screen view model controller.
class ProjectsController extends GetxController {
  ProjectsController({ProjectsService? projectsService})
      : _projectsService = projectsService ?? Get.find<ProjectsService>();

  final ProjectsService _projectsService;

  final selectedCategory = 'All'.obs;
  final searchQuery = ''.obs;
  final currentCarouselIndex = 0.obs;

  List<String> get categories => _projectsService.getCategories();
  List<ProjectModel> get allProjects => _projectsService.getAllProjects();

  List<ProjectModel> get filteredProjects {
    var projects = allProjects;
    if (selectedCategory.value != 'All') {
      projects = projects.where((p) => p.category == selectedCategory.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      projects = projects
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.description.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q),
          )
          .toList();
    }
    return projects;
  }

  void selectCategory(String category) => selectedCategory.value = category;
  void updateSearch(String query) => searchQuery.value = query;
  void setCarouselIndex(int index) => currentCarouselIndex.value = index;
}
