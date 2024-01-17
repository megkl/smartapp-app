import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/DesignConfig.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'BattleGamePlayActivity.dart';

class BattleResultActivity extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return BattleResultActivityState();
  }
}

class BattleResultActivityState extends State<BattleResultActivity> {


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {


    Duration aLongWeekend =
    new Duration(milliseconds: totalplaytime);
    int sec = aLongWeekend.inSeconds;
    int milli = totalplaytime - sec * 1000;

    Duration bLongWeekend =
    new Duration(milliseconds: int.parse(battleuser_totaltime!));

    int bsec = bLongWeekend.inSeconds;

    int bmilli = int.parse(battleuser_totaltime!) - sec * 1000;




    return Scaffold(
      appBar: AppBar(
        //backgroundColor: appcolor,
        flexibleSpace: Container(decoration: DesignConfig.gradientbackground,),
        centerTitle: true,
        title: Text(StringRes.result),
      ),
      body:
      //Container()
      Container(decoration: DesignConfig.gradientbackground,
        height: double.maxFinite,
        child: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(mainAxisSize: MainAxisSize.min,
              children: <Widget>[


                Image.asset(
                  'assets/images/home_logo.png',
                  width: 150,
                  height: 150,
                  //color: appcolor,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${selectedoneononeevent!.title!}",style: Theme.of(context).textTheme.headlineSmall?.merge(TextStyle(fontWeight: FontWeight.bold)),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(Constant.setFirstLetterUppercase(uname!),style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(fontWeight: FontWeight.bold)),),
                          uprofile == null || uprofile!.isEmpty? Image.asset("assets/images/home_logo.png", width: 80, height: 80,) :
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeInImage.assetNetwork(
                              image: uprofile!,
                              placeholder: "assets/images/home_logo.png",
                              width: 80,
                              height: 80,fit: BoxFit.cover,
                            ),
                          ) ,
                          Text("Right - "+correctQuestion.toString(),textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("Wrong - "+inCorrectQuestion.toString(),textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("Time - $sec.$milli sec",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),

                      //SizedBox(width: 50.0, height: 50.0, child: getProgressTimer()),
                      Column(mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(Constant.setFirstLetterUppercase(battleuser!.name!),style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(fontWeight: FontWeight.bold)),),
                          battleuser!.profile == null || battleuser!.profile!.isEmpty? Image.asset("assets/images/home_logo.png", width: 80, height: 80,) :
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FadeInImage.assetNetwork(
                              image: battleuser!.profile!,
                              placeholder: "assets/images/home_logo.png",
                              width: 80,
                              height: 80,fit: BoxFit.cover,
                            ),
                          ) ,
                          Text("Right - "+battleuser_rightans!,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("Wrong - "+battleuser_wrongans!,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text("Time - $bsec.$bmilli sec",textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:12,left: 8,right: 8,bottom: 5),
                  child: Text(winningtextforresult,textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleLarge,),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget totalCoinsLayout() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/coins.png",
                  width: 30,
                  height: 30,
                ),
                Text(TOTAL_COINS.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Total Coins",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Image.asset(
                  "assets/images/rank.png",
                  width: 30,
                  height: 30,
                ),
                Text(TOTAL_SCORE.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  "Total Score",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }




  rateApp() {

  }

  home() {

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeActivity()),
        ModalRoute.withName('/'));
  }
}
