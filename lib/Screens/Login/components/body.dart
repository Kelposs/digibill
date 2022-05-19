import 'package:final_project/Firebase/firebase_helper.dart';
import 'package:final_project/Screens/Login/components/background.dart';
import 'package:final_project/Screens/Signup/signup_screen.dart';
import 'package:final_project/components/already_have_an_account_check.dart';
import 'package:final_project/components/rounded_button.dart';
import 'package:final_project/components/rounded_input_field.dart';
import 'package:final_project/components/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatelessWidget {
  Body({
    Key? key,
  }) : super(key: key);
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            SizedBox(
              height: size.height * 0.45,
              child: Lottie.asset('assets/images/login.json'),
            ),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                if (RoundedInputField.emailController.text.isNotEmpty &&
                    RoundedPasswordField.passwordController.text.isNotEmpty) {
                  service.loginUser(
                      context,
                      RoundedInputField.emailController.text,
                      RoundedPasswordField.passwordController.text);
                  pref.setString(
                      "email", RoundedInputField.emailController.text);
                } else {
                  service.errorBox(context,
                      "Fields cannot be empty, provide email and password");
                }
              },
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SignUpScreen();
                }));
              },
            )
          ],
        ),
      ),
    );
  }
}
