import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Category/category.dart';
import 'package:final_project/Screens/FirstPage/dashboard_page.dart';
import 'package:final_project/choose_way.dart';
import 'package:final_project/components/menu_bar.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ChartView extends StatefulWidget {
  const ChartView({Key? key}) : super(key: key);

  @override
  _ChartViewState createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  late TooltipBehavior _tooltipBehavior;
  late var id_cat_val_map;
  late String timeNow;
  DateTime selectedDate = DateTime.now();
  late List<ChartData> chartData;
  bool clickedCentreFAB = false;
  int selectedIndex = 2;
  @override
  void initState() {
    id_cat_val_map = {};
    timeNow = DateFormat("yyyy年M月").format(selectedDate);
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  Map takeDataFromDate() {
    var catPriceMap = {};
    Set catInDay = {};
    id_cat_val_map.keys.forEach((key) {
      //bierze dzien
      String temp = key;
      temp = temp.substring(temp.indexOf("#") + 1, temp.length);
      temp = temp.replaceFirst("&", "年");
      temp = temp.replaceFirst("&", "月");
      temp = temp.substring(0, temp.indexOf("月") + 1);
      // temp += "年";
      if (temp == timeNow) {
        id_cat_val_map[key].keys.forEach((keys) {
          catInDay
              .add(keys); //zawiera categorie ktore pojawiaja sie tego miesiaca
        });
        for (var category in catInDay) {
          try {
            if (catPriceMap.containsKey(category)) {
              catPriceMap[category] = catPriceMap[category] +
                  int.parse(id_cat_val_map[key][category]);
              // print(cat_price_map[category]);id_cat_val_map[key][category]
            } else {
              catPriceMap[category] = int.parse(id_cat_val_map[key][category]);
            }
          } catch (e) {
            continue;
          }
        }
      }
    });
    return catPriceMap; //zawiera dane o danym miesiacu wazne!!!!
  }

  List<ChartData> buildCharData(Map catPriceMap) {
    List<ChartData> chars = [];
    for (var element in catPriceMap.keys) {
      chars.add(ChartData(element, int.parse(catPriceMap[element].toString())));
    }

    return chars;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: extractData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 45),
                        child: const Icon(
                          Icons.calendar_today,
                          size: 35,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 1, 5),
                            lastDate: DateTime(DateTime.now().year + 1, 9),
                            initialDate: selectedDate,
                            locale: const Locale("ja"),
                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                                timeNow =
                                    DateFormat("yyyy年M月").format(selectedDate);
                              });
                            }
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 60, bottom: 50),
                          child: Text(
                            timeNow,
                            style: const TextStyle(fontSize: 35),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                chartData.isEmpty
                    ? Center(
                        child: Image.asset("assets/images/no-data.png"),
                      )
                    : showChart(),
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

  Expanded showChart() {
    return Expanded(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: SfCircularChart(
              tooltipBehavior: _tooltipBehavior,
              legend: Legend(
                overflowMode: LegendItemOverflowMode.wrap,
                isVisible: true,
                orientation: LegendItemOrientation.horizontal,
                position: LegendPosition.bottom,
              ),
              series: <CircularSeries>[
                // Render pie chart
                PieSeries<ChartData, String>(
                  enableTooltip: true,
                  dataSource: chartData,
                  radius: "100%",
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: true,
                      // Avoid labels intersection
                      labelIntersectAction: LabelIntersectAction.shift,
                      labelPosition: ChartDataLabelPosition.outside,
                      connectorLineSettings: ConnectorLineSettings(
                        type: ConnectorType.curve,
                      )),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                  dataLabelMapper: (ChartData data, _) => data.x,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: chartData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 1.0),
                        leading: Container(
                            padding: const EdgeInsets.only(right: 12.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 1.0, color: Colors.white24))),
                            child: _image(index)),
                        // your code here

                        title: Text(
                          chartData[index].x,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        subtitle: Row(
                          children: <Widget>[
                            const Text(
                              "¥",
                              style:
                                  TextStyle(color: Colors.amber, fontSize: 20),
                            ),
                            const SizedBox(width: 10),
                            Text((chartData[index].y).toString(),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20))
                          ],
                        ),
                        // trailing: Icon(Icons.keyboard_arrow_right,
                        //     color: Colors.white, size: 30.0)),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  extractData() async {
    var collection = FirebaseFirestore.instance
        .collection('Names')
        .doc(loginUser?.email) //to sie zmienia na shared pref
        .collection("Dates");
    var docSnapshot = await collection.get();
    final allData = docSnapshot.docs.map((doc) => doc.data()).toList();
    var count = 0;
    for (var snapshot in docSnapshot.docs) {
      var documentID = snapshot.id; // <-- Document ID
      id_cat_val_map[documentID] = allData[count];
      count++;
    }
    chartData = buildCharData(takeDataFromDate());
    return id_cat_val_map;
  }

  _image(int index) {
    String tempIcon = "";
    for (var item in categories) {
      if (chartData[index].x == item.name) {
        tempIcon = item.icon;
      }
    }
    return SizedBox(
      width: 40,
      child: Image.asset(
        tempIcon,
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}
