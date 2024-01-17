import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:lottie/lottie.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Helper/NotificationHandler.dart';
import 'package:smartapp/Helper/message_dialog.dart';
import 'package:smartapp/Model/GroupModel.dart';
import 'package:smartapp/Model/MainEvent.dart';
import 'package:smartapp/Model/MainEventRound.dart';
import 'package:smartapp/Model/OneOnOneModel.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/payments.dart';
import 'package:smartapp/services/globals.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Model/language_data.dart';
import '../services/language.dart';
import '../services/locale_constant.dart';
import 'AddMoney.dart';
import 'ChatScreenActivity.dart';

import 'package:smartapp/activity/ProfileActivity.dart';
import 'package:smartapp/services/authentication.dart';
import '../Helper/Session.dart';
import '../Helper/Color.dart';
import '../Helper/Data_Helper.dart';
import 'package:http/http.dart' as http;
import 'Leaderboard/EventLeaderboard.dart';

import 'Login.dart';
import 'Privacy_Policy.dart';
import 'TheMainEvent/DailChallenge.dart';
import 'Practice.dart';
import 'TheMainEvent/MainEventActivity.dart';
import 'Wallet.dart';

String? uname,
    uemail,
    uuserid,
    uprofile,
    umobile,
    ulocation,
    firebaseuserid,
    utype,
    uamount,
    coins;
MainEventRound? selectedmainevent;

MainEventRound? selectedDailyEvent;

GroupModel? selectedgroupevent;
OneOnOneModel? selectedoneononeevent;
bool isgettingdata = true, isnodata = false;
bool isgettinggroupdata = true, isnodatagroup = false;
bool isgettingoneononedata = true, isnodataoneonone = false;
List<MainEvent>? maineventlist;
List<GroupModel>? groupeventlist;
List<OneOnOneModel>? oneononeeventlist;
ScrollController? scrollcontroller;
String notificationmessage = "";
List<MainEventRound>? maineventroundlist;
String languageCode = 'en';

bool? daily = false,
    one = false,
    mainEvent = false,
    practice = false,
    group = false;

class HomeActivity extends StatefulWidget {
  final BaseAuth? auth;
  HomeActivity({this.auth});

  @override
  MainActivityState createState() => MainActivityState();
}

var db = new DatabaseHelper();

//var bookmarkDb = new Bookmark_Helper();

class MainActivityState extends State<HomeActivity> {
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  bool _isLoading = true;
  bool showWidget = false;
  String languageText = '';
  @override
  Widget build(BuildContext context) {
    var language = Languages.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: customAppbar("SmartApp", primary, Colors.white),
      // appBar: AppBar(
      //  backgroundColor: color
      //   centerTitle: true,
      //   brightness: Brightness.dark,
      //   title: Text(
      //     "Jibu N'Pesa",
      //     style: TextStyle(color: primary),
      //   ),
      //   iconTheme: IconThemeData(
      //     color: primary,
      //   ),
      //   elevation: 0,
      // ),
      // drawer: DrawerWidget(),
      drawer: DrawerWidget(),
//
      body: _isLoading
          ? Container(
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: white,
              )),
            )
          : Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.2,
                  // 0.5,
                  1,
                ],
                colors: [
                  Color.fromARGB(255, 168, 194, 247),
                  // Colors.blue,

                  Colors.white10
                ],
              )),
              height: double.maxFinite,
              width: double.maxFinite,
              padding: EdgeInsets.only(
                  left: 5, right: 5, top: kToolbarHeight + 30, bottom: 10),
              child: Center(
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10,),
                    AutoSizeText(
                      "${language!.homeWelcome} $uname, ${language.homeWelcome1}",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold, color: primary),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/home.png',
                      ),
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          child: Text(
                              '${Languages.of(context)!.homeInfo} ${coins == null || coins!.trim().isEmpty ? "0" : coins} GCOINS',
                              style: kTextHeadStyle.apply(color: primary)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        AddMoney(refreshUi, refreshUi)));
                          },
                        )),
                    daily!
                        // ? Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: GestureDetector(
                        //       onTap: () async {
                        //         /* Navigator.of(context).push(MaterialPageRoute(
                        //             builder: (context) =>
                        //                 DailyChallengeActivity()));*/

                        //         await Navigator.of(context).push(
                        //             MaterialPageRoute(
                        //                 builder: (context) =>
                        //                     DailyChallengeActivity()));

                        //         setState(() {});
                        //       },
                        //       child: Container(
                        //           margin: EdgeInsets.only(top: 20),
                        //           child: Image.asset(
                        //               'assets/images/dailychallenge.png')),
                        //     ),
                        //   )

                        ? Container(
                            width: double.maxFinite,
                            height: 50,
                            margin: EdgeInsets.symmetric(
                              horizontal: 30,
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: StadiumBorder(),
                                  backgroundColor: purple),
                              child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      LottieBuilder.asset("assets/lottie/timer1.json", animate: false,
                                  height: 60),
                                      Text(
                                        Languages.of(context)!.dailyChallengeString!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        // style: kTextNormalBoldStyle.apply(
                                        //     color: Colors.white,),
                                      ),
                                      Container(
                                        height: 30,
                                    //padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: const Icon(
                                      Icons.arrow_right_alt_outlined,
                                      size: 25.0,
                                      color: purple,
                                    )),
                                    ],
                                  ),
                              onPressed: () async {
                                showWidget == false
                                    ? showMessage()
                                    : await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DailyChallengeActivity(
                                                    uamount:
                                                        UserModel.amount!)));

                                setState(() {});
                              },
                            ))
                        : Container(),
                    practice!
                        ? Padding(
                            padding: const EdgeInsets.only(top: 13.0),
                            child: Container(
                              width: double.maxFinite,
                              height: 50,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 5),
                              // margin: EdgeInsets.symmetric(
                              //     horizontal: 60, vertical: 5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: bluegradient2),
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      LottieBuilder.asset("assets/lottie/coins_grow.json", animate: true,
                                  height: 60),
                                      Text(
                                        Languages.of(context)!.practiceString!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        // style: kTextNormalBoldStyle.apply(
                                        //     color: Colors.white,),
                                      ),
                                      Container(
                                        height: 30,
                                    //padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: const Icon(
                                      Icons.arrow_right_alt_outlined,
                                      size: 25.0,
                                      color: purple,
                                    )),
                                    ],
                                  )),
                                // padding: EdgeInsets.symmetric(horizontal: 50)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, anim1, anim2) =>
                                            Practice(),
                                      ));
                                },
                              ),
                            ),
                          )

                        //  Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: GestureDetector(
                        //       onTap: () {
                        //         Navigator.push(
                        //             context,
                        //             PageRouteBuilder(
                        //               pageBuilder: (context, anim1, anim2) =>
                        //                   Practice(),
                        //             ));
                        //       },
                        //       child:
                        //           Image.asset('assets/images/practice.png'),
                        //     ),
                        //   )
                        : Container(),
                    mainEvent!
                        ? Padding(
                            padding:
                                const EdgeInsets.only(top: 13.0, bottom: 13.0),
                            child: Container(
                              width: double.maxFinite,
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                    backgroundColor: orangeTheme),
                                child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      LottieBuilder.asset("assets/lottie/timer2.json", animate: true,
                                  height: 60),
                                      Text(
                                        Languages.of(context)!.mainEventString!,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        // style: kTextNormalBoldStyle.apply(
                                        //     color: Colors.white,),
                                      ),
                                      Container(
                                        height: 30,
                                    //padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                    child: const Icon(
                                      Icons.arrow_right_alt_outlined,
                                      size: 25.0,
                                      color: purple,
                                    )),
                                    ],
                                  )),
                                // padding: EdgeInsets.symmetric(horizontal: 50)),
                                onPressed: () async {
                                  if (showWidget == false) {
                                    showMessage();
                                  } else {
                                    await Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainEventActivity()));
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          )

                        // Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: GestureDetector(
                        //       onTap: () async {
                        //         await Navigator.of(context).push(
                        //             MaterialPageRoute(
                        //                 builder: (context) =>
                        //                     MainEventActivity()));
                        //         setState(() {});
                        //       },
                        //       child:
                        //           Image.asset('assets/images/mainevent.png'),
                        //     ),
                        //   )
                        : Container(),
                    // group
                    //     ?
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height * 1 / 15,
                          width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                bluegradient2,
                                purple,
                              ]),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset("assets/images/groupplayer.png",
                                height: 40),
                            const Text(
                              "Group Event",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         GroupEventActivity()));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Group events are currently unavailable, kindly check later.")));
                              },
                              child: Container(
                                  height: 25,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: const Icon(
                                    Icons.arrow_right_alt_outlined,
                                    size: 25.0,
                                    color: purple,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),

                    //     : Container(),
                    //one
                    //?
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                         margin: EdgeInsets.symmetric(horizontal: 20),
                          height: MediaQuery.of(context).size.height * 1 / 15,
                          width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                purple,
                                bluegradient2,
                              ]),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image.asset("assets/images/oneonone.png",
                                height: 30),
                            const Text(
                              "One On One Event",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //         GroupEventActivity()));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "One on One events are currently unavailable, kindly check later.")));
                              },
                              child: Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: const Icon(
                                    Icons.arrow_right_alt_outlined,
                                    size: 25.0,
                                    color: purple,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                    //: Container(),

                    ),
              ),
            ),
    );
  }

  refreshUi() {
    setState(() {});
  }

  notpayedmethod() {
    if (int.parse(uamount!) < 1) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => AddPaymentEntry(auth: widget.auth)),
          (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomeActivity(auth: widget.auth)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void dispose() {
    scrollcontroller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    SetUserData();

    //new NotificationHandler().initializeFcmNotification(context, widget.auth!);

    scrollcontroller = ScrollController(keepScrollOffset: true);
    maineventlist = [];
    groupeventlist = [];

    getIntial();
  }

  Future<void> SetUserData() async {
    User currentUser = FirebaseAuth.instance.currentUser!;

    if (currentUser != null)
      firebaseuserid = currentUser.uid;
    else
      firebaseuserid = await getPrefrence(FIR_ID);

    utype = await getPrefrence(LOGIN_TYPE);
    uname = await getPrefrence(NAME);
    uemail = await getPrefrence(EMAIL);
    uuserid = await getPrefrence(USER_ID);
    uprofile = await getPrefrence(PROFILE);
    umobile = await getPrefrence(MOBILE);
    ulocation = await getPrefrence(LOCATION);

    setState(() {});
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }

  Future onSelectNotification(String? typemsg) async {
    try {
      if (typemsg != null && typemsg.isNotEmpty) {
        String payload = typemsg.split("==")[0].toString().trim();
        bool check = await isLogin();

        //debugPrint('notification payload notempty: ' + payload);

        if (check) {
          if (payload.toLowerCase() == Constant.lblgroupevent.toLowerCase()) {
            //debugPrint('notification payload: ' + typemsg);
            GroupModel groupModel = GroupModel.SetData(
                typemsg.split("==")[1], typemsg.split("==")[2]);
            //ischatscreen = true;
            selectedgroupevent = groupModel;
            chatfrom = Constant.lblgroupevent;
            chatgroupid = typemsg.split("==")[1];
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ChatScreenActivity()));
          }
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Login()));
        }
      }
    } on Exception catch (_) {}
  }

  void firebaseCloudMessaging_Listeners() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    if (Platform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    FirebaseMessaging.instance.getToken().then((token) {
      FcmTokenCheck(token!);
    });
    try {
      // _firebaseMessaging.configure(
      //   onMessage: (Map<String, dynamic> message) async {
      //     myBackgroundMessageHandler(message);
      //   },
      //   onResume: (Map<String, dynamic> message) async {
      //     myBackgroundMessageHandler(message);
      //   },
      //   onLaunch: (Map<String, dynamic> message) async {
      //     myBackgroundMessageHandler(message);
      //   },
      //   onBackgroundMessage: Platform.isIOS ? null : myBackgroundMainHandler,

      // );
    } on Exception catch (_) {}
  }

  Future<dynamic> myBackgroundMainHandler(Map<String, dynamic> message) async {
    myBackgroundMessageHandler(message);
    // Or do other work.
  }

  Future<void> FcmTokenCheck(String newtoken) async {
    String? fcmId = await getPrefrence(FLT_TOKEN);

    if (fcmId != newtoken) {
      postTokenToServer(newtoken);
    }
  }

  static void AddChatMsg(String message) {
    if (chatstreamdata != null) chatstreamdata!.sink.add(message);
  }

  static String? SetChatData(var datamain, String from, String body) {
    if (from == Constant.lblgroupevent) {
      String gid = "", gtitle = "";
      gid = datamain['group_event_id'].toString();
      gtitle = datamain['group_event_title'].toString();
      String userId = datamain['user_id'].toString();
      String dateCreated = datamain['date_created'].toString();
      String name = datamain['name'].toString();
      String email = datamain['email'].toString();
      String profile = datamain['profile'].toString();

      GroupModel groupModel = GroupModel.SetData(gid, gtitle);

      Map<String, dynamic> sendata = {
        "message_id": "${new DateTime.now().millisecondsSinceEpoch}",
        "message": "$body",
        "group_event_id": "$gid",
        "user_id": "$userId",
        "date": "$dateCreated",
        "name": "$name",
        "email": "$email",
        "profile": "$profile"
      };

      AddChatMsg(jsonEncode(sendata));

      String payload = "";

      payload = "$from==$gid==$gtitle==";

      return payload;
    }
    return null;
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data') || message.containsKey("notification")) {
      // Handle data message
      bool addnotification = true;
      var data = message['notification'];

      String? image;
      String? title = "", body = "", type = "", from = "", payload = "";

      title = data['title'].toString() ?? '';
      body = data['body'].toString() ?? '';

      image = data["image"] ?? '';

      if (body.trim().isEmpty) {
        body = data["message"] ?? '';
      }

      notificationmessage = body ?? '';

      if (message.containsKey('data')) {
        var datamain = message['data'];
        image = datamain["image"] ?? '';
        type = datamain['type'].toString();

        if (type == "chat") {
          from = datamain['from_event'].toString();

          String gid = datamain['group_event_id'].toString() ?? '';

          if (ischatscreen &&
              chatfrom.toLowerCase() == from.toLowerCase() &&
              chatgroupid == gid) addnotification = false;

          payload = SetChatData(datamain, from, body!);
        }
      } else {
        if (message.containsKey('image')) image = message["image"];

        if (message.containsKey('type')) type = message["type"];

        if (type == "chat") {
          if (message.containsKey('from_event')) from = message["from_event"];

          String gid = message['group_event_id'].toString() ?? '';

          if (ischatscreen &&
              chatfrom.toLowerCase() == from!.toLowerCase() &&
              chatgroupid == gid) addnotification = false;

          payload = SetChatData(message, from!, body!);
        }
      }

      if (body == null) addnotification = false;

      if (addnotification) {
        if (image != null && image.isNotEmpty) {
          var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
          var bigPictureStyleInformation = BigPictureStyleInformation(
              FilePathAndroidBitmap(bigPicturePath),
              hideExpandedLargeIcon: true,
              contentTitle: title,
              htmlFormatContentTitle: true,
              summaryText: title,
              htmlFormatSummaryText: true);
          var androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'big text channel id',
              'big text channel name',
              'big text channel description',
              //  largeIcon: bigPicturePath,
              // largeIconBitmapSource: BitmapSource.FilePath,
              //  style: AndroidNotificationStyle.BigPicture,
              styleInformation: bigPictureStyleInformation);
          var platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin.show(
              0, '$title', '$body', platformChannelSpecifics,
              payload: payload);
        } else {
          var androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'big text channel id',
            'big text channel name',
            'big text channel description',
          );

          var iOSPlatformChannelSpecifics = IOSNotificationDetails();
          var platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          await flutterLocalNotificationsPlugin
              .show(0, title, body, platformChannelSpecifics, payload: payload);
        }
      }
      //print('on message $data');
    }
  }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true));
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     //  print("Settings registered: $settings");
  //   });
  // }

  static Future<String> _downloadAndSaveImage(
      String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(Uri.parse(url));

    // print("path***$filePath");
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  getIntial() async {
    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      system_config: "1",
    };

    var response = await http.post(Uri.parse(BASE_URL), body: parameter);

    var getbody = json.decode(response.body);
    // print("data homeActivity ${getbody.toString()}");

    String error = getbody["error"];

    if (error == "false") {
      KEY = getbody["data"]['key'];

      APP_LINK = getbody["data"][KEY_APP_LINK];
      //LANGUAGE_MODE = getbody["data"][KEY_LANGUAGE_MODE];
      //OPTION_E_MODE = getbody["data"][KEY_OPTION_E_MODE];
      SHARE_APP_TEXT = getbody["data"][KEY_SHARE_TEXT];
      Constant.MAX_QUE_PER_LEVEL = int.parse(getbody["data"][TOTAL_QUESTION]);
      Constant.TIME_PER_QUESTION = int.parse(getbody["data"][TOTAL_TIME]);
      Constant.CURRENCYSYMBOL = getbody["data"][CURRENCY];

      Constant.FlutterWaveCurrencySymbol = getbody["data"][CURRENCY];
      Constant.CURRENCYCODE = getbody["data"][CURRENCY_CODE];
      Constant.COUNTRY = getbody["data"][COUNTRY];
      Constant.FlutterwaveCurrency = getbody["data"][CURRENCY_CODE];
      Constant.FlutterwaveCountry = getbody["data"][COUNTRY];
      Constant.MINIMUM_WITHDRAW_AMT =
          getbody["data"]['minimun_withdraw_amount'] ?? '';
      Web_URL = getbody["data"]['web_link'] ?? '';
      Constant.REFER_AMOUNT = getbody["data"]['refer_amount'] ?? '1';
      Constant.REFER_EARN_AMOUNT = getbody["data"]['earn_amount'] ?? '1';

      if (getbody['data'][PAYMENT_TYPE] != null) {
        Constant.PAYTYPELIST.clear();
        Constant.PAYTYPELIST = getbody['data'][PAYMENT_TYPE].map((item) => item).toList();
      }

      getEventConfig();
      if (await isConnected()) {
        if (await isLogin()) {
          //imgLogout.setImageResource(R.drawable.logout);

          GetUserStatus();
        } else {
          //imgLogout.setImageResource(R.drawable.login);
        }
      }
    }
  }

  Future<void> GetUserStatus() async {
    String? userid = await getPrefrence(USER_ID);

    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      GET_USER_BY_ID: "1",
      userId: userid
    };

    var response =
        await http.post(Uri.parse(BASE_URL), body: parameter, headers: headers);

    var getdata = json.decode(response.body);

    String error = getdata["error"];

    if (error == ("false")) {
      var status = getdata["data"]["status"];

      if (status != active) {
        clearUserSession();
        widget.auth!.signOut();

        //facebookSignIn.logOut();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Login()),
            ModalRoute.withName('/'));
      } else {
        UserModel user = new UserModel.fromJson(getdata["data"]);

        saveUserDetail(
            user.user_id!,
            user.name!,
            user.email!,
            user.mobile!,
            user.profile!,
            user.refer_code ?? '',
            user.type!,
            user.location!,
            user.fid?? '');
        setState(() {
          uamount = getdata['data']['amount'];
          coins = getdata['coins'].toStringAsFixed(0);
        });
        uamount = getdata['data']['amount'];
        coins = getdata['coins'].toStringAsFixed(0);
        try {
          double amount = double.parse(uamount!.replaceAll(",", "").trim());
          UserModel.amount = amount;
          if (UserModel.amount! < 25) {
            //pop dialog
            showWidget = false;
            //hereeeeeee
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AddPaymentEntry(auth: widget.auth)));

            var data = await showMessage();
            if (data != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          AddPaymentEntry(auth: widget.auth)));
            }
          } else {
            showWidget = true;
          }
        } catch (e) {}
      }
    }
  }

  showMessage() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 0),
      transitionBuilder: (context, a1, a2, child) {
        var gcoins = coins == null? "0" : coins;
        return ScaleTransition(   
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: MessageDialog(
              title: Languages.of(context)!.topUp,
              iconImage: Icon(
                Icons.attach_money,
                size: 40,
              ),
              labelText:
                  '${Languages.of(context)!.homeInfo} $gcoins GCoins\n ${Languages.of(context)!.topUp} GCoins',
              color: redgradient2,
            )
            );
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        //return null;
        return Container();
      },
    );
  }

  Future<void> postTokenToServer(String token) async {
    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      userId: uuserid,
      FCM_ID: token,
      UPDATE_FCM_ID: "1",
    };

    var response =
        await http.post(Uri.parse(BASE_URL), body: parameter, headers: headers);

    var getdata = json.decode(response.body);

    String error = getdata["error"];

    if (error == "false") {
      setPrefrence(FLT_TOKEN, token);
    }
  }

  Widget DrawerWidget() {
    return Drawer(
      child: Container(
          color: primary,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(left: 30, bottom: 10),
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: uprofile ?? "",
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100.0)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              image: DecorationImage(
                                  image: AssetImage('assets/images/user.jpg'),
                                  fit: BoxFit.cover)),
                        ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              image: DecorationImage(
                                  image: AssetImage('assets/images/user.jpg'),
                                  fit: BoxFit.cover)),
                        ),
                        width: 100,
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: uname == null || uname!.trim().isEmpty
                            ? Container()
                            : Text(
                                uname ?? "",
                                textAlign: TextAlign.center,
                                style: kTextHeadBoldStyle.apply(
                                    color: Colors.white),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          //uemail ?? umobile ?? "",
                          umobile ?? '',
                          textAlign: TextAlign.center,
                          style: kTextHeadStyle.apply(color: Colors.white),
                        ),
                      ),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 2),
                              child: Row(children: <Widget>[
                                _createLanguageDropDown()
                              ]))),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileActivity(
                            isFirst: false, auth: widget.auth)));
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: new Divider(
                  color: white,
                  thickness: 1,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          //StringRes.wallet,
                          Languages.of(context)!.drawerWallet!,
                          style: kTextNormalStyle.apply(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, anim1, anim2) => (Wallet())),
                    );
                  },
                ),
              ),

              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              //   child: MaterialButton(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
              //       child: Row(
              //         children: <Widget>[
              //           Image(
              //             image: AssetImage('assets/images/withdraw_icon.png'),
              //             width: 25,
              //             height: 28,
              //           ),
              //           SizedBox(
              //             width: 29,
              //           ),
              //           Text(
              //             StringRes.withdraw,
              //             style: kTextNormalStyle.apply(color: Colors.white),
              //           ),
              //         ],
              //       ),
              //     ),
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           PageRouteBuilder(
              //               pageBuilder: (context, anim1, anim2) =>
              //                   WithdrawActivity(this.refreshUi)));
              //     },
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          Languages.of(context)!.drawerDeposit!,
                          style: kTextNormalStyle.apply(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddPaymentEntry(auth: widget.auth)));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/images/leader.png'),
                          width: 25,
                          height: 28,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          Languages.of(context)!.drawerleaderBoard!,
                          style: kTextNormalStyle.apply(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, anim1, anim2) =>
                              (EventLeaderboard(0))),
                    );
                  },
                ),
              ),

              // ListTile(
              //   contentPadding: EdgeInsets.only(left: 70),
              //   dense: true,
              //   leading: Container(
              //       width: 40, child: Image.asset('assets/images/Leaderboard.png')),
              //   title: Text(
              //     StringRes.leaderboard,
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     //Navigator.of(context).pop();
              //     Navigator.push(
              //       context,
              //       PageRouteBuilder(
              //           pageBuilder: (context, anim1, anim2) =>
              //               (EventLeaderboard(0))),
              //     );
              //   },
              // ),

              // ListTile(
              //   contentPadding: EdgeInsets.only(left: 70, top: 0, bottom: 0),
              //   dense: true,
              //   leading: Container(
              //       width: 40, child: Image.asset('assets/images/draw_wallet.png')),
              //   title: Text(
              //     StringRes.wallet,
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       PageRouteBuilder(
              //           pageBuilder: (context, anim1, anim2) =>
              //               (WalletActivity(refreshUi))),
              //     );
              //   },
              // ),
              // ListTile(
              //   contentPadding: EdgeInsets.only(left: 70, top: 0, bottom: 0),
              //   dense: true,
              //   leading: Container(
              //       width: 40, child: Image.asset('assets/images/draw_withdraw.png')),
              //   title: Text(
              //     StringRes.withdraw,
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //         context,
              //         PageRouteBuilder(
              //             pageBuilder: (context, anim1, anim2) =>
              //                 WithdrawActivity(this.refreshUi)));
              //   },
              // ),
              // ListTile(
              //   leading: Container(
              //       width: 40,
              //       child: Image.asset('assets/images/draw_transaction.png')),
              //   title: Text(
              //     StringRes.transaction,
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       PageRouteBuilder(
              //           pageBuilder: (context, anim1, anim2) =>
              //               (TransactionActivity())),
              //     );
              //   },
              // ),

              // ListTile(
              //   leading: Container(
              //       width: 40,
              //       child: Icon(
              //         Icons.notifications,
              //         color: white,
              //         size: 20,
              //       )),
              //   title: Text(
              //     "Notifications",
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     //Navigator.of(context).pop();
              //     Navigator.push(
              //       context,
              //       PageRouteBuilder(
              //           pageBuilder: (context, anim1, anim2) => (Notifiction())),
              //     );
              //   },
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: new Divider(
                  color: Colors.white,
                  thickness: 1,
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          Languages.of(context)!.drawerAboutUs!,
                          style: kTextNormalStyle.apply(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Constant.cls_type = "aboutus";
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, anim1, anim2) =>
                              Privacy_Policy()),
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.privacy_tip_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          Languages.of(context)!.drawerPrivacyOptions!,
                          style: kTextNormalStyle.apply(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Constant.cls_type = "privacy";
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, anim1, anim2) =>
                              Privacy_Policy()),
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.receipt_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          Languages.of(context)!.drawerTermsAndConditions!,
                          style: kTextNormalStyle.apply(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Constant.cls_type = "terms";

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (context, anim1, anim2) =>
                              Privacy_Policy()),
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.call,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          Languages.of(context)!.drawerContact!,
                          style: kTextNormalStyle.apply(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    await launch("https://wa.me/254 701 151 300");
                  },
                ),
              ),

              // ListTile(
              //   contentPadding: EdgeInsets.only(left: 80),
              //   dense: true,
              //   leading: Container(
              //       width: 40, child: Image.asset('assets/images/setting_icon.png')),
              //   title: Text(
              //     "Setting",
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     showDialog(context: context, builder: (context) => SettingDialog());
              //   },
              // ),

              // ListTile(
              //   leading: Container(
              //       width: 40, child: Image.asset('assets/images/draw_tos.png')),
              //   title: Text(
              //     "Terms & Conditions",
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     //Navigator.of(context).pop();

              //     setState(() {
              //       Constant.cls_type = "terms";
              //     });
              //     Navigator.push(
              //       context,
              //       PageRouteBuilder(
              //           pageBuilder: (context, anim1, anim2) => Privacy_Policy()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Container(
              //       width: 40, child: Image.asset('assets/images/draw_pp.png')),
              //   title: Text(
              //     "Privacy Policy",
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     //Navigator.of(context).pop();
              //     Constant.cls_type = "privacy";
              //     Navigator.push(
              //       context,
              //       PageRouteBuilder(
              //           pageBuilder: (context, anim1, anim2) => Privacy_Policy()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Container(
              //       width: 40, child: Image.asset('assets/images/draw_aboutus.png')),
              //   title: Text(
              //     "About Us",
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () {
              //     // Navigator.of(context).pop();
              //     Constant.cls_type = "aboutus";
              //     Navigator.push(
              //       context,
              //       PageRouteBuilder(
              //           pageBuilder: (context, anim1, anim2) => Privacy_Policy()),
              //     );
              //   },
              // ),
              // ListTile(
              //   leading: Container(
              //       width: 40, child: Image.asset('assets/images/draw_share.png')),
              //   title: Text(
              //     "Share App",
              //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              //   ),
              //   onTap: () async {
              //     String referCode = await getPrefrence(REFER_CODE);
              //     String shareMsg = StringRes.appname +
              //         "\n" +
              //         SHARE_APP_TEXT +
              //         "\n\nUse My Refercode " +
              //         referCode +
              //         " and Earn ${Constant.REFER_AMOUNT}${Constant.CURRENCYSYMBOL}" +
              //         "\n\nAndroid App : " +
              //         APP_LINK +
              //         "\n\nIOS App : " +
              //         IOS_URL +
              //         "\n\nWeb App : " +
              //         Web_URL;

              //     if (referCode == null || referCode.trim().isEmpty) {
              //       shareMsg = StringRes.appname +
              //           "\n" +
              //           SHARE_APP_TEXT +
              //           "\n\nAndroid App : " +
              //           APP_LINK +
              //           "\n\nIOS App : " +
              //           IOS_URL +
              //           "\n\nWeb App : " +
              //           Web_URL;
              //     }

              //     Share.share(shareMsg);
              //   },
              // ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                          size: 25,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          Languages.of(context)!.drawerLogout!,
                          style: kTextNormalStyle.apply(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () async {
                    await clearUserSession();
                    if (widget.auth != null)
                      widget.auth!.signOut();
                    else
                      FirebaseAuth.instance.signOut();

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Login()),
                        (Route<dynamic> route) => false);
                  },
                ),
              ),
            ],
          ))),
    );
  }

  Widget errorImg() {
    return Icon(
      Icons.account_circle_rounded,
      size: 50,
      color: white,
    );
  }

//todo loading mainevent
  Future loadMainEventData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      // if (tradeisloadmore) {
      setState(() {
        //tradeisloadmore = false;
        isgettingdata = true;
        isnodata = false;
        /*if (tradeoffset == 0) {
            tradelist = new List<Transaction>();
          }*/
      });

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

      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
              () => setState(() {
                    isgettingdata = false;
                    maineventlist!.addAll((res['data'] as List)
                        .map((model) => MainEvent.fromJson(model))
                        .toList());
                  }));
        } else {
          setState(() {
            isgettingdata = false;
          });
        }
      } else {
        isnodata = true;
        isgettingdata = false;
        setState(() {});
      }
    }
  }

  Future loadGroupEventData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
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
      }
      Map<String, String> body = {GET_GROUP_EVENT: "1", userId: uuserid!};

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
              () => setState(() {
                    isgettinggroupdata = false;
                    groupeventlist!.addAll((res['data'] as List)
                        .map((model) => GroupModel.fromJson(model))
                        .toList());
                  }));
        } else {
          setState(() {
            isgettinggroupdata = false;
          });
        }
      } else {
        isnodatagroup = true;
        isgettinggroupdata = false;
        setState(() {});
      }
      //}
    }
  }

  _createLanguageDropDown() {
    return DropdownButton<LanguageData>(
      iconSize: 30,
      hint: Text(Languages.of(context)!.labelSelectLanguage!,
          style: kDropdownStyle),
      onChanged: (LanguageData? language) {
        changeLanguage(context, language!.languageCode);
        languageCode = language.languageCode;
      },
      items: LanguageData.languageList()
          .map<DropdownMenuItem<LanguageData>>(
            (e) => DropdownMenuItem<LanguageData>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Text(
                  //   e.flag,
                  //   style: TextStyle(fontSize: 30),
                  // ),
                  Text(e.name)
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> getEventConfig() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      var parameter = {
        ACCESS_KEY: ACCESS_KEY_VAL,
        event_config: "1",
      };

      var response = await http.post(Uri.parse(BASE_URL),
          body: parameter, headers: headers);

      var getbody = json.decode(response.body);

      String error = getbody["error"];

      if (error == "false") {
        String grp = getbody["data"]["group_player"];
        if (grp == "1") group = true;
        String dl = getbody["data"]["daily_contest"];
        if (dl == "1") daily = true;
        String mn = getbody["data"]["main_event"];
        if (mn == "1") mainEvent = true;
        String on = getbody["data"]["oneonone"];
        if (on == "1") one = true;
        String pr = getbody["data"]["practice_event"];
        if (pr == "1") practice = true;

        // int.parse(uamount) < 1 ? notpayedmethod() : null;

        setState(() {
          _isLoading = false;
        });
      }
    }
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
  bool eventnotification = false;

  @override
  void initState() {
    SetValueData();
    super.initState();
  }

  Future<void> SetValueData() async {
    bgmusic = (await getPrefrenceBool(Backgroundmusic))!;
    timermusic = (await getPrefrenceBool(TimerSound))!;
    othersound = (await getPrefrenceBool(OtherSound))!;
    eventnotification = (await getPrefrenceBool(EventNotification))!;

    if (bgmusic == null) bgmusic = false;
    if (timermusic == null) timermusic = true;
    if (othersound == null) othersound = true;
    if (eventnotification == null) eventnotification = true;

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
              activeColor: primary,
              title: Text(
                StringRes.timersound,
                style: TextStyle(color: primary),
              ),
              // secondary:  Icon(Icons.music_note),
              value: timermusic,
              onChanged: (bool value) {
                setState(() {
                  timermusic = value;
                });
                setPrefrenceBool(TimerSound, value);
              }),
        ),
        SimpleDialogOption(
          child: SwitchListTile(
              dense: true,
              activeColor: primary,
              title: Text(
                StringRes.othersound,
                style: TextStyle(color: primary),
              ),
              // secondary:  Icon(Icons.music_note),
              value: othersound,
              onChanged: (bool value) {
                setState(() {
                  othersound = value;
                });
                setPrefrenceBool(OtherSound, value);
              }),
        ),
        SimpleDialogOption(
          child: SwitchListTile(
              dense: true,
              activeColor: primary,
              title: Text(
                StringRes.eventnotification,
                style: TextStyle(color: primary),
              ),
              // secondary:  Icon(Icons.music_note),
              value: eventnotification,
              onChanged: (bool value) {
                setState(() {
                  eventnotification = value;
                });
                setPrefrenceBool(EventNotification, value);
              }),
        ),
        Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              child: Text(
                "Ok",
                style: TextStyle(color: appcolor, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ))
      ],
    );
  }
}

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<Offset>? slideAnimation;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    slideAnimation = Tween<Offset>(begin: Offset(0.0, -4.0), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: controller!, curve: Curves.decelerate));
    controller!.addListener(() {
      setState(() {});
    });
    controller!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
        position: slideAnimation!,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(),
            body: Container(
                padding: const EdgeInsets.all(13.0),
                height: MediaQuery.of(context).size.height / 2.7,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  children: [Text("test")],
                ))));
  }
}
