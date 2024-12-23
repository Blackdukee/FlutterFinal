import 'package:final_project/models/diet_model.dart';
import 'package:final_project/services/api_service.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class DietController extends GetxController {
  var itemList = List<DietModel>.empty(growable: true).obs;
  var searchQuery = ''.obs;
  var selectedIngredients = List<String>.empty(growable: true).obs;
  var currentPage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      if (currentPage.value.isNotEmpty) {
        itemList.value = await apiService
                .getDietsByCategory(currentPage.value.split(' ')[0]) ??
            [];
      }
    } catch (e) {
      if (e.toString() == 'Exception: No internet connection') {
        Get.snackbar(
            'No internet connection', 'Please check your internet connection');
      } else {
        Get.snackbar('Error', 'Failed to retrieve diets by category');
      }
    }
  }

  Future<List<DietModel>> get getDietsByCategory async {
    var recipes =
        await apiService.getDietsByCategory(currentPage.value.split(' ')[0]) ??
            [];
    return recipes;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateSelectedIngredients(List<String> selectedIngredients) {
    this.selectedIngredients.value = selectedIngredients;
  }

  void updateCurrentPage(String page) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentPage.value = page;
    });
  }

  Future<List<DietModel>> get filteredRecipe async {
    var filteredItems = itemList.toList();
    try {
      if (searchQuery.value.isEmpty) {
        if (currentPage.value.split('').length > 1 &&
            currentPage.value.split(' ')[1] == 'Category') {
          filteredItems = await apiService
                  .getDietsByCategory(currentPage.value.split(' ')[0]) ??
              [];
          return filteredItems;
        }
      }

      if (selectedIngredients.isNotEmpty && searchQuery.isNotEmpty) {
        if (currentPage.value.split(' ').length > 1 &&
            currentPage.value.split(' ')[1] == 'Category') {
          filteredItems = filteredItems.where((item) {
            return selectedIngredients.any((ingredient) {
              return item.ingredients.contains(ingredient);
            });
          }).toList();

          return filteredItems;
        }

        filteredItems = await apiService.getDietsWIthFilterAndQuery(
            selectedIngredients.join(','), searchQuery.value);

        if (searchQuery.isNotEmpty) {
          filteredItems = filteredItems.where((item) {
            return item.name.toLowerCase().contains(searchQuery.value);
          }).toList();

          return filteredItems;
        }
      }

      if (searchQuery.isNotEmpty) {
        filteredItems = await apiService.getDietsWithQuery(searchQuery.value);
        return filteredItems;
      } else {
        return filteredItems;
      }
    } catch (e) {
      if (e.toString() == 'Exception: No internet connection') {
        Get.snackbar(
            'No internet connection', 'Please check your internet connection');
      } else {
        Get.snackbar('Error', 'Failed to retrieve diets by category');
      }
    } finally {
      return filteredItems;
    }
  }

  ApiService apiService = ApiService();

  void createDiet(DietModel diet) async {
    await apiService.createDiet(diet);
  }
}
