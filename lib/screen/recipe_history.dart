import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:recipe_wizard1/model/recipe_model.dart';
import 'package:recipe_wizard1/screen/result_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage(
      {super.key, required this.history, required this.onRemoveRecipe});

  final List<RecipeModel> history;
  final void Function(RecipeModel recipe) onRemoveRecipe;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
    getRecipe();
    super.initState();
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
        MediaQuery
            .of(context)
            .platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: widget.history.isEmpty
          ? const Center(child: Text('No History recipes yet.'))
          : Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
              invertColors: isDarkMode ? false : true,
              opacity: 0.7),
        ),
        child: ListView.builder(
            itemCount: widget.history.length,
            itemBuilder: (context, index) {
              final recipe = widget.history[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                      child: Card(
                        color: Colors.white.withOpacity(0.1),
                        child: ListTile(
                          tileColor: Colors.transparent,
                          title: Text(
                            recipe.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ResultPage(recipe: recipe),
                              ),
                            );
                          },
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                widget.onRemoveRecipe(recipe);
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
                          .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                          .shimmer(
                        duration: 3000.ms,
                        delay: 1000.ms,
                        color: Color(0xffb6fbff).withOpacity(0.5),
                      )),
                ),
              );
            }),
      ),
    );
  }
}

// return ListView.builder(
//   itemBuilder: (context, index) => Dismissible(
//       key: ValueKey(_recipeHistory[index]),
//       onDismissed: (direction) {
//         onRemoveRecipe(_recipeHistory[index]);
//       },
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ResultPage(
//                     recipe: RecipeModel(
//                       id: _recipeHistory[index].id,
//                       title: _recipeHistory[index].title,
//                       ingredients: _recipeHistory[index].ingredients,
//                       instructions: _recipeHistory[index].instructions,
//                       fav: _recipeHistory[index].fav,
//                       description: _recipeHistory[index].description,
//                       allergens: _recipeHistory[index].allergens,
//                       servings: _recipeHistory[index].servings,
//                     ),
//                   ),
//                 ));
//           });
//         },
//         child: Padding(
//           padding: const EdgeInsets.only(
//             left: 20,
//             right: 20,
//             top: 10,
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 height: 200,
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: [
//                     Color(0xff83a4d4).withOpacity(0.4),
//                     Color(0xffb6fbff).withOpacity(0.4)
//                   ]),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(
//                     color: isDarkMode
//                         ? Colors.white
//                         : Colors.black.withOpacity(0.7),
//                   ),
//                 ),
//                 child: Center(
//                     child: Text(
//                   _recipeHistory[index].title,
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                   ),
//                 )),
//               ),
//             ),
//           ),
//         ),
//       )),
//   itemCount: _recipeHistory.length,
// );
//   }
// }
