import 'dart:convert';

import 'package:auto_animated/auto_animated.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_cantine_app/screens/restaurant_home.dart';
import 'package:restaurant_cantine_app/state/cart_state.dart';
import 'package:restaurant_cantine_app/state/main_state.dart';
import 'package:restaurant_cantine_app/strings/main_string.dart';
import 'package:restaurant_cantine_app/view_model/main_vm/main_view_model_imp.dart';
import 'package:restaurant_cantine_app/widgets/common/common_widget.dart';
import 'package:restaurant_cantine_app/widgets/main/main_widgets.dart';

import 'consts.dart';
import 'model/cart_model.dart';
import 'model/restaurant_model.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FirebaseApp? app;
    if (kIsWeb) {
      app = await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCW81XJjGHF0FcbKrJ-OC1Q8xh-VaCMQ8o",
            authDomain: "apu-canteen.firebaseapp.com",
            databaseURL: "https://apu-canteen-default-rtdb.asia-southeast1.firebasedatabase.app",
            projectId: "apu-canteen", storageBucket: "apu-canteen.appspot.com",
            messagingSenderId: "550031226034",
            appId: "1:550031226034:web:9c0ea321a450d2e3f5c5ab"),
      );
    } else {
      app = await Firebase.initializeApp();
    }
    await GetStorage.init();
    runApp(MyApp(app: app));
  } on Exception catch (e, stk) {
    print('ahmed');
    print(e.toString());
    print(stk);
  }
}


class MyApp extends StatelessWidget {
  final FirebaseApp app;

  const MyApp({Key? key, required this.app}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      home:  MyHomePage(app: app),
    );
  }
}


class MyHomePage extends StatefulWidget {
  FirebaseApp app;
  final viewModel = MainViewModelImp();
  final mainStateController = Get.put(MainStateController());
  final cartStateController = Get.put(CartStateController());
  final box = GetStorage();
  MyHomePage({required this.app});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (widget.box.hasData(MY_CART_KEY)) {
        var cartSave = await widget.box.read(MY_CART_KEY) as String;
        if (cartSave.length > 0 && cartSave.isNotEmpty) {
          final listCart = jsonDecode(cartSave) as List<dynamic>;
          final listCartParsed =
          listCart.map((e) => CartModel.fromJson(e)).toList();
          if (listCartParsed.length > 0)
            widget.cartStateController.cart.value = listCartParsed;
        }
      } else
        widget.cartStateController.cart.value =
        new List<CartModel>.empty(growable: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          restaurantText,
          style: GoogleFonts.jetBrainsMono(
              fontWeight: FontWeight.w900, color: Colors.black),
        ),
        // backgroundColor: Colors.white,
        elevation: 10,
      ),
      body: FutureBuilder(
        future: widget.viewModel.displayRestaurantList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else {
            var lst = snapshot.data as List<RestaurantModel>;
            return Container(
                margin: const EdgeInsets.only(top: 10),
                child: LiveList(
                  showItemDuration: Duration(milliseconds: 350),
                  showItemInterval: Duration(milliseconds: 150),
                  reAnimateOnVisibility: true,
                  scrollDirection: Axis.vertical,
                  itemCount: lst.length,
                  itemBuilder: animationItemBuilder((index) => InkWell(
                      onTap: () {
                        widget.mainStateController.selectedRestaurant.value =
                        lst[index];
                        Get.to(() => RestaurantHome());
                      },
                      child: Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RestaurantImageWidget(
                                  imageUrl: lst[index].imageUrl),
                              SizedBox(
                                height: 5,
                              ),
                              RestaurantInfoWidget(
                                  name: lst[index].name,
                                  address: lst[index].address)
                            ],
                          )))),
                ));
          }
        },
      ),
    );
  }
}
