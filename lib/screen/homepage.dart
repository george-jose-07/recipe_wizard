import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:recipe_wizard1/screen/result_page.dart';
import '../model/recipe_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final GenerativeModel _model;
  String generatedText = '';
  String apikey = 'AIzaSyBomlERxZuAQTve5bekPwlfE7NpkbKFQoI';
  bool _loading = false;
  String _errorMessage = '';
  File? _image;
  String _recipeTitle = '';
  String _recipeId = '';
  String _cuisine = '';
  String _servings = '';
  String _description = '';

  // String totalFat = '';
  // String carbohydrates = '';
  // String totalProtein = '';
  // String calories = '';
  List<String> _instructions = [];
  List<String> _allergens = [];
  List<String> _ingredients = [];
  String selectedCuisine = '';
  final List<String> _selectedIngredients = [];
  final List<String> _dietaryRestrictions = [];
  String _addition = '';
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source);

    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getAPIkey();
  }

  void _getAPIkey() async {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apikey,
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );
  }

  Future<void> _generateText() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });
    print(_addition);
    final prompt = TextPart(
        """Recommend a recipeResponse for me based on the provided image.
the recipeResponse should only contain real, edible ingredients. If the image attached don't contain any food items, respond to say that you cannot recommend a recipeResponse with inedible ingredients.
Adhere to food safety and handling best practices like ensuring that poultry is fully cooked.

I'm in the mood for the following types of cuisine: $selectedCuisine

I have the following dietary restrictions: $_dietaryRestrictions

Optionally also include the following ingredients: $_selectedIngredients

after providing the recipeResponse, explain creatively why the recipeResponse is good based on only the ingredients used in the recipeResponse. Tell a short story of a travel experience that inspired the recipeResponse.
Provide a summary of how many people the recipeResponse will serve and the nutritional information per serving.
List out any ingredients that are potential allergen's.""");

    final formatting = TextPart(
        """Return the recipeResponse in JSON using following structures:
{
	'title': \$recipeTitle,
	'ingredients': \$ingredients,
	'instructions': \$instructions,
	'id': \$uniqueId,
	'cuisine': \$cuisineType,
	'description': \$description,
	'allergens': \$allergens,
	'servings': \$servings,
}
uniqueId should be unique and of type string.
title, description, cuisine, allergens, and servings should be of string type.
ingredients and instructions should be of type List<String>.
Return the recipeResponse in JSON format only. Do not include any other text.""");
    // 'calories': \$calories,
    // 'fat': \$totalFat,
    // 'carbohydrates': \$carbohydrate,
    // 'protein': \$totalProtein
    //calories, fat, carbohydrates and protein should be string type and should be per 100 grams.
    final mimeType = lookupMimeType(_image!.path);
    final imageParts = DataPart(mimeType!, _image!.readAsBytesSync());

    final content = [
      Content.multi([prompt, imageParts, formatting])
    ];
    final recipeResponse = await _model.generateContent(content);
    generatedText = recipeResponse.text!.replaceAll('```', '');
    generatedText = generatedText.replaceAll('json', '');
    if (recipeResponse.text != null) {
      final Map<String, dynamic> recipeData = jsonDecode(generatedText);

      _recipeTitle = recipeData['title'];
      _recipeId = recipeData['id'];
      _cuisine = recipeData['cuisine'];
      _servings = recipeData['servings'];
      _description = recipeData['description'];
      // carbohydrates = recipeData['carbohydrates'];
      // calories = recipeData['calories'];
      // totalProtein = recipeData['protein'];
      // totalFat = recipeData['fat'];
      _ingredients = List<String>.from(recipeData['ingredients']);
      _instructions = List<String>.from(recipeData['instructions']);
      _allergens = List<String>.from(recipeData['allergens']);
      //print('$generatedText');
      // print(_recipeTitle);
      // print(_cuisine);
      // print(_description);
      // print(_servings);
      // print(generatedText);
      // for (String fr in _ingredients) {
      //   print(fr);
      // }
      // for (String fr in _instructions) {
      //   print(fr);
      // }
      // for (String fr in _allergens) {
      //   print(fr);
      // }
      // print(_recipeId);
      setState(() {
        _loading = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              recipe: Recipe(
                title: _recipeTitle,
                ingredients: _ingredients,
                instructions: _instructions,
                id: _recipeId,
                cuisine: _cuisine,
                description: _description,
                allergens: _allergens,
                servings: _servings,
                // calories: calories,
                // carbohydrates: carbohydrates,
                // totalFat: totalFat,
                // totalProtein: totalProtein,
              ),
            ),
          ),
        );
      });
    } else {
      setState(() {
        _errorMessage = "Error: No text response from the model.";
        _loading = false;
      });
    }
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 100,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 10, top: 20, bottom: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    _getImage(ImageSource.camera);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30,
                                    height: 60,
                                    child: Center(
                                      child: Icon(Icons.camera_alt_outlined),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 20, top: 20, bottom: 20),
                                child: GestureDetector(
                                  onTap: () {
                                    _getImage(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2 -
                                            30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    height: 60,
                                    child: Center(
                                      child: Icon(Icons
                                          .photo_size_select_actual_outlined),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.transparent,
                    border: Border.all(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    image: DecorationImage(
                      image: _image != null
                          ? FileImage(_image!)
                          : AssetImage('assets/images/no_pic.jpg'),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ADDITIONAL INGREDIENTS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Wrap(runSpacing: 8, spacing: 8, children: [
                            for (String filter in [
                              'salt',
                              'sugar',
                              'milk',
                              'oil',
                              'rice flour',
                              'pepper',
                              'egg',
                              'olive oil'
                            ])
                              FilterChip(
                                label: Text(filter),
                                side: BorderSide(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  style: BorderStyle.solid,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.transparent,
                                selectedColor: Colors.green,
                                elevation: 10,
                                showCheckmark: true,
                                checkmarkColor:
                                    isDarkMode ? Colors.white : Colors.black,
                                selected: _selectedIngredients.contains(filter),
                                onSelected: (bool selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedIngredients.add(filter);
                                    } else {
                                      _selectedIngredients.remove(filter);
                                    }
                                  });
                                },
                              ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ],
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CUISINE STYLE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(
                        runSpacing: 8,
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: Text('Italian'),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            selected: selectedCuisine == 'Italian',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCuisine = selected ? 'Italian' : '';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text('Indian'),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            selected: selectedCuisine == 'Indian',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCuisine = selected ? 'Indian' : '';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text('Chinese'),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            selected: selectedCuisine == 'Chinese',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCuisine = selected ? 'Chinese' : '';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text('French'),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            selected: selectedCuisine == 'French',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCuisine = selected ? 'French' : '';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text('Arabic'),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            selected: selectedCuisine == 'Arabic',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCuisine = selected ? 'Arabic' : '';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text('English'),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            selected: selectedCuisine == 'English',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCuisine = selected ? 'English' : '';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text('Korean'),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            selected: selectedCuisine == 'Korean',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCuisine = selected ? 'Korean' : '';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: Text('Mexican'),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            selected: selectedCuisine == 'Mexican',
                            onSelected: (bool selected) {
                              setState(() {
                                selectedCuisine = selected ? 'Mexican' : '';
                              });
                            },
                          ),
                        ],
                      ),
                    ],
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DIETARY RESTRICTIONS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Wrap(runSpacing: 8, spacing: 8, children: [
                        for (String filter in [
                          'Vegetarianism',
                          'Veganism',
                          'Lactose Intolerance',
                          'Gluten Intolerance',
                          'Nuts',
                          'Kosher',
                          'Diabetes',
                          'Keto',
                          'Dairy-free',
                          'Low carb',
                          'Fish and shellfish',
                          'Eggs',
                          'Soy',
                          'Wheat'
                        ])
                          FilterChip(
                            label: Text(filter),
                            side: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              style: BorderStyle.solid,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.green,
                            showCheckmark: true,
                            checkmarkColor:
                                isDarkMode ? Colors.white : Colors.black,
                            selected: _dietaryRestrictions.contains(filter),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _dietaryRestrictions.add(filter);
                                } else {
                                  _dietaryRestrictions.remove(filter);
                                }
                              });
                            },
                          ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: GestureDetector(
                onTap: () {
                  _generateText();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.green,
                    border: Border.all(
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _loading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'ENTER',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
