import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/GroupModel.dart';
import 'package:smartapp/activity/GroupEvent/GroupEventDetailActivity.dart';
import 'package:smartapp/activity/HomeActivity.dart';

class GroupEventActivity extends StatefulWidget {
  @override
  GroupEventState createState() => GroupEventState();
}

class GroupEventState extends State<GroupEventActivity> {
  @override
  void initState() {
    super.initState();

    groupeventlist = [];
    loadGroupEventData();
  }

  Future loadGroupEventData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
    
      // if (tradeisloadmore) {
      setState(() {
        isgettinggroupdata = true;
        isnodatagroup = false;
      });

      if (uuserid == null) {
        uname = await getPrefrence(NAME);
        uemail = await getPrefrence(EMAIL);
        uuserid = await getPrefrence(USER_ID);
        uprofile = await getPrefrence(PROFILE);
        umobile = await getPrefrence(MOBILE);
        ulocation = await getPrefrence(LOCATION);
        utype = await getPrefrence(LOGIN_TYPE);
      }
      Map<String, String> body = {GET_GROUP_EVENT: "1", userId: uuserid!};

      var response = await Constant.getApiData(body);
      print("loadmain---res-$response");
      final res = json.decode(response);

      String error = res['error'];
      isgettinggroupdata = false;

      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
              () => setState(() {
                    groupeventlist!.clear();
                    groupeventlist!.addAll((res['data'] as List)
                        .map((model) => GroupModel.fromJson(model))
                        .toList());
              
                  }));
        }
      } else {
        //tradeisloadmore = false;
        isnodatagroup = true;
        setState(() {});
      }
      //}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            centerTitle: true,
elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            StringRes.groupplayer,
            style: TextStyle(fontFamily: 'TitleFont', color: white),
          ),
        ),
        body: Builder(
            builder: (context) => Container(
              height: double.maxFinite,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/gameback.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: isgettinggroupdata
                  ? Center(
                      child: new CircularProgressIndicator(
                      backgroundColor: appcolor,
                    ))
                  : Container(
                      padding: const EdgeInsets.only(
                          top: 8.0, left: 5, right: 5, bottom: 5),

                      child: isnodatagroup
                          ? Center(
                              child: Text(
                              StringRes.nodatafound,
                              style: Theme.of(context).textTheme.titleMedium?.merge(
                                  TextStyle(
                                      color: white, fontWeight: FontWeight.bold)),
                            ))
                          : ListView.builder(
                              itemCount: groupeventlist?.length,
                              itemBuilder: (BuildContext context, int index) {
                                GroupModel item = groupeventlist![index];
                                DateTime datee = DateTime.parse(
                                    "${item.date!.split("-")[2]}-${item.date!.split("-")[1]}-${item.date!.split("-")[0]} ${item.end_time}");
                                String endtime =
                                    DateFormat('hh:mm a').format(datee);

                                return GestureDetector(
                                  onTap: () {
                                    selectedgroupevent = item;
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            GroupEventDetailActivity()));
                                  },
                                  child: Card(
                                    margin: EdgeInsets.only(bottom: 10),
                                     shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    )),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: FadeInImage.assetNetwork(
                                              image: item.image!,
                                              placeholder:
                                                  "assets/images/placeholder.png",
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, right: 5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 8.0),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.centerRight,
                                                        child: new Text(
                                                          item.hours! +
                                                              " hours " +
                                                              item.min! +
                                                              " min " +
                                                              item.sec! +
                                                              " sec to go",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: primary),
                                                        )),
                                                  ),
                                                  Text("${item.title}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.merge(TextStyle(
                                                              color: appcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600))),
                                                  Text(
                                                      "Buy Ticket at ${item.entryamount}${Constant.CURRENCYSYMBOL.toLowerCase()} and Win ${item.winningamount}${Constant.CURRENCYSYMBOL.toLowerCase()}",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleSmall
                                                          ?.merge(TextStyle(
                                                              color: appcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5.0),
                                                    child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: <Widget>[
                                                          RichText(
                                                            text: TextSpan(
                                                              text: StringRes
                                                                  .endsin,
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style
                                                                  .merge(TextStyle(
                                                                      color:
                                                                          appcolor)),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                        '\n$endtime',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            appcolor)),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                              height: 20,
                                                              child:
                                                                  VerticalDivider(
                                                                color: appcolor,
                                                                thickness: 1,
                                                              )),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: StringRes
                                                                  .members,
                                                              style: DefaultTextStyle
                                                                      .of(context)
                                                                  .style
                                                                  .merge(TextStyle(
                                                                      color:
                                                                          appcolor)),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text:
                                                                        '\n${item.join_user}/${item.no_of_user}',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color:
                                                                            appcolor)),
                                                              ],
                                                            ),
                                                          ),
                                                        ]),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
            )));
  }
}
