import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:recipe_wizard1/screen/favourite_recipe.dart';
import 'package:recipe_wizard1/screen/recipe_history.dart';

import '../model/recipe_model.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
    required this.history,
    required this.onRemoveRecipe,
  });

  final List<RecipeModel> history;
  final void Function(RecipeModel bmi) onRemoveRecipe;

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
                invertColors: isDarkMode ? false : true,
                opacity: 0.5,
              ),
            ),
            child: Center(
              child: Text(
                "RECIPE WIZARD",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: Card(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.favorite_border,
                  size: 26,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  'Favourites',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 24),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavouriteRecipe(),
                    ),
                  );
                },
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
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Card(
              color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
              child: ListTile(
                leading: Icon(
                  Icons.history,
                  size: 26,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                title: Text(
                  'History',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 24),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryPage(
                        history: history,
                        onRemoveRecipe: onRemoveRecipe,
                      ),
                    ),
                  );
                },
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
          )
        ],
      ),
    );
  }
}
