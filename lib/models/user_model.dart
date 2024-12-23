import 'package:final_project/models/diet_model.dart';

class UserModel {
  String? id;
  final String name;
  final String email;
  final String password;
  final List<DietModel> history;
  final List<DietModel> savedRecipes;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.history,
    required this.savedRecipes,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var user = UserModel(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      history: (json['history'] as List)
          .map((item) => DietModel.fromMap(item))
          .toList(),
      savedRecipes: (json['savedRecipes'] as List)
          .map((item) => DietModel.fromMap(item))
          .toList(),
    );
    user.id = json['id'];
    return user; 
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'history': history.map((diet) => diet.toJson()).toList(),
        'savedRecipes': savedRecipes.map((diet) => diet.toJson()).toList(),
      };
}
