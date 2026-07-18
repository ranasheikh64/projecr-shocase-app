import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'features/projects/data/datasources/project_local_datasource.dart';
import 'features/projects/data/datasources/project_remote_datasource.dart';
import 'features/projects/data/models/project_model.dart';
import 'features/projects/data/repositories/project_repository_impl.dart';
import 'features/projects/domain/repositories/project_repository.dart';
import 'features/projects/domain/usecases/create_project_usecase.dart';
import 'features/projects/domain/usecases/delete_project_usecase.dart';
import 'features/projects/domain/usecases/get_all_projects_usecase.dart';
import 'features/projects/domain/usecases/get_single_project_usecase.dart';
import 'features/projects/domain/usecases/update_project_usecase.dart';
import 'features/projects/presentation/bloc/project_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── Hive ────────────────────────────────────────────────────
  Hive.registerAdapter(ProjectModelAdapter());
  final projectBox = await Hive.openBox<ProjectModel>(AppConstants.projectsBox);

  // ─── Core ────────────────────────────────────────────────────
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // ─── Data Sources ─────────────────────────────────────────────
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(dioClient: sl()),
  );
  sl.registerLazySingleton<ProjectLocalDataSource>(
    () => ProjectLocalDataSourceImpl(projectBox: projectBox),
  );

  // ─── Repository ───────────────────────────────────────────────
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ─── Use Cases ────────────────────────────────────────────────
  sl.registerLazySingleton(() => GetAllProjectsUseCase(sl()));
  sl.registerLazySingleton(() => GetSingleProjectUseCase(sl()));
  sl.registerLazySingleton(() => CreateProjectUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProjectUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProjectUseCase(sl()));

  // ─── BLoC ─────────────────────────────────────────────────────
  sl.registerFactory(
    () => ProjectBloc(
      getAllProjectsUseCase: sl(),
      getSingleProjectUseCase: sl(),
      createProjectUseCase: sl(),
      updateProjectUseCase: sl(),
      deleteProjectUseCase: sl(),
    ),
  );
}
