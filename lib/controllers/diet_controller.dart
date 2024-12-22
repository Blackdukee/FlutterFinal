import 'package:final_project/models/diet_model.dart';
import 'package:final_project/services/api_service.dart';
import 'package:get/get.dart';

class DietController extends GetxController {
  var itemList = List<DietModel>.empty(growable: true).obs;
  var searchQuery = ''.obs;
  var selectedIngredients = List<String>.empty(growable: true).obs;
  var currentPage = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    itemList.value =
        await apiService.getDietsByCategory(currentPage.value.split(' ')[0]);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateSelectedIngredients(List<String> selectedIngredients) {
    this.selectedIngredients.value = selectedIngredients;
  }

  void updateCurrentPage(String page) {
    currentPage.value = page;
  }

  Future<List<DietModel>> get filteredRecipe async {
    var filteredItems = itemList.toList();

    if (searchQuery.value.isEmpty) {
      if (currentPage.value.split('').length > 1 &&
          currentPage.value.split(' ')[1] == 'Category') {
        filteredItems =
            await getDietByCategory(currentPage.value.split(' ')[0]);
        return filteredItems;
      }
    }

    if (selectedIngredients.isNotEmpty) {
      if (currentPage.value.split(' ').length > 1 &&
          currentPage.value.split(' ')[1] == 'Category') {
        filteredItems = filteredItems.where((item) {
          return selectedIngredients.any((ingredient) {
            return item.ingredients.contains(ingredient);
          });
        }).toList();

        return filteredItems;
      }

      filteredItems =
          await apiService.getDietsWithFilters(selectedIngredients.join(','));

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
  }

  ApiService apiService = ApiService();

  void createDiet(DietModel diet) async {
    await apiService.createDiet(diet);
  }

  Future<List<DietModel>> getDietByCategory(String category) async {
    List<DietModel> items = [];
    items = await apiService.getDietsByCategory(category);
    print(items.length);
    return items;
  }
}
