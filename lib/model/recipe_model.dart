class Recipe {
  final String title;
  final List<String> ingredients;
  final List<String> instructions;
  final String id;
  final String cuisine;
  final String description;
  final List<String> allergens;
  final String servings;

  // final String totalFat;
  // final String carbohydrates;
  // final String calories;
  // final String totalProtein;

  //final Map<String, String> nutritionInformation;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.id,
    required this.cuisine,
    required this.description,
    required this.allergens,
    required this.servings,
    // required this.calories,
    // required this.carbohydrates,
    // required this.totalFat,
    // required this.totalProtein
    // required this.nutritionInformation,
  });

// factory Recipe.fromJson(Map<String, dynamic> json) {
//   return Recipe(
//     title: json['title'],
//     ingredients: List<String>.from(json['ingredients']),
//     instructions: List<String>.from(json['instructions']),
//     id: json['id'],
//     cuisine: json['cuisine'],
//     description: json['description'],
//     allergens: json['allergens'],
//     servings: json['servings'],
//     nutritionInformation: Map<String, String>.from(json['nutritionInformation']),
//   );
// }
}
