import 'dart:async';

import 'package:academia/features/chapel_attendance/widgets/timer_widget.dart';
import 'package:academia/utils/validator/validator.dart';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
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

    var gottenValue = rawData['data'][0]['rawValue'];
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
                    onPressed: () {},
                    icon: Icon(Clarity.check_line),
                  ),
                  hintText: "xx-xxxx",
                  label: const Text("Student Admission Number"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
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
            endTime: DateTime.now().add(Duration(hours: 1)),
            onEnd: () {},
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
                    "No Scanned",
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
                    "75",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontFamily: GoogleFonts.dynaPuff().fontFamily,
                        ),
                  ),
                  Text(
                    "No Scanned",
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
