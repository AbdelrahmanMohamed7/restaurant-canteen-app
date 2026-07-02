
import 'food_model.dart';

class CartModel extends FoodModel {
  int quantity = 0;
  String restaurantId = '';
  String userUid = '';

  CartModel(
      {description,
      id,
      name,
      image,
      price,
      size,
      addon,
      required this.quantity,
      required this.restaurantId,
      required this.userUid})
      : super(
          id: id,
          name: name,
          image: image,
          price: price,
          size: size,
          addon: addon,
          description: description,
        );

  factory CartModel.fromJson(Map<dynamic, dynamic> json) {
    final food = FoodModel.fromJson(json);
    final quantity = json['quantity'];
    final restaurantId = json['restaurantId'];
    final userUid = json['userUid'];
    return CartModel(
        id: food.id,
        image: food.image,
        price: food.price,
        name: food.name,
        addon: food.addon,
        size: food.size,
        description: food.description,
        quantity: quantity,
        restaurantId: restaurantId,
        userUid: userUid);
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['description'] = description;
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['price'] = price;
    data['size'] = size.map((v) => v.toJson()).toList();
    data['addon'] = addon.map((v) => v.toJson()).toList();
    data['quantity'] = quantity;
    data['restaurantId'] = restaurantId;
    data['userUid'] = userUid;

    return data;
  }
}
