import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';

class GetSingleProjectUseCase {
  final ProjectRepository repository;

  GetSingleProjectUseCase(this.repository);

  Future<ProjectEntity> call(String id) {
    return repository.getSingleProject(id);
  }
}
