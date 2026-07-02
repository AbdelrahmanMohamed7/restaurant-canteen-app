import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../model/cart_model.dart';
import '../../screens/auth/login_option_screen.dart';
import '../../screens/place_order_screen.dart';
import '../../state/cart_state.dart';
import '../../state/main_state.dart';
import '../menu/menu_viewmodel_imp.dart';
import 'cart_view_model.dart';

class CartViewModelImp implements CartViewModel {
  final MainStateController mainStateController = Get.find();
  final MenuViewModelImp menuViewModelImp = MenuViewModelImp();

  @override
  void updateCart(CartStateController controller, String restaurantId,
      int index, int value) {
    controller.cart.value = controller.getCart(restaurantId);
    controller.cart[index].quantity = value;
    controller.cart.refresh();
    controller.saveDatabase();
  }

  @override
  void deleteCart(
      CartStateController controller, String restaurantId, int index) {
    controller.cart.value = controller.getCart(restaurantId);
    controller.cart.removeAt(index);
    controller.saveDatabase();
  }

  @override
  void clearCart(CartStateController controller) {
    controller
        .clearCart(mainStateController.selectedRestaurant.value.restaurantId);
  }

  @override
  processCheckOut(BuildContext context, List<CartModel> cart) {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.to(() => PlaceOrderScreen());
    } else {
      Get.to(() => SelectionScreen());
      // menuViewModelImp.login(context);
    }
  }
}
