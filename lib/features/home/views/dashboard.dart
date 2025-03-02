import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sliver_tools/sliver_tools.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Academia").animate(delay: 250.ms).moveY(
                      curve: Curves.easeInQuint,
                      duration: 1000.ms,
                      begin: -20,
                      end: 0,
                    ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: MultiSliver(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
