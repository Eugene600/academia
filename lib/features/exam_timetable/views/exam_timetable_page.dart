import 'package:academia/constants/common.dart';
import 'package:academia/database/database.dart';
import 'package:academia/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sliver_tools/sliver_tools.dart';

class ExamTimeTablePage extends StatefulWidget {
  const ExamTimeTablePage({super.key});

  @override
  State<ExamTimeTablePage> createState() => _ExamTimeTablePageState();
}

class _ExamTimeTablePageState extends State<ExamTimeTablePage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  bool _searchComplete = false;

  late UserData user;

  @override
  void initState() {
    user =
        (BlocProvider.of<AuthBloc>(context).state as AuthenticatedState).user;
    super.initState();

    BlocProvider.of<ExamBloc>(context).add(FetchCachedExams());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExamBloc, ExamState>(
      listener: (context, state) {
        if (state is ExamStateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            final coursestate = (BlocProvider.of<CourseCubit>(context).state);
            if (coursestate is CourseStateLoaded) {
              final List<String> courses = [];
              for (final course in coursestate.courses) {
                courses.add(
                  "${course.unit.replaceAll("-", "")}${course.section.split("-").first}",
                );
              }
              BlocProvider.of<ExamBloc>(context).add(
                FetchExamsEvent(courses: courses, autoAdd: true),
              );
            }

            await Future.delayed(Duration(seconds: 2));
          },
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: true,
                expandedHeight: 250,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text("Hi ${user.firstname.title()}!"),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(12),
                sliver: MultiSliver(children: [
                  BlocBuilder<ExamBloc, ExamState>(builder: (context, state) {
                    if (state is ExamStateLoading) {
                      return Column(
                        children: [
                          Lottie.asset(
                            "assets/lotties/cooking.json",
                          ),
                          Text(
                            "Mumble jumble 🌀 – Let me cook some magic! ✨🔮",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      );
                    }

                    if (state is ExamStateLoaded) {
                      return state.userExams.isEmpty
                          ? Column(
                              children: [
                                Lottie.asset("assets/lotties/magic-mage.json"),
                                SizedBox(height: 16),
                                Text(
                                  "Whoops! No exams found. Pull to refresh them and conjure your schedule!",
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : MultiSliver(
                              children: [
                                SliverPinnedHeader(
                                  child: ExamCountDownWidget(
                                      endtime: DateTime.now(), examCount: 6),
                                ),
                                SliverList.separated(
                                    itemCount: state.userExams.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final exam = state.userExams[index];
                                      return ExamCard(exam: exam);
                                    })
                              ],
                            );
                    }

                    if (state is ExamStateError) {
                      return Text(
                        state.error,
                        style: Theme.of(context).textTheme.headlineSmall,
                      );
                    }
                    return SizedBox();
                  }),
                ]),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => StatefulBuilder(
                builder: (context, StateSetter setState) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "BIL 111K, ENG 112, ...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              if (_searchController.text.trim().isEmpty) {
                                return;
                              }

                              BlocProvider.of<ExamBloc>(context)
                                  .add(FetchExamsEvent(
                                courses: _searchController.text.split(","),
                              ));
                            },
                            icon: const Icon(Clarity.search_line),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      BlocBuilder<ExamBloc, ExamState>(
                        builder: (context, state) {
                          if (state is ExamStateLoading) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                              ),
                              child: Text(
                                  "Your wish is my command. Performing forbidden magic 🧞\n Double Tap a course to add it",
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            );
                          }

                          if (state is ExamStateLoaded) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: ListView.builder(
                                  itemCount: state.fetchedExams.length,
                                  itemBuilder: (context, index) {
                                    final exam = state.fetchedExams[index];
                                    return GestureDetector(
                                      onDoubleTap: () async {
                                        BlocProvider.of<ExamBloc>(context).add(
                                          AddExamToCache(exam: exam),
                                        );
                                        setState(() {});
                                      },
                                      child: ExamCard(
                                        exam: exam,
                                        hideDelete: true,
                                      ),
                                    );
                                  }),
                            );
                          }
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                            ),
                            child: Text(
                                "Enter your units, separated by commas, and watch the magic unfold!",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge!),
                          );
                        },
                      ),
                    ]),
                  );
                },
              ),
            );
          },
          child: Icon(Clarity.search_line),
        ),
      ),
    );
  }

  DateTime getExamDate(ExamModelData exam) {
    final formatter = DateFormat('EEEE dd/MM/yy');
    return formatter.parse(exam.day.title());
  }
}
