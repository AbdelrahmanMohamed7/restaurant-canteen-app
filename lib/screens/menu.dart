import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts.dart';
import '../strings/main_string.dart';
import '../strings/restaurant_home_strings.dart';
import '../view_model/menu/menu_viewmodel_imp.dart';
import '../widgets/menu/home_menu_widget.dart';
import '../widgets/menu/menu_widget.dart';
import '../widgets/menu/menu_widget_callback.dart';
import 'auth/login_option_screen.dart';

class MenuScreen extends StatelessWidget {
  final zoomDrawerController;
  final viewModel = MenuViewModelImp();

  MenuScreen(this.zoomDrawerController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(COLOR_MENU_BG),
      body: SafeArea(
        child: Column(
          children: [
            Row(children: [
              DrawerHeader(
                  child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 40),
                    height: 110,
                    width: 110,
                    child:  CircleAvatar(
                        maxRadius: 60,
                        backgroundColor: Color(COLOR_ICON_DRAWER),
                        backgroundImage: Image.asset(
                          'assets/images/tojitos_icon.png',
                          fit: BoxFit.contain,
                        ).image,),
                  )
                ],
              ))
            ]),
            Divider(
              thickness: 1,
            ),
            HomeMenuWidget(zoomDrawerController: zoomDrawerController),
            Divider(
              thickness: 1,
            ),
            MenuWidget(
              icon: Icons.restaurant_rounded,
              menuName: restaurantListText,
              callback: viewModel.backToRestaurantList,
            ),
            Divider(
              thickness: 1,
            ),
            MenuWidget(
              icon: Icons.list,
              menuName: categoriesText,
              callback: viewModel.navigateCategories,
            ),
            Divider(
              thickness: 1,
            ),
            MenuWidgetCallback(
              icon: Icons.list,
              menuName: orderHistoryText,
              callback: viewModel.checkLoginState(context)
                  ? viewModel.viewOrderHistory
                  : (BuildContext context) {
                      Get.to(() => SelectionScreen());
                    },
            ),
            Divider(
              thickness: 1,
            ),
            Spacer(),
            Visibility(
                visible: viewModel.checkLoginState(context) &&
                    FirebaseAuth.instance.currentUser!.uid ==
                        'WXlruswLziQ6NWIpdvK47GENwki1',
                child: Wrap(
                  children: [
                    Divider(
                      thickness: 1,
                    ),
                    MenuWidgetCallback(
                      icon: Icons.settings,
                      menuName: managerRestaurantText,
                      callback: viewModel.managerRestaurant,
                    ),
                  ],
                )),
            Divider(
              thickness: 1,
            ),
            MenuWidgetCallback(
              icon: viewModel.checkLoginState(context)
                  ? Icons.logout
                  : Icons.login,
              menuName:
                  viewModel.checkLoginState(context) ? logoutText : loginText,
              callback: viewModel.checkLoginState(context)
                  ? viewModel.logout
                  : (BuildContext context) {
                      Get.to(() => SelectionScreen());
                    },
            ),
            Divider(
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
