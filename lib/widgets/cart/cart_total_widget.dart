import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../state/cart_state.dart';
import '../../state/main_state.dart';
import '../../strings/cart_strings.dart';
import 'cart_total_item_widget.dart';

class TotalWidget extends StatelessWidget {
  TotalWidget(
      {Key? key, required this.controller, required this.distanceInMeters})
      : super(key: key);
  final double distanceInMeters;
  final CartStateController controller;
  final MainStateController mainStateController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TotalItemWidget(
              text: totalText,
              value: controller.sumCart(
                  mainStateController.selectedRestaurant.value.restaurantId).toString(),
              isSubTotal: false,
            ),
            Divider(thickness: 2),
            TotalItemWidget(
              text: shippingFeeText,
              value: 'To Subject',
              isSubTotal: false,
            ),
            Divider(thickness: 2),
            TotalItemWidget(
              text: subTotalText,
              value: controller.getSubTotal(
                  mainStateController.selectedRestaurant.value.restaurantId).toString(),
              isSubTotal: true,
            ),
          ],
        ),
      ),
    );

  }
}
