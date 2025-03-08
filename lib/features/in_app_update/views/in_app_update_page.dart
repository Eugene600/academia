import 'package:academia/exports/barrel.dart';
import 'package:academia/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppUpdatePage extends StatefulWidget {
  const InAppUpdatePage({super.key});

  @override
  State<InAppUpdatePage> createState() => _InAppUpdatePageState();
}

class _InAppUpdatePageState extends State<InAppUpdatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<InAppUpdateCubit, InAppUpdateState>(
        listener: (context, state) {
          if (state is InAppUpdateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
            return;
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              pinned: true,
              title: SvgPicture.asset("assets/logos/google_play.svg"),
            ),
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: MultiSliver(
                children: [
                  SizedBox(height: 28),
                  Text(
                    "Update available",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "To use this app, download the latest version.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 22),
                  ListTile(
                    leading: Image.asset(
                      "assets/icons/academia.png",
                    ),
                    title: Text("Academia"),
                    subtitle: Text("com.dita.academia"),
                  ),
                  SizedBox(height: 22),
                  ListTile(
                    title: Text(
                      "What's new",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Visit the google playstore to learn what's new",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final Uri url = Uri.parse(
                          'https://play.google.com/store/apps/details?id=com.dita.academia',
                        );
                        if (!await launchUrl(url)) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      icon: Icon(Clarity.store_solid),
                    ),
                  ),
                  SizedBox(height: 22),
                  BlocBuilder<InAppUpdateCubit, InAppUpdateState>(
                      builder: (context, state) {
                    if (state is InAppUpdateLoading) {
                      return LinearProgressIndicator();
                    }
                    return Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text("Update Required"),
                                        content: Text(
                                            "Security fixes and bug updates are available. If you choose to cancel, the app will terminate. Please update to continue."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              exit(0);
                                            },
                                            child: Text("Quit Anyway"),
                                          ),
                                          FilledButton(
                                            onPressed: () {
                                              BlocProvider.of<InAppUpdateCubit>(
                                                      context)
                                                  .performUpdate();
                                            },
                                            child: Text("Update Now"),
                                          )
                                        ],
                                      ));
                            },
                            child: Text("Cancel"),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              final res =
                                  await BlocProvider.of<InAppUpdateCubit>(
                                          context)
                                      .performUpdate();
                              if (!context.mounted) return;
                              if (res == AppUpdateResult.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Success")));
                                return;
                              }
                              if (res == AppUpdateResult.userDeniedUpdate) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("User canceled"),
                                  ),
                                );
                                return;
                              }

                              if (res == AppUpdateResult.inAppUpdateFailed) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Failed to update app please use playstore"),
                                  ),
                                );
                                return;
                              }
                            },
                            child: Text("Update now"),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
