import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wasel_task/core/di/dependencies.dart';
import 'package:wasel_task/core/di/injection.dart';
import 'package:wasel_task/core/router/app_router.dart';
import 'package:wasel_task/core/services/firebase_service.dart';
import 'package:wasel_task/core/theme/app_theme.dart';
import 'package:wasel_task/features/auth/domain/entities/user_entity.dart';
import 'package:wasel_task/features/auth/domain/repositories/auth_repository.dart';
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
  
  // Configure dependencies using GetIt
  await configureDependencies();
  
  // Initialize manual dependencies
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
  late final AuthBloc _authBloc;
  
  @override
  void initState() {
    super.initState();
    _authBloc = GetIt.instance<AuthBloc>();
    
    // Initial authentication check
    final currentUser = GetIt.instance<AuthRepository>().currentUser;
    if (currentUser != null) {
      _authBloc.add(AuthStateChanged(currentUser));
    } else {
      _authBloc.add(const AuthStateChanged(UserEntity.empty));
    }
  }
  
  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth Bloc - The AuthBloc will automatically check auth state on creation
        BlocProvider<AuthBloc>.value(
          value: _authBloc,
        ),
        // Product Bloc
        BlocProvider<ProductBloc>(
          create: (context) => GetIt.instance<ProductBloc>(),
        ),
        // Cart Bloc
        BlocProvider<CartBloc>(
          create: (context) => GetIt.instance<CartBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: 'Wasel Task',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter(context, authBloc: _authBloc).router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
