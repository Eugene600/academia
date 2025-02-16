import 'package:academia/features/features.dart';
import 'package:academia/utils/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(AppLaunchDetected());
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 80,
              child: Lottie.asset(
                "assets/lotties/bunny.json",
              ),
            ),
            const Spacer(),
            Expanded(
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Text(
                    "A scholarly haven for students, crafted by students. 📜✨",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontFamily: GoogleFonts.marcellus().fontFamily,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    return state is AuthInitialState ||
                            state is AuthLoadingState
                        ? const CircularProgressIndicator.adaptive()
                        : FilledButton(
                            onPressed: () {
                              GoRouter.of(context).pushNamed(
                                AcademiaRouter.auth,
                              );
                            },
                            child: const Text("Get Started"),
                          );
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
