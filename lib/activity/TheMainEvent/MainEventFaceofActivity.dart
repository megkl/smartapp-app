import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/DesignConfig.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/MainEventRound.dart';



import '../HomeActivity.dart';
import '../PlayActivity.dart';
import 'MainEventDetail.dart';


GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class MainEventFaceofActivity extends StatefulWidget {
  @override
  MainEventFaceofState createState() => new MainEventFaceofState();
}

class MainEventFaceofState extends State<MainEventFaceofActivity> {
  bool isloading = false, eventloading = false, nodata = false;
  List<MainEventRound>? maineventroundlist;
  String? dttoday, dttomorrow;
  MainEventRound? currevent;
  Timer? timer;

  @override
  void initState() {
    dttoday = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
    dttomorrow = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now()
            .add(new Duration(days: 1))
            .millisecondsSinceEpoch
            .toString())));

    maineventroundlist = [];
    loadMainEventRound();

    WidgetsBinding.instance.addPostFrameCallback((_) => updateUi());

    super.initState();
  }

  Future loadMainEventRound() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      setState(() {
        isloading = true;
        nodata = false;
      });

      Map<String, String> body = {
        GET_MAIN_EVENT_FACEOFROUND: "1",
        userId: uuserid!,
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      isgettingdata = false;



      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
              () => setState(() {
                    isloading = false;
                    maineventroundlist!.addAll((res['data'] as List)
                        .map((model) => MainEventRound.fromFaceofJson(model))
                        .toList());

                  }));
        }
      } else {
        //tradeisloadmore = false;
        nodata = true;
        isloading = false;
        setState(() {});
      }
      //}
    }
  }

  Future<bool> onBackPress() {
    setState(() {
      if (currevent != null) currevent!.isprocess = false;
      if (eventloading) eventloading = false;
    });
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        key: scaffoldKey,
        // backgroundColor: Colors.white,
        appBar: AppBar(
          //brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
          centerTitle: true,
          //backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          flexibleSpace: Container(
            decoration: DesignConfig.gradientbackground,
          ),
          title: Text(
            StringRes.mainevent,
            style: TextStyle(color: white, fontFamily: 'TitleFont'),
          ),
        ),
        body: Container(
          decoration: DesignConfig.gradientbackground,
          height: double.maxFinite,
          child: isloading
              ? Center(
                  child: new CircularProgressIndicator(
                  backgroundColor: white,
                ))
              : nodata
                  ? Center(
                      child: Text(
                      StringRes.nodatafound,
                      style: Theme.of(context).textTheme.titleMedium?.merge(
                          TextStyle(color: white, fontWeight: FontWeight.bold)),
                    ))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: maineventroundlist!.length,
                      itemBuilder: (BuildContext ctxt, int index) {


                        MainEventRound event = maineventroundlist![index];
                        String? eventdate = event.date!.trim() == dttoday
                            ? StringRes.today
                            : event.date!.trim() == dttomorrow
                                ? StringRes.tomorrow
                                : event.date;
                        //var now = DateTime.parse(event.start_time);
                        var now = new DateTime.now();
                        DateTime datee = DateTime.parse(
                            "${event.date!.split("-")[2]}-${event.date!.split("-")[1]}-${event.date!.split("-")[0]} ${event.start_time}");
                        String starttime = DateFormat('hh:mm a').format(datee);
                        String buyamt = int.parse(event.amount!) <= 0
                            ? StringRes.free
                            : "${event.amount}${Constant.CURRENCYSYMBOL.toLowerCase()}";

                        return GestureDetector(
                          onTap: () {
                            if (!eventloading) {
                              if (int.parse(event.no_of!) <
                                  Constant.MAX_QUE_PER_LEVEL) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(StringRes.notenoughque),
                                    backgroundColor: appcolor,
                                  ),
                                );
                              } else {

                                CheckEligibility(event);
                              }
                              // CheckEligibility(event);
                            }
                          },
                          child: Container(
                              decoration:
                                  DesignConfig.RoundedcornerWithColor(white),
                              margin: EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: new Text(
                                        event.hours! +
                                            " hours " +
                                            event.min! +
                                            " min " +
                                            event.sec! +
                                            " sec to go",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primary),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(
                                      event.event_title!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.merge(TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: appcolor)),
                                    ),
                                  ),
                                  new Text(
                                    event.title!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.merge(TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: black)),
                                  ),
                                  event.isprocess!
                                      ? new CircularProgressIndicator(
                                          backgroundColor: appcolor,
                                        )
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom: 8.0,
                                        left: 5,
                                        right: 5),
                                    child: Text(
                                      "Live Game to Start at $starttime\nPrice to be Won ${event.point}${Constant.CURRENCYSYMBOL.toLowerCase()}\nTap here to Buy Ticket of $buyamt",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.merge(TextStyle(color: black)),
                                    ),
                                  ),

                                ],
                              )),
                        );
                      }),
        ),
      ),
    );
  }

  _asyncSimpleDialog(BuildContext context, MainEventRound event) async {
    return await showDialog(
        context: context,
        builder: (dialogContext) {

          return SimpleDialog(
            title: const Text(
              'Select Payment Method',
              style: TextStyle(color: appcolor),
            ),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  selectedmaineventround = event;
                  String paypalurl = PAYPAL_URL +
                      "amount=" +
                      event.amount! +
                      "&title=" +
                      event.title!.replaceAll(" ", "") +
                      "&id=" +
                      event.id!;

                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5),
                  child: const Text(
                    '1. Paypal',
                    style: TextStyle(color: appcolor),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  if (uemail!.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Add Email from Profile")));
                  }
                  //else
                 // CardPayment(event.id, event.amount, event, context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5),
                  child: const Text('2. Card Payment',
                      style: TextStyle(color: appcolor)),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  if (umobile!.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Add Phone Number from Profile")));
                  } else {
                     showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            //backgroundColor: ColorsRes.Grey_primary,
                            child: PhoneNumberialog(event),
                          );
                        });


                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5),
                  child:
                      const Text('3. Mpesa', style: TextStyle(color: appcolor)),
                ),
              ),
            ],
          );
        });
  }

  Widget PhoneNumberialog(MainEventRound event) {
    String errmsg = "";
    String phno = "";
    TextEditingController edtmobile =
        TextEditingController(text: umobile!.replaceAll("+", "") ?? '');

    return StatefulBuilder(
        //context: context,
        //barrierDismissible: false,
        builder: (BuildContext context, StateSetter setState) {
      //return new AlertDialog(
      //title: Text('Login with Phone Number',style: TextStyle(color: appcolor,fontWeight: FontWeight.bold),),
      return Container(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Mpesa',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.merge(TextStyle(color: appcolor, fontWeight: FontWeight.bold)),
          ),
          TextField(
            decoration: InputDecoration(
                hintText: 'Enter Phone number',
                hintStyle: TextStyle(color: primary)),
            controller: edtmobile,
            style: TextStyle(color: primary),
            cursorColor: appcolor,
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              phno = value;
            },
          ),
          (errmsg != ''
              ? Text(
                  "\n$errmsg",
                  style: TextStyle(color: Colors.red),
                )
              : Container()),
          SizedBox(
            height: 10,
          ),
          Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style:
                        TextStyle(color: appcolor, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (phno.trim().isEmpty ||
                        Constant.validateMobile(phno) != null) {
                      setState(() {
                        errmsg = "Enter Valid Phone number";
                      });
                    } else {
                      Navigator.of(context).pop();
                      //MPesaPayment(event.id, event.amount, event, phno);
                    }
                  },
                  child: Text(
                    'Send',
                    style:
                        TextStyle(color: appcolor, fontWeight: FontWeight.bold),
                  ),
                )
              ]),
        ]),
      );

      //);
    });
  }




  Future CheckEligibility(MainEventRound event) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(StringRes.checknetwork), backgroundColor: appcolor));
    } else {
      currevent = event;

      setState(() {
        event.isprocess = true;
        eventloading = true;
      });

      Map<String, String> body = {
        ELIGIBLE_FOR_ROUND: "1",
        userId: uuserid!,
        MAIN_EVENT_ID: event.main_event_id!,
        ROUND_ID: event.id!,
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];
      event.isprocess = false;
  
      event.count = res[COUNT] ?? "1";
 
      eventloading = false;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']), backgroundColor: appcolor));
      if (error == "false") {
        bool ispaid = res[IS_PAID].toString().toLowerCase() == "true"
            ? true
            : false ?? false;
        if (ispaid) {
          if (mounted) {
            new Future.delayed(Duration.zero, () {
              selectedmaineventround = event;

              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        PlayActivity(cls: Constant.lblmainevent),
                  ));
            });
          }
        } else {
          //CardPayment(event.id, event.amount,event);
          GoToPayPage(event);
        }
      } else {
        //tradeisloadmore = false;
        print("======check--${res[IS_PAID] != null}");
        if (res[IS_PAID] != null) {
          bool ispaid = res[IS_PAID].toString().toLowerCase() == "true"
              ? true
              : false ?? false;
          if (!ispaid) {
            /*if(int.parse(event.amount) <= 0)
              SetTransactionData(event,"${uuserid}_${event.main_event_id}_${event.id}");
            else
              CardPayment(event.id, event.amount,event);*/
            GoToPayPage(event);
          }
        }
      }
      setState(() {});
      //}
    }
  }

  void GoToPayPage(MainEventRound event) {
  
    if (int.parse(event.amount!) <= 0)
      SetTransactionData(event, "${uuserid}_${event.main_event_id}_${event.id}",
          "Free(0 amount)");
    else {
      //CardPayment(event.id, event.amount, event);
      _asyncSimpleDialog(context, event);
    }
  }

  updateUi() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _update());
  }

  _update() {
    for (int i = 0; i < maineventroundlist!.length; i++) {
      MainEventRound event = maineventroundlist![i];
      if (event.sec == "00" || event.sec == "0") {
        if (event.min == "00" || event.min == "0") {
          event.hours = (int.parse(event.hours!) - 1).toString();
          event.min = 59.toString();
        } else {
          event.min = (int.parse(event.min!) - 1).toString();
          event.sec = 59.toString();
        }
      } else
        event.sec = (int.parse(event.sec!) - 1).toString();
    }
    if (mounted) setState(() {});
  }

  Future SetTransactionData(
      MainEventRound event, String transid, String paytype) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      setState(() {
        event.isprocess = true;
      });

      Map<String, String> body = {
        SET_USER_PAID_MAIN_EVENT: "1",
        userId: uuserid!,
        MAIN_EVENT_ID: event.main_event_id!,
        ROUND: event.round_number!,
        TRANSACTION_ID: transid,
        AMOUNT: event.amount!,
        TYPE: paytype,
      };

      var responseapi = await Constant.getApiData(body);
      final res = json.decode(responseapi);

      String error = res['error'];
      event.isprocess = false;
      eventloading = false;

      setState(() {});

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(res['message'])));

    }
  }
}
