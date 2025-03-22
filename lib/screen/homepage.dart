import 'package:flutter/material.dart';

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
  int _selectedIndex = 0;
  List<RecipeModel> _recipeHistory = [];

  getRecipe() async {
    var box = await Hive.openBox<RecipeModel>('recipe_box');
    setState(() {
      _recipeHistory = box.values.toList();
    });
  }

  @override
  void initState() {
    getRecipe();
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
    setState(() {
      box.delete(recipe.id);
      _recipeHistory.removeAt(recipeIndex);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Removed from favorites'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'RECIPE WIZARD',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      drawer: MainDrawer(
        history: _recipeHistory,
        onRemoveRecipe: _removeRecipe,
      ),
      body: NewRecipe(onAddRecipe: _addRecipe),
    );
  }
}
