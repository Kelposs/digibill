import 'package:final_project/Screens/FirstPage/dashboard_page.dart';
import 'package:final_project/chart.dart';
import 'package:flutter/material.dart';

class MenuBar extends StatefulWidget {
  MenuBar({Key? key, required this.menuNumber}) : super(key: key);
  int menuNumber;

  @override
  State<MenuBar> createState() => _MenuBarState();
}

class _MenuBarState extends State<MenuBar> {
  //call this method on click of each bottom app bar item to update the screen
  void updateTabSelection(int index, String buttonText) {
    setState(() {
      widget.menuNumber = index;
      switch (widget.menuNumber) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const FirstPage();
              },
            ),
          );
          break;
        case 2:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const ChartView();
              },
            ),
          );
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        margin: const EdgeInsets.only(left: 12.0, right: 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(),
            IconButton(
              //update the bottom app bar view each time an item is clicked
              onPressed: () {
                updateTabSelection(0, "Home");
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.home,
                //darken the icon if it is selected or else give it a different color
                color: widget.menuNumber == 0
                    ? Colors.green.shade800
                    : Colors.grey.shade400,
              ),
            ),
            //to leave space in between the bottom app bar items and below the FAB
            const SizedBox(
              width: 50.0,
            ),

            IconButton(
              onPressed: () {
                updateTabSelection(2, "Incoming");
              },
              iconSize: 27.0,
              icon: Icon(
                Icons.pie_chart,
                color: widget.menuNumber == 2
                    ? Colors.green.shade800
                    : Colors.grey.shade400,
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
      //to add a space between the FAB and BottomAppBar
      shape: const CircularNotchedRectangle(),
      //color of the BottomAppBar
      color: Colors.white,
    );
  }
}

      // body: Stack(
      //   children: <Widget>[
      //     Align(
      //       alignment: FractionalOffset.center,
      //       //in this demo, only the button text is updated based on the bottom app bar clicks
      //       child: RaisedButton(
      //         child: Text(text),
      //         onPressed: () {},
      //       ),
      //     ),
      //     //this is the code for the widget container that comes from behind the floating action button (FAB)
      //     Align(
      //       alignment: FractionalOffset.bottomCenter,
      //       child: AnimatedContainer(
      //         duration: Duration(milliseconds: 250),
      //         //if clickedCentreFAB == true, the first parameter is used. If it's false, the second.
      //         height:
      //             clickedCentreFAB ? MediaQuery.of(context).size.height : 10.0,
      //         width:
      //             clickedCentreFAB ? MediaQuery.of(context).size.height : 10.0,
      //         decoration: BoxDecoration(
      //             borderRadius:
      //                 BorderRadius.circular(clickedCentreFAB ? 0.0 : 300.0),
      //             color: Colors.blue),
      //       ),
      //     )
      //   ],
      // ),

     