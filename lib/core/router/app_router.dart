import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/cart/presentation/pages/cart_screen.dart';
import '../../features/product/presentation/pages/product_detail_screen.dart';
import '../../features/product/presentation/pages/product_list_screen.dart';
import 'protected_route.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final BuildContext context;

  AppRouter(this.context);

  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Public routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: 'product/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductDetailScreen(productId: int.parse(id));
            },
          ),
          GoRoute(
            path: 'login',
            builder: (context, state) {
              return const LoginScreen();
            },
          ),
          GoRoute(
            path: 'register',
            builder: (context, state) {
              return const RegisterScreen();
            },
          ),
        ],
      ),
      
      // Protected routes
      protectedRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
        redirectPath: '/login',
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authBloc = context.read<AuthBloc>();
      final isLoggedIn = authBloc.state is Authenticated;
      final isAuthRoute = _isAuthRoute(state.uri.path);
      
      if (!isLoggedIn && !isAuthRoute) {
        return state.namedLocation(
          'login',
          queryParameters: {'returnUrl': state.uri.toString()},
        );
      }
      
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );

  bool _isAuthRoute(String path) {
    final authRoutes = ['/login', '/register'];
    return authRoutes.any((route) => path.startsWith(route));
  }
}

// Global router instance with a dummy context for initialization
// This will be replaced with the actual context in main.dart
final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    ),
  ],
);
