import 'package:academia/features/chapel_attendance/view/chapel_attendance_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sliver_tools/sliver_tools.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  bool _isTuesdayBetween8And10AM() {
    DateTime now = DateTime.now();
    return now.weekday == DateTime.tuesday && now.hour >= 7 && now.hour < 10;
    //return false;
  }

  @override
  Widget build(BuildContext context) {
    return _isTuesdayBetween8And10AM()
        ? Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 200,
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
                      children: [
                        Visibility(
                          visible: _isTuesdayBetween8And10AM(),
                          child: ChapelAttendancePage(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: Text("Home"),
            ),
          );
  }
}
