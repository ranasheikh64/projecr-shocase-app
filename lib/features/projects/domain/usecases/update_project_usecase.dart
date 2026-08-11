import 'dart:io';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class UpdateProjectParams {
  final String id;
  final String? name;
  final String? details;
  final String? googlePlayStoreLink;
  final String? appleAppStoreLink;
  final String? github;
  final List<File>? newImages;

  const UpdateProjectParams({
    required this.id,
    this.name,
    this.details,
    this.googlePlayStoreLink,
    this.appleAppStoreLink,
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
      googlePlayStoreLink: params.googlePlayStoreLink,
      appleAppStoreLink: params.appleAppStoreLink,
      github: params.github,
      newImages: params.newImages,
    );
  }
}
