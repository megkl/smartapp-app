import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/GroupModel.dart';
import 'package:smartapp/Model/MainEvent.dart';
import 'package:smartapp/Model/OneOnOneModel.dart';
import 'package:smartapp/activity/HomeActivity.dart';

import 'LeaderboardRankActivity.dart';

class EventLeaderboard extends StatefulWidget {
  int tabindex;

  EventLeaderboard(this.tabindex);

  @override
  EventLeaderboardState createState() =>
      new EventLeaderboardState(this.tabindex);
}

class EventLeaderboardState extends State<EventLeaderboard>
    with TickerProviderStateMixin {
  bool? ismainloading = false,
      isdailyloading = false,
      isgrouploading = false,
      isoneononeloading = false,
      ismainnodata = false,
      isdailynodata = false,
      isgroupnodata = false,
      isonoononenodata = false;
  List<MainEvent> tr_maineventlist = [];
  List<MainEvent> tr_dailyventlist = [];
  List<GroupModel> tr_groupeventlist = [];
  List<OneOnOneModel> tr_oneononeeventlist =[];
  TabController? tabController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int tabindex;

  EventLeaderboardState(this.tabindex);

  @override
  void initState() {
    tr_maineventlist = [];
    tr_dailyventlist = [];
    tr_groupeventlist = [];
    tr_oneononeeventlist = [];

    tabController =
        new TabController(length: 2, vsync: this, initialIndex: tabindex);

    GetEventData(0);
    GetEventData(1);
    GetEventData(2);
    GetEventData(3);

    super.initState();
  }

  Future GetEventData(int type) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      String eventname;
      setState(() {
        eventname = SetLoading(type, true, false);
      });

      Map<String, String> body = {
        userId: uuserid!,
      };

      if (type == 0) {
        body[GET_MEAINEVENT_LEADERBOARD] = "1";
      } else if (type == 1) {
        body[GET_MAINEVENT_NEW_LEADER] = "1";
      }
      //else if (type == 2) {
      //   body[GET_GROUPEVENT_LEADERBOARD] = "1";
      // } else if (type == 3) {
      //   body[GET_ONEONONEEVENT_LEADERBOARD] = "1";
      // }

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
              () => setState(() {
                    String eventtype = SetLoading(type, false, false);

                    if (type == 0)
                      tr_dailyventlist.addAll((res['data'] as List)
                          .map((model) => MainEvent.fromLeaderboardJson(model))
                          .toList());
                    else if (type == 1)
                      tr_maineventlist.addAll((res['data'] as List)
                          .map((model) => MainEvent.fromLeaderboardJson(model))
                          .toList());
                    // else if (type == 2)
                    //   tr_groupeventlist.addAll((res['data'] as List)
                    //       .map((model) => GroupModel.fromLeaderboardJson(model))
                    //       .toList());
                    // else if (type == 3)
                    //   tr_oneononeeventlist.addAll((res['data'] as List)
                    //       .map((model) =>
                    //           OneOnOneModel.fromLeaderboardJson(model))
                    //       .toList());
                  }));
        }
      } else {
        setState(() {
          SetLoading(type, false, true);
        });
      }
    }
  }

  String SetLoading(int type, bool value, bool isnodata) {
    String? eventname;
    if (type == 0) {
      isdailyloading = value;
      isdailynodata = isnodata;
      eventname = "daily_event";
    } else if (type == 1) {
      isdailyloading = value;
      isdailynodata = isnodata;
      eventname = "main_event";
    }
    // else if (type == 2) {
    //   isgrouploading = value;
    //   isgroupnodata = isnodata;
    //   eventname = "group_event";
    // } else if (type == 3) {
    //   isoneononeloading = value;
    //   isonoononenodata = isnodata;
    //   eventname = "one_on_one_contest";
    // }
    return eventname??'';
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          //brightness: Brightness.dark,
          iconTheme: IconThemeData(
            color: white,
          ),
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ColoredBox(
                    color: lightPink,
                    child: TabBar(
                      indicator: BoxDecoration(color: orange),

                      //indicatorColor: white,
                      labelColor: white,
                      unselectedLabelColor: white,
                      controller: tabController,
                      tabs: [
                        Tab(
                            child: Text(StringRes.event_daily,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13))),
                        Tab(
                            child: Text(StringRes.event_main,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 13))),
                        // Tab(
                        //     child: Text(
                        //   StringRes.event_group,
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(fontSize: 13),
                        // )),
                        // Tab(
                        //     child: Text(
                        //   StringRes.event_oneonone,
                        //   textAlign: TextAlign.center,
                        //   style: TextStyle(fontSize: 13),
                        // )),
                      ],
                    )),
              )),
          //  backgroundColor: white,
          backgroundColor: primary,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
             // Image.asset("assets/images/Leaderboard.png"),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  StringRes.leaderboard,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            Container(
                color: primary,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/back.png"),
                //     fit: BoxFit.fill,
                //   ),
                // ),
                child: MainEventData(
                    0, isdailyloading!, isdailynodata!, tr_dailyventlist)),
            Container(
                color: primary,
                // decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage("assets/images/back.png"),
                //     fit: BoxFit.fill,
                //   ),
                // ),
                child: MainEventData(
                    1, ismainloading!, ismainnodata!, tr_maineventlist)),
            // Container(
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: AssetImage("assets/images/back.png"),
            //         fit: BoxFit.fill,
            //       ),
            //     ),
            //     child: GroupEventData(
            //         2, isgrouploading, isgroupnodata, tr_groupeventlist)),
            // Container(
            //     decoration: BoxDecoration(
            //       image: DecorationImage(
            //         image: AssetImage("assets/images/back.png"),
            //         fit: BoxFit.fill,
            //       ),
            //     ),
            //     child: OneOnOneEventData(3, isoneononeloading, isonoononenodata,
            //         tr_oneononeeventlist)),
          ],
        ),
      ),
    );
  }

  Widget MainEventData(int type, bool iseventloading, bool iseventnodata,
      List<MainEvent> transactionlist) {
    return iseventloading
        ? Center(child: new CircularProgressIndicator())
        : iseventnodata || transactionlist.length == 0
            ? Center(
                child: Text(
                StringRes.nodatafound,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.merge(TextStyle(fontWeight: FontWeight.bold)),
              ))
            : ListView.builder(
                itemCount: transactionlist.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  MainEvent item = transactionlist[index];
                  return new ExpansionTile(
                    backgroundColor: white.withOpacity(0.5),
                    title: new Text(
                      item.title!,
                      style:
                          Theme.of(context).textTheme.titleMedium?.merge(TextStyle(
                                color: white,
                              )),
                    ),
                    children: <Widget>[
                      new Column(
                        children: _buildExpandableContent(item, type),
                      ),
                    ],
                  );
                });
  }

  _buildExpandableContent(MainEvent item, int type) {
    List<Widget> columnContent = [];

    columnContent.add(
      new ListTile(
          title: new Text(
            "${item.title}",
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.merge(TextStyle(color: appcolor)),
          ),
          onTap: () {
            if (type == 0) {
              selecteddailyleaderboard = item;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaderboardRankActivity(0)));
            } else {
              selectedmainroundleaderboard = item;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaderboardRankActivity(1)));
            }
          }),
    );

    return columnContent;
  }

  Widget GroupEventData(int type, bool iseventloading, bool iseventnodata,
      List<GroupModel> transactionlist) {
    return iseventloading
        ? Center(child: new CircularProgressIndicator())
        : iseventnodata || transactionlist.length == 0
            ? Center(
                child: Text(
                StringRes.nodatafound,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.merge(TextStyle(fontWeight: FontWeight.bold)),
              ))
            : ListView.builder(
                itemCount: transactionlist.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  GroupModel item = transactionlist[index];
                  return new ListTile(
                    title: new Text(
                      item.title!,
                      style:
                          Theme.of(context).textTheme.titleMedium?.merge(TextStyle(
                                color: white,
                              )),
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      color: grey,
                    ),
                    onTap: () {
                      selectedgroupleaderboard = item;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LeaderboardRankActivity(1)));
                    },
                  );
                });
  }

  Widget OneOnOneEventData(int type, bool iseventloading, bool iseventnodata,
      List<OneOnOneModel> transactionlist) {
    return iseventloading
        ? Center(child: new CircularProgressIndicator())
        : iseventnodata || transactionlist.length == 0
            ? Center(
                child: Text(
                StringRes.nodatafound,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.merge(TextStyle(fontWeight: FontWeight.bold)),
              ))
            : ListView.builder(
                itemCount: transactionlist.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  OneOnOneModel item = transactionlist[index];
                  return new ListTile(
                    title: new Text(
                      item.title!,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.merge(TextStyle(color: white)),
                    ),
                    trailing: Icon(
                      Icons.navigate_next,
                      color: grey,
                    ),
                    onTap: () {
                      selectedoneononeleaderboard = item;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LeaderboardRankActivity(2)));
                    },
                  );
                });
  }
}
