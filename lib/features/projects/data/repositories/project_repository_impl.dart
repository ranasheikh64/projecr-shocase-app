import 'dart:io';
import 'package:dio/dio.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/project_local_datasource.dart';
import '../datasources/project_remote_datasource.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final ProjectLocalDataSource localDataSource;

  ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<ProjectEntity>> getAllProjects() async {
    try {
      // Try remote first
      final models = await remoteDataSource.getAllProjects();
      // Update cache
      await localDataSource.cacheProjects(models);
      return models.map((m) => m.toEntity()).toList();
    } on DioException {
      // Fallback to cache on network error
      final cached = await localDataSource.getCachedProjects();
      if (cached.isNotEmpty) {
        return cached.map((m) => m.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<ProjectEntity> getSingleProject(String id) async {
    try {
      final model = await remoteDataSource.getSingleProject(id);
      await localDataSource.cacheProject(model);
      return model.toEntity();
    } on DioException {
      final cached = await localDataSource.getCachedProject(id);
      if (cached != null) return cached.toEntity();
      rethrow;
    }
  }

  @override
  Future<ProjectEntity> createProject({
    required String name,
    required String details,
    required String googlePlayStore,
    required String appleAppStore,
    required String github,
    required List<File> images,
  }) async {
    final model = await remoteDataSource.createProject(
      name: name,
      details: details,
      googlePlayStore: googlePlayStore,
      appleAppStore: appleAppStore,
      github: github,
      images: images,
    );
    await localDataSource.cacheProject(model);
    return model.toEntity();
  }

  @override
  Future<ProjectEntity> updateProject({
    required String id,
    String? name,
    String? details,
    String? googlePlayStore,
    String? appleAppStore,
    String? github,
    List<File>? newImages,
  }) async {
    final model = await remoteDataSource.updateProject(
      id: id,
      name: name,
      details: details,
      googlePlayStore: googlePlayStore,
      appleAppStore: appleAppStore,
      github: github,
      newImages: newImages,
    );
    await localDataSource.cacheProject(model);
    return model.toEntity();
  }

  @override
  Future<void> deleteProject(String id) async {
    await remoteDataSource.deleteProject(id);
    await localDataSource.deleteProjectFromCache(id);
  }
}
