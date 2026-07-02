import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:badges/badges.dart' as badges;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/cart_state.dart';
import '../state/category_state.dart';
import '../state/food_detail_state.dart';
import '../state/food_list_state.dart';
import '../state/main_state.dart';
import '../strings/food_detail_strings.dart';
import '../utils/utils.dart';
import '../widgets/food_detail/food_detail_description_widget.dart';
import '../widgets/food_detail/food_detail_image_widget.dart';
import '../widgets/food_detail/food_detail_name_widget.dart';
import '../widgets/food_detail/food_detail_size_widget.dart';
import 'address/address.dart';
import 'auth/login_option_screen.dart';

class FoodDetailScreen extends StatelessWidget {
  final CategoryStateController categoryStateController = Get.find();
  final FoodListStateController foodListStateController = Get.find();
  final FoodDetailStateController foodDetailStateController =
      Get.put(FoodDetailStateController());
  final CartStateController cartStateController = Get.find();
  final MainStateController mainStateController = Get.find();

  // List<AddonModel> selectedAddon=[];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                cartStateController.addToCart(
                    foodListStateController.selectedFood.value,
                    mainStateController.selectedRestaurant.value.restaurantId,
                    addonList:
                        List.from(foodDetailStateController.selectedAddon),
                    quantity: foodDetailStateController.quantity.value);
              },
              child: Icon(
                Icons.add_shopping_cart,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              elevation: 10,
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    actions: [
                      Obx(() => badges.Badge(
                          position: badges.BadgePosition.topEnd(top: 0, end: 1),
                          showBadge: true,
                          badgeContent: Text(
                            '${cartStateController.getQuantity(mainStateController.selectedRestaurant.value.restaurantId)}',
                            style: GoogleFonts.jetBrainsMono(color: Colors.white),
                          ),
                          child: IconButton(
                              onPressed: () {
                                if (FirebaseAuth.instance.currentUser != null) {
                                  Get.to(() => AddressScreen());
                                } else {
                                  Get.to(() => SelectionScreen());
                                }
                              },
                              icon: Icon(Icons.shopping_bag)))),
                      SizedBox(
                        width: 20,
                      )
                    ],
                    title: Text(
                      '${foodListStateController.selectedFood.value.name}',
                      style: GoogleFonts.jetBrainsMono(color: Colors.black),
                    ),
                    elevation: 10,
                    // backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: Colors.black),
                    foregroundColor: Colors.black,
                    bottom: PreferredSize(
                      preferredSize:
                          Size.square(foodDetailImageAreaSize(context)),
                      child: FoodDetailImageWidget(
                          foodListStateController: foodListStateController),
                    ),
                  )
                ];
              },
              body: SingleChildScrollView(
                  child: Container(
                margin: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FoodNameDetailWidget(
                      foodListStateController: foodListStateController,
                      foodDetailStateController: foodDetailStateController,
                    ),
                    FoodDetailDescriptionWidget(
                        foodListStateController: foodListStateController),
                    FoodDetailSizeWidget(
                        foodListStateController: foodListStateController,
                        foodDetailStateController: foodDetailStateController),
                    Card(
                      elevation: 12,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() => ExpansionTile(
                                  title: Text(
                                    addonText,
                                    style: GoogleFonts.jetBrainsMono(
                                        color: Colors.blueGrey,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  children: [
                                    Wrap(
                                      children: foodListStateController
                                          .selectedFood.value.addon
                                          .map((e) => Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: ChoiceChip(
                                                  label: Column(
                                                    children: [
                                                      Text(e.name),
                                                      Text(e.price.toString()),
                                                    ],
                                                  ),
                                                  selected:
                                                      foodDetailStateController
                                                          .selectedAddon
                                                          .contains(e),
                                                  selectedColor: Colors.yellow,
                                                  onSelected: (selected) {
                                                    selected
                                                        ? foodDetailStateController
                                                            .selectedAddon
                                                            .add(e)
                                                        : foodDetailStateController
                                                            .selectedAddon
                                                            .remove(e);
                                                    print(
                                                        foodDetailStateController
                                                            .selectedAddon);
                                                  },
                                                ),
                                              ))
                                          .toList(),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
            )));
  }
}
