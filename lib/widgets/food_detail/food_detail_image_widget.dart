import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../consts.dart';
import '../../state/cart_state.dart';
import '../../state/food_detail_state.dart';
import '../../state/food_list_state.dart';
import '../../state/main_state.dart';
import '../../utils/utils.dart';

class FoodDetailImageWidget extends StatelessWidget {
  final CartStateController cartStateController = Get.find();
  final FoodDetailStateController foodDetailStateController = Get.find();
  final MainStateController mainStateController = Get.find();
  FoodDetailImageWidget({
    Key? key,
    required this.foodListStateController,
  }) : super(key: key) {
  }

  final FoodListStateController foodListStateController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: foodDetailImageAreaSize(context) * 0.9,
          child: Hero(
            tag: foodListStateController.selectedFood.value.name,
            child: CachedNetworkImage(
                imageUrl: foodListStateController.selectedFood.value.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, err) => const Center(
                      child: Icon(Icons.image),
                    ),
                progressIndicatorBuilder: (context, url, dowloadProgress) =>
                    const Center(
                      child: CircularProgressIndicator(),
                    )),
          ),
        ),
        Align(
          alignment: const Alignment(0.8, 1.0),
          heightFactor: 0.5,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  heroTag: FAB_FAV_TAG,
                  onPressed: () {},
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                  ),
                  backgroundColor: Colors.white,
                  elevation: 10,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
