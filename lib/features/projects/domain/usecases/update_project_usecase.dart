import 'dart:io';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class UpdateProjectParams {
  final String id;
  final String? name;
  final String? details;
  final String? liveLink;
  final String? github;
  final List<File>? newImages;

  const UpdateProjectParams({
    required this.id,
    this.name,
    this.details,
    this.liveLink,
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
      liveLink: params.liveLink,
      github: params.github,
      newImages: params.newImages,
    );
  }
}
