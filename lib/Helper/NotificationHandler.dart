// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:smartapp/Model/GroupModel.dart';
// import 'package:smartapp/Model/OneOnOneModel.dart';
// import 'package:smartapp/activity/ChatScreenActivity.dart';
// import 'package:smartapp/activity/GroupEvent/GroupEventActivity.dart';
// import 'package:smartapp/activity/HomeActivity.dart';
// import 'package:smartapp/activity/Login.dart';

// import 'package:smartapp/activity/TheMainEvent/MainEventActivity.dart';

// import 'package:smartapp/services/authentication.dart';
// import 'Constant.dart';
// import 'Session.dart';
// import 'package:smartapp/activity/Leaderboard/EventLeaderboard.dart';


// class NotificationHandler {
//     FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//    // FirebaseMessaging _fcm = FirebaseMessaging();
//     StreamSubscription? iosSubscription;
//     static final NotificationHandler? _singleton = new NotificationHandler._internal();
//     BuildContext? context;
//     String? lastmsgid = "";
//     String? newmsgid = "";
//     BaseAuth? auth;

//     //WebSocketChannel channel;

//     factory NotificationHandler() {
//         return _singleton!;
//     }

//     NotificationHandler._internal();

//     Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//         print("onMessage-background: $message");
//         showNotification(message,"background");
//         // Or do other work.
//     }

//     void Test(String message) {
//         print("=====call==");
//         if (chatstreamdata != null)
//             chatstreamdata!.sink.add(message);
//     }

//     /*setfunction(Message Function() addItem){
//       this.InsertItem;
//   }*/

//     initializeFcmNotification(BuildContext context,BaseAuth auth) async {
//         try {
//             this.context = context;
//             this.auth = auth;

//             flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

//             var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
//         //     var initializationSettingsIOS = new IOSInitializationSettings(
//         //         requestSoundPermission: true,
//         //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//         //   final MacOSInitializationSettings initializationSettingsMacOS =
//         // MacOSInitializationSettings();
         
//  final InitializationSettings initializationSettings =
//         // InitializationSettings(
//         //     android: initializationSettingsAndroid,
//         //     iOS: initializationSettingsIOS,
//         //     macOS: initializationSettingsMacOS);


//             // flutterLocalNotificationsPlugin!.initialize(initializationSettings,
//             //     onSelectNotification: onSelectNotification);

         
//             _saveDeviceToken();

//             // _fcm.configure(
//             //     onMessage: (Map<String, dynamic> message) async {
//             //         debugPrint("onMessage1=: ${message.toString()}");

//             //         //Test();
//             //         showNotification(message,"main");
//             //     },
            
//             //     onLaunch: (Map<String, dynamic> message) async {
//             //         debugPrint("onMessage-launch2=: $message");
//             //         //Test();
//             //         showNotification(message,"launch");
//             //     },
//             //     onResume: (Map<String, dynamic> message) async {
//             //         debugPrint("onMessage-resume3: $message");
//             //         //Test();
//             //         showNotification(message,"resume");
//             //     },
//             // );
//         } on Exception catch (_) {}
//     }

//     void showNotification(Map<String, dynamic> message,String devicestatus) async {
//         try {
//             if (message.containsKey('data') || message.containsKey("notification")) {
//                 bool addnotification = true;
//                 var data = message['notification'];

//                 String image;
//                 String title = "",
//                     body = "",
//                     type = "",
//                     from = "",
//                     payload = "";

//                 title = data['title'].toString() ?? '';
//                 body = data['body'].toString() ?? '';

//                 image = data["image"] ?? '';

//                 if (body
//                     .trim()
//                     .isEmpty) {
//                     body = data["message"] ?? '';
//                 }

//                 notificationmessage = body;

//                 if(devicestatus == "resume"){
//                     print("====resume---");
//                     var datamain = message['data'];

//                     title = datamain['title'].toString() ?? '';
//                     body = datamain['body'].toString() ?? '';

//                     print("====resume---${datamain['message']}");
//                     image = datamain["image"] ?? '';
//                     type = datamain['type'].toString();


//                     payload = "$type==";

//                     if (type == Constant.notification_chat) {
//                         if (datamain.containsKey('from_event'))
//                             from = datamain["from_event"];

//                         String gid = datamain['event_id'].toString() ?? '';

//                         if (ischatscreen && chatfrom.toLowerCase() == from.toLowerCase() && chatgroupid == gid)
//                             addnotification = false;

//                           payload = SetChatData(datamain, from, body,type);
//                     }
//                 }else if (message.containsKey('data')) {
//                     var datamain = message['data'];
//                     image = datamain["image"] ?? '';
//                     type = datamain['type'].toString();

//                     payload = "$type==";

//                     if (type == Constant.notification_chat) {
//                         from = datamain['from_event'].toString();

//                         String gid = datamain['event_id'].toString() ?? '';

//                         if (ischatscreen && chatfrom.toLowerCase() == from.toLowerCase() && chatgroupid == gid)
//                             addnotification = false;

//                           payload = SetChatData(datamain, from, body,type);

//                         /*if(from == Constant.lblgroupevent){
//               String gid = "",gtitle = "";
//               gid = datamain['group_event_id'].toString();
//               gtitle = datamain['event_title'].toString();
//               String user_id = datamain['user_id'].toString();
//               String date_created = datamain['date_created'].toString();
//               String name = datamain['name'].toString();
//               String email = datamain['email'].toString();
//               String profile = datamain['profile'].toString();

//               GroupModel groupModel = GroupModel.SetData(gid, gtitle);


//               Map<String,dynamic> sendata = {
//                "message_id":"${new DateTime.now().millisecondsSinceEpoch}",
//                 "message":"${body}",
//                 "group_event_id":"${gid}",
//                 "user_id":"${user_id}",
//                 "date":"${date_created}",
//                 "name":"${name}",
//                 "email":"${email}",
//                 "profile":"${profile}"
//               };
//               AddChatMsg(jsonEncode(sendata));
//             }*/


//                     }
//                 } else {
//                     if (message.containsKey('image'))
//                         image = message["image"];

//                     if (message.containsKey('type'))
//                         type = message["type"];

//                     payload = "$type==";

//                     if (type == Constant.notification_chat) {
//                         if (message.containsKey('from_event'))
//                             from = message["from_event"];

//                         String gid = message['event_id'].toString() ?? '';

//                         if (ischatscreen && chatfrom.toLowerCase() == from.toLowerCase() &&
//                             chatgroupid == gid)
//                             addnotification = false;

//                           payload = SetChatData(message, from, body,type);
//                     }
//                 }

//                 print("notification===$title---$body");
//                 if (title == 'null' || body == 'null') {
//                     addnotification = false;
//                 }else if(type != 'null' && type != Constant.notification_chat){
//                     bool? eventnotification = await getPrefrenceBool(EventNotification);
//                     if(eventnotification == null || eventnotification == true){
//                         addnotification = true;
//                     }else{
//                         addnotification = false;
//                     }
//                 }


//                 if (addnotification) {
//                     if (image == "null" || image.isEmpty) {
//                         var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//                             'com.quiz.smartapp',
//                             'smartapp',
//                             playSound: true,

//                             //enableVibration: true,
//                            // importance: Importance.Max,
//                            // priority: Priority.High,
//                         ); 
                        
//                         //var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//                         var platformChannelSpecifics = new NotificationDetails(
//                            android: androidPlatformChannelSpecifics);


//                         await flutterLocalNotificationsPlugin!.show(0, '$title', '$body', platformChannelSpecifics, payload: payload);

//                     } else {
//                         var largeIconPath = await _downloadAndSaveImage(image, 'largeIcon');
//                         var bigPicturePath = await _downloadAndSaveImage(image, 'bigPicture');
//                         var bigPictureStyleInformation = BigPictureStyleInformation(
//                            FilePathAndroidBitmap(bigPicturePath),
//                             hideExpandedLargeIcon: true,
//                             contentTitle: '$title',
//                             htmlFormatContentTitle: true,
//                             summaryText: '$body',
//                             htmlFormatSummaryText: true);
//                         var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//                             'com.quiz.smartapp', 'smartapp',
//                             playSound: true,
//                             largeIcon:  FilePathAndroidBitmap(largeIconPath),
//                            // largeIconBitmapSource: BitmapSource.FilePath,
//                            // style: AndroidNotificationStyle.BigPicture,
//                             styleInformation: bigPictureStyleInformation);

//                         var platformChannelSpecifics = NotificationDetails(android:androidPlatformChannelSpecifics);

//                         await flutterLocalNotificationsPlugin!.show(0, '$title', '$body', platformChannelSpecifics, payload: payload);

//                     }
//                 }
//             }
//         } on Exception catch (_) {}
//     }

//     static void AddChatMsg(String message) {
     

//         if (chatstreamdata != null)
//             chatstreamdata!.sink.add(message);

//     }


//     static String SetChatData(var datamain,String from,String body,String type){
//         //if(from == Constant.lblgroupevent){
//         String gid = "",gtitle = "";
//         gid = datamain['event_id'].toString();
//         gtitle = datamain['event_title'].toString();
//         String userId = datamain['user_id'].toString();
//         String dateCreated = datamain['date_created'].toString();
//         String name = datamain['name'].toString();
//         String email = datamain['email'].toString();
//         String profile = datamain['profile'].toString();

//         //GroupModel groupModel = GroupModel.SetData(gid, gtitle);


//         Map<String,dynamic> sendata = {
//             "message_id":"${new DateTime.now().millisecondsSinceEpoch}",
//             "message":"$body",
//             "event_id":"$gid",
//             "user_id":"$userId",
//             "date":"$dateCreated",
//             "name":"$name",
//             "email":"$email",
//             "profile":"$profile",
//             "event_title":"$gtitle"
//         };


//         AddChatMsg(jsonEncode(sendata));

//         String payload = "";

//         payload = "$type==$from==$gid==$gtitle==";

//         return payload;
//         // }
//     }

//     _saveDeviceToken() async {
//         /*String fcmToken = await _fcm.getToken();
//     print("FCM_TOKEN: $fcmToken");*/

//         try {
//             FirebaseMessaging.instance.getToken().then((token) async {
             
//                 FcmTokenCheck(token!);
//             });

//         } on Exception catch (_) {}
//     }

//     Future<void> FcmTokenCheck(String newtoken) async {
//         String? fcmId = await getPrefrence(FLT_TOKEN);

//         if (fcmId != newtoken) {
//             if(uuserid == null || uuserid == 'null'){
//                 print("--useridnull");
//                 uuserid = (await getPrefrence(USER_ID))!;
//                 print("--useridnull===$uuserid");
//             }
//             postTokenToServer(newtoken);
//         }
//     }

//     Future<void> postTokenToServer(String token) async {
//         var parameter = {
//             ACCESS_KEY: ACCESS_KEY_VAL,
//             userId: uuserid,
//             FCM_ID: token,
//             UPDATE_FCM_ID: "1",
//         };

//         print('responce***system${parameter.toString()}');

//         var response = await http.post(Uri.parse(BASE_URL), body: parameter,headers: headers);

//         print('responce***system${response.body.toString()}');

//         var getdata = json.decode(response.body);

//         String error = getdata["error"];

//         if (error == "false") {
//             setPrefrence(FLT_TOKEN, token);
//         }
//     }

//     Future onSelectNotification(String? typemsg) async {
//         try {
//             if (typemsg != null && typemsg.isNotEmpty) {

//                 String type = typemsg.split("==")[0].toString().trim();
//                 bool check = await isLogin();

//                 //debugPrint('notification payload notempty: ' + payload);

//                 if (check) {
//                     if (type == Constant.notification_chat) {
//                         String payload = typemsg.split("==")[1].toString().trim();
//                         if (payload.toLowerCase() == Constant.lblgroupevent.toLowerCase()) {
//                             //debugPrint('notification payload: ' + typemsg);
//                             GroupModel groupModel = GroupModel.SetData(typemsg.split("==")[2], typemsg.split("==")[3]);
//                             //ischatscreen = true;
//                             selectedgroupevent = groupModel;
//                             chatfrom = Constant.lblgroupevent;
//                             chatgroupid = typemsg.split("==")[2];
//                             Navigator.of(context!).push(MaterialPageRoute(builder: (context) => ChatScreenActivity()));
//                         } else if (payload.toLowerCase() == Constant.lbloneononeevent.toLowerCase()) {
//                             OneOnOneModel groupModel = OneOnOneModel.SetData(typemsg.split("==")[2], typemsg.split("==")[3]);
//                             //ischatscreen = true;
//                             selectedoneononeevent = groupModel;
//                             chatfrom = Constant.lbloneononeevent;
//                             chatgroupid = typemsg.split("==")[2];
//                             Navigator.of(context!).push(MaterialPageRoute(builder: (context) => ChatScreenActivity()));
//                         }
//                     }else if(type == Constant.notification_group){
//                         Navigator.of(context!).push(MaterialPageRoute(builder: (context) => GroupEventActivity()));
//                     }else if(type == Constant.notification_main){
//                         Navigator.of(context!).push(MaterialPageRoute(builder: (context) => MainEventActivity()));
//                     }else if(type == Constant.notification_mainleaderboard){
//                         Navigator.push(context!, PageRouteBuilder(pageBuilder: (context, anim1, anim2) => (EventLeaderboard(0))),);
//                     }else if(type == Constant.notification_groupleaderboard){
//                         Navigator.push(context!, PageRouteBuilder(pageBuilder: (context, anim1, anim2) => (EventLeaderboard(1))),);
//                     }
//                 } else {
//                     Navigator.push(context!, MaterialPageRoute(builder: (context) => Login(auth: auth!)));
//                 }
//             }
//         } on Exception catch (_) {}
//     }

//     Future<void> onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
//         // display a dialog with the notification details, tap ok to go to another page
//     }

//     Future<String> _downloadAndSaveImage(String url, String fileName) async {
//         var directory = await getApplicationDocumentsDirectory();
//         var filePath = '${directory.path}/$fileName';
//         var response = await http.get(Uri.parse(url));
//         var file = File(filePath);
//         await file.writeAsBytes(response.bodyBytes);
//         return filePath;
//     }
// }
