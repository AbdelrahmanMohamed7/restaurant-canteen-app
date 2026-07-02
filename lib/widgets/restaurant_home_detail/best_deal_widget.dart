import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/category_model.dart';
import '../../screens/food_detail.dart';
import '../../state/food_list_state.dart';
import '../../state/main_state.dart';
import '../../view_model/category_vm/category_viewmodel_imp.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../view_model/restaurant_home_detail_vm/restaurant_home_detail_vm.dart';

class BestDealsWidget extends StatelessWidget {
  BestDealsWidget({
    Key? key,
    required this.viewModel,
    required this.mainStateController,
  }) : super(key: key);

  final RestaurantHomeDetailViewModel viewModel;
  final MainStateController mainStateController;
  final categoryViewModel = CategoryViewModelImp();
  final FoodListStateController foodListStateController =
      Get.put(FoodListStateController());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<CategoryModel>(
        future: categoryViewModel.getBundleFromCategory(
            mainStateController.selectedRestaurant.value.restaurantId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            // print(snapshot.data);
            CategoryModel categoryModel = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('OFFERS',style: GoogleFonts.jetBrainsMono(
                fontWeight: FontWeight.w900,
                fontSize: 24,
                color: Colors.black45),
            ),
                CarouselSlider(
                    items: categoryModel.foods
                        .map((e) => Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    foodListStateController.selectedFood.value = e;
                                    Get.to(() => FoodDetailScreen());
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Card(
                                        semanticContainer: true,
                                        clipBehavior: Clip.antiAliasWithSaveLayer,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(e.image,
                                                fit: BoxFit.cover,
                                                // errorWidget: (context, url,
                                                //         err) =>
                                                //     Center(
                                                //       child: Icon(Icons.image),
                                                //     ),
                                                // progressIndicatorBuilder:
                                                //     (context, url,
                                                //             dowloadProgress) =>
                                                //         Center(
                                                //           child:
                                                //               CircularProgressIndicator(),
                                                //         )
                                                      ),
                                            Center(
                                                child: Text('${e.name}',
                                                    style:
                                                        GoogleFonts.jetBrainsMono(
                                                            color: Colors.white,
                                                            fontSize: 18)))
                                          ],
                                        )),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                    options: CarouselOptions(
                        autoPlay: true,
                        autoPlayAnimationDuration: Duration(seconds: 3),
                        autoPlayCurve: Curves.easeIn,
                        height: Get.height * 0.5)),
              ],
            );
          }
        },
      ),
    );
  }
}
