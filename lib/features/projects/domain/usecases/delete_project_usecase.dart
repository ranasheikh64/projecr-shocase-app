import '../repositories/project_repository.dart';

class DeleteProjectUseCase {
  final ProjectRepository repository;

  DeleteProjectUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteProject(id);
  }
}
