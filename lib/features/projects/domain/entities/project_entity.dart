import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String name;
  final String details;
  final String googlePlayStore;
  final String appleAppStore;
  final String github;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectEntity({
    required this.id,
    required this.name,
    required this.details,
    required this.googlePlayStore,
    required this.appleAppStore,
    required this.github,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        details,
        googlePlayStore,
        appleAppStore,
        github,
        images,
        createdAt,
        updatedAt
      ];
}
