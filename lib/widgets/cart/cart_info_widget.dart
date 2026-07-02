import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../model/cart_model.dart';
class CartInfo extends StatelessWidget {
  const CartInfo({
    Key? key,
    required this.cartModel,
  }) : super(key: key);

  final CartModel cartModel;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  cartModel.name,
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Text(
                      '${cartModel.price}',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )),
            () {
              if (cartModel.addon.length == 0) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Container(
                      margin: EdgeInsets.all(2.0),
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Text('No Addons ')),
                );
              } else {
                return SizedBox(
                  height: 20,
                  width: Get.width,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                        itemCount: cartModel.addon.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, addonIndex) {
                          return Container(
                              margin: EdgeInsets.all(2.0),
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              child: Row(
                                children: [
                                  Text(cartModel.addon[addonIndex].name + ' '),
                                  Text('\$' +
                                      cartModel.addon[addonIndex].price
                                          .toString() +
                                      ' '),
                                ],
                              ));
                        }),
                  ),
                );
              }
            }(),
          ],
        ));
  }
}
