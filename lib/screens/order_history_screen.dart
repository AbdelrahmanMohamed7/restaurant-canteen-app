import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts.dart';
import '../state/main_state.dart';
import '../strings/main_string.dart';
import '../view_model/order_history_vm/order_history_view_model_imp.dart';
import '../widgets/order_history/order_history_widget.dart';

class OrderHistory extends StatelessWidget {
  final vm = new OrderHistoryViewModelImp();
  final MainStateController mainStateController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DefaultTabController(length: 4,child: Scaffold(
          appBar: AppBar(
            title: Text(orderHistoryText),
            bottom: TabBar(tabs: [
              Tab(child: Text('NEW'),),
              Tab(child: Text('PROCESS'),),
              Tab(child: Text('SHIPPED'),),
              Tab(child: Text('CANCEL'),),


            ],),
          ),
          body: TabBarView(
            children:[
              OrderHistoryWidget(vm, mainStateController, ORDER_NEW),
              OrderHistoryWidget(vm, mainStateController, ORDER_PROCESSING),
              OrderHistoryWidget(vm, mainStateController, ORDER_SHIPPED),
              OrderHistoryWidget(vm, mainStateController, ORDER_CANCELLED),

            ],
          ),
        ),));
  }
}
