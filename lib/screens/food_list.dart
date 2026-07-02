import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts.dart';
import '../state/cart_state.dart';
import '../state/category_state.dart';
import '../state/food_list_state.dart';
import '../state/main_state.dart';
import '../strings/food_list_string.dart';
import '../widgets/common/appbar_with_cart_widget.dart';
import '../widgets/common/common_widget.dart';
import 'food_detail.dart';

class FoodListScreen extends StatelessWidget {
  final CategoryStateController categoryStateController = Get.find();
  final MainStateController mainStateController = Get.find();
  final FoodListStateController foodListStateController =
      Get.find<FoodListStateController>();
  final CartStateController cartStateController = Get.find();
  // final FoodDetailStateController foodDetailStateController = Get.find();
  //FoodListScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarWithCartButton(
            title: '${categoryStateController.selectedCategory.value.name}'),
        body: Column(children: [
          Expanded(
            child: LiveList(
              showItemInterval: const Duration(milliseconds: 300),
              showItemDuration: const Duration(milliseconds: 300),
              reAnimateOnVisibility: true,
              scrollDirection: Axis.vertical,
              itemCount:
                  categoryStateController.selectedCategory.value.foods.length,
              itemBuilder: animationItemBuilder((index) => InkWell(
                    onTap: () {
                      //assign state controller
                      foodListStateController.selectedFood.value =
                          categoryStateController
                              .selectedCategory.value.foods[index];
                      Get.to(() => FoodDetailScreen());
                    },
                    child: Hero(
                      tag: categoryStateController
                          .selectedCategory.value.foods[index].name,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height / 6 * 2,
                          child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                      imageUrl: categoryStateController
                                          .selectedCategory
                                          .value
                                          .foods[index]
                                          .image,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, err) =>
                                          const Center(
                                            child: Icon(Icons.image),
                                          ),
                                      progressIndicatorBuilder: (context, url,
                                              dowloadProgress) =>
                                          const Center(
                                            child: CircularProgressIndicator(),
                                          )),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        color: Color(COLOR_OVERLAY),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            '${categoryStateController.selectedCategory.value.foods[index].name}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .jetBrainsMono(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18)),
                                                        Text(
                                                            '$priceText: ${categoryStateController.selectedCategory.value.foods[index].price}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .jetBrainsMono(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18)),

                                                      ],
                                                    )
                                                  ],
                                                ))
                                          ],
                                        )),
                                  )
                                ],
                              ))),
                    ),
                  )),
            ),
          )
        ]));
  }
}
