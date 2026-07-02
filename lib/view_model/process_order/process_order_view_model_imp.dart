import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:restaurant_cantine_app/view_model/process_order/process_order_view_model.dart';

import '../../firebase/order_reference.dart';
import '../../model/order_model.dart';
import '../../model/server_time_offset.dart';
import '../../state/cart_state.dart';
import '../../utils/utils.dart';

class ProcessOrderViewModelImp extends ProcessOrderViewModel {
  @override
  Future<bool> submitOrder(OrderModel orderModel) {
    return writeOrderToFirebase(orderModel);
  }

  @override
  Future<OrderModel> createOrderModel(
      {required String restaurantId,
      required double discount,
      required String firstName,
      required String lastName,
      required String address,
      required String comment,
      required bool isCod,
      required CartStateController cartStateController}) async {
    var serverTime = await getServerTimeOffset();
    Get.snackbar('Order Accepted', 'Your order will be shipped soon');
    return OrderModel(
        userId: FirebaseAuth.instance.currentUser!.uid,
        userName: '$firstName $lastName',
        userPhone: FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
        shippingAddress: address,
        comment: comment,
        orderNumber: createOrderNumber(serverTime).toString(),
        restaurantId: restaurantId,
        totalPayment: cartStateController.getSubTotal(restaurantId),
        finalPayment: calculateFinalPayment(
            cartStateController.getSubTotal(restaurantId), discount),
        shippingCost: 0,
        discount: discount,
        isCod: isCod,
        cartItemList: cartStateController.getCart(restaurantId),
        orderStatus: 0,
        createdDate: serverTime);
  }
}
