import 'package:academia/features/ask_me/bloc/ask_me_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sliver_tools/sliver_tools.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int? selectedIndex;
  bool isAnswered = false;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text("Confirm Exit"),
                          content: const Text("Are you sure you want to quit?"),
                          actions: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                context.pop(); // Dismiss dialog
                                context.pop();
                                context
                                    .read<AskMeBloc>()
                                    .add(CompleteQuestions());
                              },
                              child: const Text("Quit"),
                            ),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.arrow_back)),
            centerTitle: true,
            title: BlocBuilder<AskMeBloc, AskMeState>(
              buildWhen: (previous, current) {
                if (previous is QuestionState && current is QuestionState) {
                  return previous.questionIndex != current.questionIndex;
                }
                return previous.runtimeType != current.runtimeType;
              },
              builder: (context, state) {
                if (state is QuestionState) {
                  return Text(
                    "${state.questionIndex + 1} of ${state.total}",
                    style: theme.textTheme.titleLarge,
                  );
                }
                return Text("Quiz", style: theme.textTheme.titleLarge);
              },
            ),
            actions: [
              BlocBuilder<AskMeBloc, AskMeState>(
                buildWhen: (previous, current) {
                  if (previous is QuestionState && current is QuestionState) {
                    return previous.remainingTime != current.remainingTime;
                  }
                  return previous.runtimeType != current.runtimeType;
                },
                builder: (context, state) {
                  if (state is QuestionState && state.remainingTime > 0) {
                    final minutes = state.remainingTime ~/ 60;
                    final seconds = state.remainingTime % 60;
                    final timeFormatted =
                        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Text(
                        timeFormatted,
                        style: theme.textTheme.titleLarge,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: MultiSliver(
              children: [
                BlocConsumer<AskMeBloc, AskMeState>(
                    listenWhen: (previous, current) {
                  if (previous is QuestionState && current is QuestionState) {
                    return previous.questionIndex != current.questionIndex;
                  }
                  return false;
                }, listener: (context, state) {
                  setState(() {
                    selectedIndex = null;
                    isAnswered = false;
                  });
                }, buildWhen: (previous, current) {
                  if (previous is QuestionState && current is QuestionState) {
                      return previous.questionIndex != current.questionIndex;
                    }
                    return previous.runtimeType != current.runtimeType;
                }, builder: (context, state) {
                  if (state is QuestionState) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          LinearProgressIndicator(
                            value: (state.questionIndex + 1) / state.total,
                            minHeight: 10,
                            backgroundColor:
                                theme.colorScheme.secondaryContainer,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(20),
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.outlineVariant,
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    state.currentQuestion.question,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Column(
                                  children: List.generate(
                                    state.currentQuestion.choices.length,
                                    (index) {
                                      final isSelected = selectedIndex == index;
                                      final isCorrect = state
                                              .currentQuestion.choices[index] ==
                                          state.currentQuestion.correctAnswer;

                                      return Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? theme
                                                  .colorScheme.primaryContainer
                                              : theme.colorScheme.surface,
                                          border: Border.all(
                                            color: theme.colorScheme.outline,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          },
                                          leading: Radio<int>(
                                            value: index,
                                            groupValue: selectedIndex,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedIndex = value;
                                              });
                                            },
                                          ),
                                          title: Text(
                                            state
                                                .currentQuestion.choices[index],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          trailing: isAnswered
                                              ? Icon(
                                                  isCorrect
                                                      ? Icons.check
                                                      : Icons.close,
                                                  color: isCorrect
                                                      ? Colors.green
                                                      : Colors.red,
                                                )
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (isAnswered)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Correct Answer is ${state.currentQuestion.correctAnswer}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          FilledButton(
                            onPressed: () {
                              if (isAnswered) {
                                context.read<AskMeBloc>().add(NextQuestion());
                              } else if (selectedIndex != null) {
                                setState(() {
                                  isAnswered = true;
                                });
                                context.read<AskMeBloc>().add(SubmitAnswer(
                                    answer: state.currentQuestion
                                        .choices[selectedIndex!]));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please select an answer.")),
                                );
                              }
                            },
                            child: Text(isAnswered ? "Next" : "Submit"),
                          ),
                        ],
                      ),
                    );
                  }
                  return SizedBox(
                    child: Text("State is $state"),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
