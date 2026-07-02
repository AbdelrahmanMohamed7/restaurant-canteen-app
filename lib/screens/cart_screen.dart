import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_elegant_number_button/flutter_elegant_number_button.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../consts.dart';
import '../model/distance_matrix_api_model.dart';
import '../model/resaurant_location_model.dart';
import '../state/cart_state.dart';
import '../state/main_state.dart';
import '../strings/cart_strings.dart';
import '../view_model/cart_vm/cart_view_model_imp.dart';
import '../widgets/cart/cart_image_widget.dart';
import '../widgets/cart/cart_info_widget.dart';
import '../widgets/cart/cart_total_widget.dart';

class CartDetailScreen extends StatelessWidget {
  final box = GetStorage();
  final CartStateController controller = Get.find();
  final MainStateController mainStateController = Get.find();
  final CartViewModelImp cartViewModel = CartViewModelImp();
  final LatLng? userLatLng;

  CartDetailScreen({Key? key, required this.userLatLng}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          controller.getQuantity(mainStateController
                      .selectedRestaurant.value.restaurantId) >
                  0
              ? IconButton(
                  onPressed: () => Get.defaultDialog(
                      title: clearCartConfirmTitleText,
                      middleText: clearCartConfirmContentText,
                      textCancel: cancelText,
                      textConfirm: confirmText,
                      confirmTextColor: Colors.yellow,
                      onConfirm: () => cartViewModel.clearCart(controller)),
                  icon: const Icon(Icons.clear))
              : Container(),
        ],
      ),
      body: controller.getQuantity(
                  mainStateController.selectedRestaurant.value.restaurantId) >
              0
          ? (userLatLng == null)
              ? Obx(() => Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: controller
                                  .getCart(mainStateController
                                      .selectedRestaurant.value.restaurantId)
                                  .length,
                              itemBuilder: (context, index) => Slidable(
                                  child: Card(
                                    elevation: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: CartImageWidget(
                                              cartModel: controller.getCart(
                                                  mainStateController
                                                      .selectedRestaurant
                                                      .value
                                                      .restaurantId)[index],
                                              controller: controller,
                                            ),
                                          ),
                                          Expanded(
                                              flex: 6,
                                              child: CartInfo(
                                                  cartModel: controller.getCart(
                                                          mainStateController
                                                              .selectedRestaurant
                                                              .value
                                                              .restaurantId)[
                                                      index])),
                                          Center(
                                            child: ElegantNumberButton(
                                                initialValue: controller
                                                    .getCart(mainStateController
                                                        .selectedRestaurant
                                                        .value
                                                        .restaurantId)[index]
                                                    .quantity,
                                                minValue: 1,
                                                maxValue: 100,
                                                color: Colors.amber,
                                                onChanged: (value) {
                                                  print(value);
                                                  cartViewModel.updateCart(
                                                      controller,
                                                      mainStateController
                                                          .selectedRestaurant
                                                          .value
                                                          .restaurantId,
                                                      index,
                                                      value.toInt());
                                                },
                                                decimalPlaces: 0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    extentRatio: 0.25,
                                    children: [
                                      SlidableAction(
                                        label: deleteText,
                                        icon: Icons.delete,
                                        backgroundColor: Colors.red,
                                        onPressed: (BuildContext context) => {
                                          Get.defaultDialog(
                                              title: deleteCartConfirmTitleText,
                                              middleText:
                                                  deleteCartConfirmContentText,
                                              textCancel: cancelText,
                                              textConfirm: confirmText,
                                              confirmTextColor: Colors.yellow,
                                              onConfirm: () {
                                                cartViewModel.deleteCart(
                                                    controller,
                                                    mainStateController
                                                        .selectedRestaurant
                                                        .value
                                                        .restaurantId,
                                                    index);
                                                Get.back();
                                              })
                                        },
                                      )
                                    ],
                                  )))),
                      TotalWidget(
                        controller: controller,
                        distanceInMeters: 0,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => cartViewModel.processCheckOut(
                            context,
                            controller.getCart(mainStateController
                                .selectedRestaurant.value.restaurantId),
                          ),
                          child: Text(checkOutText),
                        ),
                      )
                    ],
                  ))
              : Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: controller
                      .getCart(mainStateController
                      .selectedRestaurant
                      .value
                      .restaurantId)
                      .length,
                  itemBuilder: (context, index) =>
                      Slidable(
                          child: Card(
                            elevation: 8.0,
                            margin: const EdgeInsets
                                .symmetric(
                                horizontal: 10.0,
                                vertical: 6.0),
                            child: Container(
                              padding:
                              const EdgeInsets.all(
                                  8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .center,
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child:
                                    CartImageWidget(
                                      cartModel: controller.getCart(
                                          mainStateController
                                              .selectedRestaurant
                                              .value
                                              .restaurantId)[index],
                                      controller:
                                      controller,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 6,
                                      child: CartInfo(
                                          cartModel: controller.getCart(
                                              mainStateController
                                                  .selectedRestaurant
                                                  .value
                                                  .restaurantId)[index])),
                                  Center(
                                    child:
                                    ElegantNumberButton(
                                        initialValue: controller
                                            .getCart(
                                            mainStateController
                                                .selectedRestaurant
                                                .value
                                                .restaurantId)[
                                        index]
                                            .quantity,
                                        minValue: 1,
                                        maxValue: 100,
                                        color: Colors
                                            .amber,
                                        onChanged:
                                            (value) {
                                          print(
                                              value);
                                          cartViewModel.updateCart(
                                              controller,
                                              mainStateController
                                                  .selectedRestaurant
                                                  .value
                                                  .restaurantId,
                                              index,
                                              value
                                                  .toInt());
                                        },
                                        decimalPlaces:
                                        0),
                                  )
                                ],
                              ),
                            ),
                          ),
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                label: deleteText,
                                icon: Icons.delete,
                                backgroundColor:
                                Colors.red,
                                onPressed: (BuildContext
                                context) =>
                                {
                                  Get.defaultDialog(
                                      title:
                                      deleteCartConfirmTitleText,
                                      middleText:
                                      deleteCartConfirmContentText,
                                      textCancel:
                                      cancelText,
                                      textConfirm:
                                      confirmText,
                                      confirmTextColor:
                                      Colors.yellow,
                                      onConfirm: () {
                                        cartViewModel.deleteCart(
                                            controller,
                                            mainStateController
                                                .selectedRestaurant
                                                .value
                                                .restaurantId,
                                            index);
                                        Get.back();
                                      })
                                },
                              )
                            ],
                          )))),
          TotalWidget(
            controller: controller,
            distanceInMeters: 0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                vertical: 4, horizontal: 8),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () =>
                  cartViewModel.processCheckOut(
                    context,
                    controller.getCart(
                        mainStateController
                            .selectedRestaurant
                            .value
                            .restaurantId),
                  ),
              child: Text(checkOutText),
            ),
          )
        ],
      )
          : Center(
              child: Text(cartEmptyText),
            ),
    );
  }

  Future<double> getDistance() async {
    try {
      // Position userPosition = await _determinePosition();
      RestaurantLocationModel restaurantLocationModel =
          await getRestaurantLatLng();
      // RestaurantLocationModel restaurantLocationModel =
      //     RestaurantLocationModel(lat: 33.5651, lng: 73.0169);
      // print(distanceMatrixApiModel.toJson());
      DistanceMatrixApiModel? distanceMatrixApiModel =
          await getDistanceMatrixApiModel(restaurantLocationModel);
      if (distanceMatrixApiModel != null) {
        if (distanceMatrixApiModel.status == 'OK') {
          if (distanceMatrixApiModel.rows!.isNotEmpty &&
              distanceMatrixApiModel.rows![0].elements![0].status == 'OK') {
            List<String> list = distanceMatrixApiModel
                .rows![0].elements![0].distance!.text!
                .split(' ');
            if (list[1] == 'm') {
              return double.parse(list[0]);
            } else if (list[1] == 'km') {
              print(list[0].runtimeType);
              return double.parse(list[0].replaceAll(',', '')) * 1000;
            }
          }

          return -1.0;
        } else {
          return -1.0;
        }
      } else {
        return -1.0;
      }
    } on Exception catch (e, stk) {
      print(e);
      print(stk);
      return -1.0;
    }
  }

  Future<DistanceMatrixApiModel?> getDistanceMatrixApiModel(
      RestaurantLocationModel restaurantLocationModel) async {
    try {
      if (kIsWeb) {
        Uri url = Uri.parse(
            'https://googlemapapi.ahmedzahuid.repl.co/tojitos/getDistanceMatrixApi');
        var response = await http.post(url, body: {
          'destinationsLat': restaurantLocationModel.lat.toString(),
          'destinationsLong': restaurantLocationModel.lng.toString(),
          'originsLat': userLatLng!.latitude.toString(),
          'originsLong': userLatLng!.longitude.toString(),
          'key': GOOGLE_MAP_API_KEY
        });
        if (response.statusCode == 200) {
          return DistanceMatrixApiModel.fromJson(jsonDecode(response.body));
        }
      } else {
        Uri url = getDistanceLocationApiLink(restaurantLocationModel);
        var response = await http.get(url);

        if (response.statusCode == 200) {
          return DistanceMatrixApiModel.fromJson(jsonDecode(response.body));
        }
      }
    } catch (e, stk) {
      print(e);
      print(stk);
    }
    return null;
  }

  Future<RestaurantLocationModel> getRestaurantLatLng() async {
    DatabaseEvent databaseEvent = await FirebaseDatabase.instance
        .ref()
        .child(RESTAURANT_REF)
        .child(mainStateController.selectedRestaurant.value.restaurantId)
        .child(LOCATION_REF)
        .once();
    print(mainStateController.selectedRestaurant.value.restaurantId);
    DataSnapshot values = databaseEvent.snapshot;
    return RestaurantLocationModel.fromJson(
        jsonDecode(jsonEncode(values.value)));
  }

  Uri getDistanceLocationApiLink(
      RestaurantLocationModel restaurantLocationModel) {
    return Uri.parse(
      "https://maps.googleapis.com/maps/api/distancematrix/json?" +
          "destinations=${restaurantLocationModel.lat},${restaurantLocationModel.lng}&origins=${userLatLng!.latitude},${userLatLng!.longitude}&key=$GOOGLE_MAP_API_KEY",
    );
  }

  /// Determine the current position of the device.
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition();
  // }
}
