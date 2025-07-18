import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:wasel_task/core/router/go_router_refresh_stream.dart';
import 'package:wasel_task/core/router/protected_route.dart';
import 'package:wasel_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wasel_task/features/auth/presentation/bloc/auth_state.dart';
import 'package:wasel_task/features/auth/presentation/pages/login_screen.dart';
import 'package:wasel_task/features/auth/presentation/pages/register_screen.dart';
import 'package:wasel_task/features/cart/presentation/pages/cart_screen.dart';
import 'package:wasel_task/features/product/presentation/pages/product_detail_screen.dart';
import 'package:wasel_task/features/product/presentation/pages/product_list_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final BuildContext context;
  final AuthBloc authBloc;

  AppRouter(this.context, {required this.authBloc});

  GoRouter get router => _router;

  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Public routes
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const ProductListScreen(),
        routes: [
          GoRoute(
            path: 'product/:id',
            name: 'product',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductDetailScreen(productId: int.parse(id));
            },
          ),
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) {
              final returnUrl = state.uri.queryParameters['returnUrl'];
              return LoginScreen(returnUrl: returnUrl);
            },
          ),
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) {
              return const RegisterScreen();
            },
          ),
        ],
      ),
      
      // Protected routes
      GoRoute(
        path: '/cart',
        name: 'cart',
        builder: (context, state) => const ProtectedRoute(
          child: CartScreen(),
          redirectPath: '/login',
        ),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isLoggedIn = authBloc.state is Authenticated;
      final isAuthRoute = _isAuthRoute(state.uri.path);
      
      // If user is not logged in and trying to access a protected route
      if (!isLoggedIn && !isAuthRoute && state.uri.path != '/') {
        return '/login?returnUrl=${Uri.encodeComponent(state.uri.toString())}';
      }
      
      // If user is logged in and trying to access auth routes, redirect to home
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }
      
      return null;
    },
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
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

// This is now handled by the AppRouter class
