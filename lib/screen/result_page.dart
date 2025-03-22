import 'package:flutter/material.dart';
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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('fat ${widget.recipe.totalFat}'),
            // Text('pr ${widget.recipe.totalProtein}'),
            // Text('cal ${widget.recipe.calories}'),
            // Text('carb ${widget.recipe.carbohydrates}'),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        child: Text(widget.recipe.description),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 10, bottom: 10, top: 10),
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
                          _recipe.fav ? Icons.favorite : Icons.favorite_border,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10, right: 20, bottom: 10, top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.transparent,
                      border: Border.all(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    height: 60,
                    width: MediaQuery.of(context).size.width - 120,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'SERVINGS:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(widget.recipe.servings)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            style: TextStyle(),
                          ),
                      ],
                    )
                    // Text(
                    //   widget.recipe.ingredients.join('\n'),
                    // ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                          Text('*  $i')
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                        for (String i in widget.recipe.allergens) Text('* $i')
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
