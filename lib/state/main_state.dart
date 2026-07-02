
import 'package:get/get.dart';

import '../model/restaurant_model.dart';

class MainStateController extends GetxController{
  var selectedRestaurant = RestaurantModel(address: 'address',
      name: 'name',
      imageUrl: 'imageUrl',
      paymentUrl: 'paymentUrl',
      phone: 'phone').obs;

}