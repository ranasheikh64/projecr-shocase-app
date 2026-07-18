import 'package:equatable/equatable.dart';
import '../../domain/entities/project_entity.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object?> get props => [];
}

// --- List States ---
class ProjectInitial extends ProjectState {
  const ProjectInitial();
}

class ProjectsLoading extends ProjectState {
  const ProjectsLoading();
}

class ProjectsLoaded extends ProjectState {
  final List<ProjectEntity> projects;
  const ProjectsLoaded(this.projects);

  @override
  List<Object?> get props => [projects];
}

class ProjectsEmpty extends ProjectState {
  const ProjectsEmpty();
}

// --- Single Project States ---
class SingleProjectLoading extends ProjectState {
  const SingleProjectLoading();
}

class SingleProjectLoaded extends ProjectState {
  final ProjectEntity project;
  const SingleProjectLoaded(this.project);

  @override
  List<Object?> get props => [project];
}

// --- Action States (Create / Update / Delete) ---
class ProjectActionLoading extends ProjectState {
  const ProjectActionLoading();
}

class ProjectCreated extends ProjectState {
  final ProjectEntity project;
  const ProjectCreated(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectUpdated extends ProjectState {
  final ProjectEntity project;
  const ProjectUpdated(this.project);

  @override
  List<Object?> get props => [project];
}

class ProjectDeleted extends ProjectState {
  final String id;
  const ProjectDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

// --- Error State ---
class ProjectError extends ProjectState {
  final String message;
  const ProjectError(this.message);

  @override
  List<Object?> get props => [message];
}
