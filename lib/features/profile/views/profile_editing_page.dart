import 'package:academia/features/profile/profile.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ProfileEditingPage extends StatefulWidget {
  const ProfileEditingPage({super.key});

  @override
  State<ProfileEditingPage> createState() => _ProfileEditingPageState();
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  final formstate = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
            return;
          }
          if (state is ProfileLoadedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Your profile has been successfully updated"),
              ),
            );
            return;
          }
        },
        child: Form(
          key: formstate,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Academia"),
                ),
              ),
              SliverPinnedHeader(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: Row(
                    children: [
                      Lottie.asset(
                        "assets/lotties/bunny.json",
                        height: 160,
                      ),
                      Flexible(
                        child: Text(
                          "Change your academia profile",
                          style: Theme.of(context).textTheme.titleLarge,
                        ).animate().moveX(begin: -10, end: 3, duration: 500.ms),
                      ),
                    ],
                  ),
                ),
              ),

              // Form to modify the user profile
              SliverPadding(
                padding: EdgeInsets.all(12),
                sliver: MultiSliver(
                  children: [
                    // Form
                    TextFormField(
                      controller: _controller,
                      textAlign: TextAlign.center,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "Please provide your bio",
                        label: const Text("Your Bio"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),

                    SizedBox(height: 12),
                    BlocBuilder<ProfileCubit, ProfileState>(
                        buildWhen: (stateA, stateB) {
                      if (stateA is ProfileLoadedState) return true;
                      if (stateA is ProfileLoadingState) return true;
                      return false;
                    }, builder: (context, state) {
                      if (state is ProfileLoadingState) {
                        return Lottie.asset(
                          "assets/lotties/fetching.json",
                          height: 40,
                          width: 40,
                        );
                      }
                      return FilledButton(
                        onPressed: () {
                          BlocProvider.of<ProfileCubit>(context)
                              .updateUserProfile(
                            (state as ProfileLoadedState)
                                .profile
                                .copyWith(bio: Value(_controller.text)),
                          );
                        },
                        child: Text("Update profile"),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
