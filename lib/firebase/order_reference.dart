import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../consts.dart';
import '../model/order_model.dart';

Future<bool> writeOrderToFirebase(OrderModel orderModel) async {
  try {
    await FirebaseDatabase.instance
        .ref()
        .child(RESTAURANT_REF)
        .child(orderModel.restaurantId)
        .child(ORDER_REF)
        .child(orderModel.orderNumber)
        .set(orderModel.toJson());

    return true;
  }
  catch (e) {
    print(e);
    return false;
  }
}

Future<List<OrderModel>> getUserOrdersByRestaurant(String restaurantId,
    String statusMode) async {
  var orderStatusMode=-1;
  if(statusMode == ORDER_CANCELLED){
    orderStatusMode =  3;
  }else if(statusMode==ORDER_PROCESSING){
    orderStatusMode=1;
  }else if(statusMode==ORDER_NEW){
    orderStatusMode=0;
  }else if(statusMode==ORDER_SHIPPED){
    orderStatusMode=2;
  }
  var userId = FirebaseAuth.instance.currentUser?.uid;
  var list = new List<OrderModel>.empty(growable: true);
  var source = await FirebaseDatabase.instance
      .ref()
      .child(RESTAURANT_REF)
      .child(restaurantId)
      .child(ORDER_REF)
      .orderByChild('userId')
      .equalTo(userId)
      .once();
  var values = source.snapshot;
  list.clear();
  values.children.forEach((element) {
    OrderModel orderModel=OrderModel.fromJson(jsonDecode(jsonEncode(element.value)));
    if(orderModel.orderStatus==orderStatusMode){
      list.add(orderModel);
    }

  });
  return list;
}