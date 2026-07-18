import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/projects/presentation/bloc/project_bloc.dart';
import 'features/projects/presentation/screens/projects_list_screen.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.bgDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize dependencies
  await di.initDependencies();

  runApp(const PortfolioAdminApp());
}

class PortfolioAdminApp extends StatelessWidget {
  const PortfolioAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectBloc>(
      create: (_) => di.sl<ProjectBloc>(),
      child: MaterialApp(
        title: 'DevUpload',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const ProjectsListScreen(),
      ),
    );
  }
}
