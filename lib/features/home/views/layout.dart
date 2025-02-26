import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:vibration/vibration.dart';

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({
    super.key,
    required this.navigationShell,
  });

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        elevation: 2,
        selectedIndex: navigationShell.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        animationDuration: 1000.ms,
        destinations: const [
          NavigationDestination(
            icon: Icon(Clarity.home_solid),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Clarity.calendar_solid),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Clarity.tools_solid),
            label: 'Essentials',
          ),
        ],
        onDestinationSelected: _onTap,
      ),
    );
  }

  void _onTap(index) async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(
        duration: 250,
        sharpness: 250,
      );
    }
    navigationShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active. This example demonstrates how to support this behavior,
      // using the initialLocation parameter of goBranch.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
