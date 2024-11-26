import 'dart:async';
import 'dart:convert';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

import 'package:photo_view/photo_view.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:smartapp/Helper/DesignConfig.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/Question.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/OneOnOneEvent/BattleResultActivity.dart';

import 'OneOnOneEventDetailActivity.dart';

List<Question> battlequestionList = [];
bool eMode = false;

UserModel? battleuser;
String? matchid = "";
bool issetqueonfirebase = false;
String? battleuser_rightans = "0",
    battleuser_wrongans = "0",
    battleuser_totaltime = "0",
    battleuser_currtime = "0",
    battleuser_curr_selectoption = "";
int totalplaytime = 0, currquetime = 0, battleuser_queindex = 0;
int correctQuestion = 0, inCorrectQuestion = 0;
String winningtextforresult = "";
bool isplayscreenforque = false;

class BattleGamePlayActivity extends StatefulWidget {
    String? cls;

    BattleGamePlayActivity({this.cls});

    @override
    State<StatefulWidget> createState() {
        return BattleGamePlayActivityState(this.cls);
    }
}

class BattleGamePlayActivityState extends State<BattleGamePlayActivity>
    with SingleTickerProviderStateMixin {
    AssetsAudioPlayer? _assetsBackgorundPlayer, _assetsTimerPlayer;

    Question? question;
    int queIndex = 0;
    String? curQue,
        curnote,
        optionA,
        optionB,
        optionC,
        optionD,
        optionE,
        rightAns,
        rightoption,
        userSelected,
        userselectedoption;
    bool loading = true, errorExist = false;

    int score = 0;
    bool _isTap = true, isCheckAns = false;
    AnimationController? _animationController;

    //int levelNo = 1;
    int _curTime = Constant.TIME_PER_QUESTION;
    bool optEVisible = false;

    //bool isBook = false;
    List<String> options = [];
    int btnPosition = 0;
    int? aPer, bPer, cPer, dPer, ePer;
    List<String>? visibilityOption;
    int oldtime = 0;

    bool _isFifty = false, _isAudience = false;

    String? from, title = "";

    //MainEvent,GroupEvent
    Timer? clocktimer, totalTimer;
    String? remainingtime = "";
    int leftmillisecond = Constant.TIME_PER_QUESTION;

    BattleGamePlayActivityState(this.from);

    DatabaseReference? userLiveEventReference;
    String? oppuserid, oppusername, oppusermatchid;
    StreamSubscription? _onNoteRemoveSubscription;
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    bool isoptclicknotevisible = false, levelfinishwaitother = false;
    int mycurrquetime = 0;
    bool isoppo_selectans = false, isi_selectans = false;

    @override
    void initState() {
        super.initState();
        //secureScreen();
        Constant.assetsBackgorundPlayer = null;
        Constant.assetsTimerPlayer = null;

        visibilityOption = [];

        battleuser_rightans = "0";
        battleuser_wrongans = "0";
        battleuser_totaltime = "0";
        battleuser_currtime = "0";
        battleuser_curr_selectoption = "";
        totalplaytime = 0;
        currquetime = 0;
        battleuser_queindex = 0;
        correctQuestion = 0;
        inCorrectQuestion = 0;
        queIndex = 0;
        winningtextforresult = "";

        Constant.SetRightWrongSound();

        oppuserid = battleuser!.user_id;
        oppusername = battleuser!.name;
        oppusermatchid = battleuser!.matchid;

        if (matchid == null || matchid!.trim().isEmpty) {
            matchid = GetMatchId();
        }

        title = currenteventdata!.title;

        if (this.mounted) {
            setState(() {});
        }

        SetInitData();
    }



    Future<void> SetInitData() async {
        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));

            FinishPage(false);
            Timer(Duration(milliseconds: 100), () {
                Navigator.of(context).pop();
            });
        } else {
            userLiveEventReference = FirebaseDatabase.instance
                .ref()
                .child('livegame')
                .child(selectedoneononeevent!.id!)
                .child(matchid!);
            _onNoteRemoveSubscription = userLiveEventReference!
                .child(oppuserid!)
                .onChildRemoved
                .listen(_onMatchUserRemoved);

            Timer(Duration(milliseconds: 500), () {
                userLiveEventReference!
                    .child(oppuserid!)
                    .child("answer")
                    .once()
                    //.then((DataSnapshot snapshot) {
                    .then((dynamic snapshot) {

                    if (snapshot.value == null) {
                       ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(StringRes.matchuserleft),
                                backgroundColor: appcolor,
                            ),
                        );
                        FinishPage(true);
                        Timer(Duration(milliseconds: 100), () {
                            Navigator.of(context).pop();
                        });
                    }
                });
            });



            userLiveEventReference!
                .child(oppuserid!)
                .child("answer")
                .onChildChanged
                .listen((event) {
                DataSnapshot snapshot = event.snapshot;

                if (snapshot.key == 'currquetime')
                    battleuser_currtime = snapshot.value.toString() ?? '';
                if (snapshot.key == 'totaltime')
                    battleuser_totaltime = snapshot.value.toString() ?? '';
                if (snapshot.key == 'incorrectans')
                    battleuser_wrongans = snapshot.value.toString() ?? '';
                if (snapshot.key == 'correctans')
                    battleuser_rightans = snapshot.value.toString() ?? '';
                if (snapshot.key == 'curr_selected_option')
                    battleuser_curr_selectoption = snapshot.value.toString() ?? '';
                if (snapshot.key == 'selectans') {
                    isoppo_selectans = snapshot.value as bool ?? false;
                    //if(isoppo_selectans)
                    //CallNextQue();

                    CallNextQue();
                }
                if (snapshot.key == 'queindex') {
                    battleuser_queindex =
                    snapshot.value == null ? 0 : int.parse(snapshot.value.toString());

                       if (battleuser_queindex >= Constant.MAX_QUE_PER_LEVEL &&
                        queIndex >= Constant.MAX_QUE_PER_LEVEL) {
                         Isfinishpage(true);
                    }
                }
                //CallNextQue();

                try {
                    if (this.mounted) {
                        setState(() {});
                    }
                } on Exception catch (_) {}
            });

            getQuestionsFromJson();

            _animationController = AnimationController(
                vsync: this,
                duration: Duration(seconds: Constant.TIME_PER_QUESTION),
            );

            //Constant.PlayBGMusic(true, true,4);
        }
    }

    String GetMatchId() {
        //if (uuserid.hashCode <= oppuserid.hashCode) {
        String mainmatchid = "";
        if (int.parse(uuserid!) <= int.parse(oppuserid!)) {
            issetqueonfirebase = true;
            mainmatchid =
            '${currenteventdata!.id}_${eventmymatchid}_$eventbattleusermatchid';
            //return '${currenteventdata!.id}_${mymatchid}_${oppusermatchid}';
            //return '${currenteventdata!.id}-$uuserid-$oppuserid';
        } else {
            issetqueonfirebase = false;
            mainmatchid =
            '${currenteventdata!.id}_${eventbattleusermatchid}_$eventmymatchid';
            //return '${currenteventdata!.id}_${oppusermatchid}_${mymatchid}';
            //return '${currenteventdata!.id}-$oppuserid-$uuserid';
        }

        return mainmatchid;


    }

    @override
    Widget build(BuildContext context) {


        Duration aLongWeekend = new Duration(milliseconds: mycurrquetime);

        int sec = aLongWeekend.inSeconds;

        int milli = mycurrquetime - sec * 1000;

        return WillPopScope(
            onWillPop: onBackPress,
            child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                    // backgroundColor: appcolor,
                    flexibleSpace: Container(
                        decoration: DesignConfig.gradientbackground,
                    ),
                    title: Text(
                        title!,
                        style: TextStyle(fontFamily: 'TitleFont'),
                    ),
                    centerTitle: true,
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                                showDialog(
                                    context: context, builder: (context) => SettingDialog());
                            },
                        ),
                    ],
                ),
                body: loading
                    ? Center(
                    child: CircularProgressIndicator(
                        backgroundColor: appcolor,
                    ))
                    : (errorExist ||
                    battlequestionList.length < Constant.MAX_QUE_PER_LEVEL)
                    ? Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                        child: Text(
                            "${StringRes.notenoughque}",
                            style: TextStyle(color: appcolor),
                        ),
                    ))
                    : question == null
                    ? Container()
                    : Container(
                    child: Center(
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                    getCoins(),
                                    isoptclicknotevisible
                                        ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: Text(
                                            "Your Current Quetion time is $sec sec $milli msec, Waiting for ${Constant.setFirstLetterUppercase(oppusername!)} to Select option.",
                                            style: TextStyle(
                                                color: green,
                                                fontWeight: FontWeight.bold),
                                        ),
                                    )
                                        : Container(),
                                    levelfinishwaitother
                                        ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 5),
                                        child: Text(
                                            "Waiting for ${Constant.setFirstLetterUppercase(oppusername!)} to Complete.",
                                            style: TextStyle(
                                                color: green,
                                                fontWeight: FontWeight.bold),
                                        ),
                                    )
                                        : Container(),
                                    getQuestion(),
                                    getOption(OPTIONA, optionA!),
                                    getOption(OPTIONB, optionB!),
                                    getOption(OPTIONC, optionC!),
                                    getOption(OPTIOND, optionD!),
                                    (eMode && optEVisible)
                                        ? (getOption(OPTIONE, optionE!))
                                        : Container(
                                        height: 0,
                                    )
                                ],
                            )),
                    ),
                ),
            ),
        );
    }

    @override
    void dispose() {

        FinishPage(false);
        super.dispose();
    }

    Future<bool> onBackPress() {

        FinishPage(false);
        return Future.value(true);
    }

    void FinishPage(bool fromotheruser) {


        Constant.StopBgMusic(true, true);

        DistroyQue();
        if (clocktimer != null) clocktimer!.cancel();
        if (totalTimer != null) totalTimer!.cancel();



        if (_onNoteRemoveSubscription != null) _onNoteRemoveSubscription!.cancel();

        Timer(Duration(milliseconds: 200), () {
            userLiveEventReference!.child(uuserid!).remove();
            if (!fromotheruser) {
                userLiveEventReference!.child(oppuserid!).remove();
            }
        });

        if (_animationController != null) {
            if (!_animationController!.isDismissed) _animationController!.stop();
            _animationController!.dispose();
        }
    }

    Future<void> DistroyQue() async {
        if (matchid == null || matchid!.trim().isEmpty) {
            matchid = GetMatchId();
        }

        var parameter = {
            ACCESS_KEY: ACCESS_KEY_VAL,
            userId: uuserid,
            GET_QUESTION_BY_ONEONONE_EVENT: "1",
            EVENT_ID: currenteventdata!.id,
            MATCH_ID: matchid,
            OPPONENT_ID: battleuser!.user_id,
            DESTROY_MATCH: "1",
        };

        var response = await Constant.getApiData(parameter);
        battlequestionList.clear();
    }

    void _onMatchUserRemoved(dynamic event) {
        //userLiveEventReference.child(uuserid).remove();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(StringRes.matchuserleft),
                backgroundColor: appcolor,
            ),
        );

        FinishPage(true);
        Timer(Duration(milliseconds: 100), () {
            Navigator.of(context).pop();
        });
    }

    Future<void> SetEventScore(bool gotoresult) async {

        updateEventScore(gotoresult);
    }

    Widget getOption(String option, String optValue) {
        int per;

        if (btnPosition == 1) {
            if (option == OPTIONA)
                per = aPer!;
            else if (option == OPTIONB)
                per = bPer!;
            else if (option == OPTIONC)
                per = cPer!;
            else if (option == OPTIOND)
                per = dPer!;
            else if (option == OPTIONE) per = ePer!;
        } else if (btnPosition == 2) {
            if (option == OPTIONA)
                per = bPer!;
            else if (option == OPTIONB)
                per = aPer!;
            else if (option == OPTIONC)
                per = cPer!;
            else if (option == OPTIOND)
                per = dPer!;
            else if (option == OPTIONE) per = ePer!;
        } else if (btnPosition == 3) {
            if (option == OPTIONA)
                per = cPer!;
            else if (option == OPTIONB)
                per = bPer!;
            else if (option == OPTIONC)
                per = aPer!;
            else if (option == OPTIOND)
                per = dPer!;
            else if (option == OPTIONE) per = ePer!;
        } else if (btnPosition == 4) {
            if (option == OPTIONA)
                per = dPer!;
            else if (option == OPTIONB)
                per = bPer!;
            else if (option == OPTIONC)
                per = cPer!;
            else if (option == OPTIOND)
                per = aPer!;
            else if (option == OPTIONE) per = ePer!;
        } else if (btnPosition == 5) {
            if (option == OPTIONA)
                per = ePer!;
            else if (option == OPTIONB)
                per = bPer!;
            else if (option == OPTIONC)
                per = cPer!;
            else if (option == OPTIOND)
                per = dPer!;
            else if (option == OPTIONE) per = aPer!;
        }

        return Container(
            //decoration: DesignConfig.gradientbackground,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: AnimatedOpacity(
                duration: Duration(milliseconds: 600),
                curve: Curves.easeIn,
                opacity:
                _isFifty ? visibilityOption!.contains(option) ? 1.0 : 0.0 : 1.0,
                //opacity: _isAdded ? 0.0 : option==OPTION_A? optAVisible?1.0:0.0,
                child: Card(
                    color: primary,
                    child: Material(
                        //color:primary,
                        child: InkWell(
                            splashColor: primary,
                            child: Row(
                                children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Card(
                                            child: Container(
                                                decoration: DesignConfig.gradientbackground,
                                                child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 10, vertical: 7),
                                                    child: Text(
                                                        option,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold),
                                                    ),
                                                ),
                                            ),
                                        ),
                                    ),
                                    Expanded(
                                        child: Text(
                                            optValue,
                                            style: TextStyle(color: primary),
                                        )),

                                ],
                            ),
                            onTap: _isTap
                                ? () {
                                if (this.mounted) {
                                    setState(() {
                                        _isTap = false;
                                    });
                                }

                                setState(() {
                                    question!.userSelected = optValue;

                                    userSelected = optValue;
                                    userselectedoption = option;
                                    isCheckAns = true;

                                         handleOptionClick(optValue, option);
                                });
                            }
                                : null,
                        ),
                        //elevation: 4,
                        color: isCheckAns
                        //? rightAns == optValue
                            ? rightoption!.toLowerCase().trim() ==
                            option.toLowerCase().trim()
                            ? Colors.greenAccent
                        //: userSelected == optValue
                            : userselectedoption!.toLowerCase().trim() ==
                            option.toLowerCase().trim()
                            ? Colors.redAccent[200]
                            : Colors.white
                            : Colors.white,
                    ),
                )),
        );
    }

    getNextQuestion() async {
        isCheckAns = false;
        isi_selectans = false;
        userLiveEventReference!
            .child(uuserid!)
            .child("answer")
            .child('selectans')
            .set(false);
        userLiveEventReference!
            .child(uuserid!)
            .child("answer")
            .child('queindex')
            .set(queIndex);

        if (queIndex < Constant.MAX_QUE_PER_LEVEL) {
            question = battlequestionList[queIndex];
            question!.queindex = queIndex.toString();
            curQue = question!.question;
            curnote = question!.note ?? '';
            visibilityOption!.clear();


            _isFifty = false;
            _isAudience = false;

            if (question!.answer!.toLowerCase() == "A".toLowerCase()) {
                rightAns = question!.optiona!.trim();
            } else if (question!.answer!.toLowerCase() == "B".toLowerCase()) {
                rightAns = question!.optionb!.trim();
            } else if (question!.answer!.toLowerCase() == "C".toLowerCase()) {
                rightAns = question!.optionc!.trim();
            } else if (question!.answer!.toLowerCase() == "D".toLowerCase()) {
                rightAns = question!.optiond!.trim();
            } else if (question!.answer!.toLowerCase() == "E".toLowerCase()) {
                rightAns = question!.optione!.trim();
            }

            question!.setRightAns = rightAns!;

            options.clear();

            options.add(question!.optiona!);
            options.add(question!.optionb!);
            options.add(question!.optionc!);
            options.add(question!.optiond!);

            if (eMode) {
                if (question!.optione!.isNotEmpty || question!.optione != "")
                    options.add(question!.optione!);
            }



            rightoption = question!.answer;

            if (options.length == 4)
                optEVisible = false;
            else
                optEVisible = true;

            optionA = options[0];
            optionB = options[1];
            optionC = options[2];
            optionD = options[3];

            if (optEVisible) optionE = options[4];
        } else {
            levelCompleted();
        }
    }

    Future<void> getQuestionsFromJson() async {
        //MainEvent,GroupEvent

        if (battlequestionList.length != 0) {
            isplayscreenforque = true;
            queIndex = 0;
            totalplaytime = 0;
            currquetime = 0;
            errorExist = false;
            setState(() {
                loading = false;
            });
            startTimer(false);


        } else {

            var parameter = {
                ACCESS_KEY: ACCESS_KEY_VAL,
                userId: uuserid,
                GET_QUESTION_BY_ONEONONE_EVENT: "1",
                EVENT_ID: currenteventdata!.id,
                MATCH_ID: matchid,
                OPPONENT_ID: battleuser!.user_id,
            };



            var response = await http.post(Uri.parse(BASE_URL), body: parameter,headers: headers);


            var getdata = json.decode(response.body);

            String error = getdata["error"];

            if (error == ("false")) {
                var data = getdata["data"];

                //eMode = await getPrefrenceBool(E_MODE);

                battlequestionList =
                    (data as List).map((data) => new Question.fromJson(data)).toList();

                //getNextQuestion();

                queIndex = 0;

                if (this.mounted) {
                    setState(() {
                        loading = false;
                    });
                }
                totalplaytime = 0;
                currquetime = 0;
                startTimer(false);
            } else {
                if (this.mounted) {
                    setState(() {
                        loading = false;
                        errorExist = true;
                    });
                }
            }
        }
    }

    Widget getCoins() {
        return Card(
            child: Container(
                decoration: DesignConfig.gradientbackground,
                padding: EdgeInsets.all(5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                Text(
                                    Constant.setFirstLetterUppercase(uname!),
                                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                                ),
                                uprofile == null || uprofile!.isEmpty
                                    ? Image.asset(
                                    "assets/images/home_logo.png",
                                    width: 40,
                                    height: 40,
                                )
                                    : FadeInImage.assetNetwork(
                                    image: uprofile!,
                                    placeholder: "assets/images/home_logo.png",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                ),
                                Text(
                                    "Right - " + correctQuestion.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "Wrong - " + inCorrectQuestion.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                            ],
                        ),
                        //SizedBox(width: 40.0, height: 40.0),
                        SizedBox(width: 50.0, height: 50.0, child: getProgressTimer()),
                        Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                                Text(
                                    Constant.setFirstLetterUppercase(battleuser!.name!),
                                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                                ),
                                battleuser!.profile == null || battleuser!.profile!.isEmpty
                                    ? Image.asset(
                                    "assets/images/home_logo.png",
                                    width: 40,
                                    height: 40,
                                )
                                    : FadeInImage.assetNetwork(
                                    image: battleuser!.profile!,
                                    placeholder: "assets/images/home_logo.png",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                ),
                                Text(
                                    "Right - " + battleuser_rightans!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "Wrong - " + battleuser_wrongans!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                            ],
                        ),
                    ],
                ),
            ));
    }

    Future<void> levelCompleted() async {
        if (clocktimer != null) clocktimer!.cancel();
        if (totalTimer != null) totalTimer!.cancel();
        if (_onNoteRemoveSubscription != null) _onNoteRemoveSubscription!.cancel();


        SetEventScore(true);

        DistroyQue();

        Timer(Duration(milliseconds: 500), () {
            userLiveEventReference!.child(uuserid!).remove();
            //userLiveEventReference.child(oppuserid).remove();
        });


        if (_animationController != null) {
            _animationController!.stop();
        }
    }

    Future<void> updateScore(final String score) async {
        String? userid = await getPrefrence(USER_ID);

        var parameter = {
            ACCESS_KEY: ACCESS_KEY_VAL,
            SET_MONTH_LEADERBOARD: "1",
            USER_ID: userid,
            SCORE: score
        };



        var response = await http.post(Uri.parse(BASE_URL), body: parameter,headers: headers);

        var getdata = json.decode(response.body);

        String error = getdata["error"];

        if (error == ("false")) {
            var data = getdata["data"];
        }
    }

    Future SetTransactionData() async {
        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
        } else {
            Map<String, String> body = {
                SET_USER_PAID_ONEONONE_EVENT: "1",
                userId: uuserid!,
                EVENT_ID: currenteventdata!.id!,
                TRANSACTION_ID: "",
                AMOUNT: currenteventdata!.entryamount!,
                TYPE: "",
                IS_ADD: "false"
            };


            var responseapi = await Constant.getApiData(body);
            //print("====transaction--res---${responseapi.toString()}");
            final res = json.decode(responseapi);
        }
    }

    Future AddWinningWalletData(bool addinboth, String winneruserid) async {
        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
        } else {
            String amount = currenteventdata!.winning_amount!;
            String detail =
                "Winning Amt of Event ${currenteventdata!.title}(id-${currenteventdata!.id})";
            if (addinboth) {
                amount = (double.parse(amount) / 2).toString();
                detail =
                "Drawn Winning Amt of Event ${currenteventdata!.title}(id-${currenteventdata!.id})";
            }

            Map<String, String> body = {
                ADD_WALLET_DATA: "1",
                userId: winneruserid,
                AMOUNT: amount,
                DETAIL: detail,
            };

            var responseapi = await Constant.getApiData(body);
            final res = json.decode(responseapi);



        }
    }

    Future<void> updateEventScore(bool gotoresult) async {

        if (battleuser_rightans == '0' && correctQuestion == 0) {
            winningtextforresult = "No One Played Well !!";
        } else {
            int oppusertime = int.parse(battleuser_totaltime!);
            int oppusercorrectans = int.parse(battleuser_rightans!);

            String status;
            String winneruserid = uuserid!;
            bool bothwinner = false, faulgame = false;

            winningtextforresult = "";

            if (oppusercorrectans == correctQuestion) {
                if (oppusertime == totalplaytime) {
                    status = "Drawn";
                    bothwinner = true;
                } else if (totalplaytime < oppusertime) {
                    status = "Win";
                } else {
                    status = "Loose";
                }
            } else if (oppusercorrectans < correctQuestion) {
                status = "Win";
            } else {
                status = "Loose";
            }

            String winnername = "";
            if (status == "Loose") {
                winneruserid = oppuserid!;
                winnername = Constant.setFirstLetterUppercase(oppusername!);
            } else {
                winnername = Constant.setFirstLetterUppercase(uname!);
            }


            if (bothwinner) {
                winningtextforresult = "Congratulations, Both players Results same !";
            } else {
                if (winneruserid == uuserid)
                    winningtextforresult =
                    "Congratulations $winnername, you are Winner  !";
                else
                    winningtextforresult = "Sorry you Loose, $winnername is Winner  !";
            }


            int attemptque = correctQuestion + inCorrectQuestion;

            if (matchid == null || matchid!.trim().isEmpty) matchid = GetMatchId();


            var parameter = {
                ACCESS_KEY: ACCESS_KEY_VAL,
                userId: uuserid,
                OPPONENT_ID: oppuserid,
                EVENT_ID: currenteventdata!.id,
                TIME: totalplaytime.toString(),
                TOTAL_QUESTIONS: Constant.MAX_QUE_PER_LEVEL.toString(),
                CORRECT_ANSWERS: correctQuestion.toString(),
                INCORRECT_ANSWERS: inCorrectQuestion.toString(),
                ATTEMPT_QUESTION: attemptque.toString(),
                SCORE: correctQuestion.toString(),
                SET_ONEONONE_EVENT_SCORE: "1",
                STATUS: status,
                MATCH_ID: matchid,
            };

            var response = await http.post(Uri.parse(BASE_URL), body: parameter,headers: headers);


            var getdata = json.decode(response.body);

            String error = getdata["error"];

            if (error == ("false")) {
                var data = getdata["data"];
                SetTransactionData();
                if (bothwinner || winneruserid == uuserid) {
                    AddWinningWalletData(bothwinner, winneruserid);
                }
            }
        }

        if (gotoresult) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => BattleResultActivity()));
        }
    }

    void blankAllValue() {
        queIndex = 0;
        score = 0;
        correctQuestion = 0;
        inCorrectQuestion = 0;
    }

    Widget getQuestion() {
        return question == null
            ? Container()
            : Column(
            children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                        // rightProgress(),
                        questionLayout(),
                        // wrongProgress()
                    ],
                ),
                question!.image!.isNotEmpty
                    ? getImgQuesText()
                    : Container(
                    height: 0,
                ),
            ],
        );
    }


    void handleOptionClick(String userSelected, String optionselect) {
        if (this.mounted) {
            setState(() {
                isi_selectans = true;
            });
        }

        Constant.StopBgMusic(false, true);

        userLiveEventReference!
            .child(uuserid!)
            .child("answer")
            .child('curr_selected_option')
            .set(optionselect);
        userLiveEventReference!
            .child(uuserid!)
            .child("answer")
            .child('selectans')
            .set(true);

        totalplaytime = totalplaytime + currquetime;
        userLiveEventReference!
            .child(uuserid!)
            .child("answer")
            .child('totaltime')
            .set(totalplaytime.toString());
        userLiveEventReference!
            .child(uuserid!)
            .child("answer")
            .child('currquetime')
            .set(currquetime.toString());

        if (queIndex < battlequestionList.length) {
            //if (rightAns == userSelected) {
            if (rightoption!.toLowerCase().trim() ==
                optionselect.toLowerCase().trim()) {
                score = score + FOR_CORRECT_ANS;
                correctQuestion = correctQuestion + 1;
                Constant.PlayRightWrongSound(true);
                userLiveEventReference!
                    .child(uuserid!)
                    .child("answer")
                    .child('correctans')
                    .set(correctQuestion.toString());
            } else {
                score = score - PENALTY;
                inCorrectQuestion = inCorrectQuestion + 1;
                Constant.PlayRightWrongSound(false);
                userLiveEventReference!
                    .child(uuserid!)
                    .child("answer")
                    .child('incorrectans')
                    .set(inCorrectQuestion.toString());
            }
            TOTAL_SCORE = score;

            //if(clocktimer != null) clocktimer.cancel();
            CallNextQue();
        }
    }

    void CallNextQue() {

        if (queIndex == battleuser_queindex && isi_selectans && isoppo_selectans) {
            Timer(Duration(milliseconds: 500), () {
                queIndex++;
                startTimer(false);
            });
        } else if (isi_selectans) {
            if (this.mounted) {
                setState(() {
                    mycurrquetime = currquetime;
                    isoptclicknotevisible = true;
                });


            }
        }
    }

    Future<void> startTimer(bool istimefinish) async {
        if (clocktimer != null) clocktimer!.cancel();
        if (totalTimer != null) totalTimer!.cancel();

        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));

            FinishPage(false);
            Timer(Duration(milliseconds: 100), () {
                Navigator.of(context).pop();
            });
        } else {

            if (queIndex >= Constant.MAX_QUE_PER_LEVEL) {
                isCheckAns = false;
                isi_selectans = false;
                userLiveEventReference!
                    .child(uuserid!)
                    .child("answer")
                    .child('selectans')
                    .set(false);
                userLiveEventReference!
                    .child(uuserid!)
                    .child("answer")
                    .child('queindex')
                    .set(queIndex);

                SetTimeFinishIncorrect(istimefinish, true);

            } else {
                leftmillisecond = Constant.TIME_PER_QUESTION;

                SetTimeFinishIncorrect(istimefinish, false);


                currquetime = 0;
                mycurrquetime = 0;
                clocktimer =
                    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

                totalTimer = Timer.periodic(
                    Duration(milliseconds: 100), (Timer t) => _getPlus());

                if (this.mounted) {
                    setState(() {

                        isoptclicknotevisible = false;
                        _curTime = Constant.TIME_PER_QUESTION;
                        if (_animationController != null) {
                            _animationController!.reset();
                            _animationController!.forward();
                        }
                        //queIndex++;
                        _isTap = true;
                        Constant.PlayBGMusic(false, true, 4);
                        getNextQuestion();
                    });
                }
            }
        }
    }

    _getPlus() {

        currquetime = currquetime + 100;

    }

    void SetTimeFinishIncorrect(bool istimefinish, bool islevelcomplete) {
        if (istimefinish && !isi_selectans) {

            Constant.StopBgMusic(false, true);

            inCorrectQuestion = inCorrectQuestion + 1;
            Constant.PlayRightWrongSound(false);
            userLiveEventReference!
                .child(uuserid!)
                .child("answer")
                .child('incorrectans')
                .set(inCorrectQuestion.toString());

            //

            isi_selectans = true;
            userLiveEventReference!
                .child(uuserid!)
                .child("answer")
                .child('curr_selected_option')
                .set("0");
            userLiveEventReference!
                .child(uuserid!)
                .child("answer")
                .child('selectans')
                .set(true);

            //

            //if(!isi_selectans) {
            totalplaytime = totalplaytime + currquetime;
            userLiveEventReference!
                .child(uuserid!)
                .child("answer")
                .child('totaltime')
                .set(totalplaytime.toString());
            userLiveEventReference!
                .child(uuserid!)
                .child("answer")
                .child('currquetime')
                .set(currquetime.toString());

            Isfinishpage(islevelcomplete);
        } else {
            Isfinishpage(islevelcomplete);
        }
    }

    void Isfinishpage(bool islevelcomplete) {
        if (islevelcomplete) {
            if (queIndex >= Constant.MAX_QUE_PER_LEVEL &&
                battleuser_queindex >= Constant.MAX_QUE_PER_LEVEL) {
                Timer(Duration(seconds: 1), () {
                    levelCompleted();
                });
            } else {
                if (this.mounted) {
                    setState(() {
                        _isTap = false;
                        levelfinishwaitother = true;
                    });
                }
            }
        }
    }

    void _getTime() {
        String remain;
        leftmillisecond = leftmillisecond - 1;

        if (leftmillisecond == 0) {
            remain = "0";
        } else {
            remain = leftmillisecond.toString();
        }

        if (this.mounted) {
            setState(() {
                remainingtime = remain;
            });
        }
        if (leftmillisecond == 0) {
            queIndex++;
            startTimer(true);
        }
    }

    Widget getProgressTimer() {
        return LiquidCircularProgressIndicator(
            value: _animationController!.value,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation(primary),
            center: Text(
                //_curTime.toString(),
                remainingtime!,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                ),
            ),
        );
    }

    Widget getQuesText() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: DesignConfig.gradientbackground,
                child: Center(
                    child: SingleChildScrollView(
                        child: curnote!.trim().isEmpty
                            ? GetQueView()
                            : Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                            GetQueView(),
                            Text(
                                "Note: $curnote",
                                style: TextStyle(color: primary),
                            ),
                        ]),
                    ),
                ),
            ),
        );
    }

    Widget GetQueView() {
        return Html(
            data: "<center>" + curQue! + "</center>",
        );
    }

    Widget getImgQuesText() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                decoration: DesignConfig.gradientbackground,
                child: curnote!.trim().isEmpty
                    ? GetQueView()
                    : Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    GetQueView(),
                    Text("Note: $curnote"),
                ]),
            ),
        );
    }

    Widget questionLayout() {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0)), // set rounded corner radius
                        boxShadow: [
                            BoxShadow(
                                blurRadius: 5,
                                color: Colors.black26,
                                offset: Offset(1, 2))
                        ] // make rounded corner of border
                    ),
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 180,
                    alignment: Alignment.center,
                    child: question!.image != null &&
                        question!.image != 'null' &&
                        question!.image!.isNotEmpty
                        ? ClipRRect(
                        child: PhotoView(
                            imageProvider: new NetworkImage(question!.image!),
                            maxScale: PhotoViewComputedScale.covered * 2.0,
                            minScale: PhotoViewComputedScale.covered,
                            initialScale: PhotoViewComputedScale.covered,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    )
                        : getQuesText()),
                getQueNo()
            ]),
        );
    }

    Widget getQueNo() {
        int que = queIndex;
        ++que;
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
                que <= Constant.MAX_QUE_PER_LEVEL
                    ? que.toString()
                    : Constant.MAX_QUE_PER_LEVEL.toString(),
                style: TextStyle(color: Colors.white),
            ),
            decoration: BoxDecoration(
                color: primary.withOpacity(0.7),
                // set border width
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(10.0)), // set rounded corner radius
            ),
        );
    }
}

class SettingDialog extends StatefulWidget {
    @override
    _SettingDialogState createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
    bool bgmusic = false;
    bool timermusic = false;
    bool othersound = false;

    @override
    void initState() {
        SetValueData();
        super.initState();
    }

    Future<void> SetValueData() async {
        bgmusic = (await getPrefrenceBool(Backgroundmusic))!;
        timermusic = (await getPrefrenceBool(TimerSound))!;
        othersound = (await getPrefrenceBool(OtherSound))!;



        if (this.mounted) {
            setState(() {});
        }
    }

    @override
    Widget build(BuildContext context) {
        return SimpleDialog(
            title: Text(
                "Setting",
                style: TextStyle(color: appcolor),
            ),
            children: <Widget>[

                SimpleDialogOption(
                    child: SwitchListTile(
                        dense: true,
                        title: Text(
                            StringRes.timersound,
                            style: TextStyle(color: primary),
                        ),
                        // secondary:  Icon(Icons.music_note),
                        value: timermusic,
                        activeColor: primary,
                        onChanged: (bool value) {
                            setState(() {
                                timermusic = value;
                            });
                            setPrefrenceBool(TimerSound, value);
                            if (value) {
                                Constant.PlayBGMusic(false, true, 4);
                            } else {
                                Constant.StopBgMusic(false, true);
                            }
                        }),
                ),
                SimpleDialogOption(
                    child: SwitchListTile(
                        dense: true,
                        title:
                        Text(StringRes.othersound, style: TextStyle(color: primary)),
                        // secondary:  Icon(Icons.music_note),
                        value: othersound,
                        activeColor: primary,
                        onChanged: (bool value) {
                            setState(() {
                                othersound = value;
                            });
                            setPrefrenceBool(OtherSound, value);
                        }),
                ),
            ],
        );
    }
}
