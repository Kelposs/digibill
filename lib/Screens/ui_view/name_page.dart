import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Firebase/firebase_helper.dart';
import 'package:final_project/Screens/FirstPage/dashboard_page.dart';
import 'package:final_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class NameInputPage extends StatefulWidget {
  const NameInputPage({Key? key}) : super(key: key);
  static TextEditingController myNameController = TextEditingController();

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  Service service = Service();
  var auth = FirebaseAuth.instance;
  final storeMessage = FirebaseFirestore.instance;
  String? mail;

  getCurrentUser() {
    var user = auth.currentUser;

    if (user != null) {
      loginUser = user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: Lottie.asset("assets/images/welcome_name.json"),
            height: MediaQuery.of(context).size.height * 0.35,
          ),
          const SizedBox(
            height: 20.0,
          ),
          const Center(
            child: Text(
              "Before we start,\n could you tell us your name?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: Constants.POPPINS,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.5),
            ),
          ),
          const SizedBox(height: 35.0),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: NameInputPage.myNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter Name Here',
                    hintText: 'Enter Name Here',
                  ),
                  autofocus: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          ElevatedButton(
              child: Text("Confirm".toUpperCase(),
                  style: const TextStyle(fontSize: 14)),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.green)))),
              onPressed: () => {
                    if (NameInputPage.myNameController.text.trim() == "")
                      {
                        Fluttertoast.showToast(
                            msg: "Name field is empty",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey)
                      }
                    else
                      {
                        storeMessage
                            .collection("Names")
                            .doc("${loginUser?.email}")
                            .set({
                          "name": NameInputPage.myNameController.text.trim(),
                        }),
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const FirstPage();
                            },
                          ),
                        ),
                      },
                  })
        ],
      ),
    );
  }
}
