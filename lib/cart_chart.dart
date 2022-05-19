import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'Screens/FirstPage/dashboard_page.dart';

class CartesianChart extends StatefulWidget {
  CartesianChart({Key? key, required this.productName}) : super(key: key);
  String productName;

  @override
  _CartesianChartState createState() => _CartesianChartState();
}

class _CartesianChartState extends State<CartesianChart> {
  late TooltipBehavior _tooltipBehavior;
  late Map<String, dynamic> temp_date_price_map = {};
  Map<String, dynamic> date_price_map = {};
  late List<ChartData> chartData;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    chartData = [];
    print(loginUser?.email);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enablePanning: true,
    );
    super.initState();
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
              backgroundColor: Colors.white,
              body: Center(
                child: (chartData.isEmpty || chartData.length == 1)
                    ? Center(
                        child: Image.asset("assets/images/not-enough.png"),
                      )
                    : cartChart(),
              ),
            );
          }
        });
  }

  SizedBox cartChart() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: SfCartesianChart(
        zoomPanBehavior: _zoomPanBehavior,
        title: ChartTitle(text: widget.productName),
        // Enables the tooltip for all the series in chart
        tooltipBehavior: _tooltipBehavior,
        // Initialize category axis
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(
            // Additional range padding is applied to y axis
            rangePadding: ChartRangePadding.additional),
        series: <ChartSeries>[
          // Initialize line series
          FastLineSeries<ChartData, String>(
              markerSettings: const MarkerSettings(isVisible: true),
              name: widget.productName,
              // Enables the tooltip for individual series
              enableTooltip: true,
              dataSource: chartData,
              xValueMapper: (ChartData sales, _) => sales.year,
              yValueMapper: (ChartData sales, _) => sales.price)
        ],
      ),
    );
  }

  Map<String, dynamic> takeDataFromDate(Map<String, dynamic> tempDatePriceMap) {
    Map<String, dynamic> datePriceMap = {};
    print("object  $tempDatePriceMap");
    for (var key in tempDatePriceMap.keys) {
      print(key);
      String temp = key;
      temp = temp.substring(temp.indexOf("#") + 1, temp.length);
      temp = temp.replaceFirst("&", "年");
      temp = temp.replaceFirst("&", "月");
      temp = temp.substring(0, temp.indexOf("月") + 1);
      if (datePriceMap.containsKey(temp)) {
        datePriceMap[temp] = int.parse(datePriceMap[temp].toString()) +
            int.parse(tempDatePriceMap[key].toString());
      } else {
        datePriceMap[temp] = tempDatePriceMap[key];
      }
      print(datePriceMap);
    }
    return datePriceMap;
  }

  List<ChartData> buildCharData(Map datePriceMap) {
    List<ChartData> chars = [];
    for (var element in datePriceMap.keys) {
      chars
          .add(ChartData(element, int.parse(datePriceMap[element].toString())));
    }

    return chars;
  }

  extractData() async {
    var collection = FirebaseFirestore.instance
        .collection('Names')
        .doc(loginUser?.email) //to sie zmienia na shared pref
        .collection("Products")
        .doc(widget.productName);
    var docSnapshot = await collection.get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? tempDatePriceMap = docSnapshot.data();
      // print(date_price_map);
      print(tempDatePriceMap);
      date_price_map = takeDataFromDate(tempDatePriceMap!);
      var allData = [];
      for (var e in date_price_map.entries) {
        allData.add(e);
      }
      date_price_map.clear();
      allData.sort((a, b) => a.key.compareTo(b.key));
      for (var e in allData) {
        date_price_map[e.key] = e.value;
        print(date_price_map);
      }
      chartData = buildCharData(date_price_map);
      return date_price_map;
    } else {
      return chartData = [];
    }
  }
}

class ChartData {
  ChartData(this.year, this.price);
  final String year;
  final int? price;
}
