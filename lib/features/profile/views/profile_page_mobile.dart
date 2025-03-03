import 'package:academia/constants/common.dart';
import 'package:academia/database/database.dart';
import 'package:academia/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:vibration/vibration.dart';

class ProfilePageMobile extends StatefulWidget {
  const ProfilePageMobile({super.key});

  @override
  State<ProfilePageMobile> createState() => _ProfilePageMobileState();
}

class _ProfilePageMobileState extends State<ProfilePageMobile> {
  late UserData user;

  bool notify = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotificationCubit>(context)
        .hasNotificationAccess()
        .then((granted) {
      setState(() {
        notify = granted;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                spacing: 12,
                children: [
                  CircularProgressIndicator(),
                  Text("Just a momement"),
                ],
              ),
            ),
          );
          return;
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          return;
        }
        if (state is UnauthenticatedState) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message ?? "Goodbye ${user.firstname}"),
            ),
          );

          return context.goNamed("auth");
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (stateA, stateB) {
          if (stateB is AuthenticatedState) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          final user = (state as AuthenticatedState).user;
          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPinnedHeader(
                  child: Visibility(
                    visible: state is AuthLoadingState ? true : false,
                    child: LinearProgressIndicator(),
                  ),
                ),
                SliverPinnedHeader(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Column(
                      spacing: 8,
                      children: [
                        CircleAvatar(
                          radius: 60,
                        ),
                        SizedBox(height: 2),
                        Text(
                          "@${user.username.toLowerCase()}",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        Text(
                          "${user.email}",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: 2),
                        Row(
                          spacing: 12,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Clarity.pencil_line),
                            ),
                            FilledButton.icon(
                              icon: Icon(Clarity.id_badge_line),
                              onPressed: () {},
                              label: Text("Show digital school ID"),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Clarity.menu_line),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(12),
                  sliver: MultiSliver(
                    children: [
                      Text(
                        "Bio Data",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 12),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: ListTile(
                          leading: const Icon(Clarity.user_line),
                          title: Text("${user.firstname} ${user.othernames}"),
                          subtitle: Text(
                            "Official name",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(),
                        ),
                        child: ListTile(
                          leading: const Icon(Clarity.id_badge_line),
                          title: Text(user.nationalId),
                          subtitle: Text(
                            "National ID",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(),
                        ),
                        child: ListTile(
                          leading: Icon(
                            user.gender == "male"
                                ? Bootstrap.gender_male
                                : Bootstrap.gender_female,
                          ),
                          title: Text(user.gender.title()),
                          subtitle: Text(
                            "Gender",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Clarity.host_solid_badged),
                          title: Text(
                            user.active ? "Active" : "Inactive",
                          ),
                          subtitle: Text(
                            "Status",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),

                      // Profile

                      // Preferences
                      SizedBox(height: 22),
                      Text(
                        "Academia Profile",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 12),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(Clarity.host_solid_badged),
                          title: Text(""),
                          subtitle: Text(
                            "Status",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),

                      // Preferences
                      SizedBox(height: 22),
                      Text(
                        "Preferences",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 12),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 2),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: SwitchListTile(
                          title: Text("Allow Push Notifications"),
                          value: notify,
                          onChanged: (val) async {
                            if (!val) {
                              notify = await BlocProvider.of<NotificationCubit>(
                                      context)
                                  .revokePermission(user);
                            } else {
                              notify = await BlocProvider.of<NotificationCubit>(
                                      context)
                                  .requestPermission(user);
                            }

                            if (await Vibration.hasVibrator()) {
                              Vibration.vibrate(duration: 32, amplitude: 255);
                            }

                            setState(() {});
                          },
                        ).animate(delay: 1000.ms).scale(
                              curve: Curves.easeIn,
                              duration: 500.ms,
                            ),
                      ),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 2),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(),
                        ),
                        child: SwitchListTile.adaptive(
                          title: Text("Biometric Lock"),
                          value: true,
                          onChanged: (val) {},
                        ),
                      ),
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.only(bottom: 2),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context).add(
                              LogoutRequested(user: user),
                            );
                          },
                          trailing: Icon(Clarity.logout_line),
                          title: Text("Logout"),
                          subtitle: Text(
                            "Leave the application",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
