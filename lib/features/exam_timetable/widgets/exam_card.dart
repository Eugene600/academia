import 'package:academia/database/database.dart';
import 'package:academia/exports/barrel.dart';
import 'package:academia/features/features.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.exam,
    this.ispast = false,
    this.hideDelete = false,
  });
  final ExamModelData exam;
  final bool ispast;
  final bool hideDelete;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // color: ispast
          //     ? Theme.of(context).colorScheme.secondaryContainer
          //     : Theme.of(context).colorScheme.primaryContainer,
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(exam.courseCode.toString()),
          trailing: hideDelete
              ? TextButton(
                  onPressed: () {
                    BlocProvider.of<ExamBloc>(context).add(
                      AddExamToCache(exam: exam),
                    );
                  },
                  child: Text("Add"),
                )
              : IconButton(
                  onPressed: () {
                    BlocProvider.of<ExamBloc>(context).add(
                      RemoveExamFromCache(exam: exam),
                    );
                  },
                  icon: Icon(Clarity.trash_line),
                ),
          children: [
            ListTile(
              enabled: !ispast,
              title: Text(
                exam.day,
              ),
              leading: CircleAvatar(
                child: Text(exam.hours),
              ),
              subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
              subtitle: Column(
                children: [
                  SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Ionicons.location),
                      const SizedBox(width: 4),
                      Text(
                        exam.venue,
                      ),
                      const Spacer(),
                      const Icon(Ionicons.time),
                      const SizedBox(width: 2),
                      Text(
                        exam.time,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  exam.invigilator != null
                      ? Column(children: [
                          Row(
                            children: [
                              Text(
                                "Coordiator: ${exam.invigilator.toString().title()}",
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                "Invigilator ${exam.invigilator.toString().title()}",
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ])
                      : const SizedBox()
                ],
              ),
            ),
          ],
        ));
  }
}
