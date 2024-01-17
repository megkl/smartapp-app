import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
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

import '../HomeActivity.dart';
import '../Result.dart';

import 'OneOnOneEventDetailActivity.dart';

List<Question> questionList = [];
bool eMode = false;
int timefrom = 1;

class RobotPlayActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return playState();
  }
}

class playState extends State<RobotPlayActivity>
    with SingleTickerProviderStateMixin {
  Question? question;
  int queIndex = 0,
      level_coin = 6,
      correctQuestion = 0,
      inCorrectQuestion = 0;
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
  bool loading = true,
      errorExist = false;
  int battleuser_rightans=0, battleuser_wrongans=0;

  //int score = 0;
  bool _isTap = true,
      isCheckAns = false;
  AnimationController? _animationController;

  //int levelNo = 1;
  int _curTime = Constant.TIME_PER_QUESTION;
  int totalplaytime = 0,
      currquetime = 0;
  bool optEVisible = false;

  //bool isBook = false;
  List<String> options = [];
  int btnPosition = 0;
  int? aPer, bPer, cPer, dPer, ePer;
  List<String>? visibilityOption;
  int oldtime = 0;
String robotSelected="";
  bool _isFifty = false,
      _isAudience = false;

  String from="Battle",
      title = "Battle";

  //MainEvent,GroupEvent
  Timer? clocktimer,totalTimer;
  String remainingtime = "";
  int leftmillisecond = Constant.TIME_PER_QUESTION;

  @override
  void initState() {
    super.initState();
    visibilityOption =[];
    Constant.assetsBackgorundPlayer = null;
    Constant.assetsTimerPlayer = null;

    setState(() {});

    Constant.SetRightWrongSound();

    getQuestionsFromJson();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: Constant.TIME_PER_QUESTION),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: DesignConfig.gradientbackground,
          ),
          title: Text(
            title,
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
              backgroundColor: primary,
            ))
            : (errorExist || questionList.length < Constant.MAX_QUE_PER_LEVEL)
            ? Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            padding: EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                "${StringRes.notenoughque}",
              ),
            ))
            : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                getCoins(),
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
    );
  }

  void resetTimer() {

    if (TOTAL_COINS >= 4) {
      TOTAL_COINS = TOTAL_COINS - 4;

      _curTime = Constant.TIME_PER_QUESTION;
      _animationController!.reset();
      _animationController!.forward();

      setState(() {});
    }

  }

  Future<void> SkipQuestion() async {

    bool? isusedskip = await getPrefrenceBool(SKIP);

    if (isusedskip == null || isusedskip == false) {
      if (TOTAL_COINS >= 4) {
        _animationController!.reset();
        _animationController!.forward();
        _curTime = Constant.TIME_PER_QUESTION;

        TOTAL_COINS = TOTAL_COINS - 4;

        queIndex++;

        getNextQuestion();
        setPrefrenceBool(SKIP, true);
      }

    } else
      showDialog(
          context: context,
          builder: (_) {
            return showUsedDialog();
          });
  }

  @override
  void dispose() {
    ClosePage();
    super.dispose();
  }

  Future<bool> onBackPress() {
    ClosePage();
    return Future.value(true);
  }

  void ClosePage() {
    Constant.StopBgMusic(true, true);

    if (clocktimer != null) clocktimer!.cancel();
    if (totalTimer != null) totalTimer!.cancel();
    if (queIndex < Constant.MAX_QUE_PER_LEVEL) {
      SetEventScore(false);
    }

    if (_animationController != null) {
      if (!_animationController!.isDismissed) _animationController!.stop();
      _animationController!.dispose();
    }

  }

  Future<void> SetEventScore(bool gotoresult) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                Result(
                  correct: correctQuestion.toString(),
                  incorrect: inCorrectQuestion.toString(),
                  totaltime: totalplaytime.toString(),
                  from: from,
                )));
  }

  Widget getOption(String option, String optValue) {



    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedOpacity(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeIn,
          opacity:
          _isFifty ? visibilityOption!.contains(option) ? 1.0 : 0.0 : 1.0,
          //opacity: _isAdded ? 0.0 : option==OPTION_A? optAVisible?1.0:0.0,
          child: Card(
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
                        color: primary,
                      ),
                    ),
                    Expanded(
                        child: Text(
                          optValue,
                          style: TextStyle(color: primary),
                        )),
                    isCheckAns && (robotSelected.toLowerCase()==option.toLowerCase()) ? Container(
                      child: Text("Robot", style: TextStyle(color:robotSelected.toLowerCase().toString().trim() == rightoption?Colors.green:Colors.red),),
                      color: Colors.white,) : Container(height: 0,)
                  ],
                ),
                onTap: _isTap
                    ? () {

                  setState(() {
                    _isTap = false;
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

    if (queIndex < Constant.MAX_QUE_PER_LEVEL) {
      question = questionList[queIndex];
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

      if (eMode == null) eMode = false;

      if (eMode) {
        if (question!.optione!.isNotEmpty || question!.optione != "")
          options.add(question!.optione!);
      }

      //options.shuffle();

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

      //isBook = await bookmarkDb.isBookmarkExist(question.id);
    } else {
      levelCompleted();
    }
  }

  Future<void> getQuestionsFromJson() async {

    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      userId: uuserid,
      GET_QUESTION_BY_ONEONONE_EVENT: "1",
      EVENT_ID: currenteventdata!.id,
      MATCH_ID: '',
      OPPONENT_ID: '',
    };

       var response = await http.post(Uri.parse(BASE_URL), body: parameter,headers: headers);


    var getdata = json.decode(response.body);

    String error = getdata["error"];

    if (error == ("false")) {
      var data = getdata["data"];


      questionList =
          (data as List).map((data) => new Question.fromJson(data)).toList();



      queIndex = 0;

      setState(() {
        loading = false;
      });

      totalplaytime = 0;
      currquetime = 0;
      startTimer(false);
    } else {
      setState(() {
        loading = false;
        errorExist = true;
      });
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
                    'Robot',
                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.android,
                    size: 40,
                    color: white,
                  ),
                Text(
                    "Right - " + battleuser_rightans.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Wrong - " + battleuser_wrongans.toString(),
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
    SetEventScore(true);

    if (_animationController != null) _animationController!.stop();


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


  void blankAllValue() {
    queIndex = 0;

    correctQuestion = 0;
    inCorrectQuestion = 0;
  }

  Widget getQuestion() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            rightProgress(),
            questionLayout(),
            wrongProgress()
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

  Widget rightProgress() {
    double curPer = correctQuestion / Constant.MAX_QUE_PER_LEVEL;

    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.05,
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: LiquidLinearProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Colors.greenAccent),
        borderColor: Colors.green,
        borderWidth: 2.0,
        borderRadius: 10,
        direction: Axis.vertical,
        value: curPer,
        center: Text(
          correctQuestion.toString(),
          style: TextStyle(
            color: Colors.green,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget wrongProgress() {
    double incurPer = inCorrectQuestion / Constant.MAX_QUE_PER_LEVEL;
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width * 0.05,
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 2.0),
      child: LiquidLinearProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation(Colors.redAccent[100]!),
        borderColor: Colors.red,
        borderWidth: 2.0,
        direction: Axis.vertical,
        borderRadius: 10,
        value: incurPer,
        center: Text(
          inCorrectQuestion.toString(),
          style: TextStyle(
            color: Colors.red,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void handleOptionClick(String userSelected, String optionselect) {
    Constant.StopBgMusic(false, true);

    if (queIndex < questionList.length) {
      if (rightoption!.toLowerCase().trim() ==
          optionselect.toLowerCase().trim()) {
        correctQuestion = correctQuestion + 1;
        Constant.PlayRightWrongSound(true);
      } else {
        inCorrectQuestion = inCorrectQuestion + 1;
        Constant.PlayRightWrongSound(false);
      }

       performVirtualClick();
    }
  }

  void startTimer(bool istimefinish) {
    if (clocktimer != null) clocktimer!.cancel();
    if (totalTimer != null) totalTimer!.cancel();

    if (queIndex > Constant.MAX_QUE_PER_LEVEL) {
      levelCompleted();
    } else {
      leftmillisecond = Constant.TIME_PER_QUESTION;
      totalplaytime = totalplaytime + currquetime;
      currquetime = 0;
        //totalplaytime
      clocktimer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

      totalTimer =
          Timer.periodic(Duration(milliseconds: 100), (Timer t) => _getPlus());
      setState(() {
        //score = score - PENALTY;
        if (istimefinish) {
          Constant.StopBgMusic(false, true);
          inCorrectQuestion = inCorrectQuestion + 1;
          Constant.PlayRightWrongSound(false);
        }

        _curTime = Constant.TIME_PER_QUESTION;
        _animationController!.reset();
        _animationController!.forward();
        //queIndex++;
        Constant.PlayBGMusic(false, true, timefrom);
        getNextQuestion();
      });
    }
  }

  _getPlus() {

    currquetime = currquetime + 100;

  }
  void _getTime() {
    String remain;
    leftmillisecond = leftmillisecond - 1;
   // currquetime = currquetime + 1;

    if (leftmillisecond <= 0) {
      remain = "0";
    } else {
      remain = leftmillisecond.toString();
    }
    if (this.mounted) {
      setState(() {
        remainingtime = remain;
      });
    }
    if (leftmillisecond <= 0) {
      queIndex++;

      bool isfinish = _isTap;
      _isTap=true;
      startTimer(isfinish);

    }
  }

  Widget getProgressTimer() {

    return LiquidCircularProgressIndicator(
      value: _animationController!.value,
      backgroundColor: Colors.grey,
      valueColor: AlwaysStoppedAnimation(primary),
      center: Text(
        //_curTime.toString(),
        remainingtime,
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
        padding: EdgeInsets.all(5),
        child: Center(
          child: SingleChildScrollView(
            child: curnote!
                .trim()
                .isEmpty
                ? GetQueView()
                : Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              GetQueView(),
              Text("Note: $curnote"),
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
          child: curnote!
              .trim()
              .isEmpty
              ? GetQueView()
              : Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            GetQueView(),
            Text("Note: $curnote"),
          ])),

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
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            height: 180,
            alignment: Alignment.center,
            child: question!.image!.isNotEmpty
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

  void performVirtualClick() {
   robotSelected = randomAlphaNumeric();

    if (robotSelected.toLowerCase().toString().trim() == rightoption)
      battleuser_rightans++;
    else
     battleuser_wrongans++;
  }

  randomAlphaNumeric() {
    var list = ['A', 'B', 'C', 'D'];

    final _random = new Random();

    var element = list[_random.nextInt(list.length)];
    return element;
  }
}

class showUsedDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<showUsedDialog> {
  _MyDialogState();

  @override
  Widget build(BuildContext context) {
    return new CupertinoAlertDialog(
      title: new Text(
        title_already_used,
        style: TextStyle(fontWeight: FontWeight.bold, color: primary),
      ),
      // message: new Text("Please select the best option from below"),
      content: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    msg_lifeline_used,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          )),
      actions: [
        CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "Ok",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              Navigator.pop(context, 'Cancel');
            }),
      ],
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

    if (bgmusic == null) bgmusic = false;
    if (timermusic == null) timermusic = true;
    if (othersound == null) othersound = true;



    setState(() {});
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
                  Constant.PlayBGMusic(false, true, timefrom);
                } else {
                  Constant.StopBgMusic(false, true);
                }
              }),
        ),
        SimpleDialogOption(
          child: SwitchListTile(
              dense: true,
              title: Text(
                StringRes.othersound,
                style: TextStyle(color: primary),
              ),
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


