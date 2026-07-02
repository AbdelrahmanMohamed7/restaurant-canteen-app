import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../screens/address/address.dart';
import '../../screens/auth/login_option_screen.dart';
import '../../state/cart_state.dart';
import '../../state/main_state.dart';

class AppBarWithCartButton extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final CartStateController cartStateController = Get.find();
  final MainStateController mainStateController = Get.find();

  AppBarWithCartButton({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          Text('$title', style: GoogleFonts.jetBrainsMono(color: Colors.black)),
      elevation: 10,
      // backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        Obx(() => badges.Badge(
            position: badges.BadgePosition.topEnd(top: 0, end: 1),
            showBadge: true,
            badgeContent: Text(
              '${cartStateController.getQuantity(mainStateController.selectedRestaurant.value.restaurantId)}',
              style: GoogleFonts.jetBrainsMono(color: Colors.white),
            ),
            child: IconButton(
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    Get.to(() => AddressScreen());
                  } else {
                    Get.to(() => SelectionScreen());
                  }
                },
                icon: Icon(Icons.shopping_bag)))),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
