import 'package:academia/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AcademiaAppBar extends StatelessWidget {
  const AcademiaAppBar({super.key});

  String customGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) {
      return "Good morning!";
    } else if (hour < 14) {
      return "Hope you're having a fantastic day.";
    } else if (hour < 18) {
      return "Afternoon! Keep up the great work.";
    } else if (hour < 20) {
      return "Relax and unwind, you've earned it.";
    } else {
      return "Have some sleep.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverPinnedHeader(
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (stateA, stateB) {
          if (stateB is AuthenticatedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) => Container(
          padding: EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              GestureDetector(
                onTap: ()=> context.pushNamed("profile"),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/cake.png"),
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi there ${(state as AuthenticatedState).user.firstname}!",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ).animate(delay: 500.ms).moveY(
                        duration: 1000.ms,
                        begin: -10,
                        end: 0,
                        curve: Curves.bounceInOut,
                      ),
                  Text(
                    customGreeting(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ).animate(delay: 1000.ms).moveX(
                        begin: -20,
                        end: 0,
                        duration: 500.ms,
                        curve: Curves.easeInSine,
                      ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    width: 1.5,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: Icon(
                  Clarity.bell_solid,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
