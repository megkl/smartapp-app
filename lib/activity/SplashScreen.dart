import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/onboard/welcome.dart';
import 'package:smartapp/services/authentication.dart';

class SplashScreen extends StatefulWidget {
  final BaseAuth? auth;

  SplashScreen({this.auth});

  @override
  State<StatefulWidget> createState() {
    return new SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  Animation<double>? animation;
  var _visible = true;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
        new CurvedAnimation(parent: animationController!, curve: Curves.easeOut);

    animation!.addListener(() => this.setState(() {}));
    animationController!.forward();
    setState(() {
      _visible = !_visible;
    });

    Timer(Duration(seconds: 3), () {
      getCls();
    });
    super.initState();
  }

  @override
  dispose() {
    animationController!.dispose();
    super.dispose();
  }

  getCls() async {
    bool check = await isLogin();

    return check
        ? 
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeActivity(
                //auth: widget.auth!,
              ),
            ))
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Welcome(
               // auth: widget.auth,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/color_logo.png',
                width: animation!.value * 300,
                height: animation!.value * 300,
              ),
            //  RichText(
            //             text: TextSpan(children: <TextSpan>[
            //           TextSpan(
            //               text: 'Smart',
            //               style: TextStyle(color: selection, fontSize: 24, fontWeight: FontWeight.bold)),
            //           TextSpan(
            //               text: 'App',
            //               style: TextStyle(
            //                   fontWeight: FontWeight.bold, color: orangeTheme, fontSize: 24))
                            
            //             ]
            //             ))
            
            ],
          ),
        ],
      ),
    );
  }
}
