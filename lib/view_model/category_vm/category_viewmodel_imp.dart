import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import '../../consts.dart';
import '../../firebase/category_reference.dart';
import '../../model/category_model.dart';
import 'category_viewmodel.dart';

class CategoryViewModelImp implements CategoryViewModel {
  @override
  Future<List<CategoryModel>> displayCategoryByRestaurantId(
      String restaurantId) {
    return getCategoryByRestaurantId(restaurantId);
  }

  Future<CategoryModel> getBundleFromCategory(String restaurantId) async {
    DatabaseEvent databaseEvent = await FirebaseDatabase.instance
        .ref()
        .child(RESTAURANT_REF)
        .child(restaurantId)
        .child(CATEGORY_REF)
        .child('menu_08')
        .once();
    // print();
    CategoryModel categoryModel = CategoryModel.fromJson(
        jsonDecode(jsonEncode(databaseEvent.snapshot.value)));
    return categoryModel;
  }
}
