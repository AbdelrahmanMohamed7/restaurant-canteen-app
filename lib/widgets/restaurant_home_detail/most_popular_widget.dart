import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/category_model.dart';
import '../../screens/food_list.dart';
import '../../state/category_state.dart';
import '../../state/main_state.dart';
import '../../view_model/category_vm/category_viewmodel.dart';
import '../common/common_widget.dart';

class MostPopularWidget extends StatelessWidget {
  MostPopularWidget({
    Key? key,
    required this.viewModel,
    required this.mainStateController,
  }) : super(key: key);

  final CategoryViewModel viewModel;
  final MainStateController mainStateController;
  final CategoryStateController categoryStateController =
      Get.put(CategoryStateController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: viewModel.displayCategoryByRestaurantId(
            mainStateController.selectedRestaurant.value.restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            var lstPopular = snapshot.data as List<CategoryModel>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: GoogleFonts.jetBrainsMono(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Colors.black45),
                ),
                Expanded(
                    child: LiveList(
                  showItemDuration: Duration(milliseconds: 350),
                  showItemInterval: Duration(milliseconds: 150),
                  reAnimateOnVisibility: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: lstPopular.length,
                  itemBuilder: animationItemBuilder((index) => GestureDetector(
                        onTap: () async {
                          try {
                            categoryStateController.selectedCategory.value =
                                lstPopular[index];
                            Get.to(() => FoodListScreen());
                          } catch (e, stk) {
                            Get.snackbar('Error', e.toString());
                            print(stk);
                          }
                          // // print(dataSnapshot.value);
                          // print(lstPopular[index].toJson());
                        },
                        child: SizedBox(
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(lstPopular[index].image),
                                  radius: 48,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  lstPopular[index].name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.jetBrainsMono(),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                ))
              ],
            );
          }
        },
      ),
    );
  }
}
