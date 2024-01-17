import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';

class DesignConfig {
  static BoxDecoration circulargradient_box = BoxDecoration(
    gradient: btngradient,
    borderRadius: BorderRadius.circular(100),
    boxShadow: [
      boxShadow,
    ],
  );

  static BoxDecoration roundedcorner_box = BoxDecoration(
    gradient: btngradient,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      boxShadow,
    ],
  );
  static BoxDecoration RoundedcornerWithColor(Color bgcolor) {
    return BoxDecoration(
      //gradient: btngradient,
      color: bgcolor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        boxShadow,
      ],
    );
  }

  static BoxDecoration gradientbackground = BoxDecoration(
    gradient: btngradient,
    //borderRadius: BorderRadius.circular(10),
    boxShadow: [
      boxShadow,
    ],
  );
  static BoxDecoration light_roundedcorner_box = BoxDecoration(
    gradient: gradient,
    borderRadius: BorderRadius.circular(10),
    boxShadow: [
      boxShadow,
    ],
  );

  static const BoxShadow boxShadow = const BoxShadow(
    color: Colors.black12,
    offset: Offset(3, 3),
    blurRadius: 5,
  );

  static const Gradient redgradient = const LinearGradient(
    colors: [
      redgradient2,
      redgradient1,
    ],
    stops: [0, 1],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const Gradient gradient = const LinearGradient(
    colors: [
      appgradient1,
      appgradient2,
      appgradient2,
      appgradient1,
    ],
    // stops: [0.2,0.5,0.7,1],
    begin: Alignment.topRight,

    end: Alignment.bottomRight,
  );
  static const Gradient btngradient = const LinearGradient(
    colors: [
      appgradient1,
      appgradient2,
      appgradient1,
    ],
    //  stops: [0,0.5,1],

    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static const BoxDecoration backgroundimg = const BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/images/background.png"),
      fit: BoxFit.cover,
    ),
  );
}
