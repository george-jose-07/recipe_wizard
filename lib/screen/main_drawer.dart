import 'package:flutter/material.dart';
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
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
            child: SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Center(child: Text("RECIPE WIZARD")),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.favorite_border,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Favourites',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
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
          ListTile(
            leading: Icon(
              Icons.history,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'History',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
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
          )
        ],
      ),
    );
  }
}
