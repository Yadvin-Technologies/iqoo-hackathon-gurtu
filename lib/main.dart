import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';

import 'screens/bench_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Core ships no engine; LiteRT-LM runs .litertlm models on CPU / GPU / NPU.
  await FlutterGemma.initialize(inferenceEngines: [LiteRtLmEngine()]);
  runApp(const GurtuTestApp());
}

class GurtuTestApp extends StatelessWidget {
  const GurtuTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemma Bench',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF), brightness: Brightness.dark),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      ),
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF))),
      home: const BenchScreen(),
    );
  }
}
