import 'package:academia/features/features.dart';
import 'package:academia/utils/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Spacer(),
            Lottie.asset(
              "assets/lotties/onboarding.json",
              repeat: false,
              height: 250,
            ),
            //const Spacer(),
            Expanded(
              child: Column(
                spacing: 12,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  Text(
                    "Academia is for you by you, crafted by students, for students",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontFamily: GoogleFonts.marcellus().fontFamily,
                        ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 1000.ms),
                  const SizedBox(height: 12),
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    return state is AuthInitialState ||
                            state is AuthLoadingState
                        ? Lottie.asset(
                            "assets/lotties/loading-bounce.json",
                            height: 80,
                          )
                        : FilledButton(
                            onPressed: () async {
                              if (await Vibration.hasVibrator()) {
                                Vibration.vibrate(amplitude: 32);
                              }
                              if (!context.mounted) return;
                              GoRouter.of(context).pushReplacementNamed(
                                AcademiaRouter.auth,
                              );
                            },
                            child: const Text("Get Started"),
                          )
                            .animate(delay: 1500.ms)
                            .shake()
                            .then(delay: 1000.ms);
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
