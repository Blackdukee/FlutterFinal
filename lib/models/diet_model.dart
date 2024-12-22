import 'dart:convert';

import 'package:flutter/material.dart';

class DietModel {
  String? id;
  String categoryName;
  String name;
  List<String> ingredients;
  String iconPath;
  String level;
  String duration;
  String calorie;
  Color boxColor;
  bool isPopular = false;
  bool viewIsSelected;

  DietModel(
      {required this.categoryName,
      required this.name,
      required this.ingredients,
      required this.iconPath,
      required this.level,
      required this.duration,
      required this.calorie,
      required this.boxColor,
      required this.isPopular,
      required this.viewIsSelected});

  static List<DietModel> getDiets() {
    List<DietModel> diets = [];

    diets.add(DietModel(
      categoryName: "Cake",
      name: 'Blueberry Pancake',
      ingredients: ['Flour', 'Eggs', 'Milk'],
      iconPath: 'assets/icons/blueberry-pancake.svg',
      level: 'Medium',
      boxColor: const Color(0xff9DCEFF),
      duration: '30mins',
      calorie: '230kCal',
      isPopular: true,
      viewIsSelected: true,
    ));

    diets.add(DietModel(
        categoryName: "Cake",
        name: 'Honey Pancake',
        ingredients: ['Flour', 'Eggs', 'Milk'],
        iconPath: 'assets/icons/honey-pancakes.svg',
        level: 'Easy',
        duration: '30mins',
        calorie: '180kCal',
        isPopular: false,
        viewIsSelected: false,
        boxColor: const Color(0xff9DCEFF)));
    diets.add(DietModel(
      categoryName: "Salad",
      name: 'Salmon Nigiri',
      ingredients: ['Salmon', 'Rice', 'Nori'],
      iconPath: 'assets/icons/salmon-nigiri.svg',
      level: 'Easy',
      duration: '20mins',
      boxColor: const Color(0xffFFD180),
      calorie: '120kCal',
      isPopular: true,
      viewIsSelected: false,
    ));
    diets.add(DietModel(
        categoryName: "Pie",
        name: 'Canai Bread',
        ingredients: ['Bola', 'Cheese', 'Milk'],
        iconPath: 'assets/icons/canai-bread.svg',
        level: 'Easy',
        duration: '20mins',
        calorie: '230kCal',
        isPopular: false,
        viewIsSelected: false,
        boxColor: const Color(0xffEEA4CE)));
    diets.add(DietModel(
        categoryName: "Cake",
        name: 'Bola Bread',
        ingredients: ['Eggs', 'Bola', 'Mola'],
        iconPath: 'assets/icons/canai-bread.svg',
        level: 'Easy',
        duration: '20mins',
        calorie: '230kCal',
        isPopular: false,
        viewIsSelected: false,
        boxColor: const Color(0xffEEA4CE)));
    return diets;
  }

  static DietModel fromMap(Map<String, dynamic> map) {
    DietModel diet = DietModel(
      categoryName: map['categoryName'],
      name: map['name'],
      ingredients: List<String>.from(map['ingredients']),
      iconPath: map['iconPath'],
      level: map['level'],
      duration: map['duration'],
      calorie: map['calorie'],
      boxColor: Color(map['boxColor']),
      isPopular: map['isPopular'] == 1,
      viewIsSelected: map['viewIsSelected'] == 1,
    );
    diet.id = map['id'];
    return diet;
  }

  String toJson() {
    return jsonEncode({
      "categoryName": categoryName,
      "name": name,
      "ingredients": ingredients,
      "iconPath": iconPath,
      "level": level,
      "duration": duration,
      "calorie": calorie,
      "boxColor": boxColor.value,
      "isPopular": isPopular ? 1 : 0,
      "viewIsSelected": viewIsSelected ? 1 : 0,
    });
  }

  static void updateSelectedDiet(var diets, int selectedIndex) {
    for (int i = 0; i < diets.length; i++) {
      diets[i].viewIsSelected = (i == selectedIndex);
    }
  }
}
