import 'dart:async';

import 'package:academia/features/chapel_attendance/widgets/timer_widget.dart';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TimerWidget(
          hours: 0,
          minutes: 1,
          seconds: 0,
        ),
        Text(
          DateTime.now().toString().substring(
                0,
                16,
              ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: MobileScanner(
            controller: controller,
            fit: BoxFit.fill,
          ),
        ),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
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
                        TextField(
                          controller: stdAdm,
                          decoration: InputDecoration(
                            hintText: "XX-XXXX",
                            label: const Text("Student Admission Number"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: FilledButton(
                              onPressed: () {},
                              child: Text("Mark Attendance"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Text("Enter Admission Instead"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text("75"),
                    ),
                  ),
                  Text("No Scanned"),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: Text("75"),
                    ),
                  ),
                  Text("Total Scanned"),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
