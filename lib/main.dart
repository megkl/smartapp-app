import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/Login.dart';
import 'package:smartapp/activity/ProfileActivity.dart';
import 'package:smartapp/activity/SplashScreen.dart';
import 'package:smartapp/services/app_localization.dart';
import 'package:smartapp/services/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'Helper/Color.dart';
import 'activity/onboard/welcome.dart';
import 'services/locale_constant.dart';
//import 'services/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    
  );
  await FirebaseAppCheck.instance.activate(
    // appleProvider: AppleProvider.debug,
    // androidProvider: AndroidProvider.debug
  );

    AwesomeNotifications().initialize(
        'resource://drawable/launch_background', // icon for your app notification
        [
          NotificationChannel(
            channelKey: 'Notification1',
            channelName: 'SmartApp',
            channelDescription: "Game about to start notification",
            defaultColor: Color(0XFF9050DD),
            ledColor: Colors.white,
            playSound: true,
            enableLights: true,
            enableVibration: true,
          ),
          NotificationChannel(
            channelKey: 'Notification2',
            channelName: 'SmartApp',
            channelDescription: "Game about to start notification",
            defaultColor: purple,
            ledColor: white,
            playSound: true,
            enableLights: true,
            enableVibration: true,
          ),
          NotificationChannel(
            channelKey: 'Notification3',
            channelName: 'SmartApp',
            channelDescription: "Game about to start notification",
            defaultColor: purple,
            ledColor: white,
            playSound: true,
            enableLights: true,
            enableVibration: true,
          )
        ]);
        
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          return null;
        },
      );
    }
  }
  HttpOverrides.global = new MyHttpOverrides();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Auth _auth = new Auth();
  // This widget is the root of your application.
  Locale? _locale;
  bool isAllowed = false;
  @override
  void initState() {
    
     AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow Notifications'),
              content: Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
   
    super.initState();
  }
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }
@override
  void dispose() {
    //AwesomeNotifications().actionSink.close();
    //AwesomeNotifications().createdSink.close();
    super.dispose();
  }
  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: StringRes.appname,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        }),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "login": (context) => Login(),
        "welcome": (context) => Welcome(),
        "profile": (context) => ProfileActivity(),
        "home": (context) => HomeActivity()
      },
      home: SplashScreen(auth: _auth),
      locale: _locale,
      supportedLocales: [Locale('en', ''), Locale('sw', '')],
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode &&
              supportedLocale.countryCode == locale?.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
    );

    //home: Login_Master(auth: _auth));
  }

/*getCls()  async{

    bool check = await isLogin();

    print("get login**$check}");


    return check ? HomeActivity(auth:_auth ,) : Login_Master(auth: _auth);

  }*/
}

//keytool -genkey -v -keystore C:/Users/erastusmugambi/StudioProjects/SmartApp-daily/android/app/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
    ..badCertificateCallback = (X509Certificate, String host, int port)=> true;
  }
}

//  class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate, String host, int port)=> true;
//   }
// }