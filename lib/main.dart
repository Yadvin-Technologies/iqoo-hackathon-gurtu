import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_embeddings/flutter_gemma_embeddings.dart';

import 'app/ask_screen.dart';
import 'app/bench_screen.dart';
import 'app/live_screen.dart';
import 'app/memory_controller.dart';
import 'app/memory_screen.dart';
import 'app/storage_screen.dart';
import 'perf/load_generator.dart';
import 'perf/telemetry.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // flutter_gemma owns model downloads and tokenizers. The Gemma 4 layer
  // adds `inferenceEngines: [LiteRtLmEngine()]` here when it is merged.
  await FlutterGemma.initialize(
    embeddingTokenizers: [const GemmaEmbeddingTokenizers()],
    maxDownloadRetries: 10,
  );
  final controller = await MemoryController.create();
  // Sampled from app start so every tab's work shows up on the Live tab.
  final telemetry = TelemetryService()..start();
  runApp(GurtuApp(controller: controller, telemetry: telemetry, load: LoadGenerator(controller)));
}

class GurtuApp extends StatelessWidget {
  const GurtuApp({super.key, required this.controller, required this.telemetry, required this.load});

  final MemoryController controller;
  final TelemetryService telemetry;
  final LoadGenerator load;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF0F766E);
    return MaterialApp(
      title: 'Gurtu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: seed, brightness: Brightness.dark, useMaterial3: true),
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Gurtu · Care Memory'),
            bottom: const TabBar(
              labelPadding: EdgeInsets.zero,
              tabs: [
                Tab(icon: Icon(Icons.favorite_border), text: 'Memory'),
                Tab(icon: Icon(Icons.storage), text: 'Storage'),
                Tab(icon: Icon(Icons.manage_search), text: 'Ask'),
                Tab(icon: Icon(Icons.monitor_heart_outlined), text: 'Live'),
                Tab(icon: Icon(Icons.speed), text: 'Bench'),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MemoryScreen(c: controller),
              StorageScreen(c: controller),
              AskScreen(c: controller),
              LiveScreen(c: controller, t: telemetry, load: load),
              BenchScreen(c: controller),
            ],
          ),
        ),
      ),
    );
  }
}
