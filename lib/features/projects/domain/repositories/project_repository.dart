import 'dart:io';
import '../entities/project_entity.dart';

abstract class ProjectRepository {
  /// Get all projects
  Future<List<ProjectEntity>> getAllProjects();

  /// Get single project by id
  Future<ProjectEntity> getSingleProject(String id);

  /// Create a new project
  Future<ProjectEntity> createProject({
    required String name,
    required String details,
    required String googlePlayStoreLink,
    required String appleAppStoreLink,
    required String github,
    required List<File> images,
  });

  /// Update an existing project
  Future<ProjectEntity> updateProject({
    required String id,
    String? name,
    String? details,
    String? googlePlayStoreLink,
    String? appleAppStoreLink,
    String? github,
    List<File>? newImages,
  });

  /// Delete a project
  Future<void> deleteProject(String id);
}
