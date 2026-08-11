import 'package:hive/hive.dart';
import '../../domain/entities/project_entity.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String details;

  @HiveField(3)
  final String googlePlayStoreLink;

  @HiveField(4)
  final String github;

  @HiveField(5)
  final List<String> images;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime updatedAt;

  @HiveField(8)
  final String appleAppStoreLink;

  ProjectModel({
    required this.id,
    required this.name,
    required this.details,
    required this.googlePlayStoreLink,
    required this.appleAppStoreLink,
    required this.github,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  // From JSON (API response)
  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      details: json['details'] as String? ?? '',
      googlePlayStoreLink: json['googlePlayStoreLink'] as String? ?? '',
      appleAppStoreLink: json['appleAppStoreLink'] as String? ?? '',
      github: json['github'] as String? ?? '',
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'details': details,
      'googlePlayStoreLink': googlePlayStoreLink,
      'appleAppStoreLink': appleAppStoreLink,
      'github': github,
      'images': images,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert to domain entity
  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      name: name,
      details: details,
      googlePlayStoreLink: googlePlayStoreLink,
      appleAppStoreLink: appleAppStoreLink,
      github: github,
      images: images,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convert from domain entity
  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      details: entity.details,
      googlePlayStoreLink: entity.googlePlayStoreLink,
      appleAppStoreLink: entity.appleAppStoreLink,
      github: entity.github,
      images: entity.images,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ProjectModel copyWith({
    String? id,
    String? name,
    String? details,
    String? googlePlayStoreLink,
    String? appleAppStoreLink,
    String? github,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      details: details ?? this.details,
      googlePlayStoreLink: googlePlayStoreLink ?? this.googlePlayStoreLink,
      appleAppStoreLink: appleAppStoreLink ?? this.appleAppStoreLink,
      github: github ?? this.github,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
