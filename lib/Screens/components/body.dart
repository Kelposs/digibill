import 'package:final_project/Screens/Login/login_screen.dart';
import 'package:final_project/Screens/Signup/signup_screen.dart';
import 'package:final_project/components/rounded_button.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'background.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Welcome to DigiBill",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
            ),
            SizedBox(
              height: size.height * 0.45,
              child: Lottie.asset('assets/images/welcome.json'),
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginScreen();
                }));
              },
            ),
            RoundedButton(
              text: "REGISTER",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SignUpScreen();
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}
