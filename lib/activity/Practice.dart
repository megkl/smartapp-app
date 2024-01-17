import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/activity/PlayActivity.dart';

import '../services/globals.dart';


class Practice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: primary,
      appBar: customAppbar("", primary, white),
      body: Container(
        height: double.maxFinite,
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
              Colors.white,
            // Colors.blue,

            Colors.white
          ],
        )),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/gameback.png"),
        //     fit: BoxFit.fill,
        //   ),
        // ),
        child: SingleChildScrollView(
            padding: EdgeInsets.only(top: kToolbarHeight * 1),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Container(
                    height: size.height / 5,
                    child: Center(
                      child: Image.asset(
                        'assets/images/smarta_logomain.png',
                      ),
                    ),
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: 'Smart',
                          style: TextStyle(color: orangeTheme, fontSize: 24, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: 'App',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: selection, fontSize: 24))
                            
                        ]
                        )),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [
                              0.2,
                              0.5,
                              0.7,
                              1,
                            ],
                            colors: [
                               selection,
                               selection,
                               selection,
                               selection
                              
                            ],
                          ),
                          // color: Colors.red,
                          //borderRadius: BorderRadius.all(Radius.circular(40))
                          ),
                      margin: const EdgeInsets.only(top: 30.0),
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Practice',
                        style: TextStyle(fontSize: 25, color: white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 50),
                    child: Text(
                      'Answer 10 trivia questions correctly in the fastest time.\n\n Sharpen your skills as your prepare for the Daily challenge and Main Event.',
                      // style: Theme.of(context).textTheme.subtitle1,
                      style: TextStyle(fontSize: 16, color: selection),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                    child: Container(
                      width: 300,
                      height: 70,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: selection,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 50)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, anim1, anim2) =>
                                      PlayActivity(cls: Constant.lblPractice),
                                ));
                          },
                          child: Text('Start >>', style: TextStyle(fontSize: 25),)),
                    ),
                  ),
                ])),
      ),
    );
  }
}
