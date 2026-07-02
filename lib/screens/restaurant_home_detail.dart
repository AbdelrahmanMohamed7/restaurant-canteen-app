import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../state/cart_state.dart';
import '../state/main_state.dart';
import '../view_model/category_vm/category_viewmodel_imp.dart';
import '../view_model/restaurant_home_detail_vm/restaurant_home_detail_vm.dart';
import '../view_model/restaurant_home_detail_vm/restaurant_home_detail_vm_imp.dart';
import '../widgets/restaurant_home_detail/best_deal_widget.dart';
import '../widgets/restaurant_home_detail/most_popular_widget.dart';
import 'address/address.dart';
import 'auth/login_option_screen.dart';

class RestaurantHomeDetail extends StatelessWidget {
  final MainStateController mainStateController = Get.find();
  final RestaurantHomeDetailViewModel viewModel =
  RestaurantHomeDetailViewModelImp();
  final categoryViewModel = CategoryViewModelImp();
  final zoomDrawerController;

  RestaurantHomeDetail(this.zoomDrawerController);

  final CartStateController cartStateController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              '${mainStateController.selectedRestaurant.value.name}',
              style: GoogleFonts.jetBrainsMono(
                  color: Colors.black, fontWeight: FontWeight.w900),
            ),
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
            foregroundColor: Colors.black,
            elevation: 10,
            iconTheme: IconThemeData(color: Colors.black),
            leading: InkWell(
              child: Icon(Icons.view_headline),
              onTap: () => zoomDrawerController.toggle!(),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Flexible(
                  child: MostPopularWidget(
                      viewModel: categoryViewModel,
                      mainStateController: mainStateController),
                ),
                Flexible(
                  flex: 2,
                  child: BestDealsWidget(
                      viewModel: viewModel,
                      mainStateController: mainStateController),
                ),
              ],
            ),
          ),
        ));
  }
}
