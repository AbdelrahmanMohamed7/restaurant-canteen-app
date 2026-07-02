import 'package:get/get.dart';

import '../model/cart_model.dart';
import '../model/order_model.dart';

class OrderHistoryState extends GetxController {
  var selectedOrder = OrderModel(userId: "userId",
      userName: 'userName',
      userPhone: 'userPhone',
      shippingAddress: 'shippingAddress',
      comment: 'comment',
      orderNumber: 'orderNumber',
      restaurantId: 'restaurantId',
      totalPayment: 0,
      finalPayment: 0,
      shippingCost: 0,
      discount: 0,
      isCod: true,
      cartItemList: List<CartModel>.empty(),
      orderStatus: 0,
      createdDate: 0).obs;
}