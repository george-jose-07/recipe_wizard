import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'package:recipe_wizard1/model/recipe_model.dart';
import 'package:recipe_wizard1/screen/homepage.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue,
  primary: Colors.blue.shade900,
  error: Colors.red.shade400,
  secondary: Colors.blue.shade300,
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: Colors.blue,
  primary: Colors.blue.shade700,
  error: Colors.red.shade400,
  secondary: Colors.blue.shade400,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(RecipeModelAdapter());
  await Hive.openBox<RecipeModel>("recipe_box");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Wizard',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.secondary,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(16.5),
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(),
            borderRadius: BorderRadius.circular(16.5),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
