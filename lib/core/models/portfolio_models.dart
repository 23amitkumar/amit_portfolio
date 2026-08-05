import 'package:flutter/material.dart';

/// Statistic data model.
class StatModel {
  const StatModel({
    required this.value,
    required this.suffix,
    required this.label,
  });

  final double value;
  final String suffix;
  final String label;
}

/// Timeline entry model.
class TimelineModel {
  const TimelineModel({
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
    this.icon,
    this.isHighlighted = false,
  });

  final String title;
  final String subtitle;
  final String period;
  final String description;
  final String? icon;
  final bool isHighlighted;
}

/// Skill data model.
class SkillModel {
  const SkillModel({
    required this.name,
    required this.category,
    required this.experience,
    required this.description,
    required this.progress,
    required this.icon,
    required this.color,
  });

  final String name;
  final String category;
  final String experience;
  final String description;
  final double progress;
  final String icon;
  final int color;
}

/// Service offering model.
class ServiceModel {
  const ServiceModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
  });

  final String title;
  final String description;
  final String icon;
  final List<String> features;
}

/// Project showcase model.
class ProjectModel {
  const ProjectModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.techStack,
    required this.features,
    required this.role,
    required this.duration,
    required this.gradientColors,
    required this.icon,
    this.playStoreUrl,
    this.appStoreUrl,
    this.githubUrl,
    this.caseStudyUrl,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final List<String> techStack;
  final List<String> features;
  final String role;
  final String duration;
  final List<int> gradientColors;
  final String icon;
  final String? playStoreUrl;
  final String? appStoreUrl;
  final String? githubUrl;
  final String? caseStudyUrl;
}

/// Work experience model.
class ExperienceModel {
  const ExperienceModel({
    required this.company,
    required this.role,
    required this.duration,
    required this.location,
    required this.responsibilities,
    required this.technologies,
    required this.achievements,
    required this.type,
  });

  final String company;
  final String role;
  final String duration;
  final String location;
  final List<String> responsibilities;
  final List<String> technologies;
  final List<String> achievements;
  final String type;
}

/// Client testimonial model.
class TestimonialModel {
  const TestimonialModel({
    required this.name,
    required this.role,
    required this.company,
    required this.quote,
    required this.rating,
    required this.avatarInitials,
  });

  final String name;
  final String role;
  final String company;
  final String quote;
  final double rating;
  final String avatarInitials;
}

/// Achievement badge model.
class AchievementModel {
  const AchievementModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  final String title;
  final String description;
  final String icon;
  final int color;
}

/// Navigation item model.
class NavItemModel {
  const NavItemModel({
    required this.label,
    required this.route,
    required this.icon,
  });

  final String label;
  final String route;
  final IconData icon;
}
