import 'package:academia/exports/barrel.dart';
import 'package:academia/features/features.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:logger/logger.dart';

class PerformanceReportView extends StatefulWidget {
  const PerformanceReportView({
    super.key,
    required this.metricType,
  });
  final PerformanceMetricType metricType;

  @override
  State<PerformanceReportView> createState() => _PerformanceReportViewState();
}

class _PerformanceReportViewState extends State<PerformanceReportView> {
  final _logger = Logger();
  bool _isLoading = true;

  late PDFViewController _controller;

  late Future<dartz.Either<String, List<Uint8List>>> reportResponse;

  @override
  void initState() {
    super.initState();
    reportResponse = fetchReport();
  }

  Future<dartz.Either<String, List<Uint8List>>> fetchReport() async {
    final magnet = GetIt.instance.get<Magnet>(instanceName: "magnet");
    try {
      magnet.token;
    } catch (e) {
      _logger.e("Token was null attempting to refresh token");
      final result = await magnet.login();
      if (result.isLeft()) {
        _logger.e((result as dartz.Left).value);
        return dartz.left((result as dartz.Left).value);
      }
    }

    // fetch the actual darn thing
    if (widget.metricType == PerformanceMetricType.audit) {
      //return await  magnet.fetchStudentAudit();
      final result = await magnet.fetchStudentAudit();
      return result.fold((error) {
        _logger.e(error);
        return dartz.left(error.toString());
      }, (rawAudits) {
        final transcripts = <Uint8List>[];
        for (var rawTranscript in rawAudits) {
          transcripts.add(base64Decode(rawTranscript));
          Clipboard.setData(ClipboardData(text: rawTranscript));
        }
        return dartz.right(transcripts);
      });
    }

    // fetch the actual darn thing
    if (widget.metricType == PerformanceMetricType.transcript) {
      //return await  magnet.fetchStudentAudit();
      final result = await magnet.fetchTranscript();
      return result.fold((error) {
        _logger.e(error);
        return dartz.left(error.toString());
      }, (rawTranscripts) {
        final transcripts = <Uint8List>[];
        for (var rawTranscript in rawTranscripts) {
          try {
            _logger.i(rawTranscript);
            transcripts.add(base64Decode(rawTranscript));
          } catch (e) {
            _logger.e(e);
          }
        }
        return dartz.right(transcripts);
      });
    }

    return dartz.left("We ran into an error please try again later");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            title: Text(
              widget.metricType == PerformanceMetricType.audit
                  ? "Student Audit"
                  : "Student Transcript",
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Clarity.archive_line),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(4),
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Row(
                children: [],
              ),
            ),
          ),
          SliverFillRemaining(
            child: FutureBuilder(
              future: reportResponse,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  );
                }
                final data = snapshot.data!;

                return data.fold((error) {
                  return Center(
                    child: Text(
                      error,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  );
                }, (data) {
                  return GestureDetector(
                    child: PDFView(
                      onViewCreated: (controller) {
                        _controller = controller;
                      },
                      fitEachPage: true,
                      enableSwipe:
                          true, // Disable built-in swipe to handle it manually
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageFling: true,
                      pdfData: data.first, // Your PDF data
                    ),
                  );
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
