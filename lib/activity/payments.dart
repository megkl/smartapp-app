import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/custom_dialog.dart';
import 'package:smartapp/Helper/global.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/TheMainEvent/DailChallenge.dart';
import 'package:smartapp/activity/TheMainEvent/MainEventActivity.dart';
import 'package:smartapp/services/authentication.dart';
import 'package:smartapp/services/globals.dart';

import 'PaypalWebviewActivity.dart';
import 'Practice.dart';

class AddPaymentEntry extends StatefulWidget {
  final BaseAuth? auth;

  const AddPaymentEntry({Key? key, this.auth}) : super(key: key);
  _AddPaymentEntry createState() => _AddPaymentEntry();
}

class _AddPaymentEntry extends State<AddPaymentEntry> {
  bool? isVisible = false;
  BuildContext? scaffoldContext;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightSpace = size.width / 10;
    return Scaffold(
        appBar: customAppbar('Add Payment', primary, Colors.white),
        body: Builder(builder: (BuildContext context) {
          scaffoldContext = context;
          return new SingleChildScrollView(
            child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.2,
                    // 0.5,
                    1,
                  ],
                  colors: [
                    Color.fromARGB(40, 246, 244, 241),
                    // Colors.blue,

                    Colors.white
                  ],
                )),
                height: size.height,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      // Image(
                      //   image: AssetImage("assets/images/payment.jpg"),
                      //   height: (270 / 896) * size.height,
                      // ),

                      // Spacer(),
                      SizedBox(
                        height: 30,
                      ),
                      // DefaultTextStyle(
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //       fontSize: 24,
                      //       color: kTextColor,
                      //       fontWeight: FontWeight.bold),
                      //   child: AnimatedTextKit(
                      //     totalRepeatCount: 1,
                      //     animatedTexts: [
                      //       TypewriterAnimatedText(
                      //           'Make a deposit to your wallet, compete and win'),
                      //       //TypewriterAnimatedText('to your wallet, compete and win'),
                      //     ],
                      //     onTap: () {
                      //       print("Tap Event");
                      //     },
                      //   ),
                      // ),

                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: orangeTheme,
                          border: Border.all(width: 1.0,color: Colors.blue[100]!),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                        ),
                        child: Center(
                          child: AutoSizeText(
                            "BUY GCOINS NOW TO CONTEST AND WIN",
                            textAlign: TextAlign.center,
                            style: kTextNormalBoldStyle.apply(color: primary, fontSizeFactor: 1.1),
                          ),
                        ),
                      ),

                      //Spacer(),
                      SizedBox(
                        height: heightSpace,
                      ),

                      AutoSizeText(
                        "** Select amount **",
                        textAlign: TextAlign.center,
                        style: kTextNormalBoldStyle.apply(color: lovandar, fontSizeFactor: 1.1),
                      ),
                     // Spacer(),
                      SizedBox(
                        height: heightSpace,
                      ),
                      Column(
                        //spacing: 30,
                        //runSpacing: 30,
                        children: [
                          CustomButtons("50", "${getGpoints("50")}"),
                          SizedBox(height: 20),
                          CustomButtons("100", "${getGpoints("100")}"),
                          SizedBox(height: 20),
                          CustomButtons("200", "${getGpoints("200")}"),
                          SizedBox(height: 20),
                          CustomButtons("500", "${getGpoints("500")}"),
                        ],
                      ),
                      SizedBox(
                        height: heightSpace,
                      ),

                       SizedBox(
                        height: 10,
                      ),

                      ElevatedButton(
                        onPressed: () => {goToPractice()},
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(), backgroundColor: orangeTheme),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Text("Practice for Event >>",
                              style:
                                  kTextNormalStyle.apply(color: primary)),
                        ),
                      ),

                      Spacer(),
                    ],
                  ),
                )),
          );
        }));
  }

  goToPractice() {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim1, anim2) => Practice(),
        ));
  }

  Widget CustomButtons(String amount, String jcoin) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
      color: lovandar,
        borderRadius: BorderRadius.circular(30)),
      width: 340,
      height: 70,
      child: ElevatedButton(
        onPressed: () async {
          var callbackData = await showPlayOptions("$jcoin");
          // print("$amount $callbackData");
          if (callbackData != null) {
            // print("$amount $callbackData");
            mpesaPayment(amount, callbackData.toString());
          } else {
            ScaffoldMessenger.of(scaffoldContext!).showSnackBar(SnackBar(
              content: Text('Top Up Cancelled',
                  style: kTextNormalStyle.apply(color: Colors.white)),
              backgroundColor: redgradient2,
            ));
          }
        },
        style:
            ElevatedButton.styleFrom(shape: StadiumBorder(), backgroundColor: lovandar),
        child: Padding(
          padding: EdgeInsets.all(1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                 LottieBuilder.asset("assets/lottie/coins_grow.json", animate: true,
                                  height: 30),
              Text("Ksh $amount ------>",
                  style: kTextNormalBoldStyle.apply(color: Colors.white, fontSizeFactor: 1.1)),
              Text(
                '$jcoin GCoins',
                style: kTextNormalStyle.apply(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  showPlayOptions(String point) {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 0),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: ChoiceDialog(
              title: 'Top Up & Play',
              points: point,
              iconImage: Icon(
                Icons.view_module,
                size: 40,
              ),
              labelText: '',
              color: redgradient2,
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
            return Container();
        //return null;
      },
    );
  }

  getRandomId() {
    var rng = new Random();
    String code = (rng.nextInt(900000) + 100000).toString();

    return code;
  }

  mpesaPayment(String amount, String playEvent) async {
    umobile!.replaceAll("+254", "") ?? '';
    umobile!.replaceAll("+", "");
    String? userid = await getPrefrence(USER_ID);
    String? cardurl = CARD_URL +
        "amount=" +
        amount +
        "&" +
        userId +
        "=" +
        userid! +
        "&email=" +
        uemail! +
        "&mobile=" +
        umobile! +
        "&event_id=" +
        getRandomId() +
        "&name=" +
        uname! +
        "&country=" +
        Constant.COUNTRY +
        "&currency_code=" +
        Constant.CURRENCYCODE;

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PaypalWebviewActivity(cardurl, Constant.lblWallet,
            amount, 'Mpesa', refresh, refresh, playEvent, null)));
  }

  refresh() {
    setState(() {});
  }

  navigateToPlay(String playEvent) {
    if (playEvent == "daily") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DailyChallengeActivity()));
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainEventActivity()));
    }
  }
}
