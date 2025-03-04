import 'dart:async';
import 'package:academia/database/database.dart';
import 'package:academia/features/features.dart';
import 'package:academia/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:google_fonts/google_fonts.dart';

class ChapelAttendancePage extends StatefulWidget {
  const ChapelAttendancePage({super.key});

  @override
  State<ChapelAttendancePage> createState() => _ChapelAttendancePageState();
}

class _ChapelAttendancePageState extends State<ChapelAttendancePage>
    with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController(
      // required options for the scanner
      );

  void _handleBarCode(BarcodeCapture event) {
    Map rawData = event.raw as Map;

    var admno = rawData['data'][0]['rawValue'];

    final today = DateTime.now();
    BlocProvider.of<AttendanceBloc>(context).add(
      AttendanceMarkingRequested(
        record: AttendanceModelData(
          studentID: admno,
          date: DateTime(today.year, today.month, today.day).toLocal(),
          checkIn: 'present',
          campus: 'athi river',
        ),
      ),
    );
  }

  StreamSubscription<Object?>? _subscription;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarCode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  DateTime _getNextTuesday() {
    DateTime now = DateTime.now();
    if (now.weekday == DateTime.tuesday && now.hour < 10) {
      return now.copyWith(hour: 10, minute: 0, second: 0);
    }
    now = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
    int daysToAdd = (DateTime.tuesday - now.weekday + 7) % 7;
    daysToAdd = daysToAdd == 0 ? 7 : daysToAdd;
    return now.add(Duration(days: daysToAdd));

    //DateTime now = DateTime.now().copyWith(hour: 0, minute: 0, second: 0);
    //int daysToAdd = (DateTime.tuesday - now.weekday + 7) % 7;
    //daysToAdd = daysToAdd == 0 ? 7 : daysToAdd;
    //final nextTuesday = now.add(Duration(days: daysToAdd));
    //
    //return DateTime(
    //  nextTuesday.year,
    //  nextTuesday.month,
    //  nextTuesday.day,
    //  10,
    //  0,
    //  0,
    //);
  }

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarCode);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  void _showAdmissionInput() => showModalBottomSheet(
      context: context,
      builder: (context) {
        final TextEditingController stdAdm = TextEditingController();
        return Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 42.0,
            bottom: 16.0,
          ),
          child: BlocListener<AttendanceBloc, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceMarkedState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
                return;
              }
            },
            child: Column(
              children: [
                TextFormField(
                  controller: stdAdm,
                  inputFormatters: [
                    AdmnoDashFormatter(),
                  ],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        final today = DateTime.now();
                        BlocProvider.of<AttendanceBloc>(context).add(
                          AttendanceMarkingRequested(
                            record: AttendanceModelData(
                              studentID: stdAdm.text,
                              date: DateTime(today.year, today.month, today.day)
                                  .toLocal(),
                              checkIn: 'present',
                              campus: 'athi river',
                            ),
                          ),
                        );
                      },
                      icon: Icon(Clarity.check_line),
                    ),
                    hintText: "xx-xxxx",
                    label: const Text("Student Admission Number"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                BlocBuilder<AttendanceBloc, AttendanceState>(
                  buildWhen: (statA, stateB) {
                    if (stateB is AttendanceLoadingState ||
                        stateB is AttendaceErrorState) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is AttendanceLoadingState) {
                      return Column(
                        spacing: 12,
                        children: [
                          Lottie.asset(
                            "assets/lotties/search.json",
                            height: 200,
                            width: 200,
                          ),
                        ],
                      );
                    }
                    if (state is AttendaceErrorState) {
                      return Column(
                        spacing: 12,
                        children: [
                          Lottie.asset(
                            "assets/lotties/cat-error.json",
                            height: 200,
                            width: 200,
                          ),
                          Text(
                            state.error,
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      );
                    }
                    return Column(
                      spacing: 12,
                      children: [
                        Lottie.asset(
                          "assets/lotties/bunny.json",
                          height: 200,
                          width: 200,
                        ),
                        Text(
                          "Please provide a student admission number to continue",
                          style: Theme.of(context).textTheme.titleLarge,
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 250,
            maxWidth: 280,
            maxHeight: 280,
            minHeight: 250,
          ),
          child: MobileScanner(
            controller: controller,
            fit: BoxFit.fill,
          ),
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          child: TimerCountdown(
            timeTextStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontFamily: GoogleFonts.dynaPuff().fontFamily,
                ),
            format: CountDownTimerFormat.daysHoursMinutesSeconds,
            endTime: _getNextTuesday(),
            onEnd: () {
              context.goNamed("home");
            },
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "75",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontFamily: GoogleFonts.dynaPuff().fontFamily,
                        ),
                  ),
                  Text(
                    "Personally scanned",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              CircleAvatar(
                child: IconButton(
                  tooltip: "Enter Admission number instead",
                  onPressed: _showAdmissionInput,
                  icon: Icon(Clarity.id_badge_line),
                ),
              ),
              Column(
                children: [
                  Text(
                    "780",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontFamily: GoogleFonts.dynaPuff().fontFamily,
                        ),
                  ),
                  Text(
                    "Total Scanned",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
