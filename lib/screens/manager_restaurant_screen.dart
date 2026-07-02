import 'dart:convert';

import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../consts.dart';
import '../firebase/server_manager_state.dart';
import '../firebase/server_user_reference.dart';
import '../model/order_model.dart';
import '../model/server_user_model.dart';
import '../state/main_state.dart';
import '../state/order_history_state.dart';
import '../strings/cart_strings.dart';
import '../strings/manager_restaurant_string.dart';
import '../strings/place_order_strings.dart';
import '../strings/restaurant_home_strings.dart';
import '../utils/utils.dart';
import '../view_model/manager_restaurant_vm/manager_restaurant_view_model.dart';
import '../view_model/manager_restaurant_vm/manager_restaurant_view_model_imp.dart';
import '../widgets/common/common_widget.dart';
import 'order_view_detail_screen.dart';

class ManagerRestaurantScreen extends StatefulWidget {
  const ManagerRestaurantScreen({Key? key}) : super(key: key);

  @override
  _ManagerRestaurantScreenState createState() =>
      _ManagerRestaurantScreenState();
}

class _ManagerRestaurantScreenState extends State<ManagerRestaurantScreen> {
  ServerManagerState serverManagerState = Get.put(ServerManagerState());
  MainStateController mainStateController = Get.find();
  final orderDetailState = Get.put(OrderHistoryState());
  ManagerRestaurantViewModel managerRestaurantViewModel =
      ManagerRestaurantVMImp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      var result =
          await checkIsServerUser(FirebaseAuth.instance.currentUser!.uid);
      serverManagerState.isServerLogin.value = result;
      if (!result) {
        showRegisterDialog();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(managerRestaurantText),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: getOrder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OrderModel> listOrder = snapshot.data ?? <OrderModel>[];
            return Column(
              children: [
                Expanded(
                    child: LiveList(
                  showItemDuration: Duration(milliseconds: 300),
                  showItemInterval: Duration(milliseconds: 300),
                  reAnimateOnVisibility: true,
                  scrollDirection: Axis.vertical,
                  itemCount: listOrder.length,
                  itemBuilder: animationItemBuilder((index) => InkWell(
                        onTap: () {
                          orderDetailState.selectedOrder.value =
                              listOrder[index];
                          Get.to(() => OrderViewDetailScreen());
                        },
                        child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      listOrder[index].cartItemList[0].image,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, err) => Center(
                                    child: Icon(Icons.image),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, download) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                        color: Color(COLOR_OVERLAY),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 20, bottom: 20),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Order #${listOrder[index].orderNumber}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .jetBrainsMono(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                          Text(
                                                            'Date #${convertToDate(listOrder[index].createdDate)}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .jetBrainsMono(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18),
                                                          ),
                                                          Text(
                                                            'Order Status:${convertStatus(listOrder[index].orderStatus)}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: GoogleFonts
                                                                .jetBrainsMono(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        18),
                                                          )
                                                        ],
                                                      )
                                                    ]))
                                          ],
                                        )))
                              ],
                            )),
                      )),
                ))
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<OrderModel>> getOrder() async {
    try {
      DatabaseEvent databaseEvent = await FirebaseDatabase.instance
          .ref()
          .child(RESTAURANT_REF)
          .child(mainStateController.selectedRestaurant.value.restaurantId)
          .child(ORDER_REF)
          .once();
      var values = databaseEvent.snapshot;
      List<OrderModel> orderList = <OrderModel>[];
      values.children.forEach((element) {
        orderList
            .add(OrderModel.fromJson(jsonDecode(jsonEncode(element.value))));
      });
      return orderList;
    } catch (e, stk) {
      print(e);
      print(stk);
      return <OrderModel>[];
    }
  }

  void showRegisterDialog() {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    Get.defaultDialog(
        title: registerMangerText,
        content: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: firstNameController,
                        validator: ValidationBuilder(
                                requiredMessage:
                                    '$firstNameText $isRequiredText')
                            .required()
                            .build(),
                        decoration: InputDecoration(
                            hintText: firstNameText,
                            label: Text(firstNameText),
                            border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: lastNameController,
                        validator: ValidationBuilder(
                                requiredMessage:
                                    '$lastNameText $isRequiredText')
                            .required()
                            .build(),
                        decoration: InputDecoration(
                            hintText: lastNameText,
                            label: Text(lastNameText),
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        textConfirm: registerText,
        textCancel: cancelText,
        confirmTextColor: Colors.white,
        onConfirm: () async {
          ServerUserModel serverUserModel = ServerUserModel(
              '${firstNameController.text} ${lastNameController.text}',
              mainStateController.selectedRestaurant.value.restaurantId,
              FirebaseAuth.instance.currentUser!.uid,
              FirebaseAuth.instance.currentUser!.phoneNumber.toString());
          await managerRestaurantViewModel.registerServerUser(serverUserModel);
        });
  }
}
