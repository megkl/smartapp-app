import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Helper/global.dart';
import 'package:smartapp/Model/MainEventRound.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/services/language.dart';
import 'package:shimmer/shimmer.dart';

import '../../services/authentication.dart';
import 'MainEventDetail.dart';

class MainEventActivity extends StatefulWidget {
  final BaseAuth? auth;
  const MainEventActivity({this.auth});
  @override
  MainEventState createState() => MainEventState();
}

class MainEventState extends State<MainEventActivity> {
  String? dttoday, dttomorrow, eventDate;
    
  @override
  void initState() {
    maineventroundlist = [];
    super.initState();
    dttoday = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
    dttomorrow = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now()
            .add(new Duration(days: 1))
            .millisecondsSinceEpoch
            .toString())));
    //isDateTimeAutomatic();
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

      Map<String, String> body = {MAIN_EVENT_NEW: "1", userId: uuserid!};

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      print("main event $res");

      String error = res['error'];

      List<MainEventRound> maineventroundlist = [];
      if (error == "false") {
        maineventroundlist.addAll((res['data'] as List)
            .map((model) => MainEventRound.fromJson(model))
            .toList());
        // if(maineventroundlist[0].start_time)
        return maineventroundlist;
      } else {
        return "No data";
        //error no data
      }
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
     // appBar: customAppbar(StringRes.mainevent, primary, Colors.white),
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
          Languages.of(context)!.mainEventString!,
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
                                                                 child: snapshot.data[index].date.trim() == dttoday ?
                                                                 
                                                                Text(
                                                                  "Starts Today: ${snapshot.data[index].start_time}",
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: kTextNormalStyle.apply(
                                                                      color: Colors
                                                                          .white),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ) 
                                                                : snapshot.data[index].date.trim() == dttomorrow ?
                                                                Text(
                                                                  "Starts Tommorrow: ${snapshot.data[index].start_time}",
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: kTextNormalStyle.apply(
                                                                      color: Colors
                                                                          .white),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ) :
                                                                
                                                                Text(
                                                                  "Starts ${snapshot.data[index].date}: ${snapshot.data[index].start_time}",
                                                                  maxLines: 1,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: kTextNormalStyle.apply(
                                                                      color: Colors
                                                                          .white),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ) 
                                                              ),
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
                                          selectedDailyEvent = snapshot.data[index];
                                         // print(" selected ${selectedDailyEvent.title}");

                                          //todo open main event
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => MainEventDetail(sDate: snapshot.data[index].start_time,selectedmainevent: selectedDailyEvent,)));

// //showScaffoldMessage("On reworks..", context);
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

  // Future<bool> isDateTimeAutomatic() async {
  //   DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  //   AndroidDeviceInfo deviceInfo = await deviceInfoPlugin.androidInfo;
  //   print("datetime ${deviceInfo.isDateTimeAutomatic}");
  //   bool val = await isDateTimeAutomatic();
  //   if (!val) {
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return showNotificationDialog();
  //         });
  //
  //   }
  // }

  // showNotificationDialog() {
  //   return AlertDialog(
  //     title: Text('Attention',
  //         textAlign: TextAlign.center, style: TextStyle(color: appcolor)),
  //     content: Text(
  //         'Your date is not set automatically, \n'
  //         'Please go to your device settings and enable Automatic Date and Time inorder to proceed',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(color: Colors.black)),
  //     actions: [
  //       Center(
  //         child: TextButton(
  //           onPressed: () => goToDateSettings(),
  //           child: Text('Update Date',
  //               style: TextStyle(fontSize: 18, color: Colors.black)),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // goToDateSettings() async {
  //   try {
  //     if (Platform.isAndroid) {
  //       AppSettings.openDateSettings();
  //       Navigator.pop(context);

  //       //Navigator.of(context).pop();
  //       loadMainEventData();
  //     }
  //   } catch (e) {
  //     print("failed to open date settings");
  //   }
  // }

}
