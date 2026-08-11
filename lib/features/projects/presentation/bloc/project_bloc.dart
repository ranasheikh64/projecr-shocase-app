import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_project_usecase.dart';
import '../../domain/usecases/delete_project_usecase.dart';
import '../../domain/usecases/get_all_projects_usecase.dart';
import '../../domain/usecases/get_single_project_usecase.dart';
import '../../domain/usecases/update_project_usecase.dart';
import 'project_event.dart';
import 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final GetAllProjectsUseCase getAllProjectsUseCase;
  final GetSingleProjectUseCase getSingleProjectUseCase;
  final CreateProjectUseCase createProjectUseCase;
  final UpdateProjectUseCase updateProjectUseCase;
  final DeleteProjectUseCase deleteProjectUseCase;

  ProjectBloc({
    required this.getAllProjectsUseCase,
    required this.getSingleProjectUseCase,
    required this.createProjectUseCase,
    required this.updateProjectUseCase,
    required this.deleteProjectUseCase,
  }) : super(const ProjectInitial()) {
    on<LoadAllProjectsEvent>(_onLoadAllProjects);
    on<RefreshProjectsEvent>(_onRefreshProjects);
    on<LoadSingleProjectEvent>(_onLoadSingleProject);
    on<CreateProjectEvent>(_onCreateProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
  }

  Future<void> _onLoadAllProjects(
    LoadAllProjectsEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const ProjectsLoading());
    try {
      final projects = await getAllProjectsUseCase();
      if (projects.isEmpty) {
        emit(const ProjectsEmpty());
      } else {
        emit(ProjectsLoaded(projects));
      }
    } catch (e) {
      emit(ProjectError(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onRefreshProjects(
    RefreshProjectsEvent event,
    Emitter<ProjectState> emit,
  ) async {
    try {
      final projects = await getAllProjectsUseCase();
      if (projects.isEmpty) {
        emit(const ProjectsEmpty());
      } else {
        emit(ProjectsLoaded(projects));
      }
    } catch (e) {
      emit(ProjectError(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onLoadSingleProject(
    LoadSingleProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const SingleProjectLoading());
    try {
      final project = await getSingleProjectUseCase(event.id);
      emit(SingleProjectLoaded(project));
    } catch (e) {
      emit(ProjectError(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onCreateProject(
    CreateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const ProjectActionLoading());
    try {
      final project = await createProjectUseCase(
        CreateProjectParams(
          name: event.name,
          details: event.details,
          googlePlayStoreLink: event.googlePlayStoreLink,
          appleAppStoreLink: event.appleAppStoreLink,
          github: event.github,
          images: event.images,
        ),
      );
      emit(ProjectCreated(project));
    } catch (e) {
      emit(ProjectError(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onUpdateProject(
    UpdateProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const ProjectActionLoading());
    try {
      final project = await updateProjectUseCase(
        UpdateProjectParams(
          id: event.id,
          name: event.name,
          details: event.details,
          googlePlayStoreLink: event.googlePlayStoreLink,
          appleAppStoreLink: event.appleAppStoreLink,
          github: event.github,
          newImages: event.newImages,
        ),
      );
      emit(ProjectUpdated(project));
    } catch (e) {
      emit(ProjectError(_mapErrorToMessage(e)));
    }
  }

  Future<void> _onDeleteProject(
    DeleteProjectEvent event,
    Emitter<ProjectState> emit,
  ) async {
    emit(const ProjectActionLoading());
    try {
      await deleteProjectUseCase(event.id);
      emit(ProjectDeleted(event.id));
    } catch (e) {
      emit(ProjectError(_mapErrorToMessage(e)));
    }
  }

  String _mapErrorToMessage(Object error) {
    return error.toString().replaceAll('Exception:', '').trim();
  }
}
