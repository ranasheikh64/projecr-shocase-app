import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllProjectsEvent extends ProjectEvent {
  const LoadAllProjectsEvent();
}

class LoadSingleProjectEvent extends ProjectEvent {
  final String id;
  const LoadSingleProjectEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProjectEvent extends ProjectEvent {
  final String name;
  final String details;
  final String liveLink;
  final String github;
  final List<File> images;

  const CreateProjectEvent({
    required this.name,
    required this.details,
    required this.liveLink,
    required this.github,
    required this.images,
  });

  @override
  List<Object?> get props => [name, details, liveLink, github, images];
}

class UpdateProjectEvent extends ProjectEvent {
  final String id;
  final String? name;
  final String? details;
  final String? liveLink;
  final String? github;
  final List<File>? newImages;

  const UpdateProjectEvent({
    required this.id,
    this.name,
    this.details,
    this.liveLink,
    this.github,
    this.newImages,
  });

  @override
  List<Object?> get props => [id, name, details, liveLink, github, newImages];
}

class DeleteProjectEvent extends ProjectEvent {
  final String id;
  const DeleteProjectEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class RefreshProjectsEvent extends ProjectEvent {
  const RefreshProjectsEvent();
}
