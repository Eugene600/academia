import 'dart:typed_data';
import 'package:academia/features/auth/bloc/auth_bloc.dart';
import 'package:academia/features/home/views/widget/course_dashboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vibration/vibration.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  //bool _isTuesdayBetween8And10AM() {
  //DateTime now = DateTime.now();
  //return now.weekday == DateTime.tuesday && now.hour >= 7 && now.hour < 10;
  //return false;
  // DateTime now = DateTime.now();
  // return now.weekday == DateTime.tuesday && now.hour >= 7 && now.hour < 10;
  //return GetIt.instance<FlavorConfig>().isDevelopment;
  //}

  @override
  Widget build(BuildContext context) {
    final roleresult = BlocProvider.of<AuthBloc>(context).fetchUserRole(
      (BlocProvider.of<AuthBloc>(context).state as AuthenticatedState).user.id,
    );
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: FutureBuilder(
                future: roleresult,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final ok = snapshot.data!.firstWhereOrNull(
                      (elem) =>
                          elem.roleName == "admin" || elem.roleName == "usher",
                    );
                    if (ok == null) return SizedBox();
                    return IconButton(
                      onPressed: () async {
                        context.pushNamed("chapel-attendance");
                        if (await Vibration.hasVibrator()) {
                          await Vibration.vibrate(
                            duration: 32,
                            sharpness: 250,
                          );
                        }
                      },
                      icon: Icon(Clarity.qr_code_line),
                    );
                  }
                  return SizedBox();
                }),
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/diversity.jpg",
                fit: BoxFit.cover,
              ),
              title: Text("Academia").animate(delay: 250.ms).moveY(
                    curve: Curves.easeInCubic,
                    duration: 1000.ms,
                    begin: -20,
                    end: 0,
                  ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  context.goNamed("profile");
                },
                icon: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (stateA, stateB) {
                    if (stateB is AuthenticatedState) return true;
                    return false;
                  },
                  builder: (context, state) => CircleAvatar(
                    backgroundImage: MemoryImage(
                      (state as AuthenticatedState).user.picture ??
                          Uint8List(0),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: CourseDashboardWidget(),
          ),

          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverPinnedHeader(
              child: Container(
                color: Theme.of(context).colorScheme.surface,
                child: Text(
                  "Explore",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),

          // courses
          //SliverPadding(
          //  padding: EdgeInsets.all(12),
          //  sliver: MultiSliver(
          //    children: [
          //      Visibility(
          //        visible: _isTuesdayBetween8And10AM(),
          //        child: ChapelAttendancePage(),
          //      ),
          //    ],
          //  ),
          //),
        ],
      ),
    );
  }
}
