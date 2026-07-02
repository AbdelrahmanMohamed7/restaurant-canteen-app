
import '../../model/order_model.dart';
import '../../state/cart_state.dart';

abstract class ProcessOrderViewModel {
  Future<bool> submitOrder(OrderModel orderModel);

  Future<OrderModel> createOrderModel(
      {required String restaurantId,
      required double discount,
      required String firstName,
      required String lastName,
      required String address,
      required String comment,
      required bool isCod,
      required CartStateController cartStateController});
}
