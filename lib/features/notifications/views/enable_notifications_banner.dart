import 'package:academia/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class EnableNotificationsBanner extends StatefulWidget {
  const EnableNotificationsBanner({super.key});

  @override
  State<EnableNotificationsBanner> createState() =>
      _EnableNotificationsBannerState();
}

class _EnableNotificationsBannerState extends State<EnableNotificationsBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      height: 160,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          spacing: 12,
          children: [
            Text(
              "Notifications permissions are off please grant notification permissions to stay updated 🫠",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton.icon(
                  style: ElevatedButton.styleFrom(
                    iconColor: Colors.white,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                  ),
                  icon: Icon(Clarity.bell_line),
                  onPressed: () async {
                    if (!context.mounted) return;

                    final user = (BlocProvider.of<AuthBloc>(context).state
                            as AuthenticatedState)
                        .user;
                    await BlocProvider.of<NotificationCubit>(context)
                        .requestPermission(user);

                    setState(() {});
                  },
                  label: Text("Grant Permission"),
                )
                    .animate(
                        delay: 1000.ms,
                        onComplete: (controller) async {
                          if (await Vibration.hasVibrator()) {
                            await Vibration.vibrate(
                              preset: VibrationPreset.dramaticNotification,
                            );
                          }
                        })
                    .shake(
                      duration: 250.ms,
                    )
              ],
            )
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: 1500.ms,
          curve: Curves.easeIn,
        );
  }
}
