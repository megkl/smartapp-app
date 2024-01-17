import 'dart:convert';
import 'dart:io';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Constant.dart';

final String LANG_MODE = "lang_mode";
final String N_COUNT = "n_count";
final String E_MODE = "e_mode";
final String LOGIN = "login";
final String USER_ID = "userId";
final String LOGIN_TYPE = "logintype";

final String MOBILE = "mobile";
final String LOCATION = "location";
final String PROFILE = "profile";
final String PWD = "password";
final String IS_FIRST_TIME = "isfirsttime";
final String FIR_ID = "firebase_id";

final String LANGUAGE = "language";
final String FCM = "fcm";

final String FIFTY = "is_used_fifty";
final String SKIP = "is_used_skip";
final String AUDIENCE = "is_used_audience";
final String TIMER = "is_used_timer";

final String Backgroundmusic = "backgroundplaymusic";
final String TimerSound = "playtimetickersound";
final String OtherSound = "playothersoundsound";
final String EventNotification = "eventnotification";

setPrefrence(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
}

Future<String?> getPrefrence(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
}

setPrefrenceBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
}

Future<bool?> getPrefrenceBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
}

Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

  
    return prefs.getBool(LOGIN) ?? false;
}

Future<bool> isConnected() async {
    try {
        final result = await InternetAddress.lookup('google.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        
            return true;
        }
        else{
          return false;
        }
    } on SocketException catch (_) {
   
        return false;
    }
}

Future<void> saveUserDetail(
    String userId,
    String name,
    String email,
    String mobile,
    String profile,
    String referCode,
    String type,
    String location,
    String fid) async {
    final waitList = <Future<void>>[];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    waitList.add(prefs.setString(USER_ID, userId));
    waitList.add(prefs.setString(NAME, name));
    waitList.add(prefs.setString(EMAIL, email));
    waitList.add(prefs.setString(MOBILE, mobile));
    waitList.add(prefs.setString(PROFILE, profile));
    waitList.add(prefs.setString(REFER_CODE, referCode));
    waitList.add(prefs.setBool(LOGIN, true));
    waitList.add(prefs.setString(LOGIN_TYPE, type));
    waitList.add(prefs.setString(LOCATION, location));
    waitList.add(prefs.setString(FIR_ID, fid ?? ''));
    await Future.wait(waitList);
}

Future<void> clearUserSession() async {
    final waitList = <Future<void>>[];

    SharedPreferences prefs = await SharedPreferences.getInstance();

    waitList.add(prefs.remove(USER_ID));
    waitList.add(prefs.remove(NAME));
    waitList.add(prefs.remove(EMAIL));
    waitList.add(prefs.remove(MOBILE));
    waitList.add(prefs.remove(PROFILE));
    waitList.add(prefs.remove(LANGUAGE));
    waitList.add(prefs.remove(LOGIN));
}


String getToken() {
    final key = KEY;
    final claimSet =
    new JwtClaim(issuer: 'smartapp', maxAge: const Duration(minutes: 5));

    String token = issueJwtHS256(claimSet, key);
    print("token***********1*$key***$token");
    return token;
}

Map<String, String> get headers => {
    "Authorization": 'Bearer ' + getToken(),
};



Future<void> GetSystemConfig() async {

    var parameter = {
        ACCESS_KEY: ACCESS_KEY_VAL,
        system_config: "1",

    };
   
    var response = await http.post(Uri.parse(BASE_URL), body: parameter );

    var getdata = json.decode(response.body);

    String error = getdata["error"];

    if (error == "false") {
        APP_LINK = getdata["data"][KEY_APP_LINK];
        //LANGUAGE_MODE = getdata["data"][KEY_LANGUAGE_MODE];
        //OPTION_E_MODE = getdata["data"][KEY_OPTION_E_MODE];
        setPrefrenceBool(E_MODE, false);

        SHARE_APP_TEXT = getdata["data"][KEY_SHARE_TEXT];
        Constant.MAX_QUE_PER_LEVEL = int.parse(getdata["data"][TOTAL_QUESTION]);
        Constant.TIME_PER_QUESTION = int.parse(getdata["data"][TOTAL_TIME]);
        Constant.CURRENCYSYMBOL = getdata["data"][CURRENCY];
        KEY=getdata['data']['key'];
        Constant.FlutterWaveCurrencySymbol = getdata["data"][CURRENCY];
        Constant.CURRENCYCODE = getdata["data"][CURRENCY_CODE];
        Constant.COUNTRY = getdata["data"][COUNTRY];
        Constant.FlutterwaveCurrency = getdata["data"][CURRENCY_CODE];
        Constant.FlutterwaveCountry = getdata["data"][COUNTRY];
        Constant.MINIMUM_WITHDRAW_AMT =
            getdata["data"]['minimun_withdraw_amount'] ?? '';
        Web_URL = getdata["data"]['web_link'] ?? '';
        Constant.REFER_AMOUNT = getdata["data"]['refer_amount'] ?? '1';
        Constant.REFER_EARN_AMOUNT = getdata["data"]['earn_amount'] ?? '1';

        if (getdata['data'][PAYMENT_TYPE] != null) {
            Constant.PAYTYPELIST.clear();
            Constant.PAYTYPELIST = getdata['data'][PAYMENT_TYPE].map((item) => item).toList();

        }



    }
}

