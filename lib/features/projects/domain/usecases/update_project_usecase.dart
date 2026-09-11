import 'dart:io';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class UpdateProjectParams {
  final String id;
  final String? name;
  final String? details;
  final String? googlePlayStore;
  final String? appleAppStore;
  final String? github;
  final List<File>? newImages;

  const UpdateProjectParams({
    required this.id,
    this.name,
    this.details,
    this.googlePlayStore,
    this.appleAppStore,
    this.github,
    this.newImages,
  });
}

class UpdateProjectUseCase {
  final ProjectRepository repository;

  UpdateProjectUseCase(this.repository);

  Future<ProjectEntity> call(UpdateProjectParams params) {
    return repository.updateProject(
      id: params.id,
      name: params.name,
      details: params.details,
      googlePlayStore: params.googlePlayStore,
      appleAppStore: params.appleAppStore,
      github: params.github,
      newImages: params.newImages,
    );
  }
}
