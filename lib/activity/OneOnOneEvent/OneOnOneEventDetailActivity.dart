import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/DesignConfig.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/OneOnOneModel.dart';
import 'package:smartapp/Model/Question.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/ChatScreenActivity.dart';
import 'package:smartapp/activity/OneOnOneEvent/RobotPlayActivity.dart';



import '../PaypalWebviewActivity.dart';
import 'package:firebase_database/firebase_database.dart';

import 'BattleGamePlayActivity.dart';

DatabaseReference? databaseReference;
GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
String eventmymatchid = "", eventbattleusermatchid = "";
OneOnOneModel? currenteventdata;

class OneOnOneEventDetailActivity extends StatefulWidget {
    @override
    OneOnOneEventDetailState createState() => new OneOnOneEventDetailState();
}

class OneOnOneEventDetailState extends State<OneOnOneEventDetailActivity> {
    bool isloading = false;
    String? buyamt; //dttoday,dttomorrow,
    String btntext = StringRes.findyourmatch;

    @override
    void initState() {

        databaseReference = FirebaseDatabase.instance.reference();
        btntext = StringRes.findyourmatch;

        buyamt = int.parse(selectedoneononeevent!.entryamount!) <= 0
            ? StringRes.free
            : "${selectedoneononeevent!.entryamount}${Constant.CURRENCYSYMBOL.toLowerCase()}";

        super.initState();
    }

    Future<bool> onBackPress() {
        setState(() {
            if (isloading) isloading = false;
        });
        return Future.value(true);
    }

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: onBackPress,
            child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.white,
                appBar: AppBar(
                    centerTitle: true,
                    flexibleSpace: Container(
                        decoration: DesignConfig.gradientbackground,
                    ),
                    //  backgroundColor: Colors.white,
                    iconTheme: IconThemeData(
                        color: Colors.white,
                    ),
                    title: Text(
                        StringRes.oneonone,
                        style: TextStyle(color: white, fontFamily: 'TitleFont'),
                    ),

                    actions: <Widget>[
                        IconButton(
                            icon: Image.asset(
                                "assets/images/chat.png",
                                color: white,
                            ),
                            onPressed: () {
                                chatfrom = Constant.lbloneononeevent;
                                //ischatscreen = true;
                                chatgroupid = selectedoneononeevent!.id!;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatScreenActivity()));
                            },
                        )
                    ],
                ),
                body: Container(
                    // decoration: DesignConfig.backgroundimg,
                    height: double.maxFinite,
                    child: Column(
                        children: <Widget>[
                            Expanded(
                                child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                            selectedoneononeevent!.image!.isEmpty
                                                ? Container()
                                                : FadeInImage.assetNetwork(
                                                image: selectedoneononeevent!.image!,
                                                placeholder: "assets/images/placeholder.png",
                                                width: double.infinity,
                                                height: 200,
                                                fit: BoxFit.cover,
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                    selectedoneononeevent!.title!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.merge(TextStyle(color: appcolor)),
                                                )

                                            ),
                                            Padding(
                                                padding: const EdgeInsets.symmetric(horizontal:8.0),
                                                child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                        Text(
                                                            "${StringRes.entry}: $buyamt",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                decoration: TextDecoration.underline,
                                                                color: primary),
                                                        ),
                                                        Text(
                                                            "${StringRes.winningamount}: ${selectedoneononeevent!.winning_amount}${Constant.CURRENCYSYMBOL.toLowerCase()}",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                decoration: TextDecoration.underline,
                                                                color: primary)),
                                                    ],
                                                ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                    selectedoneononeevent!.description!,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium
                                                        ?.copyWith(color: primary),
                                                ),
                                            ),
                                        ])),
                            ),
                            isloading
                                ? Padding(
                                padding: const EdgeInsets.all(5),
                                child: new CircularProgressIndicator(),
                            )
                                : Container(),

                            Container(
                                decoration: DesignConfig.circulargradient_box,
                                width: 300,
                                margin: EdgeInsets.only(bottom: 5, top: 5),
                                child: CupertinoButton(
                                    //borderRadius: BorderRadius.circular(100.0),
                                    child: Text(
                                        'Play With Robot',
                                        style: TextStyle(color: white, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                        if (!isloading) {
                                            if (int.parse(selectedoneononeevent!.no_of!) <
                                                Constant.MAX_QUE_PER_LEVEL) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                        content: Text(StringRes.notenoughque),
                                                        backgroundColor: appcolor,
                                                    ),
                                                );
                                            } else {
                                                playRobot();
                                                //CheckEligibility();
                                            }
                                            // CheckEligibility(event);
                                        }
                                    },
                                ),
                            ),
                            Container(
                                decoration: DesignConfig.circulargradient_box,
                                width: 300,
                                margin: EdgeInsets.only(bottom: 15, top: 5),
                                child: CupertinoButton(
                                    //borderRadius: BorderRadius.circular(100.0),
                                    child: Text(
                                        btntext,
                                        style: TextStyle(color: white, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () {
                                        if (!isloading) {
                                            if (int.parse(selectedoneononeevent!.no_of!) <
                                                Constant.MAX_QUE_PER_LEVEL) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                        content: Text(StringRes.notenoughque),
                                                        backgroundColor: appcolor,
                                                    ),
                                                );
                                            } else {
                                                CheckEligibility();
                                            }

                                        }
                                    },
                                ),
                            )
                        ],
                    ),
                ),
            ),
        );
    }

    Future<String?> _asyncSimpleDialog(BuildContext context) async {
        return await showDialog<String>(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
                return SimpleDialog(
                    title: const Text('Select Payment Method',
                        style: TextStyle(color: appcolor)),
                    children: <Widget>[
                        SimpleDialogOption(
                            onPressed: () {
                                Navigator.pop(context);
                                String paypalurl = PAYPAL_URL +
                                    "amount=" +
                                    selectedoneononeevent!.entryamount! +
                                    "&title=" +
                                    selectedoneononeevent!.title!.replaceAll(" ", "") +
                                    "&id=" +
                                    selectedoneononeevent!.id!;
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PaypalWebviewActivity(
                                        paypalurl, Constant.lbloneononeevent,'','',null,null,"",null)));
                            },
                            child: Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5),
                                child: const Text(
                                    '1. Paypal',
                                    style: TextStyle(color: primary),
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
                                // CardPayment();
                            },
                            child: Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5),
                                child: const Text(
                                    '2. Card Payment',
                                    style: TextStyle(color: primary),
                                ),
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
                                                child: PhoneNumberialog(),
                                            );
                                        });
                                }
                            },
                            child: Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5),
                                child: const Text(
                                    '3. Mpesa',
                                    style: TextStyle(color: primary),
                                ),
                            ),
                        ),
                    ],
                );
            });
    }

    Widget PhoneNumberialog() {
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
                                            Navigator.of(context).pop();
                                            // MPesaPayment(phno);
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



    Future CheckEligibility() async {
        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(StringRes.checknetwork), backgroundColor: appcolor));
        } else {
            setState(() {
                isloading = true;
            });

            Map<String, String> body = {
                ELIGIBLE_FOR_ONEONONEEVENT: "1",
                userId: uuserid!,
                EVENT_ID: selectedoneononeevent!.id!,
            };

            var response = await Constant.getApiData(body);

            final res = json.decode(response);
            isloading = false;

            String error = res['error'];

            if (error == "false") {
                bool ispaid = res[IS_PAID].toString().toLowerCase() == "true"
                    ? true
                    : false ?? false;
                if (ispaid) {
                    /*if (mounted) {
            new Future.delayed(Duration.zero, () {
              Navigator.push(context, PageRouteBuilder(pageBuilder: (context, anim1, anim2) => PlayActivity(cls: Constant.lbloneononeevent),));
            });
          }*/
                    FindMatch();
                } else {
                    //CardPayment(event.id, event.amount,event);
                    GoToPayPage();
                }
            } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(res['message']), backgroundColor: appcolor));
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
                        GoToPayPage();
                    }
                }
            }
            setState(() {});
            //}
        }
    }

    void GoToPayPage() {
        //print("===count-**-${event.count}");
        if (int.parse(selectedoneononeevent!.entryamount!) <= 0) {
            //SetTransactionData(selectedoneononeevent,"${uuserid}_${selectedoneononeevent.id}","Free(0 amount)");
            FindMatch();
        } else {
            //CardPayment();
            _asyncSimpleDialog(context);
        }
    }

    Future SetTransactionData(
        OneOnOneModel event, String transid, String paytype) async {
        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
        } else {
            setState(() {
                isloading = true;
            });

            Map<String, String> body = {
                SET_USER_PAID_ONEONONE_EVENT: "1",
                userId: uuserid!,
                EVENT_ID: selectedoneononeevent!.id!,
                TRANSACTION_ID: transid,
                AMOUNT: selectedoneononeevent!.entryamount!,
                TYPE: paytype,
                IS_ADD: "true"
            };

            var responseapi = await Constant.getApiData(body);
            final res = json.decode(responseapi);

            String error = res['error'];
            isloading = false;

            setState(() {});

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));

            if (error == 'false') {
                FindMatch();
            }


        }
    }

    void FindMatch() {

        setState(() {
            btntext = "Rematch";
        });

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CustomDialog(),
        );
    }

    @override
    void dispose() {
        super.dispose();

        FirebaseDatabase.instance
            .ref()
            .child('event')
            .child(selectedoneononeevent!.id!)
            .child(uuserid!)
            .once()
            .then((dynamic snapshot) {
     
            if (snapshot.value != null) {
                FirebaseDatabase.instance
                    .ref()
                    .child('event')
                    .child(selectedoneononeevent!.id!)
                    .child(uuserid!)
                    .remove();
            }
        });
        if (battleuser != null && battleuser!.user_id != null) {
            FirebaseDatabase.instance
                .reference()
                .child('event')
                .child(selectedoneononeevent!.id!)
                .child(battleuser!.user_id!)
                .once()
                .then((dynamic snapshot) {
                print("====oppdata--${snapshot.value.toString()}");
                if (snapshot.value != null) {
                    FirebaseDatabase.instance
                        .ref()
                        .child('event')
                        .child(selectedoneononeevent!.id!)
                        .child(battleuser!.user_id!)
                        .remove();
                }
            });
        }

    }

    Future<void> playRobot() async {

        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(StringRes.checknetwork), backgroundColor: appcolor));
        } else {
            currenteventdata = selectedoneononeevent;
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        RobotPlayActivity(),
                ));

        }



    }



}

class CustomDialog extends StatefulWidget {
    String? title, description, buttonText;
    Image? image;



    @override
    CustomDialogState createState() => new CustomDialogState();
}

class CustomDialogState extends State<CustomDialog>
    with WidgetsBindingObserver {
    String title = "Finding Match", description = "", buttonText = "Cancel";
    Image? image;
    int matchsecond = Constant.FindMatchSecond;
    Timer? clocktimer;
    String remainingtime = "", playbtninfo = "";
    bool isloading = true,
        ismatchfound = false,
        isplaypress = false,
        otheruserpressplay = false,
        ipressplay = false;
    List<UserModel> userlist = [];
   // StreamSubscription<Event>? _onNoteAddedSubscription;
    StreamSubscription? _onNoteAddedSubscription;
    StreamSubscription? _onNoteUpdateSubscription;
    StreamSubscription? _onNoteRemoveSubscription;
    StreamSubscription? _onNoteOtherUserSubscription;
    StreamSubscription? _onNoteOtherUserUpdateSubscription;
    double itemSize = 0;
    double opacity = 1;
    UserModel? matchuser;
    Timer? playclocktimer;

    int playcountdown = 3;
    Duration animationDuration = Duration(seconds: 3);

    final userEventReference = FirebaseDatabase.instance
        .ref()
        .child('event')
        .child(selectedoneononeevent!.id!);
    final userLiveEventReference = FirebaseDatabase.instance
        .ref()
        .child('livegame')
        .child(selectedoneononeevent!.id!);



    void _onNoteAdded(dynamic event) {
      
        setState(() {
            userlist.add(new UserModel.fromMatchJson(event.snapshot));
        });
        GetOtherUsers();
    }

    void _onNoteRemoved(dynamic event) {
        print("====dataremove");
        //print("====data===${event.snapshot.toString()}");
        setState(() {
            userlist.remove(UserModel.fromMatchJson(event.snapshot));
        });
        GetOtherUsers();
    }

    void _onNoteUpdate(dynamic event) {
    
        var oldNoteValue =
        userlist.singleWhere((note) => note.user_id == event.snapshot.key);
        setState(() {
            userlist[userlist.indexOf(oldNoteValue)] =
            new UserModel.fromMatchJson(event.snapshot);
        });
        GetOtherUsers();
    }

    void _onMatchUserChanged(dynamic event) {
     

        if (event.snapshot.key == "matchwith") {
            String othermatchwith = event.snapshot.value;
            if (othermatchwith != uuserid) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(StringRes.matchuserleft),
                        backgroundColor: appcolor,
                    ),
                );
                matchuser = null;
                FinishDialog(true);
            }
        }

        if (event.snapshot.key == "isplaypress" &&
            (event.snapshot.value.toString() == "true" ||
                event.snapshot.value.toString() == "false")) {
            bool bvalue = event.snapshot.value as bool;
          
            if (bvalue) {
                setState(() {
                    //battleuser = new User.fromMatchJson(event.snapshot);
                    battleuser!.isplaypress = true;
                    matchuser!.isplaypress = true;
                    //if (matchuser.isplaypress) {
                    otheruserpressplay = true;
                    print("====dataupdate-match-otheruser---$otheruserpressplay--$ipressplay");

                    if (otheruserpressplay && ipressplay) {
                        PlayBtnCode();
                    } else {
                        setState(() {
                            playbtninfo =
                            "Press Play Button for Battle\n${Constant.setFirstLetterUppercase(matchuser!.name!)} is Ready to Play";
                        });
                    }
                    //}
                });
            }
        }
    }

    void _onMatchUserRemoved(dynamic event) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(StringRes.matchuserleft),
                backgroundColor: appcolor,
            ),
        );
        FinishDialog(true);
    }

    @override
    void initState() {
        super.initState();
        matchid = "";
        userlist = [];
        eventbattleusermatchid = "";
        eventmymatchid = "";
        eventmymatchid =
            uuserid! + "_" + DateTime.now().millisecondsSinceEpoch.toString();
        StartCancelSubscription(false);


        userEventReference.child(uuserid!).set({
            "name": uname,
            "email": uemail,
            "profile": uprofile,
            "user_id": uuserid,
            "type": utype,
            "status": "0",
            "matchwith": "0",
            "isplaypress": false,
            "matchid": eventmymatchid,
        });



        databaseReference!
            .child('event')
            .child(selectedoneononeevent!.id!)
            .orderByChild('status')
            .equalTo("0")
            .limitToFirst(1)
            .once()
            .then((dynamic snapshot) {
            //databaseReference.child('event').child(selectedoneononeevent.id).once().then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
                Map<dynamic, dynamic> values = snapshot.value;
         
                values.forEach((key, values) {
                    userlist.add(UserModel
                        .fromMatchJsonTest(values));
                });
                if (this.mounted) {
                    setState(() {});
                }
                print("====datafirstget");
                GetOtherUsers();
            }
        });

        if (clocktimer != null) clocktimer!.cancel();
        clocktimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    }

    void GetOtherUsers() {
        //print("====${userlist.length}====");
        if (_onNoteOtherUserSubscription != null)
            _onNoteOtherUserSubscription!.cancel();
        if (_onNoteOtherUserUpdateSubscription != null)
            _onNoteOtherUserUpdateSubscription!.cancel();

        isplayscreenforque = false;

        if (userlist.length != 0) {
            for (UserModel user in userlist) {
           
                if (user.user_id != uuserid &&
                    user.status == "0" &&
                    user.matchwith == "0") {

                    StartCancelSubscription(true);

                    userEventReference.child(uuserid!).set({
                        "name": uname,
                        "email": uemail,
                        "profile": uprofile,
                        "user_id": uuserid,
                        "type": utype,
                        "status": "1",
                        "matchwith": user.user_id,
                        "isplaypress": false,
                        "matchid": eventmymatchid,
                    });

                    _onNoteOtherUserSubscription = userEventReference
                        .child(user.user_id!)
                        .onChildRemoved
                        .listen(_onMatchUserRemoved);

                    _onNoteOtherUserUpdateSubscription = userEventReference
                        .child(user.user_id!)
                        .onChildChanged
                        .listen(_onMatchUserChanged);


                    if (clocktimer != null) clocktimer!.cancel();
                    matchuser = user;
                    battleuser = user;
                    String otheruserid = battleuser!.user_id!;

                    eventbattleusermatchid = battleuser!.matchid!;
                    print("==matchids==$eventmymatchid===${battleuser!.matchid}");

                    //if (uuserid.hashCode <= otheruserid.hashCode) {
                    if (int.parse(uuserid!) <= int.parse(otheruserid)) {
                        //matchid = '${selectedoneononeevent.id}-$uuserid-$otheruserid';
                        matchid =
                        '${selectedoneononeevent!.id}_${eventmymatchid}_${battleuser!.matchid}';
                    } else {
                        //matchid = '${selectedoneononeevent.id}-$otheruserid-$uuserid';
                        matchid =
                        '${selectedoneononeevent!.id}_${battleuser!.matchid}_$eventmymatchid';
                    }
           
                    getQuestionsFromJson();

                    if (this.mounted) {
                        setState(() {
                            ismatchfound = true;
                            isloading = false;
                            title = "Match Found";
                            playbtninfo = "Press Play Button for Battle";
                            remainingtime =
                            "Match Found with ${Constant.setFirstLetterUppercase(user.name!)}";
                        });
                    }

                    break;
                }


            }
        }
    }

    void StartCancelSubscription(bool iscancel) {
        if (iscancel) {
            if (_onNoteAddedSubscription != null) _onNoteAddedSubscription!.cancel();
            if (_onNoteRemoveSubscription != null) _onNoteRemoveSubscription!.cancel();
            if (_onNoteUpdateSubscription != null) _onNoteUpdateSubscription!.cancel();
            if (_onNoteOtherUserSubscription != null)
                _onNoteOtherUserSubscription!.cancel();
            if (_onNoteOtherUserUpdateSubscription != null)
                _onNoteOtherUserUpdateSubscription!.cancel();
        } else {
            _onNoteAddedSubscription =
                userEventReference.onChildAdded.listen(_onNoteAdded);
            _onNoteRemoveSubscription =
                userEventReference.onChildRemoved.listen(_onNoteRemoved);
            _onNoteUpdateSubscription =
                userEventReference.onChildChanged.listen(_onNoteUpdate);
        }
    }

    void _getTime() {
        matchsecond = matchsecond - 1;
        String remain;
        if (matchsecond <= 0) {
            remain = "0";
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Match not Found, Try Again !!"),
                    backgroundColor: appcolor,
                ),
            );
            FinishDialog(true);
        }
        if (this.mounted) {
            setState(() {
                remainingtime = matchsecond.toString();
            });
        }
    }

    //@mustCallSuper
    //@protected
    @override
    void dispose() {
        super.dispose();
        WidgetsBinding.instance.removeObserver(this);
        print("====distroy");
        FinishDialog(false);
    }

    void FinishDialog(bool closdialog) {
        if (clocktimer != null) clocktimer!.cancel();
        userEventReference.child(uuserid!).remove();
        StartCancelSubscription(true);
        /*if(battlequestionList.length != 0 && battleuser != null && matchid.isNotEmpty){
      DistroyQue();
    }*/

          if (!isplayscreenforque && battlequestionList.length != 0) {
            DistroyQue();
        }

        matchid = "";
        userLiveEventReference.child(matchid!).child(uuserid!).remove();
        if (ismatchfound && matchuser != null) {
            //battleuser = null;
            userEventReference.child(matchuser!.user_id!).remove();
            userLiveEventReference.child(matchid!).child(matchuser!.user_id!).remove();
        }

        if (closdialog) Navigator.of(context).pop();
    }

    Future<void> DistroyQue() async {
        var parameter = {
            ACCESS_KEY: ACCESS_KEY_VAL,
            userId: uuserid,
            GET_QUESTION_BY_ONEONONE_EVENT: "1",
            EVENT_ID: selectedoneononeevent!.id,
            MATCH_ID: matchid,
            OPPONENT_ID: battleuser!.user_id,
            DESTROY_MATCH: "1",
        };

        var response = await Constant.getApiData(parameter);
    }

    @override
    Widget build(BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.padding),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: dialogContent(context),
        );
    }

    Widget dialogContent(BuildContext context) {
        return Stack(
            children: <Widget>[
                Details(context),
                Positioned(
                    left: Constant.padding,
                    right: Constant.padding,
                    child: CircleAvatar(
                        backgroundColor: white,
                        radius: Constant.avatarRadius,
                        child: Image.asset("assets/images/dialogicon.png"),
                    ),
                ),
            ],
        );
    }

    Widget Details(BuildContext context) {
        return Container(
            padding: EdgeInsets.only(
                top: Constant.avatarRadius + Constant.padding,
                bottom: Constant.padding,
                left: Constant.padding,
                right: Constant.padding,
            ),
            margin: EdgeInsets.only(top: Constant.avatarRadius),
            decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Constant.padding),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                    ),
                ],
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                    Text(
                        title,
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w700, color: primary),
                    ),
                    SizedBox(height: 16.0),
                    isloading
                        ? Center(
                        child: SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: Stack(
                                children: <Widget>[
                                    Center(
                                        child: Text(
                                            "$remainingtime",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: appcolor),
                                        ),
                                    ),
                                    Center(
                                        child: SizedBox(
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                new AlwaysStoppedAnimation<Color>(primary),
                                            ),
                                            height: 50.0,
                                            width: 50.0,
                                        ),
                                    )
                                ],
                            ),
                        ),
                    )
                        : isplaypress
                        ? AnimatedOpacity(
                        duration: animationDuration,
                        opacity: opacity,
                        child: AnimatedContainer(
                            duration: animationDuration,
                            width: itemSize,
                            height: itemSize,
                            decoration: new BoxDecoration(
                                color: appcolor,
                                shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                                    playcountdown.toString(),
                                    style: TextStyle(
                                        color: white, fontWeight: FontWeight.bold),
                                )),
                        ),
                    )
                        : Text(
                        "$remainingtime",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: appcolor),
                    ),
                    playbtninfo.trim().isNotEmpty
                        ? Text(playbtninfo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold, color: red))
                        : Container(),
                    SizedBox(height: 24.0),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                        FinishDialog(true);
                                    },
                                    child: Text(buttonText),
                                ),
                                ismatchfound
                                    ? ElevatedButton(
                                    onPressed: () async {
                                        userEventReference
                                            .child(battleuser!.user_id!)
                                            .once()
                                            .then((dynamic snapshot) {
                                            print("====oppdata==playpress--${snapshot.value.toString()}");
                                            if (snapshot.value == null) {
                                                //if (!otheruserexist) {
                                                 ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                        content: Text(StringRes.matchuserleft),
                                                        backgroundColor: appcolor,
                                                    ),
                                                );
                                                FinishDialog(true);
                                            } else {
                                                userEventReference
                                                    .child(uuserid!)
                                                    .update({"isplaypress": true});

                                                setState(() {
                                                    ipressplay = true;
                                                });
                                                 if (otheruserpressplay && ipressplay) {
                                                    PlayBtnCode();
                                                } else {
                                                    setState(() {
                                                        playbtninfo =
                                                        "Waiting for ${battleuser!.name} to Press Play Button";
                                                    });
                                                }
                                            }
                                        });
                                    },
                                    child: Text(StringRes.play),
                                )
                                    : Container(),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> PlayBtnCode() async {
        userEventReference
            .child(battleuser!.user_id!)
            .once()
            .then((dynamic snapshot) {
            print("====oppdata==playpress--${snapshot.value.toString()}");
            if (snapshot.value == null) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(StringRes.matchuserleft),
                        backgroundColor: appcolor,
                    ),
                );
                FinishDialog(true);
            } else if (battlequestionList.length < Constant.MAX_QUE_PER_LEVEL) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(StringRes.notenoughque),
                        backgroundColor: appcolor,
                    ),
                );
                FinishDialog(true);
            } else {
                setState(() {
                    isplaypress = true;
                    playbtninfo = "";
                    playcountdown = 3;
                });

                Timer(Duration(milliseconds: 1), () {
                    setState(() {
                        itemSize = 90;
                        opacity = 0;
                    });
                });

                if (playclocktimer != null) playclocktimer!.cancel();

                userLiveEventReference.child(matchid!).child(uuserid!).set({
                    "name": uname,
                    "email": uemail,
                    "profile": uprofile,
                    "user_id": uuserid,
                    "type": utype,
                    "status": "1",
                    "matchwith": battleuser!.user_id,
                    "matchid": matchid,
                });

                userLiveEventReference
                    .child(matchid!)
                    .child(uuserid!)
                    .child("answer")
                    .set({
                    "totaltime": "0",
                    "currquetime": "0",
                    "incorrectans": "0",
                    "correctans": "0",
                    "curr_selected_option": "0",
                    "selectans": false,
                    "queindex": 0
                });

                playclocktimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
                    if (this.mounted) {
                        setState(() {
                            playcountdown--;
                        });
                    }
                    if (playcountdown == 0) {
                        if (playclocktimer != null) playclocktimer!.cancel();
                        currenteventdata = selectedoneononeevent;

                        StartCancelSubscription(true);

                        Timer(Duration(seconds: 1), () {
                            userEventReference.child(uuserid!).remove();
                            userEventReference.child(battleuser!.user_id!).remove();
                        });

                        battleuser!.matchid = matchid;



                        if (this.mounted) {
                            setState(() {
                                isplayscreenforque = true;
                            });
                        }

                        new Future.delayed(Duration.zero, () {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, anim1, anim2) =>
                                        BattleGamePlayActivity(cls: Constant.lbloneononeevent),
                                ));
                        });
                    }
                });
            }
        });

    }

    Future<void> getQuestionsFromJson() async {
        //MainEvent,GroupEvent
        var parameter = {
            userId: uuserid,
            GET_QUESTION_BY_ONEONONE_EVENT: "1",
            EVENT_ID: selectedoneononeevent!.id,
            MATCH_ID: matchid,
            OPPONENT_ID: battleuser!.user_id,
        };

        battlequestionList = [];

        var response = await Constant.getApiData(parameter);

        var getdata = json.decode(response);

        String error = getdata["error"];

        if (error == ("false")) {
            var data = getdata["data"];

            battlequestionList =
                (data as List).map((data) => new Question.fromJson(data)).toList();


        } else {

        }
    }
}



class BattleDialog extends StatefulWidget {
    String? title, description, buttonText;
    Image? image;



    @override
    BattleDialogState createState() => new BattleDialogState();
}

class BattleDialogState extends State<BattleDialog>
    with WidgetsBindingObserver {
    String title = "Finding Match", description = "", buttonText = "Cancel";
    Image? image;
    int matchsecond = Constant.FindMatchSecond;
    Timer? clocktimer;
    String remainingtime = "", playbtninfo = "";
    bool isloading = true,
        ismatchfound = false,
        isplaypress = false,
        otheruserpressplay = false,
        ipressplay = false;
    List<UserModel> userlist = [];
    //StreamSubscription<Event> _onNoteAddedSubscription;
    StreamSubscription? _onNoteUpdateSubscription;
    StreamSubscription? _onNoteRemoveSubscription;
    // StreamSubscription<Event> _onNoteOtherUserSubscription;
    //StreamSubscription<Event> _onNoteOtherUserUpdateSubscription;
    double itemSize = 0;
    double opacity = 1;
    UserModel? matchuser;
    Timer? playclocktimer;

    int playcountdown = 3;
    Duration animationDuration = Duration(seconds: 3);

    final userEventReference = FirebaseDatabase.instance
        .ref()
        .child('event')
        .child(selectedoneononeevent!.id!);
    final userLiveEventReference = FirebaseDatabase.instance
        .ref()
        .child('livegame')
        .child(selectedoneononeevent!.id!);



    void _onNoteAdded(dynamic event) {
      
        setState(() {
            userlist.add(new UserModel.fromMatchJson(event.snapshot));
        });
        GetOtherUsers();
    }

    void _onNoteRemoved(dynamic event) {
        print("====dataremove");
        //print("====data===${event.snapshot.toString()}");
        setState(() {
            userlist.remove(UserModel.fromMatchJson(event.snapshot));
        });
        GetOtherUsers();
    }

    void _onNoteUpdate(dynamic event) {
      
        var oldNoteValue =
        userlist.singleWhere((note) => note.user_id == event.snapshot.key);
        setState(() {
            userlist[userlist.indexOf(oldNoteValue)] =
            new UserModel.fromMatchJson(event.snapshot);
        });
        GetOtherUsers();
    }

    void _onMatchUserChanged(dynamic event) {
        print("====dataupdate--match--${event.snapshot.value}");
        print("====dataupdate--match--change--${event.snapshot.key}");
        //bool value = event.snapshot.value('isplaypress');

        if (event.snapshot.key == "matchwith") {
            String othermatchwith = event.snapshot.value;
            if (othermatchwith != uuserid) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(StringRes.matchuserleft),
                        backgroundColor: appcolor,
                    ),
                );
                matchuser = null;
                FinishDialog(true);
            }
        }

        if (event.snapshot.key == "isplaypress" &&
            (event.snapshot.value.toString() == "true" ||
                event.snapshot.value.toString() == "false")) {
            bool bvalue = event.snapshot.value as bool;
          
            if (bvalue) {
                setState(() {
                    //battleuser = new User.fromMatchJson(event.snapshot);
                    battleuser!.isplaypress = true;
                    matchuser!.isplaypress = true;
                    //if (matchuser.isplaypress) {
                    otheruserpressplay = true;
                    print("====dataupdate-match-otheruser---$otheruserpressplay--$ipressplay");

                    if (otheruserpressplay && ipressplay) {
                        PlayBtnCode();
                    } else {
                        setState(() {
                            playbtninfo =
                            "Press Play Button for Battle\n${Constant.setFirstLetterUppercase(matchuser!.name!)} is Ready to Play";
                        });
                    }
                    //}
                });
            }
        }
    }

    void _onMatchUserRemoved(dynamic event) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(StringRes.matchuserleft),
                backgroundColor: appcolor,
            ),
        );
        FinishDialog(true);
    }

    @override
    void initState() {
        super.initState();
        matchid = "";
        userlist = [];
        eventbattleusermatchid = "";
        eventmymatchid = "";
        eventmymatchid =
            uuserid! + "_" + DateTime.now().millisecondsSinceEpoch.toString();
        StartCancelSubscription(false);


        userEventReference.child(uuserid!).set({
            "name": uname,
            "email": uemail,
            "profile": uprofile,
            "user_id": uuserid,
            "type": utype,
            "status": "0",
            "matchwith": "0",
            "isplaypress": false,
            "matchid": eventmymatchid,
        });



        databaseReference!
            .child('event')
            .child(selectedoneononeevent!.id!)
            .orderByChild('status')
            .equalTo("0")
            .limitToFirst(1)
            .once()
            .then((dynamic snapshot) {
            //databaseReference.child('event').child(selectedoneononeevent.id).once().then((DataSnapshot snapshot) {
            if (snapshot.value != null) {
                Map<dynamic, dynamic> values = snapshot.value;
            
                values.forEach((key, values) {
                    userlist.add(UserModel.fromMatchJsonTest(values));
                });
                if (this.mounted) {
                    setState(() {});
                }
                print("====datafirstget");
                GetOtherUsers();
            }
        });

        //  if (clocktimer != null) clocktimer.cancel();
        //  clocktimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    }

    void GetOtherUsers() {


        isplayscreenforque = false;

        if (userlist.length != 0) {
            for (UserModel user in userlist) {
         
                if (user.user_id != uuserid &&
                    user.status == "0" &&
                    user.matchwith == "0") {

                    StartCancelSubscription(true);

                    userEventReference.child(uuserid!).set({
                        "name": "Robot",
                        "email": "",
                        "profile": "",
                        "user_id": uuserid,
                        "type": "",
                        "status": "1",
                        "matchwith": user.user_id,
                        "isplaypress": true,
                        "matchid": eventmymatchid,
                    });


                    if (clocktimer != null) clocktimer!.cancel();
                    matchuser = user;
                    battleuser = user;
                    String otheruserid = battleuser!.user_id!;

                    eventbattleusermatchid = battleuser!.matchid!;
                    print("==matchids==$eventmymatchid===${battleuser!.matchid!}");

                    //if (uuserid.hashCode <= otheruserid.hashCode) {
                    if (int.parse(uuserid!) <= int.parse(otheruserid)) {
                        //matchid = '${selectedoneononeevent.id}-$uuserid-$otheruserid';
                        matchid =
                        '${selectedoneononeevent!.id}_${eventmymatchid}_${battleuser!.matchid}';
                    } else {
                        //matchid = '${selectedoneononeevent.id}-$otheruserid-$uuserid';
                        matchid =
                        '${selectedoneononeevent!.id}_${battleuser!.matchid}_$eventmymatchid';
                    }
            

                    getQuestionsFromJson();

                    if (this.mounted) {
                        setState(() {
                            ismatchfound = true;
                            isloading = false;
                            title = "Match Found";
                            playbtninfo = "Press Play Button for Battle";
                            remainingtime =
                            "Match Found with ${Constant.setFirstLetterUppercase(user.name!)}";
                        });
                    }

                    break;
                }


            }
        }
    }

    void StartCancelSubscription(bool iscancel) {
        if (iscancel) {
            // if (_onNoteAddedSubscription != null) _onNoteAddedSubscription.cancel();
            if (_onNoteRemoveSubscription != null) _onNoteRemoveSubscription!.cancel();
            if (_onNoteUpdateSubscription != null) _onNoteUpdateSubscription!.cancel();

        } else {
            //_onNoteAddedSubscription = userEventReference.onChildAdded.listen(_onNoteAdded);
            _onNoteRemoveSubscription =
                userEventReference.onChildRemoved.listen(_onNoteRemoved);
            _onNoteUpdateSubscription =
                userEventReference.onChildChanged.listen(_onNoteUpdate);
        }
    }

    void _getTime() {
        matchsecond = matchsecond - 1;
        String remain;
        if (matchsecond <= 0) {
            remain = "0";
             ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text("Match not Found, Try Again !!"),
                    backgroundColor: appcolor,
                ),
            );
            FinishDialog(true);
        }
        if (this.mounted) {
            setState(() {
                remainingtime = matchsecond.toString();
            });
        }
    }

    //@mustCallSuper
    //@protected
    @override
    void dispose() {
        super.dispose();
        WidgetsBinding.instance.removeObserver(this);
        print("====distroy");
        FinishDialog(false);
    }

    void FinishDialog(bool closdialog) {
        if (clocktimer != null) clocktimer!.cancel();
        userEventReference.child(uuserid!).remove();
        StartCancelSubscription(true);

        if (!isplayscreenforque && battlequestionList.length != 0) {
            DistroyQue();
        }

        matchid = "";
        userLiveEventReference.child(matchid!).child(uuserid!).remove();
        if (ismatchfound && matchuser != null) {
            //battleuser = null;
            userEventReference.child(matchuser!.user_id!).remove();
            userLiveEventReference.child(matchid!).child(matchuser!.user_id!).remove();
        }

        if (closdialog) Navigator.of(context).pop();
    }

    Future<void> DistroyQue() async {
        var parameter = {
            ACCESS_KEY: ACCESS_KEY_VAL,
            userId: uuserid,
            GET_QUESTION_BY_ONEONONE_EVENT: "1",
            EVENT_ID: selectedoneononeevent!.id!,
            MATCH_ID: matchid,
            OPPONENT_ID: battleuser!.user_id!,
            DESTROY_MATCH: "1",
        };

        var response = await Constant.getApiData(parameter);
    }

    @override
    Widget build(BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constant.padding),
            ),
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            child: dialogContent(context),
        );
    }

    Widget dialogContent(BuildContext context) {
        return Stack(
            children: <Widget>[
                Details(context),
                Positioned(
                    left: Constant.padding,
                    right: Constant.padding,
                    child: CircleAvatar(
                        backgroundColor: white,
                        radius: Constant.avatarRadius,
                        child: Image.asset("assets/images/dialogicon.png"),
                    ),
                ),
            ],
        );
    }

    Widget Details(BuildContext context) {
        return Container(
            padding: EdgeInsets.only(
                top: Constant.avatarRadius + Constant.padding,
                bottom: Constant.padding,
                left: Constant.padding,
                right: Constant.padding,
            ),
            margin: EdgeInsets.only(top: Constant.avatarRadius),
            decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(Constant.padding),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: const Offset(0.0, 10.0),
                    ),
                ],
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min, // To make the card compact
                children: <Widget>[
                    Text(
                        title,
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w700, color: primary),
                    ),
                    SizedBox(height: 16.0),
                    isloading
                        ? Center(
                        child: SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: Stack(
                                children: <Widget>[
                                    Center(
                                        child: Text(
                                            "$remainingtime",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: appcolor),
                                        ),
                                    ),
                                    Center(
                                        child: SizedBox(
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                new AlwaysStoppedAnimation<Color>(primary),
                                            ),
                                            height: 50.0,
                                            width: 50.0,
                                        ),
                                    )
                                ],
                            ),
                        ),
                    )
                        : isplaypress
                        ? AnimatedOpacity(
                        duration: animationDuration,
                        opacity: opacity,
                        child: AnimatedContainer(
                            duration: animationDuration,
                            width: itemSize,
                            height: itemSize,
                            decoration: new BoxDecoration(
                                color: appcolor,
                                shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Text(
                                    playcountdown.toString(),
                                    style: TextStyle(
                                        color: white, fontWeight: FontWeight.bold),
                                )),
                        ),
                    )
                        : Text(
                        "$remainingtime",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: appcolor),
                    ),
                    playbtninfo.trim().isNotEmpty
                        ? Text(playbtninfo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold, color: red))
                        : Container(),
                    SizedBox(height: 24.0),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                        FinishDialog(true);
                                    },
                                    child: Text(buttonText),
                                ),
                                ismatchfound
                                    ? ElevatedButton(
                                    onPressed: () async {

                                        userEventReference
                                            .child(battleuser!.user_id!)
                                            .once()
                                            .then((dynamic snapshot) {
                                      
                                            if (snapshot.value == null) {
                                                //if (!otheruserexist) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                        content: Text(StringRes.matchuserleft),
                                                        backgroundColor: appcolor,
                                                    ),
                                                );
                                                FinishDialog(true);
                                            } else {
                                                userEventReference
                                                    .child(uuserid!)
                                                    .update({"isplaypress": true});

                                                setState(() {
                                                    ipressplay = true;
                                                });
                                                print(
                                                    "====dataupdate-match-iuser---$otheruserpressplay--$ipressplay");
                                                if (otheruserpressplay && ipressplay) {
                                                    PlayBtnCode();
                                                } else {
                                                    setState(() {
                                                        playbtninfo =
                                                        "Waiting for ${battleuser!.name} to Press Play Button";
                                                    });
                                                }
                                            }
                                        });
                                    },
                                    child: Text(StringRes.play),
                                )
                                    : Container(),
                            ],
                        ),
                    ),
                ],
            ),
        );
    }

    Future<void> PlayBtnCode() async {
        userEventReference
            .child(battleuser!.user_id!)
            .once()
            .then((dynamic snapshot) {
          
            if (snapshot.value == null) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(StringRes.matchuserleft),
                        backgroundColor: appcolor,
                    ),
                );
                FinishDialog(true);
            } else if (battlequestionList.length < Constant.MAX_QUE_PER_LEVEL) {
                 ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(StringRes.notenoughque),
                        backgroundColor: appcolor,
                    ),
                );
                FinishDialog(true);
            } else {
                setState(() {
                    isplaypress = true;
                    playbtninfo = "";
                    playcountdown = 3;
                });

                Timer(Duration(milliseconds: 1), () {
                    setState(() {
                        itemSize = 90;
                        opacity = 0;
                    });
                });

                if (playclocktimer != null) playclocktimer!.cancel();

                userLiveEventReference.child(matchid!).child(uuserid!).set({
                    "name": uname,
                    "email": uemail,
                    "profile": uprofile,
                    "user_id": uuserid,
                    "type": utype,
                    "status": "1",
                    "matchwith": battleuser!.user_id!,
                    "matchid": matchid,
                });

                userLiveEventReference
                    .child(matchid!)
                    .child(uuserid!)
                    .child("answer")
                    .set({
                    "totaltime": "0",
                    "currquetime": "0",
                    "incorrectans": "0",
                    "correctans": "0",
                    "curr_selected_option": "0",
                    "selectans": false,
                    "queindex": 0
                });

                playclocktimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
                    if (this.mounted) {
                        setState(() {
                            playcountdown--;
                        });
                    }
                    if (playcountdown == 0) {
                        if (playclocktimer != null) playclocktimer!.cancel();
                        currenteventdata = selectedoneononeevent;

                        StartCancelSubscription(true);

                        Timer(Duration(seconds: 1), () {
                            userEventReference.child(uuserid!).remove();
                            userEventReference.child(battleuser!.user_id!).remove();
                        });

                        battleuser!.matchid = matchid;



                        if (this.mounted) {
                            setState(() {
                                isplayscreenforque = true;
                            });
                        }

                        new Future.delayed(Duration.zero, () {
                            Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (context, anim1, anim2) =>
                                        BattleGamePlayActivity(cls: Constant.lbloneononeevent),
                                ));
                        });
                    }
                });
            }
        });

    }

    Future<void> getQuestionsFromJson() async {
        //MainEvent,GroupEvent
        var parameter = {
            userId: uuserid,
            GET_QUESTION_BY_ONEONONE_EVENT: "1",
            EVENT_ID: selectedoneononeevent!.id,
            MATCH_ID: matchid,
            OPPONENT_ID: battleuser!.user_id,
        };

        battlequestionList = [];

        var response = await Constant.getApiData(parameter);
        debugPrint('param***question${response.toString()}');
        //debugPrint('responce***question${response.body.toString()}');

        var getdata = json.decode(response);

        String error = getdata["error"];

        if (error == ("false")) {
            var data = getdata["data"];


            battlequestionList =
                (data as List).map((data) => new Question.fromJson(data)).toList();



            PlayBtnCode();


        } else {

        }
    }
}