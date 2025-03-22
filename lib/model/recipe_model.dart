import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'recipe_model.g.dart';

const uuid = Uuid();

@HiveType(typeId: 0)
class RecipeModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  List<String> ingredients;

  @HiveField(2)
  List<String> instructions;

  @HiveField(3)
  String id;

  @HiveField(4)
  final bool fav;

  @HiveField(5)
  String description;

  @HiveField(6)
  List<String> allergens;

  @HiveField(7)
  String servings;

  // final String totalFat;
  // final String carbohydrates;
  // final String calories;
  // final String totalProtein;

  //final Map<String, String> nutritionInformation;

  RecipeModel({
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.fav = false,
    required this.description,
    required this.allergens,
    required this.servings,
    required this.id,
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
