import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:wasel_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wasel_task/features/auth/presentation/bloc/auth_state.dart';

class ProtectedRoute extends StatefulWidget {
  final Widget child;
  final String redirectPath;

  const ProtectedRoute({
    Key? key,
    required this.child,
    this.redirectPath = '/login',
  }) : super(key: key);

  @override
  State<ProtectedRoute> createState() => _ProtectedRouteState();
}

class _ProtectedRouteState extends State<ProtectedRoute> {
  bool _isRedirecting = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is! Authenticated && !_isRedirecting) {
          _isRedirecting = true;
          // Use a post-frame callback to avoid build context issues
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final currentPath = GoRouterState.of(context).uri.toString();
            context.go('${widget.redirectPath}?returnUrl=\${Uri.encodeComponent(currentPath)}');
          });
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return widget.child;
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

GoRoute protectedRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  String? redirectPath,
}) {
  return GoRoute(
    path: path,
    builder: (context, state) => ProtectedRoute(
      redirectPath: redirectPath ?? '/login',
      child: builder(context, state),
    ),
  );
}
