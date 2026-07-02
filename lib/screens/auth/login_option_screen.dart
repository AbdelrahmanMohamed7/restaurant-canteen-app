import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../view_model/menu/menu_viewmodel_imp.dart';
import '../../widgets/raised_gradient_button.dart';
import 'login_phone_number.dart';
import 'package:url_launcher/url_launcher.dart';
class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final MenuViewModelImp menuViewModelImp = MenuViewModelImp();
  final Shader gradientText = LinearGradient(
    colors: <Color>[
      Colors.white,
      Color(0xfffe733f),
    ],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 20.0));
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              child: Lottie.asset(
                'assets/animation/47061-shapes-background.json',
                height: Get.height,
                width: Get.width,
                fit: BoxFit.fill,
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Image.asset('assets/images/tojitos_icon.png'),
                  // if (!kIsWeb) Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: RaisedGradientButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.google,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  ' Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              // stops: [0.0, 1.0],
                              colors: [
                                // Color(0xfffe733f),
                                Colors.redAccent,
                                Colors.red,
                              ],
                            ),
                            onPressed: () async {
                              final GoogleSignInAccount? googleUser =
                                  await GoogleSignIn().signIn();
                              // Obtain the auth details from the request
                              final GoogleSignInAuthentication? googleAuth =
                                  await googleUser?.authentication;

                              // Create a new credential
                              final credential = GoogleAuthProvider.credential(
                                accessToken: googleAuth?.accessToken,
                                idToken: googleAuth?.idToken,
                              );

                              // Once signed in, return the UserCredential
                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);
                              if (FirebaseAuth.instance.currentUser != null)
                                menuViewModelImp.navigationHome(context);
                              else
                                print('Not login');
                              // Get.to(() => SignUpScreen());
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RaisedGradientButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.phoneAlt,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  ' Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              // stops: [0.0, 1.0],
                              colors: [
                                // Color(0xfffe733f),
                                Colors.redAccent,
                                Colors.red,
                              ],
                            ),
                            onPressed: () {
                              Get.to(()=>Login());
                              // menuViewModelImp.login(context);
                              // Get.to(() => LoginScreen());
                            }),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(width: 5,),
                        GestureDetector(
                            onTap:(){
                              launch('https://www.instagram.com/tojitos_egypt/?utm_medium=copy_link');
                  },
                            child: Image.asset('assets/images/instagram.jpg',width: 50,height: 50,)),
                    ],),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
