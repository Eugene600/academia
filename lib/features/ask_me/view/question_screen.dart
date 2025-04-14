import 'package:academia/features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: BlocConsumer<AskMeBloc, AskMeState>(
        listener: (context, state) {
          if (state is QuestionsComplete) {
            //Navigate to scores section
            //will add later
          } else if (state is AskMeErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is QuestionInProgress) {
            // resetAnswer();
          }
        },
        builder: (context, state) {
          if (state is QuestionInProgress) {
            final minutes = state.remainingSeconds ~/ 60;
            final seconds = state.remainingSeconds % 60;
            final timeFormatted =
                "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text("Confirm Exit"),
                                content: const Text(
                                    "Are you sure you want to quit?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => context.pop(),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.pop(); // Dismiss dialog
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
                  title: Text(
                    "${state.questionIndex + 1} of ${state.total}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  actions: [
                    Text(
                      timeFormatted,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
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
                                      final isSelected =
                                          state.selectedOptionIndex == index;
                                      final isCorrect =
                                          state is AnswerResultState &&
                                              state.currentQuestion
                                                      .choices[index] ==
                                                  state.currentQuestion
                                                      .correctAnswer;

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
                                            context.read<AskMeBloc>().add(SelectOption(selectedIndex: index));
                                          },
                                          leading: Radio<int>(
                                            value: index,
                                            groupValue: state.selectedOptionIndex,
                                            onChanged: (value) {
                                              context.read<AskMeBloc>().add(SelectOption(selectedIndex: value!));
                                            },
                                          ),
                                          title: Text(
                                            state
                                                .currentQuestion.choices[index],
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                          trailing: state is AnswerResultState
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
                                if (state is AnswerResultState)
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
                              if (state is AnswerResultState) {
                                context.read<AskMeBloc>().add(NextQuestion());
                              } else if (state.selectedOptionIndex != null) {
                                context.read<AskMeBloc>().add(SubmitAnswer(
                                    answer: state.currentQuestion
                                        .choices[state.selectedOptionIndex!]));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please select an answer.")),
                                );
                              }
                            },
                            child: Text(
                                state is AnswerResultState ? "Next" : "Submit"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is AskMeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Column(
                children: [
                  Text("Unexpected Error Occurred"),
                  FilledButton(
                      onPressed: () => context.pop(), child: Text("Exit"))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
