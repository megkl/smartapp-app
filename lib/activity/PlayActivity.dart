import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

import 'package:photo_view/photo_view.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/MainEventRound.dart';
import 'package:smartapp/Model/Question.dart';
import 'package:smartapp/services/globals.dart';

import '../Helper/Color.dart';
import 'HomeActivity.dart';
import 'Result.dart';

List<Question> questionList =[];
bool? eMode = false;
int? timefrom = 1;

class PlayActivity extends StatefulWidget {
  String? cls;
  final MainEventRound? selectedmainevent;
  PlayActivity({this.cls, this.selectedmainevent});

  @override
  State<StatefulWidget> createState() {
    return playState(this.cls);
  }
}

class playState extends State<PlayActivity>
    with SingleTickerProviderStateMixin {
  Question? question;
  int queIndex = 0, level_coin = 6, correctQuestion = 0, inCorrectQuestion = 0;
  String? curQue,
      curnote,
      questionType,
      optionA,
      optionB,
      optionC,
      optionD,
      optionE,
      rightAns,
      rightoption,
      userSelected,
      userselectedoption;
  bool? loading = true, errorExist = false;

  int? score = 0;
  bool? _isTap = true, isCheckAns = false;
  AnimationController? _animationController;

  //int levelNo = 1;
  int? _curTime = Constant.TIME_PER_QUESTION;
  int? totalplaytime = 0, currquetime = 0;
  bool? optEVisible = false;

  //bool isBook = false;
  List<String>? options = [];
  int? btnPosition = 0;
  int? aPer, bPer, cPer, dPer, ePer;
  List<String>? visibilityOption;
  int? oldtime = 0;

  bool? _isFifty = false, _isAudience = false;

  String? from, title = "";

  //MainEvent,GroupEvent
  Timer? clocktimer, totalTimer;
  String? remainingtime = "";
  int? leftmillisecond = Constant.TIME_PER_QUESTION;

  playState(this.from);

  @override
  void initState() {
    super.initState();
    //secureScreen();
    visibilityOption =  [];
    Constant.assetsBackgorundPlayer = null;
    Constant.assetsTimerPlayer = null;

    if (from == Constant.lblmainevent) {
      title = widget.selectedmainevent!.title;

      timefrom = 1;
    } else if (from == Constant.lblgroupevent) {
      title = selectedgroupevent!.title;
      timefrom = 3;
    } else if (from == Constant.lblPractice) {
      title = widget.cls;
    } else if (from == Constant.lblDaily) {
      title = widget.selectedmainevent!.title;
    }
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
        extendBodyBehindAppBar: true,
        backgroundColor: orangeTheme,
        appBar: customAppbar('$title', primary, Colors.white),
        // AppBar(
        //   // backgroundColor: Colors.transparent,
       
        //   elevation: 0,
        //   title: Container(
        //     // color: Colors.red,
        //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        //     child: Text(
        //       title,
        //     ),
        //   ),
        //   centerTitle: true,
        
        // ),
        body: loading!
            ? Container(
                color: lightYellow,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: orangeTheme,
                )),
              )
            : (errorExist! || questionList.length < Constant.MAX_QUE_PER_LEVEL)
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/gameback.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        "${StringRes.notenoughque}",
                      ),
                    ))
                :
        SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            getCoins(),
                          questionType == 'Silver' ?  Image.asset('assets/images/silver-star.png', width: 60, height: 60,):
                           questionType == 'Gold' ?  Image.asset('assets/images/gold-star.png', width: 60, height: 60,):Container(),
                        //     Container(
                        //       // height: 50,
                        //       decoration: BoxDecoration(
                        //   // shape: BoxShape.rectangle,
                        //   color: Colors.yellow[600],
                        //   border: Border.all(width: 1.0,color: Colors.blue[100]),
                        //   borderRadius: BorderRadius.all(Radius.circular(10.0))
                        // ),
                        //       child: 
                              getQuestion(),
                              // ),
                            Text("Choose from options below:", style: TextStyle(fontSize: 20, color: white),),
                            SizedBox(height: 10,),
                            getOption(OPTIONA, optionA!),
                            getOption(OPTIONB, optionB!),
                            getOption(OPTIONC, optionC!),
                            getOption(OPTIOND, optionD!),
                            (eMode! && optEVisible!)
                                ? (getOption(OPTIONE, optionE!))
                                : Container(
                                    height: 0,
                                  )
                          ],
                        ),
                      ),




      ),
    );
  }

  void resetTimer() {
    // Utils.btnClick(view, PlayActivity.this);
    //CheckSound();
    //if (!Session.isResetUsed(PlayActivity.this)) {
    if (TOTAL_COINS >= 4) {
      TOTAL_COINS = TOTAL_COINS - 4;
      //coin_count.setText(String.valueOf(Constant.TOTAL_COINS));
      /* Constant.LeftTime = 0;
        leftTime = 0;
        stopTimer();
        starTimer();
        Session.setReset(PlayActivity.this);
        */
      _curTime = Constant.TIME_PER_QUESTION;
      _animationController!.reset();
      _animationController!.forward();

      setState(() {});
    }
    //else
    // ShowRewarded(PlayActivity.this);
    // } else
    // AlreadyUsed();
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
    if (widget.cls == Constant.lblPractice) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Result(
                    correct: correctQuestion.toString(),
                    incorrect: inCorrectQuestion.toString(),
                    totaltime: totalplaytime.toString(),
                    from: from,
                  )));
    } else if (await isLogin()) {
      updateEventScore(correctQuestion.toString(), gotoresult);
    }
    /*if(gotoresult){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Result(correct: correctQuestion.toString(), incorrect: inCorrectQuestion.toString(), level_coin: level_coin.toString(), level_score: score.toString(),from: from,)));
    }*/
  }

  void AudienceWithout_E() {
    int min = 45;
    int max = 70;
    Random r = new Random();
    aPer = r.nextInt(max - min + 1) + min;
    int remain1 = 100 - aPer!;
    bPer = r.nextInt(((remain1 - 10)) + 1);
    int remain2 = remain1 - bPer!;
    cPer = r.nextInt(((remain2 - 5)) + 1);
    dPer = remain2 - cPer!;

    String ans = question!.trueAns!.trim();

    if (options![0].toString().trim() == ans)
      btnPosition = 1;
    else if (options![1].toString().trim() == ans)
      btnPosition = 2;
    else if (options![2].toString().trim() == ans)
      btnPosition = 3;
    else if (options![3].toString().trim() == ans) btnPosition = 4;
  }

  Widget getOption(String option, String optValue) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: AnimatedOpacity(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeIn,
          opacity: _isFifty!
              ? visibilityOption!.contains(option)
                  ? 1.0
                  : 0.0
              : 1.0,
          //opacity: _isAdded ? 0.0 : option==OPTION_A? optAVisible?1.0:0.0,
          child: Material(
            borderRadius: BorderRadius.circular(8.0),
            //color:primary,
            child: InkWell(
              // splashColor: primary,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    child: Text(
                      option,
                      style: TextStyle(color: white, fontSize: 20),
                    ),
                  ),
                  Expanded(
                      child: Text(
                    optValue,
                    style: TextStyle(color: white, fontSize: 20),
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
              onTap: _isTap!
                  ? () {
                      setState(() {
                        _isTap = false;
                      });

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
            color: isCheckAns!
                ? rightoption!.toLowerCase().trim() ==
                        option.toLowerCase().trim()
                    ? Color.fromARGB(255, 1, 159, 83)
                    : userselectedoption!.toLowerCase().trim() ==
                            option.toLowerCase().trim()
                        ? const Color.fromARGB(255, 244, 23, 23)
                        : selection
                : selection,
          )),
    );
  }

  getNextQuestion() async {
    isCheckAns = false;

    if (queIndex < Constant.MAX_QUE_PER_LEVEL) {
      question = questionList[queIndex];
      curQue = question!.question!;
      curnote = question!.note ?? '';
      questionType = question!.questionType ?? '';
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

      options!.clear();

      options!.add(question!.optiona!);
      options!.add(question!.optionb!);
      options!.add(question!.optionc!);
      options!.add(question!.optiond!);

      if (eMode == null) eMode = false;

      if (eMode!) {
        if (question!.optione!.isNotEmpty || question!.optione != "")
          options!.add(question!.optione!);
      }

      rightoption = question!.answer;

      if (options!.length == 4)
        optEVisible = false;
      else
        optEVisible = true;

      optionA = options![0];
      optionB = options![1];
      optionC = options![2];
      optionD = options![3];

      if (optEVisible!) optionE = options![4];
    } else {
      levelCompleted();
    }
  }

  Future<void> getQuestionsFromJson() async {
    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      userId: uuserid,
    };

    if (from == Constant.lblmainevent) {
      parameter['get_questions_by_mainevent_new'] = "1";
      parameter[EVENT_ID] = widget.selectedmainevent!.id;
      //  parameter[COUNT] = selectedmaineventround.count;
    } else if (from == Constant.lblgroupevent) {
      parameter[Get_QuestionBYGroupEvent] = "1";
      parameter[GROUP_EVENT_ID] = selectedgroupevent!.id;
    } else if (from == Constant.lblDaily) {
      parameter['get_questions_by_main_events'] = "1";
      parameter[MAIN_EVENT_ID] =widget. selectedmainevent!.id;
      //  parameter[COUNT] = selectedmaineventround.count;
    } else if (from == Constant.lblPractice)
      parameter["get_practice_questions"] = "1";

    debugPrint('param***question${parameter.toString()}');

    var response =
        await http.post(Uri.parse(BASE_URL), body: parameter, headers: headers);

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
    return Container(
      padding: EdgeInsets.only(top: kToolbarHeight * 2),
      child: getProgressTimer(),
    );
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
    var response =
        await http.post(Uri.parse(BASE_URL), body: parameter, headers: headers);

    var getdata = json.decode(response.body);

    String error = getdata["error"];

    if (error == ("false")) {
      var data = getdata["data"];
    }
  }

  Future<void> updateEventScore(final String score, bool gotoresult) async {
    int attemptque = correctQuestion + inCorrectQuestion;
    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      userId: uuserid,
      TIME: totalplaytime.toString(),
      //TIME: _curTime.toString(),
      TOTAL_QUESTIONS: Constant.MAX_QUE_PER_LEVEL.toString(),
      CORRECT_ANSWERS: correctQuestion.toString(),
      INCORRECT_ANSWERS: inCorrectQuestion.toString(),
      ATTEMPT_QUESTION: attemptque.toString(),
      SCORE: correctQuestion.toString(),
    };

    //MainEvent,GroupEvent

    if (from == Constant.lblmainevent) {
      parameter['set_mainevent_new_score'] = "1";
      parameter[EVENT_ID] = widget.selectedmainevent!.id;
      //  parameter[ROUND] = selectedmaineventround.round_number;
    } else if (from == Constant.lblgroupevent) {
      parameter[SET_GROUP_EVENT_SCORE] = "1";
      parameter[GROUP_EVENT_ID] = selectedgroupevent!.id;
    } else if (from == Constant.lblDaily) {
      parameter['set_main_event_score'] = "1";
      parameter[MAIN_EVENT_ID] = widget.selectedmainevent!.id;
    }

    var response =
        await http.post(Uri.parse(BASE_URL), body: parameter, headers: headers);

    var getdata = json.decode(response.body);

    String error = getdata["error"];

    if (error == ("false")) {
      var data = getdata["data"];
    }

    if (gotoresult) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Result(
                    correct: correctQuestion.toString(),
                    incorrect: inCorrectQuestion.toString(),
                    totaltime: totalplaytime.toString(),
                    from: from,
                  )));
    }
  }

  Future<void> setUserStatistics(
      final String ttlQue, final String correct, final String percent) async {
    String? userid1 = await getPrefrence(USER_ID);

    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      SET_USER_STATISTICS: "1",
      userId: userid1,
      SCORE: score.toString(),
      QUESTION_ANSWERED: ttlQue,
      CORRECT_ANSWERS: correct,
      COINS: TOTAL_COINS.toString(),
      RATIO: percent,
      CAT_ID: CATE_ID.toString()
    };

    var response =
        await http.post(Uri.parse(BASE_URL), body: parameter, headers: headers);

    var getdata = json.decode(response.body);

    String error = getdata["error"];

    if (error == ("false")) {
      var data = getdata["data"];
    }
  }

  void blankAllValue() {
    queIndex = 0;
    score = 0;
    correctQuestion = 0;
    inCorrectQuestion = 0;
  }

  Widget getQuestion() {
    return Column(
      children: <Widget>[
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // rightProgress(),
            questionLayout(),
            //wrongProgress()
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
      width: MediaQuery.of(context).size.width * 0.05,
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
      width: MediaQuery.of(context).size.width * 0.05,
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
      //if (rightAns == userSelected) {
      if (rightoption!.toLowerCase().trim() ==
          optionselect.toLowerCase().trim()) {
        score = score! + FOR_CORRECT_ANS;
        correctQuestion = correctQuestion + 1;
        Constant.PlayRightWrongSound(true);
      } else {
        score = score! - PENALTY;
        inCorrectQuestion = inCorrectQuestion + 1;
        Constant.PlayRightWrongSound(false);
      }
      TOTAL_SCORE = score!;

      if (totalTimer != null) totalTimer!.cancel();
    }
  }

  void startTimer(bool istimefinish) {
    //totalplaytime = totalplaytime + currquetime;
    if (clocktimer != null) clocktimer!.cancel();
    if (totalTimer != null) totalTimer!.cancel();
  
    if (queIndex > Constant.MAX_QUE_PER_LEVEL) {
      levelCompleted();
    } else {
      leftmillisecond = Constant.TIME_PER_QUESTION;
      totalplaytime = totalplaytime! + currquetime!;

      print("===time---$totalplaytime--$currquetime");
      //totalplaytime
      currquetime = 0;
      totalTimer =
          Timer.periodic(Duration(milliseconds: 10), (Timer t) => _getPlus());
      clocktimer =
          Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());

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
        Constant.PlayBGMusic(false, true, timefrom!);
        getNextQuestion();
      });
    }
  }

  void _getTime() {
    String remain;
    leftmillisecond = leftmillisecond! - 1;

    if (leftmillisecond! <= 0) {
      remain = "0";
    } else {
      remain = leftmillisecond.toString();
    }
    if (this.mounted) {
      setState(() {
        remainingtime = remain;
      });
    }
    if (leftmillisecond! <= 0) {
      queIndex++;

      bool isfinish = _isTap!;

      _isTap = true;
      startTimer(isfinish);
    }
  }

  Widget getProgressTimer() {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        //todo icon
        // Image.asset(
        //   'assets/images/dailychallenge_icon empty.png',
        //   color: black,
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CircularProgressIndicator(
            value: _animationController!.value,
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(Colors.black),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            remainingtime!,
            style: TextStyle(color: black, fontSize: 18),
          ),
        ),
      ],
    );
  }

  Widget getQuesText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        //decoration: DesignConfig.gradientbackground,
        padding: EdgeInsets.all(5),
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
    return Text(
      curQue!,
      style: questionType == 'Silver' ? Theme.of(context).textTheme.titleLarge?.copyWith(color: white) : questionType == 'Gold' ? Theme.of(context).textTheme.titleLarge?.copyWith(color: white) : Theme.of(context).textTheme.titleLarge?.copyWith(color: primary),
      textAlign: TextAlign.center,
    );
  }

  Widget getImgQuesText() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: white, borderRadius: BorderRadius.circular(20)),
          // decoration: DesignConfig.gradientbackground,
          child: curnote!.trim().isEmpty
              ? GetQueView()
              : Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  GetQueView(),
                  Text("Note: $curnote"),
                ])),
    );
  }

  Widget questionLayout() {
    return 
     questionType == 'silver' ?
     Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFDA9100), // silver color
                   Color(0xFFDA9100),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black26,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.95,
            height: 230,
            alignment: Alignment.center,
            child: question!.image!.isNotEmpty
                ? ClipRRect(
                    child: PhotoView(
                      imageProvider: NetworkImage(question!.image!),
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                      minScale: PhotoViewComputedScale.covered,
                      initialScale: PhotoViewComputedScale.covered,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )
                : getQuesText(),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                color: white, // silver color
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                      Text(
                        'This is a silver question',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selection,
                        ),
                     
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
:questionType == 'Gold' ?
     Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFDA9100), // silver color
                   Color(0xFFDA9100),
                ],
              ),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black26,
                  offset: Offset(1, 2),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width * 0.95,
            height: 230,
            alignment: Alignment.center,
            child: question!.image!.isNotEmpty
                ? ClipRRect(
                    child: PhotoView(
                      imageProvider: NetworkImage(question!.image!),
                      maxScale: PhotoViewComputedScale.covered * 2.0,
                      minScale: PhotoViewComputedScale.covered,
                      initialScale: PhotoViewComputedScale.covered,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  )
                : getQuesText(),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Card(
                color: white, // silver color
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                      Text(
                        'This is a Gold question',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selection,
                        ),
                     
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    )
:
     Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(5.0)), // set rounded corner radius
              boxShadow: [
                BoxShadow(
                    blurRadius: 5, color: Colors.black26, offset: Offset(1, 2))
              ] // make rounded corner of border
              ),
          width: MediaQuery.of(context).size.width * 0.95,
          height: 230,
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

  _getPlus() {
    // print("finish****millisec${DateTime.now()}");
    currquetime = currquetime! + 10;
    // print("getting current**$currquetime");
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
                  Constant.PlayBGMusic(false, true, timefrom!);
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
