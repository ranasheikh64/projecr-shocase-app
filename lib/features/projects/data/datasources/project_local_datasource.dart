import 'package:hive/hive.dart';
import '../models/project_model.dart';

abstract class ProjectLocalDataSource {
  Future<List<ProjectModel>> getCachedProjects();
  Future<void> cacheProjects(List<ProjectModel> projects);
  Future<void> cacheProject(ProjectModel project);
  Future<ProjectModel?> getCachedProject(String id);
  Future<void> deleteProjectFromCache(String id);
  Future<void> clearCache();
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final Box<ProjectModel> projectBox;

  ProjectLocalDataSourceImpl({required this.projectBox});

  @override
  Future<List<ProjectModel>> getCachedProjects() async {
    return projectBox.values.toList();
  }

  @override
  Future<void> cacheProjects(List<ProjectModel> projects) async {
    await projectBox.clear();
    final Map<String, ProjectModel> data = {
      for (final p in projects) p.id: p,
    };
    await projectBox.putAll(data);
  }

  @override
  Future<void> cacheProject(ProjectModel project) async {
    await projectBox.put(project.id, project);
  }

  @override
  Future<ProjectModel?> getCachedProject(String id) async {
    return projectBox.get(id);
  }

  @override
  Future<void> deleteProjectFromCache(String id) async {
    await projectBox.delete(id);
  }

  @override
  Future<void> clearCache() async {
    await projectBox.clear();
  }
}
