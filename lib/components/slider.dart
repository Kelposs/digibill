import 'package:final_project/constants.dart';

class Slider {
  final String sliderLottie;
  final String sliderHeading;
  final String sliderSubHeading;

  Slider(
      {required this.sliderLottie,
      required this.sliderHeading,
      required this.sliderSubHeading});
}

final sliderArrayList = [
  Slider(
      sliderLottie: "assets/images/wallet-animation.json",
      sliderHeading: Constants.SLIDER_HEADING_1,
      sliderSubHeading: Constants.SLIDER_DESC),
  Slider(
      sliderLottie: "assets/images/savings.json",
      sliderHeading: Constants.SLIDER_HEADING_2,
      sliderSubHeading: Constants.SLIDER_DESC),
  Slider(
      sliderLottie: "assets/images/assistant-bot.json",
      sliderHeading: Constants.SLIDER_HEADING_3,
      sliderSubHeading: Constants.SLIDER_DESC),
];
