import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getAllProjects();
  Future<ProjectModel> getSingleProject(String id);
  Future<ProjectModel> createProject({
    required String name,
    required String details,
    required String liveLink,
    required String github,
    required List<File> images,
  });
  Future<ProjectModel> updateProject({
    required String id,
    String? name,
    String? details,
    String? liveLink,
    String? github,
    List<File>? newImages,
  });
  Future<void> deleteProject(String id);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final DioClient dioClient;

  ProjectRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ProjectModel>> getAllProjects() async {
    final response = await dioClient.dio.get(AppConstants.projectsEndpoint);
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ProjectModel> getSingleProject(String id) async {
    final response = await dioClient.dio
        .get('${AppConstants.projectsEndpoint}/$id');
    return ProjectModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProjectModel> createProject({
    required String name,
    required String details,
    required String liveLink,
    required String github,
    required List<File> images,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'details': details,
      'liveLink': liveLink,
      'github': github,
      'images': await Future.wait(
        images.map(
          (file) async => await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      ),
    });

    final response = await dioClient.dio.post(
      AppConstants.projectsEndpoint,
      data: formData,
    );
    return ProjectModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ProjectModel> updateProject({
    required String id,
    String? name,
    String? details,
    String? liveLink,
    String? github,
    List<File>? newImages,
  }) async {
    final Map<String, dynamic> fields = {};
    if (name != null) fields['name'] = name;
    if (details != null) fields['details'] = details;
    if (liveLink != null) fields['liveLink'] = liveLink;
    if (github != null) fields['github'] = github;

    if (newImages != null && newImages.isNotEmpty) {
      fields['images'] = await Future.wait(
        newImages.map(
          (file) async => await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ),
      );
    }

    final formData = FormData.fromMap(fields);

    final response = await dioClient.dio.put(
      '${AppConstants.projectsEndpoint}/$id',
      data: formData,
    );
    return ProjectModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteProject(String id) async {
    await dioClient.dio.delete('${AppConstants.projectsEndpoint}/$id');
  }
}
