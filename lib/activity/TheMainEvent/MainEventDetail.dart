import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Helper/global.dart';
import 'package:smartapp/Helper/loading.dart';
import 'package:smartapp/Helper/payment_options.dart';
import 'package:smartapp/Model/MainEventRound.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/PlayActivity.dart';
import 'package:smartapp/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PaypalWebviewActivity.dart';
import '../payments.dart';

MainEventRound? selectedmaineventround;
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
String isError = '';

class MainEventDetail extends StatefulWidget {
  final String? sDate;
  final MainEventRound? selectedmainevent;

  const MainEventDetail({Key? key, this.sDate, this.selectedmainevent})
      : super(key: key);

  @override
  MainEventDetailState createState() =>
      new MainEventDetailState(sDate: this.sDate);
}

class MainEventDetailState extends State<MainEventDetail> {
  bool? isloading = false, eventloading = false;
  bool? ispaid = false;
  String? dttoday, dttomorrow;
  MainEventRound? currevent;
  Timer? timer;
  bool? isRestricted = false;
  bool? showTimer = false;
  bool? isLate = false;
  String? sDate;
  bool? isNeg = false;
  String? starttime;
  String? eventdate;
  var difference;

  MainEventDetailState({this.sDate});

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

    // maineventroundlist = new List<MainEventRound>();
    //loadMainEventData();
    print("id is ${widget.selectedmainevent!.id}");
    CheckPaid(widget.selectedmainevent!);

    if (widget.selectedmainevent != null) {
      if (int.parse(widget.selectedmainevent!.hours!).isNegative) isNeg = true;

      DateTime datee = DateTime.parse(
          "${widget.selectedmainevent!.date!.split("-")[2]}-${widget.selectedmainevent!.date!.split("-")[1]}-${widget.selectedmainevent!.date!.split("-")[0]} ${widget.selectedmainevent!.start_time}");
      starttime = DateFormat('hh:mm a').format(datee);
//print("date==>$sDate");
      List datePart = widget.selectedmainevent!.date!.split("-");
      DateTime dateTime = DateTime(int.parse(datePart[2]),
          int.parse(datePart[1]), int.parse(datePart[0]));

      eventdate = widget.selectedmainevent!.date!.trim() == dttoday
          ? StringRes.today
          : widget.selectedmainevent!.date!.trim() == dttomorrow
              ? StringRes.tomorrow
              : DateFormat('EEEE').format(dateTime);
      isLate = differenceTime(widget.selectedmainevent!.start_time!) &&
          widget.selectedmainevent!.date == dttoday;
    }
    super.initState();
  }

  // Future loadMainEventData() async {
  //   bool checkinternet = await Constant.CheckInternet();
  //   if (!checkinternet) {
  //     Scaffold.of(context)
  //         .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
  //   } else {
  //     setState(() {
  //       isgettingdata = true;
  //       isnodata = false;
  //     });

  //     if (uuserid == null) {
  //       uname = await getPrefrence(NAME);
  //       uemail = await getPrefrence(EMAIL);
  //       uuserid = await getPrefrence(USER_ID);
  //       uprofile = await getPrefrence(PROFILE);
  //       umobile = await getPrefrence(MOBILE);
  //       ulocation = await getPrefrence(LOCATION);
  //     }
  //     Map<String, String> body = {MAIN_EVENT_NEW: "1", userId: uuserid};

  //     var response = await Constant.getApiData(body);

  //     final res = json.decode(response);

  //     String error = res['error'];

  //     isgettingdata = false;
  //     if (error == "false") {
  //       if (mounted) {
  //         maineventroundlist.clear();

  //         maineventroundlist.addAll((res['data'] as List)
  //             .map((model) => MainEventRound.fromJson(model))
  //             .toList());
  //         selectedmainevent = maineventroundlist[0];
  //         CheckPaid(selectedmainevent);
  //       }
  //     } else {
  //       isgettingdata = false;
  //       isnodata = true;

  //       setState(() {});
  //     }
  //   }
  // }

  Future<bool> onBackPress() {
    if (isRestricted!) {
      return Future.value(false);
    } else {
      setState(() {
        if (currevent != null) currevent!.isprocess = false;
        if (eventloading!) eventloading = false;
      });
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("length****${selectedmainevent.date}");

    Widget isEventReady() {
      if ((!isLate!  || (isLate! && ispaid!)) &&
          selectedDailyEvent!.date == dttoday) {
        return Container(
          width: double.maxFinite,
          color: blue,
          margin: const EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.all(8),
          child: Text(
            'Starts at : ' + starttime!,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );
      } else if ((!isLate! || (isLate! && ispaid!)) &&
          selectedDailyEvent!.date == dttomorrow) {
        return Container(
          width: double.maxFinite,
          color: blue,
          margin: const EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.all(8),
          child: Text(
            'Starts Tomorrow at : ' + starttime!,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );
      } else if ((!isLate! || (isLate! && ispaid!)) &&
          selectedDailyEvent!.date != dttomorrow &&
          selectedDailyEvent!.date != dttoday) {
        return Container(
          width: double.maxFinite,
          color: blue,
          margin: const EdgeInsets.only(top: 30.0),
          padding: EdgeInsets.all(8),
          child: Text(
            'Starts ${selectedDailyEvent!.date} : ' + starttime!,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );
      } else {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text(
              'Main Event has already started',
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
      }
    }

    String counterText() {
      if (showTimer!) {
        if (difference <= 20) {
          return "$difference secs";
        } else {
          return "";
        }
      } else if (ispaid! && selectedDailyEvent!.date == dttoday) {
        return updateUi();
      } else {
        return "";
      }
    }

    Widget counterWidget() {
      if (!isLate! || (isLate! && ispaid!)) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Text(
              isNeg! ? 'Game Over' : counterText() ?? '',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else {
        return SizedBox(
          height: 0,
        );
      }
    }

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        key: scaffoldKey,
        appBar: customAppbar("Main Event", primary, Colors.white),
        body: Container(
          height: double.maxFinite,
          child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/images/jibu_event.png',
                        width: MediaQuery.of(context).size.width * 0.6,
                      ),
                    ),
                    AutoSizeText(
                      "Welcome, to the ${widget.selectedmainevent!.description} Main Event",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: kTextHeadBoldStyle.apply(color: primary),
                    ),
                    showEventDetails,
                    !ispaid!
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18.0, vertical: 10),
                            child: Center(
                              child: Text(
                                widget.selectedmainevent!.description!,
                                //'Answer 10 trivia questions correctly in the fastest time to be a winner in a minimum prize pool of 100000 kenyan shillings.',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : isEventReady(),
                    !ispaid!
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(
                                '$eventdate at $starttime',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        : Container(),
                    Center(
                        child: !ispaid!
                            ? Padding(
                                padding: const EdgeInsets.only(top: 100.0),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30)),
                                    onPressed: () {
                                      (!isLate! || (isLate! && ispaid!))
                                          ? GoToPayPage(
                                              widget.selectedmainevent!)
                                          : ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Main event has already started"),
                                                  backgroundColor: Colors.red));
                                    },
                                    child: Text('Join The Contest')),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Text('Time To Event'),
                              )),
                    (ispaid! || (ispaid! && isLate!)) &&
                            (selectedDailyEvent!.date == dttoday)
                        ? counterWidget()
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(child: backTomenu),
                    ),
                    widget.selectedmainevent!.isprocess!
                        ? Center(
                            child: new CircularProgressIndicator(
                              backgroundColor: white,
                            ),
                          )
                        : Container(),
                  ])),
        ),
      ),
    );
  }

  loadingOverlay() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 0),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: LoadingOverlay());
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Container();
      },
    );
  }

  jointhecontest() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 0),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child:

                // Container(child: Text(StringRes.confirmeventjoin),)
                Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.only(top: 60, left: 10, right: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Confirm Joining Event ",
                                style: TextStyle(
                                  color: redgradient2,
                                  fontSize: 20,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20.0),
                                child: Text(
                                  "${getGpoints(selectedDailyEvent!.amount!)} GCoins will be deducted from Your wallet for this event.",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 16,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                // decoration: DesignConfig.circulargradient_box,
                                width: double.maxFinite,
                                margin: EdgeInsets.all(30),
                                child: CupertinoButton(
                                    color: btnColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Text(
                                      'Confirm',
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //color: Colors.white,
                                    onPressed: () async {
                                      Map<String, String> body = {
                                        userId: uuserid!,
                                        TRANSACTION_ID:
                                            "Wallet${selectedDailyEvent!.id}",
                                        TYPE: "Wallet",
                                      };

                                      body[SET_USER_PAID_MAIN_EVENT_NEW] = "1";
                                      body[userId] = uuserid!;
                                      body[EVENT_ID] = selectedDailyEvent!.id!;
                                      body[AMOUNT] = selectedDailyEvent!.amount!;
                                      body[EVENT_DATE] = selectedDailyEvent!.date!;

                                      var responseapi =
                                          await Constant.getApiData(body);
                                      final res = json.decode(responseapi);

                                      String error = res['error'];
                                      isloading = false;

                                      setState(() {});

                                      if (error == "false") {
                                        // FinishPage(res['message']);

                                        setState(() {
                                          ispaid = true;
                                        });

                                        // widget.refresh();
                                        print("successfully Paid");
                                        SetTransactionData(
                                            widget.selectedmainevent!,
                                            "${uuserid}_${widget.selectedmainevent!.main_event_id}_${widget.selectedmainevent!.id}",
                                            "Wallet");
                                        //  navigateTo();
                                        Navigator.pop(context);
                                      } else {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(res['message']),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Colors.red,
                                        ));
                                      }
                                    }),
                              ),
                            ],
                          ),
                        )),
                    GestureDetector(
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 40.0,
                          child: Icon(
                            Icons.attach_money_rounded,
                            size: 40,
                            color: orangeTheme,
                          )),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Container();
      },
    );
  }

  lessGcoinsDialog() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 0),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child:

                // Container(child: Text(StringRes.confirmeventjoin),)
                Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.only(top: 60, left: 10, right: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Buy More Gcoins",
                                style: TextStyle(
                                  color: redgradient2,
                                  fontSize: 20,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20.0),
                                child: Text(
                                  "You do not have enough Gcoins in your wallet for this event. Current Gcoins = ${getGpoints(uamount!)} and event requires ${int.parse(selectedDailyEvent!.amount!) / 5} Gcoins",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: 16,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                // decoration: DesignConfig.circulargradient_box,
                                width: double.maxFinite,
                                margin: EdgeInsets.all(30),
                                child: CupertinoButton(
                                    color: btnColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Text(
                                      'Top Up',
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    //color: Colors.white,
                                    onPressed: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddPaymentEntry()));
                                    }),
                              ),
                            ],
                          ),
                        )),
                    GestureDetector(
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: 40.0,
                          child: Icon(
                            Icons.attach_money_rounded,
                            size: 40,
                            color: orangeTheme,
                          )),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Container();
      },
    );
  }

  showPaymentOptions() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 0),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: PaymentOptions());
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Container();
      },
    );
  }

  get backTomenu {
    if (ispaid!) {
      if (isRestricted!) {
        return Container();
      } else {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: lightPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Back to Menu'));
      }
    } else {
      return Container();
    }
  }

  get showEventDetails {
    return Container(
        width: double.maxFinite,
        color: orangeTheme,
        margin: const EdgeInsets.only(top: 30.0),
        padding: EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Amount to Win",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "${widget.selectedmainevent!.point!.trim()}",
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }

  Future CheckPaid(MainEventRound event) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(StringRes.checknetwork), backgroundColor: appcolor));
    } else {
      currevent = event;

      Map<String, String> body = {
        ELIGIBLE_FOR_ROUND: "1",
        userId: uuserid!,
        EVENT_ID: widget.selectedmainevent!.id!,
        EVENT_DATE: widget.selectedmainevent!.date!
      };

      var response = await Constant.getApiData(body);
      print("response***$response***$body");
      final res = json.decode(response.toString());

      event.count = res[COUNT] ?? "1";
//todo negate this to see outcome if not paid
      setState(() {
        ispaid = res[IS_PAID].toString().toLowerCase() == "true"
            ? true
            : false ?? false;
      });
      isError = res['error'];
      if (widget.selectedmainevent != null) {
        DateTime datee = DateTime.parse(
            "${widget.selectedmainevent!.date!.split("-")[2]}-${widget.selectedmainevent!.date!.split("-")[1]}-${widget.selectedmainevent!.date!.split("-")[0]} ${widget.selectedmainevent!.start_time}");
        String starttime = DateFormat('hh:mm a').format(datee);

        isLate =
            differenceTime(sDate!) && widget.selectedmainevent!.date == dttoday;
        print("is late $isLate $ispaid ${widget.selectedmainevent!.id}");
        if (!isLate!) {
          if (ispaid! || (ispaid! && isLate!)) if (widget.selectedmainevent!.id !=
                  null &&
              widget.selectedmainevent!.date == dttoday) updateUi();
          // setState(() {
          // });
        }
      }
    }
  }

  bool withinThirtySec() {
    var currentYear = DateTime.now().year;
    var currentMonth = DateTime.now().month;
    var currentDay = DateTime.now().day;
    var sec = DateTime.parse(
            "$currentYear-${handleFormat(currentMonth)}-$currentDay $sDate")
        .difference(DateTime.now())
        .inSeconds;
    print("Remaining Seconds $sec");
    if (sec <= 5) {
      isRestricted = true;
      return true;
    } else {
      isRestricted = false;
      timerUp();
      return false;
    }
  }

  Timer? _timer;
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (seconds < 0) {
            timer.cancel();
          } else {
            seconds = seconds + 1;
            if (seconds > 59) {
              minutes += 1;
              seconds = 0;
              if (minutes > 59) {
                hours += 1;
                minutes = 0;
              }
            }
          }
        },
      ),
    );
  }

  Future<String?> _asyncSimpleDialog(
      BuildContext context, MainEventRound event) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            children: <Widget>[
              SimpleDialogOption(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      // if (int.parse(uamount) < int.parse(event.amount)) {
                      //   showScaffoldMessage("You don't have enough GCoins to play", context);
                      // } else {
                      //   //paid
                      //   SetTransactionData(
                      //       event,
                      //       "${uuserid}_${new DateTime.now().millisecond}",
                      //       "Wallet");
                      // }

                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddPaymentEntry()));
                    },
                    icon: Image.asset(
                      'assets/images/wallet_ic.png',
                      height: 25,
                      fit: BoxFit.fill,
                    ),
                    label: Text('GCoins Wallet')),
              ),
              SimpleDialogOption(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (umobile!.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Add Phone Number from Profile")));
                      } else if (uemail!.trim().isEmpty) {
                        //scaffoldKey.currentState.showSnackBar(
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Add Email from Profile")));
                      } else {
                        umobile = umobile!.replaceAll("+", "");
                        String? userid = await getPrefrence(USER_ID);
                        String cardurl = CARD_URL +
                            "amount=" +
                            event.amount! +
                            "&" +
                            userId +
                            "=" +
                            userid! +
                            "&email=" +
                            uemail! +
                            "&mobile=" +
                            umobile! +
                            "&event_id=" +
                            event.id! +
                            "&name=" +
                            uname! +
                            "&country=" +
                            Constant.COUNTRY +
                            "&currency_code=" +
                            Constant.CURRENCYCODE;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PaypalWebviewActivity(
                                cardurl,
                                Constant.lblmainevent,
                                event.amount,
                                'Mpesa',
                                refreshUI,
                                null,
                                "",
                                null)));
                      }
                    },
                    icon: Image.asset(
                      'assets/images/mpesa.png',
                      height: 25,
                      fit: BoxFit.fill,
                    ),
                    label: Text('Mpesa')),
              ),
              // SimpleDialogOption(
              //   child: ElevatedButton.icon(
              //       style: ElevatedButton.styleFrom(
              //         primary: btnColor.withOpacity(0.5),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.0),
              //         ),
              //       ),
              //       onPressed: () async {
              //         Navigator.pop(context);
              //         selectedmainevent = event;
              //         String paypalurl = PAYPAL_URL +
              //             "amount=" +
              //             event.amount +
              //             "&title=" +
              //             event.title.replaceAll(" ", "") +
              //             "&id=" +
              //             event.id;
              //
              //         //  print("pay***$paypalurl");
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (context) =>
              //                 PaypalWebviewActivity(paypalurl,
              //                     Constant.lblmainevent, '', '', null, null,"",null)));
              //       },
              //       icon: Image.asset(
              //         'assets/images/paypal.png',
              //         height: 25,
              //         fit: BoxFit.fill,
              //       ),
              //       label: Text('Paypal')),
              // ),
              SimpleDialogOption(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      if (uemail!.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Add Email from Profile")));
                      } else
                      // CardPayment(event.id, event.amount, event, context);
                      {
                        umobile = umobile!.replaceAll("+", "");
                        String? userid = await getPrefrence(USER_ID);
                        String cardurl = CARD_URL +
                            "amount=" +
                            event.amount! +
                            "&" +
                            userId +
                            "=" +
                            userid! +
                            "&email=" +
                            uemail! +
                            "&mobile=" +
                            umobile! +
                            "&event_id=" +
                            event.id! +
                            "&name=" +
                            uname! +
                            "&country=" +
                            Constant.COUNTRY +
                            "&currency_code=" +
                            Constant.CURRENCYCODE;
                        print('url****$cardurl');

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PaypalWebviewActivity(
                                cardurl,
                                Constant.lblmainevent,
                                event.amount,
                                'Card',
                                null,
                                null,
                                "",
                                null)));
                      }
                    },
                    icon: Icon(
                      Icons.payment,
                      size: 25,
                    ),
                    label: Text('VISA')),
              ),
            ],
          );
        });
  }

  refreshUI() {
    setState(() {});
  }

//not in use
  Widget PhoneNumberialog(MainEventRound event) {
    String errmsg = "";
    String phno = umobile!.replaceAll("+254", "") ?? '';
    TextEditingController edtmobile =
        TextEditingController(text: umobile!.replaceAll("+254", "") ?? '');

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
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
            cursorColor: appcolor,
            style: TextStyle(color: primary),
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
                      //todo you pay then dismiss dialog
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

  updateUi() {
// print("updateui");
    var currentYear = DateTime.now().year;
    var currentMonth = DateTime.now().month;
    var currentDay = DateTime.now().day;
    difference = DateTime.parse(
            "$currentYear-${handleFormat(currentMonth)}-$currentDay $sDate")
        .difference(DateTime.now())
        .inSeconds;
    if (timer == null &&
        !isRestricted! &&
        !isLate! &&
        ispaid! &&
        selectedDailyEvent!.date == dttoday) {
      showTimer = true;
      print("updateui start 0 >>$difference");
      int _start = 20;
      timer = new Timer.periodic(
        Duration(seconds: 1),
        (Timer timer) {
          if (difference == 0) {
            // print("updateui stop 0>>");
            setState(() {
              timer.cancel();
            });
            timerUp();
          } else {
            // print("updateui start >>${difference} ");
            difference--;

            setState(() {});
            if (difference <= 5) {
              isRestricted = true;
            }
          }
        },
      );
    }
    else if (ispaid! && selectedDailyEvent!.date == dttoday) {
      timerUp();
    }
     else {
      timer!.cancel();
    }
    // if (timer == null) { if(!isRestricted){
    // print("updateui start>>");
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _update());
    //
    // }else{
    //  // print("updateui cancel ****");
    //   timer.cancel();
    //
    // }}
    // else{
    // //  print("updateui cancel **");
    //   timer.cancel();
    // }
  }

//todo checks only if payed
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
        EVENT_ID: event.id!,
        EVENT_DATE: event.date!,
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      isError = res['error'];
      event.isprocess = false;

      event.count = res[COUNT] ?? "1";

      eventloading = false;

      ispaid = res[IS_PAID].toString().toLowerCase() == "true"
          ? true
          : false ?? false;

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']), backgroundColor: appcolor));
      if (isError == "false") {
        if (ispaid!) {
          if (mounted) {
            if (int.parse(widget.selectedmainevent!.no_of!) <
                Constant.MAX_QUE_PER_LEVEL) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(StringRes.notenoughque),
                  backgroundColor: appcolor,
                ),
              );
            } else {
              new Future.delayed(Duration.zero, () {
                selectedmaineventround = event;

                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, anim1, anim2) => PlayActivity(
                          cls: Constant.lblmainevent,
                          selectedmainevent: widget.selectedmainevent),
                    ));
              });
            }
          }
        } else {
          //CardPayment(event.id, event.amount,event);
          GoToPayPage(event);
        }
      } else {
        //tradeisloadmore = false;

        if (res[IS_PAID] != null) {
          ispaid = res[IS_PAID].toString().toLowerCase() == "true"
              ? true
              : false ?? false;
          if (!ispaid!) {
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

  void GoToPayPage(MainEventRound event) async {
    if (int.parse(event.amount!) <= 0) {
      SetTransactionData(event, "${uuserid}_${event.main_event_id}_${event.id}",
          "Free(0 amount)");
    } else if (int.parse(event.amount!) > int.parse(uamount!)) {
      lessGcoinsDialog();
    } else {
      //CardPayment(event.id, event.amount, event);
      //  _asyncSimpleDialog(context, event);
      var data = await jointhecontest();
      if (data != null) {
        switchToPaymentMode(data, event);
      }
    }
  }

  switchToPaymentMode(var option, MainEventRound event) async {
    switch (option) {
      case "Visa":
        if (uemail!.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add Email from Profile")));
        } else
        // CardPayment(event.id, event.amount, event, context);
        {
          umobile = umobile!.replaceAll("+", "");
          String? userid = await getPrefrence(USER_ID);
          String cardurl = CARD_URL +
              "amount=" +
              event.amount! +
              "&" +
              userId +
              "=" +
              userid! +
              "&email=" +
              uemail! +
              "&mobile=" +
              umobile! +
              "&event_id=" +
              event.id! +
              "&name=" +
              uname! +
              "&country=" +
              Constant.COUNTRY +
              "&currency_code=" +
              Constant.CURRENCYCODE;
          // print('url****$cardurl');

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaypalWebviewActivity(
                  cardurl,
                  Constant.lblmainevent,
                  event.amount,
                  'Card',
                  null,
                  null,
                  "",
                  null)));
        }
        break;
      case "M-Pesa":
        if (umobile!.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Add Phone Number from Profile")));
        } else if (uemail!.trim().isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Add Email from Profile")));
        } else {
          umobile = umobile!.replaceAll("+", "");
          String? userid = await getPrefrence(USER_ID);
          String cardurl = CARD_URL +
              "amount=" +
              event.amount! +
              "&" +
              userId +
              "=" +
              userid! +
              "&email=" +
              uemail! +
              "&mobile=" +
              umobile! +
              "&event_id=" +
              event.id! +
              "&name=" +
              uname! +
              "&country=" +
              Constant.COUNTRY +
              "&currency_code=" +
              Constant.CURRENCYCODE;

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => PaypalWebviewActivity(
                  cardurl,
                  Constant.lblmainevent,
                  event.amount,
                  'Mpesa',
                  refreshUI,
                  null,
                  "",
                  null)));
        }
        break;
      case "GCoin Wallet":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => AddPaymentEntry()));
        break;
    }
  }

//todo already paid
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

      // Map<String, String> body = {
      //   SET_USER_PAID_MAIN_EVENT_NEW: "1",
      //   userId: uuserid,
      //   EVENT_ID: event.id,
      //   //   ROUND: event.round_number,
      //   TRANSACTION_ID: transid,
      //   AMOUNT: event.amount,
      //   TYPE: paytype,
      // };

      // var responseapi = await Constant.getApiData(body);
      // final res = json.decode(responseapi);

      // String error = res['error'];
      // event.isprocess = false;
      // eventloading = false;

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
      // if (error == 'false') {
      //   // ispaid = true;

      //   // if (selectedmainevent != null) updateUi();

      //CheckPaid(widget.selectedmainevent);

      if (paytype == 'Wallet') {
        if (int.parse(uamount!) > 0 &&
            int.parse(uamount!) >= int.parse(event.amount!)) {
          uamount = (int.parse(uamount!) - int.parse(event.amount!)).toString();

          WidgetsFlutterBinding.ensureInitialized();
          SharedPreferences prefs = await SharedPreferences.getInstance();

          setState(() {
            ispaid = true;
          });

          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Kindly Top Up Your Wallet")));
        }
      } else {
        setState(() {});
      }
    }
  }

  _update() {
    // print("update==>");

    if (widget.selectedmainevent!.sec == "00" ||
        widget.selectedmainevent!.sec == "0") {
      if (widget.selectedmainevent!.min == "00" ||
          widget.selectedmainevent!.min == "0") {
        if ((widget.selectedmainevent!.hours == "00" ||
                widget.selectedmainevent!.hours == "0") &&
            ispaid!) {
          if (int.parse(widget.selectedmainevent!.no_of!) <
              Constant.MAX_QUE_PER_LEVEL) {
            isRestricted = false;
            //pop overlay

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(StringRes.notenoughque),
                backgroundColor: appcolor,
              ),
            );
          } else {
            //pop overlay

            timerUp();
          }
        } else {
          widget.selectedmainevent!.hours =
              (int.parse(widget.selectedmainevent!.hours!) - 1).toString();
          widget.selectedmainevent!.min = 59.toString();
        }
      } else {
        widget.selectedmainevent!.min =
            (int.parse(widget.selectedmainevent!.min!) - 1).toString();
        widget.selectedmainevent!.sec = 59.toString();
      }
    } else {
      widget.selectedmainevent!.sec =
          (int.parse(widget.selectedmainevent!.sec!) - 1).toString();
      if (int.parse(widget.selectedmainevent!.hours!) < 1 &&
          int.parse(widget.selectedmainevent!.min!) < 1 &&
          int.parse(widget.selectedmainevent!.sec!) > -1 &&
          int.parse(widget.selectedmainevent!.sec!) <= 5) {
        showTimer = true;
        // print("less than 30");
        isRestricted = true;
//print(int.parse(selectedmainevent.sec));
        if (int.parse(widget.selectedmainevent!.sec!) < 1) {
          // print("now zero");

          timerUp();
        }
        setState(() {});
        //pop ggdialog overlay of loading
        // if (mounted) setState(() {});
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (timer != null) timer!.cancel();
    super.dispose();
  }

//navigates to play
  Future<void> timerUp() async {
    print("timer up");
    if (timer != null) {
      isRestricted = false;
      timer!.cancel();
    } else if (ispaid!) {
      isRestricted = false;
    }

    Map<String, String> body = {
      ELIGIBLE_FOR_ROUND: "1",
      userId: uuserid!,
      EVENT_ID: widget.selectedmainevent!.id!,
      EVENT_DATE: widget.selectedmainevent!.date!,
    };

    var response = await Constant.getApiData(body);

    final res = json.decode(response);

    isError = res['error'];

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message']), backgroundColor: appcolor));
    //print("here is tomer i ${res}");
    if (isError == "false") {
      if (isError == "false") {
        selectedmaineventround = widget.selectedmainevent;
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) => PlayActivity(
                  cls: Constant.lblmainevent,
                  selectedmainevent: widget.selectedmainevent),
            ));
      }
    }
  }
}
