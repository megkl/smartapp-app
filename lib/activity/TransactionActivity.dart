import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/Transaction.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:flutter/services.dart';

import 'Login.dart';

class TransactionActivity extends StatefulWidget {
  @override
  TransactionActivityState createState() => new TransactionActivityState();
}

class TransactionActivityState extends State<TransactionActivity> {
  bool ismainloading = false,
      isgrouploading = false,
      isdailyloading = false,
      isdailynodata = false,
      isoneononeloading = false,
      ismainnodata = false,
      isgroupnodata = false,
      isonoononenodata = false;
  List<Transaction>? tr_maineventlist,
      tr_groupeventlist,
      tr_oneononeeventlist,
      tr_dailylist;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    tr_maineventlist = [];
    //tr_dailylist = new List<Transaction>();
    tr_dailylist = [];
    tr_groupeventlist = [];
    tr_oneononeeventlist = [];
    GetUserStatus();
    GetEventData(0);
    GetEventData(1);
    GetEventData(2);
    GetEventData(3);

    super.initState();
  }

  Future<void> GetUserStatus() async {
    String? userid = await getPrefrence(USER_ID);

    var parameter = {GET_USER_BY_ID: "1", userId: userid!};
    var response = await Constant.getApiData(parameter);

    final getdata = json.decode(response);

    String error = getdata["error"];

    if (error == ("false")) {
      String status = getdata["data"]["status"];

      if (status != active) {
        clearUserSession();
        FirebaseAuth.instance.signOut();
 //facebookSignIn.logOut();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Login()),
            ModalRoute.withName('/'));
      } else {
        UserModel user = new UserModel.fromJson(getdata["data"]);
        setState(() {
          uamount = getdata['data']['amount'];
        });

        saveUserDetail(
            user.user_id!,
            user.name!,
            user.email!,
            user.mobile!,
            user.profile!,
            user.refer_code!,
            user.type!,
            user.location!,
            user.fid!);

        //RemoveGameRoomId();
      }
    }
  }

  Future GetEventData(int type) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      String? eventname;
      setState(() {
        eventname = SetLoading(type, true, false);
      });

      Map<String, String> body = {
        GET_TRANSACTION_DETAIL: "1",
        userId: uuserid!,
        EVENT_NAME: eventname ?? ''
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
              () => setState(() {
                    String eventtype = SetLoading(type, false, false);

                    if (eventtype == "mainevent_new")
                      tr_maineventlist!.addAll((res['data'] as List)
                          .map((model) => Transaction.fromJson(model, type))
                          .toList());
                    else if (eventtype == "main_event")
                      tr_dailylist!.addAll((res['data'] as List)
                          .map((model) => Transaction.fromJson(model, type))
                          .toList());
                    else if (eventtype == "group_event")
                      tr_groupeventlist!.addAll((res['data'] as List)
                          .map((model) => Transaction.fromJson(model, type))
                          .toList());
                    else if (eventtype == "one_on_one_contest")
                      tr_oneononeeventlist!.addAll((res['data'] as List)
                          .map((model) => Transaction.fromJson(model, type))
                          .toList());
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
      eventname = "main_event";
    } else if (type == 1) {
      ismainloading = value;
      ismainnodata = isnodata;
      eventname = "mainevent_new";
    } else if (type == 2) {
      isgrouploading = value;
      isgroupnodata = isnodata;
      eventname = "group_event";
    } else if (type == 3) {
      isoneononeloading = value;
      isonoononenodata = isnodata;
      eventname = "one_on_one_contest";
    }
    return eventname ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: white,
          ),
          bottom: TabBar(
            indicatorColor: white,
            labelColor: white,
            unselectedLabelColor: black,
            tabs: [
              Tab(
                  child: Text(StringRes.event_daily,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13))),
              Tab(
                  child: Text(StringRes.event_main,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13))),
              Tab(
                  child: Text(
                StringRes.event_group,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              )),
              Tab(
                  child: Text(
                StringRes.event_oneonone,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              )),
            ],
          ),
          backgroundColor: practiceColor,
          // flexibleSpace: Container(decoration: DesignConfig.gradientbackground,),
          centerTitle: true,
          title: Text(
            StringRes.transaction,
            style: TextStyle(color: white, fontFamily: 'TitleFont'),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {},
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.account_balance_wallet,
                    color: white,
                  ),
                  Text(
                    uamount == null || uamount!.trim().isEmpty ? "0" : uamount!,
                    style: TextStyle(fontWeight: FontWeight.bold, color: white),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/gameback.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: WalletData(
                    0, isdailyloading, isdailynodata, tr_dailylist!)),
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/gameback.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: WalletData(
                    1, ismainloading, ismainnodata, tr_maineventlist!)),
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/gameback.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: WalletData(
                    2, isgrouploading, isgroupnodata, tr_groupeventlist!)),
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/gameback.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: WalletData(3, isoneononeloading, isonoononenodata,
                    tr_oneononeeventlist!)),
          ],
        ),
      ),
    );
  }

  Widget WalletData(int type, bool iseventloading, bool iseventnodata,
      List<Transaction> transactionlist) {
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
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  StringRes.transactionid,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.merge(TextStyle(
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(StringRes.paytype,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.merge(TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ))))),
                          Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(StringRes.date,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.merge(TextStyle(
                                              fontWeight: FontWeight.bold))))),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(StringRes.amount,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.merge(TextStyle(
                                            fontWeight: FontWeight.bold))),
                              ))
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      height: 20,
                      color: grey,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: transactionlist.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          Transaction item = transactionlist[index];
                          String wdate = DateFormat('dd-MM-yyyy')
                              .format(DateTime.parse(item.date!));
                          //String roundid = "";
                          String eventid = item.eventid!;
                          String dialogdetail =
                              'Amount : ${item.amount}\nDate : $wdate\nTransactionId : ${item.transaction_id}\nEventId : $eventid';

                          eventid = item.eventid!;

                          dialogdetail =
                              'Amount : ${item.amount}\nDate : $wdate\nTransactionId : ${item.transaction_id}\nEventId : $eventid';

                          return GestureDetector(
                            onTap: () {
                              showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: Text(
                                          '${Constant.setFirstLetterUppercase(item.type!)}',
                                          style: TextStyle(
                                              color: appcolor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: Text(
                                          dialogdetail,
                                          style: TextStyle(color: appcolor),
                                        ),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ]);
                                  });
                            },
                            onLongPress: () {
                              Clipboard.setData(new ClipboardData(
                                  text: item.transaction_id!));
                              // _scaffoldKey.currentState?.showSnackBar(SnackBar(
                              //     content: Text("TransactionId Copied")));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("TransactionId Copied"),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 5.0, bottom: 5),
                              child: Row(children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(item.transaction_id!),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: Text(
                                            Constant.setFirstLetterUppercase(
                                                item.type!)))),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: Text(
                                      wdate,
                                    ))),
                                Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Text(
                                        item.amount ?? '',
                                        textAlign: TextAlign.end,
                                      ),
                                    ))
                              ]),
                            ),
                          );
                        }),
                  ],
                ),
              );
  }
}
