import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_cantine_app/screens/restaurant_home.dart';

import '../consts.dart';
import '../model/order_model.dart';
import '../model/user/user_detail.dart';
import '../state/cart_state.dart';
import '../state/main_state.dart';
import '../state/place_order_state.dart';
import '../strings/cart_strings.dart';
import '../strings/place_order_strings.dart';
import '../view_model/process_order/process_order_view_model_imp.dart';

class PlaceOrderScreen extends StatefulWidget {
  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final placeOrderState = Get.put(PlaceOrderController());

  final placeOrderVM = ProcessOrderViewModelImp();

  final CartStateController cartStateController = Get.find();

  final MainStateController mainStateController = Get.find();

  final firstNameController = TextEditingController();

  final lastNameController = TextEditingController();

  final addressController = TextEditingController();

  final commentController = TextEditingController();

  final phoneNumberController = TextEditingController();

  Future<UserDetailModel?>? getUserDetailModelRef;

  final formKey = GlobalKey<FormState>();

  bool lock = true;
  @override
  void initState() {
    phoneNumberController.text =
        FirebaseAuth.instance.currentUser?.phoneNumber ?? '';
    getUserDetailModelRef = getUserDetailModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(placeOrderText),
      ),
      body: FutureBuilder<UserDetailModel?>(
          future: getUserDetailModelRef,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              print('Ahmed');
              print(snapshot.data);
              if (lock) {
                if (snapshot.data != null) {
                  UserDetailModel userDetailModel = snapshot.data!;
                  firstNameController.text = userDetailModel.firstName;
                  lastNameController.text = userDetailModel.lastName;
                  addressController.text = userDetailModel.address;
                  // print(userDetailModel.phoneNumber);
                  // print(userDetailModel.phoneNumber.replaceFirst('+20', ''));
                  String phoneNumberWithOutCountryCode =userDetailModel.phoneNumber.contains('+20')?
                  userDetailModel.phoneNumber.replaceFirst('+20', ''):userDetailModel.phoneNumber;
                  phoneNumberController.text = phoneNumberWithOutCountryCode;
                  commentController.text = userDetailModel.comment;
                }
                lock = false;
              }
              return Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
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
                        )),
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
                        ))
                      ]),
                      SizedBox(
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                              controller: addressController,
                              validator: ValidationBuilder(
                                      requiredMessage:
                                          '$addressText $isRequiredText')
                                  .required()
                                  .build(),
                              decoration: InputDecoration(
                                  hintText: addressText,
                                  label: Text(addressText),
                                  border: OutlineInputBorder()))
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                paymentText,
                                style: GoogleFonts.jetBrainsMono(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                              RadioListTile<String>(
                                  title: const Text(codText),
                                  value: COD_VAL,
                                  groupValue:
                                      placeOrderState.paymentSelected.value,
                                  onChanged: (String? val) {
                                    placeOrderState.paymentSelected.value =
                                        val!;
                                  }),
                              RadioListTile<String>(
                                  title: const Text(brainTreeText),
                                  value: BRAINTREE_VAL,
                                  groupValue:
                                      placeOrderState.paymentSelected.value,
                                  onChanged: (String? val) {
                                    placeOrderState.paymentSelected.value =
                                        val!;
                                  })
                            ],
                          )),
                      SizedBox(
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                              controller: commentController,
                              validator: null,
                              decoration: InputDecoration(
                                  hintText: commentText,
                                  label: Text(commentText),
                                  border: OutlineInputBorder())),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              validator: ValidationBuilder(
                                      requiredMessage:
                                          'Phone Number $isRequiredText')
                                  .phone()
                                  .build(),
                              decoration: InputDecoration(
                                prefix: Text('+20'),
                                  hintText: '1001153524',
                                  label: Text('Phone Number'),
                                  border: OutlineInputBorder()))
                        ],
                      ),
                      Spacer(),
                      Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(placeOrderText),
                            onPressed: () async {
                              try {
                                if (formKey.currentState!.validate()) {
                                  OrderModel order =
                                      await placeOrderVM.createOrderModel(
                                          restaurantId: 'restauranta',
                                          address: addressController.text,
                                          cartStateController:
                                              cartStateController,
                                          comment: commentController.text,
                                          discount: 0,
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          isCod: placeOrderState
                                                      .paymentSelected.value ==
                                                  COD_VAL
                                              ? true
                                              : false);
                                  print('Hehe:${order.toJson()}');
                                  var result =
                                      await placeOrderVM.submitOrder(order);
                                  UserDetailModel userDetailModel =
                                      UserDetailModel(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          address: addressController.text,
                                          comment: commentController.text,
                                          phoneNumber:
                                              '+20'+phoneNumberController.text);
                                  await submitUserDetailModel(userDetailModel);
                                  cartStateController.clearCart(
                                      mainStateController.selectedRestaurant
                                          .value.restaurantId);
                                  Get.defaultDialog(
                                      title: result
                                          ? orderSuccessText
                                          : orderFailedText,
                                      middleText: result
                                          ? orderSuccessMessageText
                                          : orderFailedMessageText,
                                      textCancel: cancelText,
                                      textConfirm: confirmText,
                                      cancel: Container(),
                                      onCancel: () {},
                                      confirmTextColor: Colors.yellow,
                                      onConfirm: () {
                                        print('Confirm is pressed');
                                        // cartStateController.clearCart(mainStateController
                                        //     .selectedRestaurant.value.restaurantId);
                                        Get.offAll(() => RestaurantHome());
                                      });
                                }
                              } catch (e, stk) {
                                Get.snackbar(e.toString(), 'asdsa');
                                print(e);
                                print(stk);
                              }
                            },
                          ))
                    ],
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    ));
  }

  Future<bool> submitUserDetailModel(UserDetailModel userDetailModel) async {
    try {
      await FirebaseDatabase.instance
          .ref()
          .child(users)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .set(userDetailModel.toJson());

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserDetailModel?> getUserDetailModel() async {
    try {
      DatabaseEvent databaseEvent = await FirebaseDatabase.instance
          .ref()
          .child(users)
          .child(FirebaseAuth.instance.currentUser!.uid)
          .once();

      if (jsonEncode(databaseEvent.snapshot.value).runtimeType != String) {
        return null;
      } else {
        return UserDetailModel.fromJson(
            jsonDecode(jsonEncode(databaseEvent.snapshot.value)));
      }
    } catch (e, stk) {
      print(e);
      print(stk);
      return null;
    }
  }
}
