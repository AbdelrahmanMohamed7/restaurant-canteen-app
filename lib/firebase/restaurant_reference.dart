import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../consts.dart';
import '../model/restaurant_model.dart';

Future<List<RestaurantModel>> getRestaurantlist() async{
  var list= List<RestaurantModel>.empty(growable: true);
  var source=
  await FirebaseDatabase.instance.ref().child(RESTAURANT_REF).once();
  var values = source.snapshot;
  RestaurantModel ? restaurantModel;
  values.children.forEach((element){
    restaurantModel= RestaurantModel.fromJson(jsonDecode(jsonEncode(element.value)));
    restaurantModel!.restaurantId= element.key!;
    list.add(restaurantModel!);
  });
  return list;

}