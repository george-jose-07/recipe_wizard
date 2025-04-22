import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:recipe_wizard1/model/recipe_model.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({required this.recipe, super.key});

  final RecipeModel recipe;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late RecipeModel _recipe;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
  }

  void _toggleFavorite() async {
    var box2 = await Hive.openBox<RecipeModel>('recipe_box');
    _recipe = RecipeModel(
      title: _recipe.title,
      ingredients: _recipe.ingredients,
      instructions: _recipe.instructions,
      fav: !_recipe.fav,
      description: _recipe.description,
      allergens: _recipe.allergens,
      servings: _recipe.servings,
      id: _recipe.id,
    );
    box2.put(_recipe.id, _recipe);
    setState(() {});
  }

  // void onRemoveFav(RecipeModel favorites) async {
  //   final recipeIndex = _favRecipe.indexOf(favorites);
  //   var box1 = await Hive.openBox<RecipeModel>('recipe_box');
  //   setState(() {
  //     _favRecipe.remove(favorites);
  //     box1.put(favorites.id, favorites);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'RECIPE WIZARD',
          style: TextStyle(fontWeight: FontWeight.bold),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .shimmer(
              duration: 3000.ms,
              delay: 1000.ms,
              color: Color(0xffb6fbff).withOpacity(0.5),
            ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
              invertColors: isDarkMode ? false : true,
              opacity: 0.7),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            widget.recipe.title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
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
                          color: Color(0xffb6fbff).withOpacity(0.7),
                        ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              'DESCRIPTION',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                widget.recipe.description,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .shimmer(
                          duration: 3000.ms,
                          delay: 1000.ms,
                          color: Color(0xffb6fbff).withOpacity(0.7),
                        ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent,
                            border: Border.all(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          height: 60,
                          width: 60,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: IconButton(
                              onPressed: _toggleFavorite,
                              icon: Icon(
                                _recipe.fav == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
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
                              color: Color(0xffb6fbff).withOpacity(0.7),
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 20, bottom: 10, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.transparent,
                            border: Border.all(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          height: 60,
                          width: MediaQuery.of(context).size.width - 122,
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'SERVINGS:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Text(
                                  widget.recipe.servings,
                                  style: TextStyle(fontSize: 14),
                                )
                              ],
                            ),
                          ),
                        )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .shimmer(
                              duration: 3000.ms,
                              delay: 1000.ms,
                              color: Color(0xffb6fbff).withOpacity(0.7),
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'INGREDIENTS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              for (String i in widget.recipe.ingredients)
                                Text(
                                  '*  $i',
                                  style: TextStyle(fontSize: 14),
                                ),
                            ],
                          )),
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .shimmer(
                          duration: 3000.ms,
                          delay: 1000.ms,
                          color: Color(0xffb6fbff).withOpacity(0.7),
                        ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'INSTRUCTIONS',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              for (String i in widget.recipe.instructions)
                                Text(
                                  '*  $i',
                                  style: TextStyle(fontSize: 14),
                                )
                            ],
                          )),
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .shimmer(
                          duration: 3000.ms,
                          delay: 1000.ms,
                          color: Color(0xffb6fbff).withOpacity(0.7),
                        ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent,
                        border: Border.all(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ALLERGENS',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            for (String i in widget.recipe.allergens)
                              Text(
                                '* $i',
                                style: TextStyle(fontSize: 14),
                              )
                          ],
                        ),
                      ),
                    )
                        .animate(
                          onPlay: (controller) => controller.repeat(),
                        )
                        .shimmer(
                          duration: 3000.ms,
                          delay: 1000.ms,
                          color: Color(0xffb6fbff).withOpacity(0.7),
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
