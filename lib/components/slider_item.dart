import 'package:final_project/components/slider.dart';
import 'package:final_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SlideItem extends StatelessWidget {
  final int index;
  const SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          child: Lottie.asset(sliderArrayList[index].sliderLottie),
          height: MediaQuery.of(context).size.height * 0.35,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          sliderArrayList[index].sliderHeading,
          style: const TextStyle(
              fontFamily: Constants.POPPINS,
              fontWeight: FontWeight.w700,
              fontSize: 20.5),
        ),
        const SizedBox(height: 15.0),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              sliderArrayList[index].sliderSubHeading,
              style: const TextStyle(
                fontFamily: Constants.OPEN_SANS,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 12.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}
