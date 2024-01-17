import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/activity/onboard/slider_content.dart';

import '../Login.dart';

class Welcome extends StatefulWidget {
  @override
  WelcomeState createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  int selectedSlider = 0;
  PageController sliderController =
  PageController(initialPage: 0, keepPage: false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primary),
      bodyTextStyle: TextStyle(fontSize: 15, color: black),
      bodyPadding: EdgeInsets.all(16),
      imagePadding: EdgeInsets.all(20),
    );

    return IntroductionScreen(
      globalBackgroundColor: white,
      pages: [
        PageViewModel(
          title: "SmartApp",
          body:
          "A Trivia Contest, Sign up and become a member by buying GCoins and play the daily and main events to win as many prices as possible.",
          image: introImage('assets/lottie/gCoin.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Daily Challenge",
          body:
          "Join our daily challenges and contest to win upto 100k in less than 2 Minutes",
          image: introImage('assets/lottie/timer1.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Main Event",
          body:
          "Join our main events and give yourself a chance to win up to 500K Every Weekend in less than 2 Minutes",
          image: introImage('assets/lottie/coins_grow.json'),
          decoration: pageDecoration,
        ),
      ],

      onDone: () => goHomepage(context), //go to home page on done
      onSkip: () => goHomepage(context), // You can override on skip
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      skip: Text(
        'Skip',
        style: TextStyle(color: primary),
      ),
      next: const Icon(
        Icons.arrow_forward_rounded,
        color: primary,
      ),
      done: Text(
        'Get Started',
        style: TextStyle(fontWeight: FontWeight.w600, color: primary),
      ),
      dotsDecorator:  DotsDecorator(
        size: Size(10, 10), //size of dots
        color: Colors.grey, //color of dots
        activeSize: Size(22, 10),
        activeColor: orangeTheme,
        //activeColor: Colors.white, //color of active dot
        activeShape: RoundedRectangleBorder(
          //shave of active dot
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
      ),
    );
  }

  void goHomepage(context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(
            // auth: widget.auth,
          ),
        ));
  }

  Widget introImage(String assetName) {
    //widget to show intro image
    return Align(
      child: LottieBuilder.asset(assetName),
      alignment: Alignment.bottomCenter,
    );
  }
}

//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           stops: [
//             0.2,
//             // 0.5,
//             1,
//           ],
//           colors: [
//             Colors.yellow[800],
//             // Colors.blue,

//             Colors.yellowAccent[400]
//           ],
//         )),
//         width: double.infinity,
//         // color: Colors.white,
//         child: Column(
//           children: [
//             SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               flex: 2,
//               child: PageView.builder(
//                   onPageChanged: (index) {
//                     setState(() {
//                       selectedSlider = index;
//                     });
//                   },
//                   controller: sliderController,
//                   itemCount: sliders.length,
//                   itemBuilder: (context, index) => SliderContent(
//                         image: sliders[index]['image'],
//                         title: sliders[index]['title'],
//                         text: sliders[index]['text'],
//                       )),
//             ),
//             SizedBox(height: kDefaultPadding),
//             Expanded(
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       sliders.length,
//                       (index) => circularIndicator(index: index),
//                     ),
//                   ),
//                   Spacer(),
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 20, top: 20),
//                     child: Row(
//                       children: [
//                         SkipButton(tapEvent: () {
//                           Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Login(
//                                         // auth: widget.auth,
//                                         ),
//                                   ));
//                         }),
//                         Spacer(),
//                         MainButton(
//                           tapEvent: () {
//                             if (selectedSlider != (sliders.length - 1)) {
//                               sliderController.animateToPage(
//                                   selectedSlider + 1,
//                                   duration: Duration(milliseconds: 400),
//                                   curve: Curves.linear);
//                             } else {
//                               Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => Login(
//                                         // auth: widget.auth,
//                                         ),
//                                   ));
//                             }
//                           },
//                         )
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   AnimatedContainer circularIndicator({int index}) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 150),
//       margin: EdgeInsets.symmetric(horizontal: 2.0),
//       height: selectedSlider == index ? 24.0 : 16.0,
//       width: selectedSlider == index ? 24.0 : 16.0,
//       decoration: BoxDecoration(
//         color: selectedSlider == index ? primary : Color(0xFFD7D7D7),
//         borderRadius: BorderRadius.all(Radius.circular(12)),
//       ),
//     );
//   }
// }

// class SkipButton extends StatelessWidget {
//   const SkipButton({Key key, @required this.tapEvent}) : super(key: key);

//   final GestureTapCallback tapEvent;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return InkWell(
//       onTap: tapEvent,
//       child: Container(
//         width: (150 / 414) * size.width,
//         height: 50,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Skip',
//               style: kTextHeadStyle.apply(
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MainButton extends StatelessWidget {
//   const MainButton({Key key, @required this.tapEvent}) : super(key: key);

//   final GestureTapCallback tapEvent;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     return InkWell(
//       onTap: tapEvent,
//       borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
//       child: Container(
//         width: (150 / 414) * size.width,
//         height: 50,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(25), bottomLeft: Radius.circular(25)),
//             color: primary),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Next',
//               style: kTextHeadStyle.apply(
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(width: kDefaultPadding),
//           ],
//         ),
//       ),
//     );
//   }
// }
