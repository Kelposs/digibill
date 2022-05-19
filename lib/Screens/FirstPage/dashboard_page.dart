import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Category/category.dart';
import 'package:final_project/Firebase/firebase_helper.dart';
import 'package:final_project/cart_chart.dart';
import 'package:final_project/choose_way.dart';
import 'package:final_project/components/menu_bar.dart';
import 'package:final_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Service service = Service();
  var auth = FirebaseAuth.instance;
  bool clickedCentreFAB =
      false; //boolean used to handle container animation which expands from the FAB
  int selectedIndex =
      0; //to handle which item is currently selected in the bottom app bar
  late String names;

  getName() async {
    var collection = FirebaseFirestore.instance.collection('Names');
    var docSnapshot = await collection.doc('${loginUser?.email}').get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var value = (data?['name']);
      return names = value;
      //var value = data?['some_field']; // <-- The value you want to retrieve.
      // Call setState if needed.
    }
  }

  getCurrentUser() {
    var user = auth.currentUser;

    if (user != null) {
      loginUser = user;
    }
    //print(loginUser?.email);//show email
  }

  @override
  void initState() {
    // TODO: implement initState

    getCurrentUser();
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: getName(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Container(
            height: size.height,
            width: size.width,
            color: Colors.green,
            child: Center(
              child: Lottie.asset('assets/images/loading.json'),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start, // space evenly tez ok
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    ClipPath(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: size.width,
                            height: size.height * 0.3,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.green.shade300,
                                Colors.cyan.shade600
                              ]),
                            ),
                          ),
                          Positioned(
                            top: size.height * 0.015,
                            left: 0,
                            child: Container(
                              child: Image.asset(
                                "assets/images/dog.png",
                                width: size.width * 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      clipper: BottomWaveClipper(),
                    ),
                    Positioned(
                        top: size.height * 0.06,
                        right: size.width * 0.08,
                        child: Text(
                          "Hi, \n$names",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 40,
                              fontFamily: Constants.POPPINS,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        )),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: size.width * 0.03),
                  child: const Text(
                    "Categories",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: Constants.POPPINS,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 15, top: 5),
                    itemCount: categoriesData.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.22,
                      crossAxisCount: 3,
                      crossAxisSpacing: 0,
                    ),
                    primary: false,
                    itemBuilder: (context, index) => Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CartesianChart(
                                  productName: categories[index].name,
                                );
                              },
                            ),
                          ),
                          child: SizedBox(
                            child: Container(
                              height: size.height * 0.144,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: Text(categories[index].name,
                                          style: GoogleFonts.bebasNeue()),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 26.0),
                                    child: Align(
                                      child: Image.asset(
                                        categories[index].icon,
                                        height: size.height * 0.06,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // margin: EdgeInsets.only(right: 10),
                              // decoration: BoxDecoration(
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color:
                              //           Colors.grey.shade300.withOpacity(0.4),
                              //       spreadRadius: 1,
                              //       blurRadius: 7,
                              //       offset: const Offset(
                              //           0, 4), // changes position of shadow
                              //     ),
                              //   ],
                              // ),
                              // child: ClipRRect(
                              //   clipBehavior: Clip.antiAliasWithSaveLayer,
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(10)),
                              //   child: Stack(
                              //     children: <Widget>[
                              //       Container(
                              //         height: size.height * 0.09,
                              //         decoration: BoxDecoration(
                              //             color: categories[index]
                              //                 .backgroundColor //zmaina na background z category
                              //             ),
                              //         child: Container(
                              //           margin: EdgeInsets.only(left: 4),
                              //           color: Colors.white,
                              //           child: Center(
                              //             child: Icon(
                              //               categories[index]
                              //                   .icon, //zmiana na icon z category
                              //               size: size.height * 0.07,
                              //               color: categories[index]
                              //                   .iconColor, //zmaina na icon_color
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Expanded(
                    //   child: Container(
                    //     margin: EdgeInsets.only(right: 10),
                    //     child: Center(
                    //       child: Text(
                    //         categories[index].name,
                    //         style: TextStyle(
                    //             fontSize: 20, fontWeight: FontWeight.w100),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation //THIS PART IS FLOATING BUTTON
                    .centerDocked, //specify the location of the FAB
            floatingActionButton: FloatingActionButton(
              backgroundColor: kPrimaryColor,
              onPressed: () {
                setState(() {
                  clickedCentreFAB =
                      !clickedCentreFAB; //to update the animated container
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const PictureTranslator();
                    },
                  ),
                );
              },
              tooltip: "Centre FAB",
              child: Container(
                margin: const EdgeInsets.all(15.0),
                child: const Icon(Icons.add),
              ),
              elevation: 4.0,
            ),
            bottomNavigationBar: MenuBar(
              menuNumber: selectedIndex,
            ),
          );
        }
      },
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
        size.width / 2, size.height * 1.2, size.width, size.height * 0.75);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
