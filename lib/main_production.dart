import 'package:academia/app.dart';
import 'package:academia/config/config.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// Production's entry point
void main() {
  GetIt.instance.registerSingleton<FlavorConfig>(
    FlavorConfig(
      flavor: Flavor.production,
      appName: "Academia",
      apiBaseUrl: "http://62.169.16.219:8000",
    ),
  );

  runApp(const Academia());
}
