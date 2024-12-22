import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:final_project/models/diet_model.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/models/category_model.dart';
import 'package:get/get.dart';

class ApiService {
  final String baseUrl = 'http://192.168.1.7:3000/api';
  Future<DietModel> createDiet(DietModel diet) async {
    // todo : user login
    Get.log(diet.toJson());
    final response = await http.post(
      Uri.parse('$baseUrl/diets'),
      headers: {'Content-Type': 'application/json'},
      body: diet.toJson(),
    );

    if (response.statusCode == 201) {
      return DietModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create diet');
    }
  }

  Future<List<DietModel>> getDiets() async {
    final response = await http.get(Uri.parse('$baseUrl/diets'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((json) => DietModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to retrieve diets');
    }
  }

  Future<List<DietModel>> getDietsByCategory(String category) async {
    final response =
        await http.get(Uri.parse('$baseUrl/diets/category/$category'));
    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((json) => DietModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to retrieve diets');
    }
  }

  Future<DietModel> getDietById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/diets/$id'));

    if (response.statusCode == 200) {
      return DietModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to retrieve diet');
    }
  }

  Future<UserModel> createUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<UserModel> getUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to retrieve user');
    }
  }

  Future<UserModel> updateUser(UserModel user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<List<DietModel>> getUserHistory(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/users/$userId/history'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((json) => DietModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to retrieve user history');
    }
  }

  Future<List<DietModel>> getUserSavedRecipes(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/users/$userId/saved-recipes'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((json) => DietModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to retrieve user saved recipes');
    }
  }

  Future<List<DietModel>> getDietsWithFilters(String filters) async {
    final response =
        await http.get(Uri.parse('$baseUrl/diets/filters/$filters'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((json) => DietModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to retrieve diets with filters');
    }
  }

  Future<List<DietModel>> getDietsWithQuery(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/diets/query/$query'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((json) => DietModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to retrieve diets with query');
    }
  }

  Future<CategoryModel> createCategory(CategoryModel category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toMap()),
    );

    if (response.statusCode == 201) {
      return CategoryModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((json) => CategoryModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to retrieve categories');
    }
  }
}