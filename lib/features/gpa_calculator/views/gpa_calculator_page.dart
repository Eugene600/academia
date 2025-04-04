import 'package:academia/features/courses/courses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GpaCalculatorPage extends StatefulWidget {
  const GpaCalculatorPage({super.key});

  @override
  State<GpaCalculatorPage> createState() => _GpaCalculatorPageState();
}

class _GpaCalculatorPageState extends State<GpaCalculatorPage> {
  int hoursBetween(String timeRange) {
    List<String> times = timeRange.split('-'); // Split input by '-'
    DateFormat format = DateFormat("hh:mm a");

    DateTime startTime = format.parse(times[0].trim());
    DateTime endTime = format.parse(times[1].trim());

    return endTime.difference(startTime).inHours;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("GPA Calculator"),
            ),
          ),
          BlocBuilder<CourseCubit, CourseState>(builder: (context, state) {
            if (state is CourseStateLoaded) {
              return SliverList.builder(
                itemBuilder: (context, index) {
                  final course = state.courses[index];
                  print(course.period);
                  return Card(
                    elevation: 0,
                    child: ListTile(
                      title: Text(course.unit),
                      leading: Text("A"),
                      trailing: Text(hoursBetween(course.period).toString()),
                    ),
                  );
                },
                itemCount: state.courses.length,
              );
            }
            return SliverToBoxAdapter(
              child: Text("Hello"),
            );
          })
        ],
      ),
    );
  }
}
