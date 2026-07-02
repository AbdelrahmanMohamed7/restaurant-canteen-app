import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../consts.dart';
import '../model/addon_model.dart';
import '../model/cart_model.dart';
import '../model/food_model.dart';
import '../strings/cart_strings.dart';

class CartStateController extends GetxController {
  var cart = List<CartModel>.empty(growable: true).obs;
  final box = GetStorage();
  List<CartModel> getCartAnonymous(String restaurantId) => cart
      .where((item) =>
          item.restaurantId == restaurantId && (item.userUid == KEY_ANONYMOUS))
      .toList();

  List<CartModel> getCart(String restaurantId) => cart
      .where((item) =>
          item.restaurantId == restaurantId &&
          (FirebaseAuth.instance.currentUser == null
              ? item.userUid == KEY_ANONYMOUS
              : item.userUid == FirebaseAuth.instance.currentUser!.uid))
      .toList();
//addonList optional parameter is added
  addToCart(FoodModel foodModel, String restaurantId,
      {int quantity = 1, List<AddonModel>? addonList}) async {
    try {
      double addonPrice = 0.0;
      //foreach loop
      for (AddonModel addonItem in addonList ?? []) {
        addonPrice += addonItem.price;
      }
      var cartItem = CartModel(
          id: foodModel.id,
          name: foodModel.name,
          description: foodModel.description,
          image: foodModel.image,
          price: foodModel.price + addonPrice,
          //When addonList is empty
          //
          addon: addonList == null ? <AddonModel>[] : addonList,
          size: foodModel.size,
          quantity: quantity,
          restaurantId: restaurantId,
          userUid: FirebaseAuth.instance.currentUser == null
              ? KEY_ANONYMOUS
              : FirebaseAuth.instance.currentUser!.uid);
      // for(CartModel c in cart){
      //   print(c.toJson());
      // }
      if (isExists(cartItem, restaurantId)) {
        var foodNeedToUpdate = getCartNeedUpdate(cartItem, restaurantId);
        if (foodNeedToUpdate != null) foodNeedToUpdate.quantity += quantity;
      } else {
        cart.add(
          cartItem,
        );
      }
      addonList=[];
      var jsonDBEncode = jsonEncode(cart);
      await box.write(MY_CART_KEY, jsonDBEncode);
      cart.refresh();
      Get.snackbar(successTitle, successMassage);
    } catch (e, stk) {
      Get.snackbar(errorTitle, e.toString());
      print(e);
      print(stk);
    }
  }

  isExists(CartModel cartItem, String restaurantId) => cart.any((e) {

    print(e.toJson());
    return
      e.id == cartItem.id &&
          e.restaurantId == restaurantId &&
          e.userUid ==
              (FirebaseAuth.instance.currentUser == null
                  ? KEY_ANONYMOUS
                  : FirebaseAuth.instance.currentUser!.uid) &&
          e.addon.length == cartItem.addon.length &&
          isAddonListSame(e.addon, cartItem.addon);
  });

  bool isAddonListSame(
      List<AddonModel> cartAddon, List<AddonModel> cartItemAddon) {
    if (cartAddon.length == cartItemAddon.length) {
      for (AddonModel item in cartItemAddon) {
        if (cartAddon.any((element){
          print(element.toJson());
          return element.name == item.name && element.price == item.price;
        })
            ) {
          print("true");
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
    return true;
  }

  sumCart(String restaurantId) => getCart(restaurantId).length == 0
      ? 0
      : getCart(restaurantId)
          .map((e) => e.price * e.quantity)
          .reduce((value, element) => value + element);

  getQuantity(String restaurantId) => getCart(restaurantId).length == 0
      ? 0
      : getCart(restaurantId)
          .map((e) => e.quantity)
          .reduce((value, element) => value + element);


  getSubTotal(String restaurantId) =>
      sumCart(restaurantId);

  clearCart(String restaurantId) {
    cart.value = getCart(restaurantId);
    cart.clear();
    saveDatabase();
  }

  saveDatabase() => box.write(MY_CART_KEY, jsonEncode(cart));

  void mergeCart(List<CartModel> cartItems, String restaurantId) {
    if (cart.length > 0) {
      cartItems.forEach((cartItem) {
        if (isExists(cartItem, restaurantId)) {
          var foodNeedToUpdate = getCartNeedUpdate(cartItem, restaurantId);
          if (foodNeedToUpdate != null) {
            foodNeedToUpdate.quantity += cartItem.quantity;
          } else {
            var newCart = cartItem;
            newCart.userUid = FirebaseAuth.instance.currentUser!.uid;
            cart.add(newCart);
          }
        }
      });
    }
  }

  getCartNeedUpdate(CartModel cartItem, String restaurantId) =>
      cart.firstWhere((e) =>
          e.id == cartItem.id &&
          e.restaurantId == restaurantId &&
          e.userUid ==
              (FirebaseAuth.instance.currentUser == null
                  ? KEY_ANONYMOUS
                  : FirebaseAuth.instance.currentUser!.uid));
}
