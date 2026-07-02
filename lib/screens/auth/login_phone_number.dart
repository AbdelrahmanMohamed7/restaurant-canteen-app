import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:restaurant_cantine_app/screens/auth/phone_code_verification_screen.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneController = TextEditingController();
  String? temp;
  bool _validator=false;
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  String? n;
  @override
  Widget build(BuildContext context) {
    final BlockHight = MediaQuery.of(context).size.height / 100;
    // final BlockWidth = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            reverse: false,
            child: SizedBox(
              height: Get.height,
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Image.asset(
                    'assets/images/tojitos_icon.png',
                    // width: 250,
                    // height: Get.height/2.5,
                    // fit: BoxFit.cover,
                  ),
                  Padding(
                    padding:
                    EdgeInsets.only(top: BlockHight * 5, left: 20, right: 20,bottom: 20),
                    child: Container(
                      height: 50,
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          temp=number.dialCode;
                          print(number.phoneNumber);
                          n=number.phoneNumber;
                        },
                        onInputValidated: (bool value) {
                        },
                        selectorConfig: const SelectorConfig(

                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black ),
                        initialValue: number,
                        textFieldController: phoneController,
                        formatInput: false,
                        keyboardType:
                        TextInputType.numberWithOptions(signed: true, decimal: true),
                        inputBorder: OutlineInputBorder(),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ) // foreground
                        ),
                        onPressed: () {
                          if(temp!=null) {
                            Get.to(() => PinCodeVerificationScreen(
                              phoneNumber: n,
                            ));
                          }
                          else{
                            Get.snackbar("Error", 'Enter Correct Number');
                          }
                        },
                        child: Text("Login",style: TextStyle(color: Colors.white))),
                  ),
                  Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}
