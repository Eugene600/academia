import 'package:academia/constants/common.dart';
import 'package:academia/features/courses/courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vibration/vibration.dart';

class CourseDashboardWidget extends StatelessWidget {
  const CourseDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiSliver(
      children: [
        SliverPinnedHeader(
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            child: Text(
              "Academic Dashboard",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),

        // Courses
        BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            if (state is CourseStateLoaded) {
              // Get today's weekday as a string (e.g., "Monday")
              final todayWeekday = DateFormat('EEEE').format(DateTime.now());

              // Filter courses for today's weekday
              final todayCourses = state.courses.where((course) {
                return course.weekDay.toLowerCase() ==
                    todayWeekday.toLowerCase();
              }).toList();

              if (todayCourses.isEmpty) {
                return SliverToBoxAdapter(
                  child: ListTile(
                    onTap: () async {
                      context.pushNamed("courses");
                      if (await Vibration.hasVibrator()) {
                        await Vibration.vibrate(
                          duration: 32,
                          sharpness: 250,
                        );
                      }
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: const Icon(Clarity.certificate_solid_badged),
                    ),
                    title: Text(
                        "Courses you've registered for will show up here."),
                  ),
                );
              }

              return SliverList.separated(
                itemCount: todayCourses.length,
                itemBuilder: (context, index) {
                  final course = todayCourses[index];

                  String cleanString(String input) {
                    return input.replaceAll(RegExp(r'[^0-9:APM ]'), '').trim();
                  }

                  final periodParts = course.period.split('-');
                  bool isLive = false;

                  final startTimeString = cleanString(periodParts[0].trim());
                  final endTimeString = cleanString(periodParts[1].trim());

                  try {
                    final startTime = DateFormat.jm().parse(startTimeString);
                    final endTime = DateFormat.jm().parse(endTimeString);

                    final now = DateTime.now();
                    final periodStart = DateTime(now.year, now.month, now.day,
                        startTime.hour, startTime.minute);
                    final periodEnd = DateTime(now.year, now.month, now.day,
                        endTime.hour, endTime.minute);
                    isLive =
                        now.isAfter(periodStart) && now.isBefore(periodEnd);
                  } catch (e) {
                    debugPrint(e.toString());
                  }

                  return Card(
                    elevation: 1,
                    child: Stack(
                      children: [
                        ListTile(
                          onTap: () async {
                            context.pushNamed("course-view", extra: course);
                            if (await Vibration.hasVibrator()) {
                              await Vibration.vibrate(
                                duration: 32,
                                sharpness: 250,
                              );
                            }
                          },
                          leading: CircleAvatar(
                            backgroundColor: Color(
                              course.color ??
                                  Theme.of(context).colorScheme.primary.value,
                            ).withAlpha(100),
                          ),
                          title: Text("${course.unit} ${course.section}"),
                          subtitle: Text(
                            "${course.weekDay.title()} • ${course.room} •  ${course.period}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        if (isLive)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "In session",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, state) => SizedBox(height: 2),
              );
            }

            return SliverToBoxAdapter(
              child: Text("Courses will appear here"),
            );
          },
        ),
      ],
    );
  }
}
