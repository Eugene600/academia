import 'package:academia/app.dart';
import 'package:academia/exports/barrel.dart';
import 'package:academia/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:academia/config/config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GetIt.instance.registerSingleton<FlavorConfig>(
    FlavorConfig(
      flavor: Flavor.development,
      appName: "Academia - Dev",
      apiBaseUrl: "http://62.169.16.219:8000",
    ),
  );

  // launch the application
  runApp(
    const Academia(
      flavor: 'development',
    ),
  );
}
