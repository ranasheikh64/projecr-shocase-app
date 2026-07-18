import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetAllProjectsUseCase {
  final ProjectRepository repository;

  GetAllProjectsUseCase(this.repository);

  Future<List<ProjectEntity>> call() {
    return repository.getAllProjects();
  }
}
