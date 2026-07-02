import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../consts.dart';
import '../../screens/cart_screen.dart';
import '../../screens/category.dart';
import '../../screens/manager_restaurant_screen.dart';
import '../../screens/order_history_screen.dart';
import '../../screens/restaurant_home.dart';
import '../../state/cart_state.dart';
import '../../state/main_state.dart';
import '../../strings/main_string.dart';
import 'menu_viewmodel.dart';

class MenuViewModelImp implements MenuViewModel {
  final cartState = Get.put(CartStateController());
  final mainState = Get.put(MainStateController());

  @override
  void navigateCategories() {
    Get.to(() => CategoryScreen());
  }

  @override
  void backToRestaurantList() {
    Get.back(closeOverlays: true, canPop: false);
  }

  @override
  bool checkLoginState(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null ? true : false;
  }

  @override
  void login(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      try{

        navigationHome(context);
      }catch(e,stk){
        Get.snackbar('ALERT', e.toString());
        print(stk);
      }
    }
  }

  @override
  void logout(BuildContext context) {
    Get.defaultDialog(
      title: logoutTitle,
      content: Text(logoutMessageText),
      backgroundColor: Colors.white,
      cancel:
          ElevatedButton(onPressed: () => Get.back(), child: Text(cancelText)),
      confirm: ElevatedButton(
          onPressed: () {
            FirebaseAuth.instance
                .signOut()
                .then((value) => Get.offAll(RestaurantHome()));
          },
          child:
              Text(confirmText, style: const TextStyle(color: Colors.yellow))),
    );
  }

  @override
  void navigationHome(BuildContext context) async {
    var token = await FirebaseAuth.instance.currentUser!.getIdToken();
    var box = GetStorage();
    //Save token, use for send Notification
    box.write(KEY_TOKEN, token);
    //Clone Cart
    if (cartState.cart.isNotEmpty) // if not empty
    {
      var newCart = cartState.getCartAnonymous(mainState
          .selectedRestaurant
          .value
          .restaurantId);
      for(var cart in newCart) {
        cart.userUid = FirebaseAuth.instance.currentUser!.uid; //co
      }// py , Remember get only Anonymous ^^ , if forget it , it will clone all ACcount cart
      // cartState.mergeCart(newCart,
      //     mainState.selectedRestaurant.value.restaurantId); //add to global cart
      // cartState.saveDatabase(); //Save
    }
     Get.offAll(() => RestaurantHome());
  }

  @override
  void navigateCart() => Get.to(() => CartDetailScreen(
        userLatLng: LatLng(0, 0),
      ));

  @override
  void viewOrderHistory(BuildContext context) {
    Get.to(() => OrderHistory());
  }

  @override
  void managerRestaurant(BuildContext context) {
    Get.to(() => ManagerRestaurantScreen());
  }
}
