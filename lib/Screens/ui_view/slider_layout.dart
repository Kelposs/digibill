import 'package:final_project/Screens/ui_view/name_page.dart';
import 'package:final_project/components/slide_dots.dart';
import 'package:final_project/components/slider.dart';
import 'package:final_project/components/slider_item.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';

class SliderLayoutView extends StatefulWidget {
  const SliderLayoutView({Key? key}) : super(key: key);

  @override
  _SliderLayoutViewState createState() => _SliderLayoutViewState();
}

class _SliderLayoutViewState extends State<SliderLayoutView> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: sliderArrayList.length,
            itemBuilder: (context, i) => SlideItem(i),
          ),
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, bottom: 15.0),
                  child: GestureDetector(
                      child: const Text(
                        Constants.SKIP,
                        style: TextStyle(
                          fontFamily: Constants.OPEN_SANS,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const NameInputPage();
                        }));
                      }),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 15.0, bottom: 15.0),
              //     child: Text(
              //       Constants.SKIP,
              //       style: TextStyle(
              //         fontFamily: Constants.OPEN_SANS,
              //         fontWeight: FontWeight.w600,
              //         fontSize: 14.0,
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (int i = 0; i < sliderArrayList.length; i++)
                      if (i == _currentPage)
                        SlideDots(true)
                      else
                        SlideDots(false)
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
