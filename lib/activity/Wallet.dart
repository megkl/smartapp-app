import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/global.dart';
import 'package:smartapp/activity/WalletHistory.dart';
import 'package:smartapp/activity/WithdrawHistory.dart';
import 'package:smartapp/services/authentication.dart';
import 'package:smartapp/services/globals.dart';

import 'HomeActivity.dart';

class Wallet extends StatelessWidget {
  final BaseAuth? auth;
  const Wallet({Key? key, this.auth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppbar('Wallet', primary, Colors.white),
      body: Container(
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
                  Color.fromARGB(255, 168, 194, 247),
                  // Colors.blue,

                  Colors.white10
                ],
                )),
          height: size.height,
          child: SingleChildScrollView(
            child: Container(

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/top_up_wallet.png'),
                      height: (270/896)*size.height,
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Image.asset(
                    //     'assets/images/top_up_wallet.png',
                    //   ),
                    // ),
                   //MediaQuery.of(context).padding.top
                    SizedBox(height: size.height/30,),
                    Text(
                      'Your available \nbalance is',
                      textAlign: TextAlign.center,
                      style: kTextHeadBoldStyle.apply(color:primary),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 30),
                      child: Text(
                        " ${uamount == null || uamount!.trim().isEmpty ? "0" : getGpoints(uamount!)} GCoins",
                        textAlign: TextAlign.center,
                        style: kTextHeadBoldStyle.apply(color:primary),
                      ),
                    ),
                    Container(
                        width: double.maxFinite,
                        height: size.height/15,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(), backgroundColor: purple),
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                              child:Text("Withdraw History",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.fade,
                                  style: kTextNormalBoldStyle.apply(color: Colors.white))),
                          onPressed: ()  {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, anim1, anim2) =>
                                      WithdrawHistory(),
                                ));
                          },
                        )),

                    SizedBox(height: size.height/36,),
                    Container(
                        width: double.maxFinite,
                        height: size.height/15,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(), backgroundColor: bluegradient2),
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                              child:Text("Deposit History",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.fade,
                                  style: kTextNormalBoldStyle.apply(color: Colors.white))),
                          onPressed: ()  {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, anim1, anim2) =>
                                      WalletHistory(auth: auth,),
                                ));
                          },
                        )),
                    SizedBox(height: size.height/36,),

                    Container(
                        width: double.maxFinite,
                        height: size.height/15,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(), backgroundColor: orangeTheme),
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                              child:Text("Back to Menu",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.fade,
                                  style: kTextNormalBoldStyle.apply(color: Colors.white))),
                          onPressed: ()  {
                            Navigator.pop(context);
                          },
                        ))


                  ],
                ),
              ),
            ),
          )),
    );
  }

}
