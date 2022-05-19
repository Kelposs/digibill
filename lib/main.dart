import 'package:final_project/Screens/FirstPage/dashboard_page.dart';
import 'package:final_project/Screens/Welcome/welcome_screen.dart';
import 'package:final_project/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

PageController pageController = PageController(initialPage: 0);
int currentIndex = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.getString("email");
  {
    runApp(
      (MaterialApp(
        // home: CartesianChart(
        //   productName: "Food",
        // ),
        // home: PictureTranslator(),
        home: email == null ? const MyApp() : const FirstPage(),
      )),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digibill',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
    );
  }
}
