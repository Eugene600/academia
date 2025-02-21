import 'package:academia/features/features.dart';
import 'package:academia/utils/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DefaultRoute extends StatelessWidget {
  const DefaultRoute({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AppLaunchDetected());
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedState) {
            GoRouter.of(context).pushReplacementNamed(AcademiaRouter.home);
          } else if (state is AuthenticatedState) {
            GoRouter.of(context).pushReplacementNamed(AcademiaRouter.home);
          }
        },
        child: const OnboardingPage(),
      ),
    );
  }
}
