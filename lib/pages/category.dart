import 'package:final_project/controllers/user_controller.dart';
import 'package:final_project/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:filter_list/filter_list.dart';
import 'package:get/get.dart';
import 'package:final_project/controllers/diet_controller.dart';
import 'package:final_project/models/diet_model.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/pages/recipe.dart';

List<String> DefaultList = [
  'Pasta',
  'Tomato',
  'Cheese',
  'Pizza base',
  'Salmon',
  'Rice',
  'Nori',
  'Bola'
];

class CategoryPage extends StatefulWidget {
  final String category;
  final UserModel user;
  CategoryPage({super.key, required this.category, required this.user});
  @override
  _CategoryPageState createState() => _CategoryPageState(user: user);
}

class _CategoryPageState extends State<CategoryPage> {
  final UserController userController = UserController();
  final searchControllerToRemove = TextEditingController();
  final searchFocusNode = FocusNode();
  final dietController = Get.put(DietController());
  final isFocused = false.obs;
  late List<DietModel> diets;
  final UserModel user;
  _CategoryPageState({required this.user});

  @override
  void initState() {
    super.initState();
    _getInitialInfo();
    searchFocusNode.addListener(() {
      setState(() {
        isFocused.value = searchFocusNode.hasFocus;
      });
    });
    dietController.updateCurrentPage('${widget.category} Category');
    // dietController.currentPage.value = '${widget.category} Category';
  }

  void _getInitialInfo() async {
    try {
      diets = await DietController().getDietsByCategory;
    } catch (e) {
      if (e.toString() == 'Exception: No internet connection') {
        Get.snackbar(
            'No internet connection', 'Please check your internet connection');
      } else {
        Get.snackbar('Error', 'Failed to retrieve diets by category');
      }
    }
  }

  void openFilterDialog(context) async {
    await FilterListDialog.display<String>(
      context,
      listData: DefaultList,
      selectedListData: dietController.selectedIngredients.toList(),
      choiceChipLabel: (item) => item,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (item, query) {
        return item.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        dietController.updateSelectedIngredients(List<String>.from(list!));
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.off(HomePage(
              user: user,
            ));
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(0xffF7F8F8),
                borderRadius: BorderRadius.circular(10)),
            child: SvgPicture.asset(
              'assets/icons/Arrow - Left 2.svg',
              height: 20,
              width: 20,
            ),
          ),
        ),
        // IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        actions: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                width: 37,
                decoration: BoxDecoration(
                    color: const Color(0xffF7F8F8),
                    borderRadius: BorderRadius.circular(10)),
                child: SvgPicture.asset(
                  'assets/icons/dots.svg',
                  height: 5,
                  width: 5,
                ),
              ),
            ),
          ),
        ],
        title: const Text('Category'),
      ),
      drawer: Drawer(
        shadowColor: const Color.fromARGB(0, 194, 146, 146),
        backgroundColor: const Color(0xffF7F8F8),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xffF7F8F8),
              ),
              accountName: Text(
                user.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/user_photo.png'),
              ),
            ),
          ],
        ),
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
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            return FutureBuilder<List<DietModel>>(
              future: dietController.filteredRecipe,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
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
                    margin: EdgeInsets.all(8),
                    child: const Center(
                      child: const Text(
                        'No recipes found',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                } else {
                  final filteredRecipes = snapshot.data!;
                  return Expanded(
                    child: SizedBox(
                      height: 240,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          final diet = filteredRecipes[index];
                          return Container(
                            width: 190,
                            decoration: BoxDecoration(
                              color: diet.boxColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SingleChildScrollView(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SvgPicture.asset(
                                  diet.iconPath,
                                  width: 60, // Adjust the width as needed
                                  height: 60, // Adjust the height as needed
                                ),
                                Column(
                                  children: [
                                    Text(
                                      diet.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${diet.level} | ${diet.duration} | ${diet.calorie}',
                                      style: const TextStyle(
                                        color: Color(0xff7B6F72),
                                        fontSize: 10,
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
                                                RecipeScreen(diet: diet)),
                                      );
                                      setState(() {
                                        DietModel.updateSelectedDiet(
                                            diets, index);
                                      });
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 100,
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
                                              color: !diet.viewIsSelected
                                                  ? Colors.white
                                                  : const Color(0xffC58BF2),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ))
                              ],
                            )),
                          );
                        },
                        itemCount: filteredRecipes.length,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                      ),
                    ),
                  );
                }
              },
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
                dietController.updateSearchQuery(value.toLowerCase());

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
                            dietController.updateSearchQuery('');
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
          ],
        ));
  }
}
