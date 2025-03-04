import 'package:academia/exports/barrel.dart';
import 'package:academia/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ComingSoonPage extends StatefulWidget {
  const ComingSoonPage({super.key});

  @override
  State<ComingSoonPage> createState() => _ComingSoonPageState();
}

class _ComingSoonPageState extends State<ComingSoonPage> {
  bool notify = false;

  late DateTime nextTuesday;

  @override
  void initState() {
    super.initState();
    nextTuesday = _getNextTuesday();
    //nextTuesday = _getNextTuesday();
    BlocProvider.of<NotificationCubit>(context)
        .hasNotificationAccess()
        .then((granted) {
      setState(() {
        notify = granted;
      });
    });
  }

  DateTime _getNextTuesday() {
    DateTime now = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
    int daysToAdd = (DateTime.tuesday - now.weekday + 7) % 7;
    daysToAdd = daysToAdd == 0 ? 7 : daysToAdd;
    return now.add(Duration(days: daysToAdd));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Academia"),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(12),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Lottie.asset(
                    "assets/lotties/coming-soon.json",
                    repeat: false,
                  ),
                  //
                  BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                    if (state is AuthenticatedState) {
                      return Text(
                        "Jambo ${state.user.firstname}! 👋🏾",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      );
                    }
                    return Text("Hello");
                  }),
                  SizedBox(height: 4),
                  Text(
                    "We're hard at work to improve Academia! Stay tuned for awesome new features rolling out over the next few weeks! ",
                    style: Theme.of(context).textTheme.bodySmall,
                    //fontFamily: GoogleFonts.dynaPuff().fontFamily),
                    textAlign: TextAlign.left,
                  ).animate().moveX(
                        begin: -5,
                        end: 0,
                        duration: 250.ms,
                        curve: Curves.easeInCubic,
                      ),

                  // timer count down

                  SizedBox(height: 22),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: TimerCountdown(
                      timeTextStyle:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontFamily: GoogleFonts.dynaPuff().fontFamily,
                              ),
                      format: CountDownTimerFormat.daysHoursMinutesSeconds,
                      endTime: nextTuesday,
                      onEnd: () {},
                    ),
                  ),
                  // notify me button
                  SizedBox(height: 16),

                  Visibility(
                    visible: !notify,
                    child: Card(
                      elevation: 0,
                      child: SwitchListTile(
                        title: Text("Notify me when feature is up"),
                        value: notify,
                        onChanged: (val) async {
                          final user = (BlocProvider.of<AuthBloc>(context).state
                                  as AuthenticatedState)
                              .user;
                          notify =
                              await BlocProvider.of<NotificationCubit>(context)
                                  .requestPermission(user);

                          setState(() {});
                        },
                      ).animate(delay: 1000.ms).shake(
                            curve: Curves.easeIn,
                            duration: 500.ms,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
