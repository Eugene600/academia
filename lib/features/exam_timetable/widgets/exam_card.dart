import 'package:academia/database/database.dart';
import 'package:academia/features/exam_timetable/exam_timetable.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:academia/constants/common.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.exam,
    this.hideDelete = false,
  });
  final ExamModelData exam;
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
          initiallyExpanded: DateTime.now().isBefore(exam.examDate),
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
              enabled: exam.examDate.isAfter(DateTime.now()),
              title: Text(
                DateFormat.yMMMMEEEEd().format(exam.examDate),
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
                        DateFormat.Hm().format(exam.examDate),
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
