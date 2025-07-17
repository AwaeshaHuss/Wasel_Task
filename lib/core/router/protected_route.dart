import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  final String? redirectPath;

  const ProtectedRoute({
    Key? key,
    required this.child,
    this.redirectPath = '/login',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return child;
        } else {
          // Redirect to login with return URL
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go(redirectPath!, extra: {
              'returnUrl': GoRouterState.of(context).uri.toString(),
            });
          });
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
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
      redirectPath: redirectPath,
      child: builder(context, state),
    ),
  );
}
