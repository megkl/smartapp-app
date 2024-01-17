import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Helper/global.dart';
import 'package:smartapp/Model/MainEventRound.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/TheMainEvent/DailyChallengeDetail.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/authentication.dart';

class DailyChallengeActivity extends StatefulWidget {
  final double? uamount;
  final BaseAuth? auth;
  const DailyChallengeActivity({Key? key, this.uamount, this.auth})
      : super(key: key);
  @override
  MainEventState createState() => MainEventState();
}

class MainEventState extends State<DailyChallengeActivity> {
  String? dttoday, dttomorrow, eventDate;
  StreamSubscription<ReceivedAction>? notificationsActionStreamSubscription;

  @override
  void initState() {
    super.initState();
    dttoday = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
    dttomorrow = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now()
            .add(new Duration(days: 1))
            .millisecondsSinceEpoch
            .toString())));
    // notificationsActionStreamSubscription =
    //     AwesomeNotifications().actionStream.listen((receivedNotification) {
    //   // print(
    //   //     "user tapped on notification " + receivedNotification.id.toString());
    //   Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) =>
    //           DailyChallengeActivity(uamount: widget.uamount)));
    //});

    // maineventroundlist = new List<MainEventRound>();
    // loadMainEventData();
  }

  Future loadMainEventData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      if (uuserid == null) {
        uname = await getPrefrence(NAME);
        uemail = await getPrefrence(EMAIL);
        uuserid = await getPrefrence(USER_ID);
        uprofile = await getPrefrence(PROFILE);
        umobile = await getPrefrence(MOBILE);
        ulocation = await getPrefrence(LOCATION);
      }
      Map<String, String> body = {GET_MAIN_EVENT: "1", userId: uuserid!};

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      List<MainEventRound> maineventroundlist = [];
      if (error == "false") {
        maineventroundlist.addAll((res['data'] as List)
            .map((model) => MainEventRound.fromJson(model))
            .toList());
        return maineventroundlist;
      } else {
        return "No data";
        //error no data
      }
    }
  }

  @override
  void dispose() {
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primary,
        automaticallyImplyLeading: false,
        //brightness: Brightness.dark,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          StringRes.dailyContest,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomeActivity(auth: widget.auth)),
                (Route<dynamic> route) => false);
          },
        ),
      ),
      body: Column(
        children: [
          Flexible(
              child: FutureBuilder(
                  future: loadMainEventData(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print(" snapshot ${snapshot.data}");
                      if (snapshot.data == "No data") {
                        return Center(
                          child: AutoSizeText(
                            "There are no events set,\n Once available they will appear here",
                            maxLines: 3,
                            textAlign: TextAlign.center,
                            style: kTextHeadStyle.apply(color: primary),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                    margin: EdgeInsets.only(
                                        bottom: 10, left: 4, right: 4),
                                    // elevation: 1,
//                                         onPressed: (){
//                                           selectedDailyEvent = snapshot.data[index];
//                                           print(" selected ${selectedDailyEvent.title}");
//
//                                           //todo open main event
//                                           Navigator.of(context).push(MaterialPageRoute(
//                                               builder: (context) => MainEventDetail(sDate: snapshot.data[index].start_time,selectedmainevent: selectedDailyEvent,)));
//
// //showScaffoldMessage("On reworks..", context);
//                                         },

                                    shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    )),
                                    child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 1, right: 1),
                                        child: InkWell(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    8.0),
                                                            bottomLeft: Radius
                                                                .circular(8.0)),
                                                    child: getImagePlaceHolder(
                                                        snapshot
                                                            .data[index].image,
                                                        snapshot.data[index]
                                                            .title)),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0, right: 0),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            "${snapshot.data[index].title.toString().toUpperCase()}",
                                                            maxLines: 2,
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .titleLarge
                                                                ?.merge(TextStyle(
                                                                    color:
                                                                        black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600))),
                                                        Text(
                                                          "${snapshot.data[index].description}",
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.start,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        // Row(
                                                        //   mainAxisAlignment: MainAxisAlignment.start,
                                                        //   children: <Widget>[
                                                        //     Container(
                                                        //       height: 2,
                                                        //       width: size.width / 2.2,
                                                        //       decoration: BoxDecoration(
                                                        //           color:Colors.black,
                                                        //           borderRadius: BorderRadius.circular(5)),
                                                        //     )
                                                        //   ],
                                                        // ),
                                                        Column(
                                                          children: [
                                                            Container(
                                                              color:
                                                                  orangeTheme,
                                                              height: 40,
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: snapshot
                                                                              .data[
                                                                                  index]
                                                                              .date
                                                                              .trim() ==
                                                                          dttoday
                                                                      ? Text(
                                                                          "Starts Today: ${snapshot.data[index].start_time}",
                                                                          maxLines:
                                                                              1,
                                                                          textAlign:
                                                                              TextAlign.start,
                                                                          style:
                                                                              kTextNormalStyle.apply(color: Colors.white),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        )
                                                                      : snapshot.data[index].date.trim() ==
                                                                              dttomorrow
                                                                          ? Text(
                                                                              "Starts Tommorrow: ${snapshot.data[index].start_time}",
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.start,
                                                                              style: kTextNormalStyle.apply(color: Colors.white),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            )
                                                                          : Text(
                                                                              "Starts ${snapshot.data[index].date}: ${snapshot.data[index].start_time}",
                                                                              maxLines: 1,
                                                                              textAlign: TextAlign.start,
                                                                              style: kTextNormalStyle.apply(color: Colors.white),
                                                                              overflow: TextOverflow.ellipsis,
                                                                            )),
                                                            )
                                                          ],
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .stretch,
                                                        )
                                                      ]),
                                                ))
                                              ]),
                                          onTap: () {
                                            //     showScaffoldMessage("On reworks..", context);
                                            selectedDailyEvent =
                                                snapshot.data[index];
                                            // print(" selected ${selectedDailyEvent.title}");

                                            //todo open main event
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        DailyEventDetail(
                                                          sDate: snapshot
                                                              .data[index]
                                                              .start_time,
                                                          selectedDailyEvent:
                                                              selectedDailyEvent!,
                                                          notificationsActionStreamSubscription:
                                                              notificationsActionStreamSubscription,
                                                        )));
                                          },
                                        )));
                              }),
                        );
                      }
                      return Text("here snapshot");
                    } else {
                      return Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          enabled: true,
                          child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              scrollDirection: Axis.vertical,
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index) {
                                return EventsLoadingEffect();
                              }));
                    }
                  }))
        ],
      ),
    );
  }
}
