import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/DesignConfig.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/EventLeaderboardModel.dart';
import 'package:smartapp/Model/GroupModel.dart';
import 'package:smartapp/Model/OneOnOneModel.dart';
import 'package:smartapp/Model/MainEvent.dart';
import '../HomeActivity.dart';

MainEvent? selectedmainroundleaderboard;
MainEvent? selecteddailyleaderboard;
GroupModel? selectedgroupleaderboard;
OneOnOneModel? selectedoneononeleaderboard;

class LeaderboardRankActivity extends StatefulWidget {
  int from;

  LeaderboardRankActivity(this.from);

  @override
  LeaderboardRankState createState() => new LeaderboardRankState(this.from);
}

class LeaderboardRankState extends State<LeaderboardRankActivity> {
  int? from;

  LeaderboardRankState(this.from);

  List<EventLeaderboardModel>? leaderboardlist;
  bool? isloading = true, nodata = false;
  String? title = "", message = "";
  bool? useMobileLayout;

  @override
  void initState() {
    if (from == 0) {
      title = selecteddailyleaderboard!.title;
    } else if (from == 1) {
      title = selectedmainroundleaderboard!.title;
    } else if (from == 2) {
      title = selectedgroupleaderboard!.title;
    } else if (from == 3) {
      title = selectedoneononeleaderboard!.title;
    }

    leaderboardlist = [];
    GetEventData();
    super.initState();
  }

  Future GetEventData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      Map<String, String> body = {
        userId: uuserid!,
      };

      if (from == 0) {
        body[GET_DAILY_LEADERBOARD_RANK] = "1";
        body[MAIN_EVENT_ID] = selecteddailyleaderboard!.id!;
      } else if (from == 1) {
        body[GET_MEAINEVENT_LEADERBOARD_RANK] = "1";
        body[EVENT_ID] = selectedmainroundleaderboard!.id!;
      } else if (from == 2) {
        body[GET_GROUPVENT_LEADERBOARD_RANK] = "1";
        body[GROUP_EVENT_ID] = selectedgroupleaderboard!.id!;
      } else if (from == 3) {
        body[GET_ONEONONE_LEADERBOARD_RANK] = "1";
        body[EVENT_ID] = selectedoneononeleaderboard!.id!;
      }

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      isloading = false;

      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
              () => setState(() {
                    nodata = false;

                    if (from == 0)
                      leaderboardlist!.addAll((res['data'] as List)
                          .map((model) =>
                              EventLeaderboardModel.fromDailyEventJson(model))
                          .toList());
                    else if (from == 0)
                      leaderboardlist!.addAll((res['data'] as List)
                          .map((model) =>
                              EventLeaderboardModel.fromMainEventJson(model))
                          .toList());
                    else if (from == 1)
                      leaderboardlist!.addAll((res['data'] as List)
                          .map((model) =>
                              EventLeaderboardModel.fromGroupEventJson(model))
                          .toList());
                    else if (from == 2)
                      leaderboardlist!.addAll((res['data'] as List)
                          .map((model) =>
                              EventLeaderboardModel.fromOneOnOneEventJson(
                                  model))
                          .toList());
                  }));
        }
      } else {
        setState(() {
          message = res['message'];
          nodata = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

// Determine if we should use mobile layout or not, 600 here is
// a common breakpoint for a typical 7-inch tablet.
    useMobileLayout = shortestSide < 600;

    return Scaffold(
        extendBodyBehindAppBar: from == 0 || from == 1 ? true : false,
        appBar: AppBar(
          //brightness: Brightness.dark,
          centerTitle: true,
          title: Text(
            title!,
          ),
          backgroundColor: primary,
        ),
        body: Container(
            decoration:
                from == 0 || from == 1 ? null : DesignConfig.gradientbackground,
            child: isloading!
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/back.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Center(child: new CircularProgressIndicator()))
                : nodata!
                    ? Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/back.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Center(
                            child: Text(
                          message!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.merge(TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        )),
                      )
                    : from == 0 || from == 1 || from == 2
                        ? MainEventLeaderboard()
                        : from == 3
                            ? OneOnOneLeaderboard()
                            : Container()
            //Container()
            ));
  }

  Widget MainEventLeaderboard() {
    return SingleChildScrollView(
        child: Stack(
      children: <Widget>[
        profile(),
        get_rank(),
      ],
    ));
  }

  Widget profile() {
    return Stack(
      children: <Widget>[
        //Image.asset("assets/images/l_back4.png"),
        Center(
            child: Container(
                margin: EdgeInsets.only(top: useMobileLayout! ? 100 : 200),
                child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: Column(
                          children: <Widget>[
                            CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.black26,
                                child: CircleAvatar(
                                    radius: 38,
                                    backgroundColor: Colors.white,
                                    child: leaderboardlist![0].profile!.isNotEmpty
                                        ? CircleAvatar(
                                            radius: 35,
                                            backgroundColor: primary,
                                            backgroundImage: NetworkImage(
                                                leaderboardlist![0].profile!))
                                        : CircleAvatar(
                                            radius: 35,
                                            backgroundColor: primary,
                                            child: Text(leaderboardlist![0]
                                                .name!
                                                .substring(0, 1)),
                                          ))),
                            Container(
                              width: 80,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  leaderboardlist![0].name!,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: primary),
                                ),
                              ),
                            ),
                            // Text(
                            //   leaderboardlist[0].score,
                            //   style: TextStyle(color: primary),
                            // )
                          ],
                        ))))),
        leaderboardlist!.length < 2
            ? Container()
            : Center(
                child: Container(
                    margin: EdgeInsets.only(
                        top: useMobileLayout! ? 110 : 210,
                        right: (MediaQuery.of(context).size.width / 2) + 30),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Column(
                                      children: <Widget>[
                                        CircleAvatar(
                                            radius: 40,
                                            backgroundColor: Colors.black26,
                                            child: CircleAvatar(
                                                radius: 38,
                                                backgroundColor: Colors.white,
                                                child: leaderboardlist![1]
                                                        .profile!
                                                        .isNotEmpty
                                                    ? CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Color(0xff571855),
                                                        backgroundImage:
                                                            NetworkImage(
                                                                leaderboardlist![
                                                                        1]
                                                                    .profile!))
                                                    : CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Color(0xff571855),
                                                        child: Text(
                                                            leaderboardlist![1]
                                                                .name!
                                                                .substring(
                                                                    0, 1)),
                                                      ))),
                                        Container(
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0),
                                            child: Text(
                                              leaderboardlist![1].name!,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: primary),
                                            ),
                                          ),
                                        ),
                                        // Text(
                                        //   leaderboardlist[1].score,
                                        //   style: TextStyle(color: primary),
                                        // )
                                      ],
                                    )))),
                        Container(
                            margin: EdgeInsets.only(left: 30),
                            child: Image.asset(
                              "assets/images/rank2.png",
                              height: 50,
                              width: 50,
                            )),
                      ],
                    ))),
        leaderboardlist!.length < 3
            ? Container()
            : Center(
                child: Container(
                    margin: EdgeInsets.only(
                        top: useMobileLayout! ? 130 : 230,
                        left: (MediaQuery.of(context).size.width / 2) + 30),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Column(
                                    children: <Widget>[
                                      CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.black26,
                                          child: CircleAvatar(
                                              radius: 38,
                                              backgroundColor: Colors.white,
                                              child: leaderboardlist![2]
                                                      .profile!
                                                      .isNotEmpty
                                                  ? CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor: primary,
                                                      backgroundImage:
                                                          NetworkImage(
                                                              leaderboardlist![2]
                                                                  .profile!))
                                                  : CircleAvatar(
                                                      radius: 35,
                                                      backgroundColor: primary,
                                                      child: Text(
                                                          leaderboardlist![2]
                                                              .name!
                                                              .substring(0, 1)),
                                                    ))),
                                      Container(
                                        width: 60,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            leaderboardlist![2].name!,
                                            maxLines: 1,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: primary),
                                          ),
                                        ),
                                      ),
                                      // Text(
                                      //   leaderboardlist[2].score,
                                      //   style: TextStyle(color: primary),
                                      // )
                                    ],
                                  ))),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 30),
                            child: Image.asset(
                              "assets/images/rank3.png",
                              height: 50,
                              width: 50,
                            )),
                      ],
                    ))),
        Container(
          margin: EdgeInsets.only(top: useMobileLayout! ? 320 : 420),
          height: 3,
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.3, 0.7],
              colors: [practiceColor, blue],
            ),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: useMobileLayout! ? 290 : 390),
            decoration: BoxDecoration(
              // Box decoration takes a gradient
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.3, 0.7],
                colors: [practiceColor, blue],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Rank", style: TextStyle(color: Colors.white)),
                  Text("Player", style: TextStyle(color: Colors.white)),
                  Text("Points", style: TextStyle(color: Colors.white)),
                ],
              ),
            )),
        Container(
            margin: EdgeInsets.only(
                top: useMobileLayout! ? 80 : 180,
                left: (MediaQuery.of(context).size.width) / 2.3),
            child: Image.asset(
              "assets/images/rank1.png",
              height: 50,
              width: 50,
            )),
      ],
    );
  }

  Widget get_rank() {
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Padding(
          padding: EdgeInsets.only(top: useMobileLayout! ? 320 : 420),
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: leaderboardlist == null ? 0 : leaderboardlist!.length,
              itemBuilder: (BuildContext context, int index) {
                return Center(
                    child: leaderboardlist == null
                        ? CircularProgressIndicator()
                        : (leaderboardlist!.isEmpty
                            ? Center(
                                child: Text(
                                  "No Player Found...",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                              leaderboardlist![index]
                                                      .rank
                                                      .toString() +
                                                  ".",
                                              style: TextStyle(color: primary)),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                          child: leaderboardlist![index]
                                                  .profile!
                                                  .isNotEmpty
                                              ? CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: primary,
                                                  backgroundImage: NetworkImage(
                                                      leaderboardlist![index]
                                                          .profile!))
                                              : CircleAvatar(
                                                  radius: 25,
                                                  backgroundColor: primary,
                                                  child: Text(
                                                      leaderboardlist![index]
                                                          .name!
                                                          .substring(0, 1)),
                                                ),
                                        ),
                                        Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          child: Text(
                                            leaderboardlist![index].name!,
                                            style: TextStyle(
                                                color: primary, fontSize: 14),
                                          ),
                                        )),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08),
                                          child: Text(
                                              leaderboardlist![index].score!,
                                              style: TextStyle(color: primary)),
                                        )
                                      ],
                                    ),
                                  ),
                                ))));
              }),
        ));
  }

  Widget GroupEventLeaderboard() {
    return ListView.builder(
        itemCount: leaderboardlist!.length,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        itemBuilder: (BuildContext ctxt, int index) {
          EventLeaderboardModel item = leaderboardlist![index];
          return Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: <Widget>[
              Container(
                  width: double.maxFinite,
                  //shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10.0),)),
                  decoration: DesignConfig.RoundedcornerWithColor(
                      white.withOpacity(0.7)),
                  margin: EdgeInsets.only(bottom: 10, right: 15),
                  padding: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 10, right: 5),
                  child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    item.profile != null
                        ? CircleAvatar(
                            radius: 20.0,
                            backgroundImage: ExactAssetImage(
                                    'assets/images/placeholder.png'),
                               
                            backgroundColor: Colors.transparent,
                          )
                        : CircleAvatar(
                            radius: 20.0,
                            child: Text(item.name!.substring(0, 1))),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${Constant.setFirstLetterUppercase(item.name!)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.merge(TextStyle(
                                      color: primary,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Right: " + item.correct_answers!,
                                  style: TextStyle(color: primary),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Text(
                                    "Wrong: " + item.incorrect_answers!,
                                    style: TextStyle(color: primary),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "Winning Amount: " + item.winning_amount!,
                              style: TextStyle(color: primary),
                            ),
                            Text(
                              "Time: " + item.time! + " Sec",
                              style: TextStyle(color: primary),
                            ),
                          ],
                        )),
                  ])),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundColor: white,
                  child: Center(
                    child: Text(
                      item.rank!,
                      style: TextStyle(
                          color: appcolor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  Widget OneOnOneLeaderboard() {
    return ListView.builder(
        itemCount: leaderboardlist!.length,
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        itemBuilder: (BuildContext ctxt, int index) {
          EventLeaderboardModel item = leaderboardlist![index];
          EventLeaderboardModel user1 = item.oneononematchlist![0];
          EventLeaderboardModel user2 = item.oneononematchlist![1];
          String edate = DateFormat('dd/MM/yyyy hh:mm:ss')
              .format(DateTime.parse(user1.date!));

          Duration aLongWeekend =
              new Duration(milliseconds: int.parse(user1.time!));

          int sec = aLongWeekend.inSeconds;

          int milli = int.parse(user1.time!) - sec * 1000;

          Duration bLongWeekend =
              new Duration(milliseconds: int.parse(user2.time!));

          int bsec = bLongWeekend.inSeconds;

          int bmilli = int.parse(user2.time!) - bsec * 1000;

          return Container(
              width: double.maxFinite,
              decoration:
                  DesignConfig.RoundedcornerWithColor(white.withOpacity(0.7)),
              margin: EdgeInsets.only(bottom: 10),
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text(
                    "$edate",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              user1.profile != null
                                  ? CircleAvatar(
                                      radius: 35.0,
                                      backgroundImage: ExactAssetImage(
                                              'assets/images/placeholder.png'),
                                          
                                      backgroundColor: Colors.transparent,
                                    )
                                  : CircleAvatar(
                                      radius: 35.0,
                                      child: Text(user1.name!.substring(0, 1))),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "${Constant.setFirstLetterUppercase(user1.name!)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.merge(TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Text(
                                  "Score : ${user1.score} in $sec sec $milli msec",
                                  style: TextStyle(
                                      color: appcolor,
                                      fontWeight: FontWeight.bold)),
                              Card(
                                  color: user1.status!.toLowerCase() == "win"
                                      ? green
                                      : user1.status!.toLowerCase() == "loose"
                                          ? red
                                          : appcolor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Text(
                                      "${user1.status}",
                                      style: TextStyle(color: white),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Image.asset(
                          "assets/images/versusbattle.png",
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              user2.profile != null
                                  ? CircleAvatar(
                                      radius: 35.0,
                                      backgroundImage: 
                                      //user2.profile.isEmpty?
                                           ExactAssetImage(
                                              'assets/images/placeholder.png'),
                                          //: NetworkImage("${user2.profile}"),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : CircleAvatar(
                                      radius: 35.0,
                                      child: Text(user2.name!.substring(0, 1))),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  "${Constant.setFirstLetterUppercase(user2.name!)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.merge(TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Text(
                                "Score : ${user2.score} in $bsec sec $bmilli msec",
                                style: TextStyle(
                                    color: appcolor,
                                    fontWeight: FontWeight.bold),
                              ),
                              Card(
                                  color: user2.status!.toLowerCase() == "win"
                                      ? green
                                      : user2.status!.toLowerCase() == "loose"
                                          ? red
                                          : appcolor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Text(
                                      "${user2.status}",
                                      style: TextStyle(color: white),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ]),
                ],
              ));
        });
  }
}
