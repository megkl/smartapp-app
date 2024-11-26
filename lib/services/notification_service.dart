// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:rxdart/subjects.dart';

// class NotificationService {

//   //instance of FlutterLocalNotificationsPlugin
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();

//   final BehaviorSubject<String> onNotificationClick = BehaviorSubject();
//   Future<void> init() async {

//     //Initialization Settings for Android
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');

//     //Initialization Settings for iOS
//     // const IOSInitializationSettings initializationSettingsIOS =
//     // IOSInitializationSettings(
//     //   requestSoundPermission: false,
//     //   requestBadgePermission: false,
//     //   requestAlertPermission: false,
//     // );

//     //Initializing settings for both platforms (Android & iOS)
//   //   const InitializationSettings initializationSettings =
//   //   // InitializationSettings(
//   //   //     android: initializationSettingsAndroid,
//   //   //    // iOS: initializationSettingsIOS);

//   //   // tz.initializeTimeZones();

//   //   // await flutterLocalNotificationsPlugin.initialize(
//   //   //     initializationSettings,
//   //   //     onSelectNotification: onSelectNotification
//   //   // );
//   // }

//    Future onSelectNotification(String? payload) async {
//     //Navigate to wherever you want
// if(payload != null && payload.isNotEmpty){
//   onNotificationClick.add(payload);
// }   }


//    requestIOSPermissions() {
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//   }


//   Future<void> showNotifications({id, title, body, payload}) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails( "1",
//                 "SmartApp",
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker');
//     const NotificationDetails platformChannelSpecifics =
//     NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//     id, title, body, platformChannelSpecifics,
//         payload: payload);
//   }


//   Future<void> scheduleNotifications({id, title, body, time}) async {
//     // try{
//     //   await flutterLocalNotificationsPlugin.zonedSchedule(
//     //       id,
//     //       title,
//     //       body,
//     //       tz.TZDateTime.from(time, tz.local),
//     //       const NotificationDetails(
//     //           android: AndroidNotificationDetails(
//     //             "1",
//     //             "SmartApp",
//     //               )
//     //               ),
//     //               androidScheduleMode: AndroidScheduleMode(),
//     //       //androidAllowWhileIdle: true,
//     //       uiLocalNotificationDateInterpretation:
//     //       UILocalNotificationDateInterpretation.absoluteTime);
//     // }catch(e){
//     //   print(e);
//     // }
//   }
// }
// }