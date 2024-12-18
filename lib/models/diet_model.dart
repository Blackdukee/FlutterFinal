import 'package:flutter/material.dart';

class DietModel {
  String name;
  List<String> ingredients;
  String iconPath;
  String level;
  String duration;
  String calorie;
  Color boxColor;
  bool viewIsSelected;

  DietModel(
      {required this.name,
      required this.ingredients,
      required this.iconPath,
      required this.level,
      required this.duration,
      required this.calorie,
      required this.boxColor,
      required this.viewIsSelected});

  static List<DietModel> getDiets() {
    List<DietModel> diets = [];

    diets.add(DietModel(
        name: 'Honey Pancake',
        ingredients: ['Flour', 'Eggs', 'Milk'],
        iconPath: 'assets/icons/honey-pancakes.svg',
        level: 'Easy',
        duration: '30mins',
        calorie: '180kCal',
        viewIsSelected: false,
        boxColor: const Color(0xff9DCEFF)));

    diets.add(DietModel(
        name: 'Canai Bread',
        ingredients: ['Bola', 'Cheese', 'Milk'],
        iconPath: 'assets/icons/canai-bread.svg',
        level: 'Easy',
        duration: '20mins',
        calorie: '230kCal',
        viewIsSelected: false,
        boxColor: const Color(0xffEEA4CE)));
     diets.add(DietModel(
        name: 'Bola Bread',
        ingredients: ['Eggs', 'Bola', 'Mola'],
        iconPath: 'assets/icons/canai-bread.svg',
        level: 'Easy',
        duration: '20mins',
        calorie: '230kCal',
        viewIsSelected: false,
        boxColor: const Color(0xffEEA4CE)));
    return diets;
    
  }

  static DietModel fromMap(Map<String, dynamic> map) {
    return DietModel(
      name: map['name'],
      ingredients: map['ingredients'].split(','),
      iconPath: map['iconPath'],
      level: map['level'],
      duration: map['duration'],
      calorie: map['calorie'],
      boxColor: Color(map['boxColor']),
      viewIsSelected: map['viewIsSelected'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ingredients': ingredients.join(','),
      'iconPath': iconPath,
      'level': level,
      'duration': duration,
      'calorie': calorie,
      'boxColor': boxColor.value,
      'viewIsSelected': viewIsSelected ? 1 : 0,
    };
  }

  static void updateSelectedDiet(var diets, int selectedIndex) {
    for (int i = 0; i < diets.length; i++) {
      diets[i].viewIsSelected = (i == selectedIndex);
    }
  }
}
