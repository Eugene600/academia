import 'package:academia/database/database.dart';
import 'package:academia/exports/barrel.dart';

class ExamCountDownWidget extends StatefulWidget {
  const ExamCountDownWidget({
    super.key,
    required this.endtime,
    required this.examCount,
    this.exam,
  });
  final DateTime endtime;
  final int examCount;
  final ExamModelData? exam;

  @override
  State<ExamCountDownWidget> createState() => _ExamCountDownWidgetState();
}

class _ExamCountDownWidgetState extends State<ExamCountDownWidget> {
  var isCritical = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        // items: [
        //   Container(
        //     decoration: BoxDecoration(
        //         color: isCritical
        //             ? Theme.of(context).colorScheme.errorContainer
        //             : Theme.of(context).colorScheme.primaryContainer,
        //         borderRadius: BorderRadius.circular(8)),
        //     width: MediaQuery.of(context).size.width * 0.8,
        //     child: Center(
        //       child: TimerCountdown(
        //         timeTextStyle:
        //             Theme.of(context).textTheme.displayMedium!.copyWith(
        //                   fontFamily: GoogleFonts.figtree().fontFamily,
        //                 ),
        //         format: CountDownTimerFormat.daysHoursMinutesSeconds,
        //         endTime: widget.endtime,
        //         onTick: ((remainingTime) {
        //           if (remainingTime.inMinutes < 5) {
        //             setState(() {
        //               isCritical = true;
        //             });
        //           }
        //         }),
        //       ),
        //     ),
        //   ),
        //   widget.exam == null
        //       ? Container(
        //           decoration: BoxDecoration(
        //               color: Theme.of(context).colorScheme.primaryContainer,
        //               borderRadius: BorderRadius.circular(8)),
        //           width: MediaQuery.of(context).size.width * 0.8,
        //           child: Center(
        //             child: Text(
        //               "Aah sh*t here we go again",
        //               textAlign: TextAlign.center,
        //               style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //                     fontFamily: GoogleFonts.figtree().fontFamily,
        //                   ),
        //             ),
        //           ),
        //         )
        //       : ExamCard(exam: widget.exam!),
        //   Container(
        //     decoration: BoxDecoration(
        //         color: Theme.of(context).colorScheme.tertiaryContainer,
        //         borderRadius: BorderRadius.circular(8)),
        //     width: MediaQuery.of(context).size.width * 0.8,
        //     child: Center(
        //       child: Text(
        //         "${widget.examCount} exams left to go 🫡",
        //         textAlign: TextAlign.center,
        //         style: Theme.of(context).textTheme.titleLarge!.copyWith(
        //               fontFamily: GoogleFonts.figtree().fontFamily,
        //             ),
        //       ),
        //     ),
        //   )
        // ],
        // options: CarouselOptions(
        //     height: 200,
        //     showIndicator: true,
        //     autoPlay: true,
        //     slideIndicator: const CircularSlideIndicator(slideIndicatorOptions: SlideIndicatorOptions(itemSpacing: 14))),
        );
  }
}
