import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({
    super.key,
    required this.hours,
    required this.minutes,
    required this.seconds,
  });

  final int minutes;
  final int hours;
  final int seconds;

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Duration countDownDuration = Duration(
    hours: widget.hours,
    minutes: widget.minutes,
    seconds: widget.seconds,
  );
  late ValueNotifier<Duration> durationNotifier;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(
      Duration(seconds: 1),
      (_) => addTime(),
    );
  }

  void addTime() {
    final seconds = durationNotifier.value.inSeconds - 1;
    if (seconds < 0) {
      timer?.cancel();
    } else {
      durationNotifier.value = Duration(seconds: seconds);
    }
  }

  @override
  void initState() {
    super.initState();
    durationNotifier = ValueNotifier<Duration>(countDownDuration);
    countDownDuration = Duration(
      hours: widget.hours,
      minutes: widget.minutes,
      seconds: widget.seconds,
    );
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    durationNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: durationNotifier,
        builder: (context, value, child) => RichText(
              text: TextSpan(
                text: "${value.inHours}:",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
                children: [
                  TextSpan(text: "${value.inMinutes}:"),
                  TextSpan(
                    text: "${value.inSeconds}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
            )
        // Text("${value.inHours}: ${value.inMinutes}: ${value.inSeconds}"),
        );
  }
}
