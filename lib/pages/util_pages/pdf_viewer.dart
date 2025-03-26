import 'package:academia/exports/barrel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PdfViewer extends StatefulWidget {
  const PdfViewer({
    super.key,
    required this.title,
    required this.url,
  });
  final String title, url;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  int currentPage = 0, totalPages = 0;
  bool isReady = false;
  String errorMessage = '';

  Future<Uint8List> _loadPdf() async {
    try {
      setState(() {
        isReady = false;
      });
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode != 200) {
        throw "Error while fetching content";
      }

      setState(() {
        isReady = true;
      });
      return response.bodyBytes;
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
    return Uint8List(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Information",
                  content: Column(
                    children: [
                      Image.asset("assets/images/bot_love.png", height: 100),
                      const Text(
                        "Swipe down to reveal more pages, pinch out to zoom out, pinch in to zoom",
                      )
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.info)),
        ],
      ),
      body: FutureBuilder(
          future: _loadPdf(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? snapshot.hasError
                    ? Center(
                        child: Column(
                          children: [
                            Image.asset("assets/images/bot_sad.png"),
                            Text(snapshot.error.toString()),
                          ],
                        ),
                      )
                    : Stack(
                        children: [],
                      )
                : const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Loading .."),
                      ],
                    ),
                  );
          }),
    );
  }
}
