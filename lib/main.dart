import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wasel_task/core/di/dependencies.dart';
import 'package:wasel_task/core/router/app_router.dart';
import 'package:wasel_task/core/services/firebase_service.dart';
import 'package:wasel_task/core/theme/app_theme.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await FirebaseService.initialize();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    // Handle the error appropriately in your app
  }
  
  // Initialize dependencies
  await initializeDependencies();
  
  // Run the app
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Add your BLoCs here
      ],
      child: MaterialApp.router(
        title: 'Wasel Task',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up dependencies when the app is closed
    disposeDependencies();
    super.dispose();
  }
}
