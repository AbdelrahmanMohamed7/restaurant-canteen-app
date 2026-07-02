import 'package:flutter/material.dart';
import '../../model/order_model.dart';
import '../../state/main_state.dart';
import '../../strings/order_history_string.dart';
import '../../view_model/order_history_vm/order_history_view_model_imp.dart';
import 'order_history_list_widget.dart';

class OrderHistoryWidget extends StatelessWidget {
  final OrderHistoryViewModelImp vm;
  final MainStateController mainStateController;
  final String orderStatusMode;


  OrderHistoryWidget(this.vm, this.mainStateController, this.orderStatusMode);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: vm.getUserHistory(
          mainStateController.selectedRestaurant.value.restaurantId,orderStatusMode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else {
          var lst = snapshot.data as List<OrderModel>;
          if(lst.length == 0)
          return Center(child: Text(emptyText),);
          return OrderHistoryListWidget(listOrder: lst, orderStatusMode: orderStatusMode, restaurantId: mainStateController.selectedRestaurant.value.restaurantId,);
        }
      },
    );
  }
}