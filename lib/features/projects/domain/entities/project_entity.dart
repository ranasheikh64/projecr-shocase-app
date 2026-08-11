import 'package:equatable/equatable.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String name;
  final String details;
  final String googlePlayStoreLink;
  final String appleAppStoreLink;
  final String github;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProjectEntity({
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

  @override
  List<Object?> get props => [
        id,
        name,
        details,
        googlePlayStoreLink,
        appleAppStoreLink,
        github,
        images,
        createdAt,
        updatedAt
      ];
}
