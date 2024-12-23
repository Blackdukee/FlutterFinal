import 'package:get/get.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/services/api_service.dart';
import 'package:flutter/material.dart';

class UserController extends GetxController {
  final ApiService apiService = ApiService();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var user = UserModel(
    name: '',
    email: '',
    password: '',
    history: [],
    savedRecipes: [],
  ).obs;

  Future<void> createUser(String username, email, password) async {
    try {
      UserModel createdUser = await apiService.createUser(UserModel(
          name: username,
          email: email,
          password: password,
          history: [],
          savedRecipes: []));
      user.value = createdUser;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create user: $e');
    }
  }

  Future<void> getUser(String email, String password) async {
    try {
      UserModel fetchedUser = await apiService.getUser(email, password);
      user.value = fetchedUser;
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve user: $e');
    }
  }
}
