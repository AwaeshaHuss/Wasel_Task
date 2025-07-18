import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_task/core/di/dependencies.dart';
import 'package:wasel_task/core/router/app_router.dart';
import 'package:wasel_task/core/services/firebase_service.dart';
import 'package:wasel_task/core/theme/app_theme.dart';
import 'package:wasel_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wasel_task/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wasel_task/features/product/presentation/bloc/product_bloc.dart';

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
    final getIt = GetIt.instance;
    
    return MultiBlocProvider(
      providers: [
        // Auth Bloc - The AuthBloc will automatically check auth state on creation
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
        ),
        // Product Bloc
        BlocProvider<ProductBloc>(
          create: (context) => getIt<ProductBloc>(),
        ),
        // Cart Bloc
        BlocProvider<CartBloc>(
          create: (context) => getIt<CartBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Wasel Task',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter(context).router,
            debugShowCheckedModeBanner: false,
          );
        },
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
