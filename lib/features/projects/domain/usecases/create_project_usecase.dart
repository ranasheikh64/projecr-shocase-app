import 'dart:io';
import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class CreateProjectParams {
  final String name;
  final String details;
  final String liveLink;
  final String github;
  final List<File> images;

  const CreateProjectParams({
    required this.name,
    required this.details,
    required this.liveLink,
    required this.github,
    required this.images,
  });
}

class CreateProjectUseCase {
  final ProjectRepository repository;

  CreateProjectUseCase(this.repository);

  Future<ProjectEntity> call(CreateProjectParams params) {
    return repository.createProject(
      name: params.name,
      details: params.details,
      liveLink: params.liveLink,
      github: params.github,
      images: params.images,
    );
  }
}
