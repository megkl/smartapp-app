import 'package:flutter/material.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';

class Result extends StatefulWidget {
  String? correct, incorrect, from, totaltime; //, level_coin, level_score

  Result(
      {this.correct,
      this.incorrect,
      this.totaltime,
      this.from}); //, this.level_coin, this.level_score

  @override
  State<StatefulWidget> createState() {
    return resultState(this.from!);
  }
}

class resultState extends State<Result> {
  String? btnPlay = "Play Again", txtResult = completed;
  Color? back;
  double? per;
  String? from;

  resultState(this.from);

  @override
  void initState() {
    super.initState();
    per = (int.parse(widget.correct!) / Constant.MAX_QUE_PER_LEVEL);
  }

  @override
  Widget build(BuildContext context) {
    Duration aLongWeekend =
        new Duration(milliseconds: int.parse(widget.totaltime!));

    String time = _printDuration(aLongWeekend);

    String title = "";

    if (from == Constant.lblmainevent) {
      title = "Main Event";
    } else if (from == Constant.lblgroupevent) {
      title = 'Group Event';
    } else if (from == Constant.lblDaily) {
      title = 'Daily Challenge';
    } else if (from == Constant.lblPractice) {
      title = 'Practice';
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: white,
      // appBar: AppBar(
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.transparent,
      //   title: Row(
      //     children: <Widget>[
      //       uprofile == null || uprofile.isEmpty
      //           ? Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: Icon(Icons.account_circle))
      //           : Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: FadeInImage.assetNetwork(
      //                 image: uprofile,
      //                 placeholder: "assets/images/home_logo.png",
      //                 width: 20,
      //                 height: 20, //fit: BoxFit.cover,
      //               ),
      //             ),
      //       uname == null || uname.trim().isEmpty
      //           ? Container()
      //           : Padding(
      //               padding: const EdgeInsets.symmetric(vertical: 8.0),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: <Widget>[
      //                   Text(
      //                     uname ?? "",
      //                     style: TextStyle(
      //                       color: white,
      //                       fontSize: 10,
      //                     ),
      //                   ),
      //                   Text(
      //                     '${uamount == null || uamount.trim().isEmpty ? "0" : uamount} kshs',
      //                     style: TextStyle(color: Colors.white, fontSize: 10),
      //                   )
      //                 ],
      //               ),
      //             ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Image.asset(
                  'assets/images/jibupesa.png',
                  height: 100,
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
                        SizedBox(height: 20,),
                 
            Container(
              color: selection,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: orangeTheme,
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 28.0, bottom: 8),
                    child: Text(
                      "Result",
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold, color: white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextButton.icon(
                    icon: Image.asset('assets/images/correct.png'),
                    label: Text(
                      "${widget.correct} ${StringRes.correctans}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {},
                  ),
                  TextButton.icon(
                    icon: Image.asset('assets/images/incorrect.png'),
                    label: Text(
                      "${widget.incorrect} ${StringRes.incorrectans}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: white, fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () {},
                  ),
                  Container(
                    margin: EdgeInsets.all(
                      20,
                    ),
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        "Total Time : $time",
                        style: TextStyle(color: white,fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: 
                     Container(
                      width: 300,
                      height: 60,
                       child: ElevatedButton(
                                         style: ElevatedButton.styleFrom(
                        backgroundColor: orangeTheme,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30)
                                         ),
                                         onPressed: () {
                       
                        Navigator.pop(context);
                                         },
                                       
                                         child: Text('Back to Menu')),
                     ),
                    
                 
                  ),
                ],
              ),
            ),
          ],
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

  String msToTime(duration) {
    int milliseconds = (duration % 1000),
        seconds = (duration / 1000) % 60,
        minutes = (duration / (1000 * 60)) % 60,
        hours = (duration / (1000 * 60 * 60)) % 24;

    String hr = (hours < 10) ? "0$hours" : hours.toString();
    String mn = (minutes < 10) ? "0$minutes" : minutes.toString();
    String sc = (seconds < 10) ? "0$seconds" : seconds.toString();

    return hr + ":" + mn + ":" + sc + "." + milliseconds.toString();
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n, int digit) => n.toString().padLeft(digit, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60), 2);
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60), 2);
    String twoDigitmSeconds =
        twoDigits(duration.inMilliseconds.remainder(60), 3);

    return "${twoDigits(duration.inHours, 2)}:$twoDigitMinutes:$twoDigitSeconds.$twoDigitmSeconds";
  }

  home() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeActivity()),
        ModalRoute.withName('/'));
  }
}
