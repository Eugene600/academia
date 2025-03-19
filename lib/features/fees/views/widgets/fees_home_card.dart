import 'package:academia/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class FeesHomeCard extends StatelessWidget {
  const FeesHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () async {
          // route to fees page
          context.pushNamed("fees");
          if (await Vibration.hasVibrator()) {
            await Vibration.vibrate(
              duration: 32,
              preset: VibrationPreset.doubleBuzz,
              sharpness: 250,
            );
          }
        },
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        leading: Icon(Clarity.coin_bag_solid).animate(
          onComplete: (controller) {
            if (GetIt.instance.get<FlavorConfig>().isProduction) {
              controller.repeat();
            }
          },
        ).shimmer(
          duration: 3000.ms,
          curve: Curves.easeInCirc,
        ),
        title: Text("Fees"),
      ),
    );
  }
}
