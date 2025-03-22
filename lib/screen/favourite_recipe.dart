import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:recipe_wizard1/model/recipe_model.dart';
import 'package:recipe_wizard1/screen/result_page.dart';

class FavouriteRecipe extends StatefulWidget {
  const FavouriteRecipe({super.key});

  @override
  State<FavouriteRecipe> createState() => _FavouriteRecipeState();
}

class _FavouriteRecipeState extends State<FavouriteRecipe> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ValueListenableBuilder<Box<RecipeModel>>(
        valueListenable: Hive.box<RecipeModel>('recipe_box').listenable(),
        builder: (context, box, _) {
          final favoriteRecipes =
              box.values.where((recipe) => recipe.fav == true).toList();

          if (favoriteRecipes.isEmpty) {
            return const Center(child: Text('No favorite recipes yet.'));
          }

          return ListView.builder(
            itemCount: favoriteRecipes.length,
            itemBuilder: (context, index) {
              final recipe = favoriteRecipes[index];
              return ListTile(
                title: Text(recipe.title),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite_border, color: Colors.red),
                  onPressed: () {
                    _removeFavorite(context, recipe);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(recipe: recipe),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
    // return ListView.builder(
    //   itemBuilder: (context, index) => Padding(
    //     padding: const EdgeInsets.only(
    //       left: 20,
    //       right: 20,
    //       top: 10,
    //     ),
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(20),
    //       child: BackdropFilter(
    //         filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(vertical: 10),
    //           height: 200,
    //           width: double.infinity,
    //           decoration: BoxDecoration(
    //             gradient: LinearGradient(colors: [
    //               Color(0xff83a4d4).withOpacity(0.4),
    //               Color(0xffb6fbff).withOpacity(0.4)
    //             ]),
    //             borderRadius: BorderRadius.circular(20),
    //             border: Border.all(
    //               color:
    //                   isDarkMode ? Colors.white : Colors.black.withOpacity(0.7),
    //             ),
    //           ),
    //           child: Center(
    //               child: Text(
    //             _favRecipe[index].title,
    //             style: TextStyle(
    //               fontSize: 20,
    //               color: Colors.white,
    //             ),
    //           )),
    //         ),
    //       ),
    //     ),
    //   ),
    //   itemCount: _favRecipe.length,
    // );
  }
}

void _removeFavorite(BuildContext context, RecipeModel recipe) async {
  final box = Hive.box<RecipeModel>('recipe_box');
  final updatedRecipe = RecipeModel(
    title: recipe.title,
    ingredients: recipe.ingredients,
    instructions: recipe.instructions,
    description: recipe.description,
    allergens: recipe.allergens,
    servings: recipe.servings,
    id: recipe.id,
  );
  await box.put(recipe.id, updatedRecipe);
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Removed from favorites'),
    ),
  );
}
