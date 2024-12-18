import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:filter_list/filter_list.dart';
import 'package:get/get.dart';
import 'package:finalproject/controllers/diet_controller.dart';
import 'package:finalproject/models/category_model.dart';
import 'package:finalproject/models/diet_model.dart';
import 'package:finalproject/pages/recipe.dart';
import 'package:finalproject/models/popular_model.dart';

List<String> DefaultList = ['Pasta', 'Tomato', 'Cheese', 'Pizza base'];

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);
  
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final searchControllerToRemove = TextEditingController();
  final searchFocusNode = FocusNode();
  final searchBarcontroller = Get.put(DietController());
  final isFocused = false.obs;
  late List<CategoryModel> categories;
  late List<DietModel> diets;
  late List<PopularDietsModel> popularDiets;

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
    searchFocusNode.addListener(() {
      setState(() {
        isFocused.value = searchFocusNode.hasFocus;
      });

    });
    searchBarcontroller.currentPage.value = 'Category';

  }

  void _getInitialInfo() {
    categories = CategoryModel.getCategories();
    diets = DietModel.getDiets();
    popularDiets = PopularDietsModel.getPopularDiets();
  }

  void openFilterDialog(context) async {
    await FilterListDialog.display<String>(
      context,
      listData: DefaultList,
      selectedListData: searchBarcontroller.selectedIngredients.toList(),
      choiceChipLabel: (item) => item,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (item, query) {
        return item!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        searchBarcontroller.updateSelectedIngredients(List<String>.from(list!));
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category'),
      ),
      body: Column(
        children: [
          _searchField(),
          SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Recipes',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Obx(() {
            return searchBarcontroller.filteredRecipe.isNotEmpty

                ? Expanded(
                    child: SizedBox(
                      height: 240,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          final diet = searchBarcontroller.filteredRecipe[index];
                          return Container(
                            width: 210,
                            decoration: BoxDecoration(
                              color: diet.boxColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(diet.iconPath),
                                Column(
                                  children: [
                                    Text(
                                      diet.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${diet.level} | ${diet.duration} | ${diet.calorie}',
                                      style: const TextStyle(
                                        color: Color(0xff7B6F72),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RecipeScreen()),
                                      );
                                      setState(() {
                                        DietModel.updateSelectedDiet(
                                            diets, index);
                                      });
                                    },
                                    child: Container(
                                      height: 45,
                                      width: 130,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            !diet.viewIsSelected
                                                ? const Color(0xff9DCEFF)
                                                : Colors.transparent,
                                            !diet.viewIsSelected
                                                ? const Color(0xff92A3FD)
                                                : Colors.transparent
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Center(
                                        child: Text(
                                          'View',
                                          style: TextStyle(
                                              color:
                                                  !diet.viewIsSelected
                                                      ? Colors.white
                                                      : const Color(0xffC58BF2),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          );
                        },
                        itemCount: searchBarcontroller.filteredRecipe.length,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                      ),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xff1D1617).withOpacity(0.11),
                              blurRadius: 40,
                              spreadRadius: 0.0)
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    height: 100,
                    child: const Center(
                      child: Text(
                        'No recipes found',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
          }),
        ],
      ),
    );
  }

  Container _searchField() {
    return Container(
        margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: const Color(0xff1D1617).withOpacity(0.11),
              blurRadius: 40,
              spreadRadius: 0.0)
        ]),
        child: Column(
          children: [
            TextField(
              onTapOutside: (event) {
                if (event.position.dy < 400) {
                  return;
                }

                searchControllerToRemove.clear();

                setState(() {
                  searchFocusNode.unfocus();
                });
              },
              onChanged: (value) {
                searchBarcontroller.updateSearchQuery(value.toLowerCase());

                setState(() {
                  searchFocusNode.hasFocus;
                });
              },
              focusNode: searchFocusNode,
              controller: searchControllerToRemove,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(15),
                  hintText: 'Search Pancake',
                  hintStyle:
                      const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
                  prefixIcon: !searchFocusNode.hasFocus
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset('assets/icons/Search.svg'),
                        )
                      : GestureDetector(
                          onTap: () {
                            searchControllerToRemove.clear();
                            searchBarcontroller.updateSearchQuery('');
                            setState(() {
                              searchFocusNode.unfocus();
                            });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                  'assets/icons/exitSearch.svg'))),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const VerticalDivider(
                            color: Colors.black,
                            indent: 10,
                            endIndent: 10,
                            thickness: 0.1,
                          ),
                          GestureDetector(
                              onTap: () => openFilterDialog(context),
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: SvgPicture.asset(
                                        'assets/icons/Filter.svg'),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              return isFocused.value &&
                      searchBarcontroller.filteredRecipe.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color:
                                    const Color(0xff1D1617).withOpacity(0.11),
                                blurRadius: 40,
                                spreadRadius: 0.0)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      height: 300,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  crossAxisCount: 2),
                          itemCount: searchBarcontroller.filteredRecipe.length,
                          itemBuilder: (context, index) {
                            final diet =
                                searchBarcontroller.filteredRecipe[index];
                            return SizedBox(
                              height: 240,
                              child: ListView.separated(
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 210,
                                    decoration: BoxDecoration(
                                      color: diet
                                          .boxColor
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SvgPicture.asset(diet.iconPath),
                                        Column(
                                          children: [
                                            Text(
                                              diet.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              '${diet.level} | ${diet.duration} | ${diet.calorie}',
                                              style: const TextStyle(
                                                color: Color(0xff7B6F72),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        RecipeScreen()),
                                              );
                                              setState(() {
                                                DietModel.updateSelectedDiet(
                                                    diets, index);
                                              });
                                            },
                                            child: Container(
                                              height: 45,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      LinearGradient(colors: [
                                                    !diet.viewIsSelected
                                                        ? const Color(
                                                            0xff9DCEFF)
                                                        : Colors.transparent,
                                                    !diet.viewIsSelected
                                                        ? const Color(
                                                            0xff92A3FD)
                                                        : Colors.transparent
                                                  ]),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Center(
                                                child: Text(
                                                  'View',
                                                  style: TextStyle(
                                                      color: !diet
                                                              .viewIsSelected
                                                          ? Colors.white
                                                          : const Color(
                                                              0xffC58BF2),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ))
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  width: 25,
                                ),
                                itemCount: diets.length,
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                              ),
                            );
                          }),
                    )
                  : isFocused.value &&
                          searchBarcontroller.searchQuery.value.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xff1D1617)
                                        .withOpacity(0.11),
                                    blurRadius: 40,
                                    spreadRadius: 0.0)
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          height: 100,
                          child: const Center(
                            child: Text(
                              'No recipes found',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : Container();
            }),
          ],
        ));
  }
}
