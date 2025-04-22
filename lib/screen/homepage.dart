import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:hive/hive.dart';

import 'package:recipe_wizard1/screen/new_recipe.dart';

import '../model/recipe_model.dart';
import 'main_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<RecipeModel> _recipeHistory = [];

  getRecipe() async {
    var box = await Hive.openBox<RecipeModel>('recipe_box');
    setState(() {
      final List<RecipeModel> recipes = box.values.toList();

      for (final recipe in recipes) {
        if (!_recipeHistory.any((r) => r.id == recipe.id)) {
          _recipeHistory.add(recipe);
        }
      }
    });
  }

  @override
  void initState() {
    setState(() {
      getRecipe();
    });
    super.initState();
  }

  void _addRecipe(RecipeModel history) async {
    var box = await Hive.openBox<RecipeModel>('recipe_box');
    setState(() {
      _recipeHistory.add(history);
      box.add(history);
    });
  }

  void _removeRecipe(RecipeModel recipe) async {
    final recipeIndex = _recipeHistory.indexOf(recipe);
    var box = await Hive.openBox<RecipeModel>('recipe_box');
    final _recipe = box.values.toList();
    final recipeI = _recipe.indexOf(recipe);
    setState(() {
      box.deleteAt(recipeI);
      _recipeHistory.removeAt(recipeIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from history'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title:
            Text('RECIPE WIZARD', style: TextStyle(fontWeight: FontWeight.bold))
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(
                  duration: 3000.ms,
                  delay: 1000.ms,
                  color: Color(0xffb6fbff).withOpacity(0.7),
                ),
      ),
      drawer: MainDrawer(
        history: _recipeHistory,
        onRemoveRecipe: _removeRecipe,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
              invertColors: isDarkMode ? false : true,
              opacity: 0.7),
        ),
        child: NewRecipe(onAddRecipe: _addRecipe),
      ),
    );
  }
}
