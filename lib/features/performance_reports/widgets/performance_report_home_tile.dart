import 'package:academia/features/performance_reports/performance_reports.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';

class PerformanceReportHomeTile extends StatelessWidget {
  const PerformanceReportHomeTile({
    super.key,
    required this.metricType,
    required this.title,
    required this.icon,
    this.bgColor,
  });
  final Widget icon;
  final PerformanceMetricType metricType;
  final String title;
  final MaterialColor? bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: MediaQuery.of(context).size.width * 0.46,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: bgColor?[800] ?? Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: () async {
          context.pushNamed("performance-metric-view", extra: metricType);
          // route to fees page
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(metricType == PerformanceMetricType.audit
                  ? "Audit fetching .."
                  : "Transcript fetching")));
          if (await Vibration.hasVibrator()) {
            await Vibration.vibrate(
              duration: 32,
              preset: VibrationPreset.doubleBuzz,
              sharpness: 250,
            );
          }
        },
        tileColor:
            bgColor?[500] ?? Theme.of(context).colorScheme.primaryContainer,
        leading: icon,
        title: Text(title),
      ),
    );
  }
}
