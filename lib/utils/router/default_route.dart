import 'package:academia/features/features.dart';
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
        listener: (context, state) async {
          await Future.delayed(Duration(seconds: 2));

          if (!context.mounted) return;
          if (state is AuthenticatedState) {
            return context.goNamed("dashboard");
          }
        },
        child: const OnboardingPage(),
      ),
    );
  }
}
