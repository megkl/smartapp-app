
import 'dart:convert';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:http/http.dart';
import 'package:smartapp/Helper/StringRes.dart';

//api constant

//const String Main_URL = "http://quiz.smartappcontest.com/";
const String Main_URL = "https://quiz.smartapp-gaming.com/";
//const String Main_URL = "http://10.0.2.2/quiz.smartapp/";
//var Main_URL = Uri.https("54.172.237.17", "/dashboard");
//const String Main_URL = Uri.http('20.232.135.176:8080','/powerbank_test_server');
  
//const String BASE_URL = Main_URL + "api-v2.php";

String BASE_URL = Main_URL.toString() + "/api-v2.php";

const String PAYPAL_URL = "https://smartapp-gaming.com/payment_api.php?";

const String PAYPAL_RESPONSE_URL = "https://smartapp-gaming.com/success.php";

const String CARD_URL = "https://smartapp-gaming.com/flutterwave_api.php?";

const String CARD_SUCCESS = "https://smartapp-gaming.com/flutterwave_success.php?";

const String de_active_msg = "Your Account is deactivate by admin";
const String act_verify_1 =
    "A Verified link has been sent to your email account";
const String act_verify_2 =
    "Please click on the link that has  been sent to your email account to verify your email and continue the login process.";
const String level_locked = "Level is Locked";
const String completed = "Congratulations!! \n You have completed the level.";
const String not_completed = "Oops!! \n Level not completed.Play again!";
const String title_already_used = "Life Line Already Used !!";
const String msg_lifeline_used = "You can use only once per level";
const String refer_text =
    "Refer a friend and get 1 Kshs for each person that register with your code";
const String refer_copied = "Refer code copied to clipboard";
const String refer1 = "I have earned coins using";
const String refer2 =
    "app. you can also earn coin by downloading app from below link and enter referral code while login-";
const String referMsg =
    "Your refer code not generated please re-login to get your refer code.";

const String LEVEL = "Level : ";
const String OPTIONA = "A";
const String OPTIONB = "B";
const String OPTIONC = "C";
const String OPTIOND = "D";
const String OPTIONE = "E";

//const int MAX_QUE_PER_LEVEL=10;

const int FOR_CORRECT_ANS = 4; // mark for correct answer
const int PENALTY = 2; // minus mark for incorrect
//const int TIME_PER_QUESTION = 25;

const int PASSING_PER =
    30; //count level complete when user give >30 percent correct answer
const int COIN_ONE =
    1; //give  coin when user give 30 to 40 percent correct answer
const int COIN_TWO =
    2; //give  coins when user give 40 to 50 percent correct answer
const int COIN_THREE =
    3; //give  coin when user give 50 to 60 percent correct answer
const int COIN_FOUR =
    4; //give  coin when user give > 60  percent correct answer
const int PAGE_LIMIT = 50;

const String PACKAGE_NAME = "com.quiz.smartapp";

//common variable
int CATE_ID = 0;
int SUB_CAT_ID = 0;
int TotalLevel = 0;
String CATE_NAME = "";
String SUB_CAT_NAME = "";
int RequestlevelNo = 1;
int TOTAL_COINS = 0;
int TOTAL_SCORE = 0;

//String cls_type="privacy";
const String F_CODE = "f_code";
String D_LANG_ID = "-1";
//final FacebookLogin facebookSignIn = new FacebookLogin();

//api parameter constant
const String ACCESS_KEY = "access_key";
const String ACCESS_KEY_VAL = "6808";
const String GET_PRIVACY = "privacy_policy_settings";
const String GET_TERMS = "get_terms_conditions_settings";

const String GET_ABOUT = "get_about_us";
const String UPLOAD_PROFILE_IMAGE = "upload_profile_image";

const String GET_ONEONONE_LEADERBOARD_RANK = "get_one_on_one_leaderboard";
const String GET_GROUPVENT_LEADERBOARD_RANK = "get_group_event_leaderboard";
const String GET_DAILY_LEADERBOARD_RANK = "get_main_event_leaderboard";
const String GET_MEAINEVENT_LEADERBOARD_RANK = "get_mainevent_new_leaderboard";

const String GET_ONEONONEEVENT_LEADERBOARD = "get_one_on_one_for_leaderboard";
const String GET_GROUPEVENT_LEADERBOARD = "get_group_event_for_leaderboard";
const String GET_MEAINEVENT_LEADERBOARD = "get_main_event_for_leaderboard";
const String GET_MAINEVENT_NEW_LEADER = 'get_mainevent_new_for_leaderboard';

const String? GET_QUESTION_BY_ONEONONE_EVENT =
    "get_questions_by_one_on_one_event";
const String GET_TRANSACTION_DETAIL = "get_transaction_detail";
const String REMOVE_MEMBER_GROUP = "remove_member_group";
const String ADD_MEMBER_TO_GROUP_CHAT = "add_member_to_group_chat";
const String SEND_MESSAGE_TO_GROUP = "send_message_to_group";
const String LOAD_ALL_MESSAGE = "load_all_messages";
const String MAIN_EVENT_USER_JOIN = "main_event_user_join";
const String GET_MAIN_EVENT = "get_main_events";
const String GET_GROUP_EVENT = "get_group_events";
const String GET_ONEONONE_EVENT = "get_one_on_one_events";
const String GET_MAIN_EVENT_ROUND = "get_round_by_main_event";
const String GET_MAIN_EVENT_FACEOFROUND = "get_main_event_new";
const String GET_WALLET_DETAIL = "get_wallet_detail";
const String GET_WITHDRAW_DETAIL = "get_withdraw_detail";
const String ELIGIBLE_FOR_ROUND_NEW = "eligible_for_mainevent_new";
const String ELIGIBLE_FOR_GROUPEVENT = "eligible_for_group_event";
const String ELIGIBLE_FOR_ONEONONEEVENT = "eligible_for_one_on_one_event";
const String CHECK_USER = "check_user";
const String SET_USER_PAID_MAIN_EVENT = "set_user_paid_main_event";
const String SET_USER_PAID_MAIN_EVENT_NEW = "set_user_paid_mainevent_new";

const String SET_USER_PAID_GROUP_EVENT = "set_user_paid_group_event";
const String SET_USER_PAID_ONEONONE_EVENT = "set_user_paid_one_on_one_event";
const String ADD_WALLET_DATA = "add_wallet_data";
const String UPDATE_PROFILE = "update_profile";
const String USER_SIGNUP = "user_signup";
const String Get_QuestionBYRound = "get_questions_by_round";
const String Get_QuestionBYGroupEvent = "get_questions_by_group_event";
const String SET_MAIN_EVENT_SCORE = "set_main_event_score";
const String SET_ONEONONE_EVENT_SCORE = "set_one_on_one_event_score";
const String SET_GROUP_EVENT_SCORE = "set_group_event_score";
const String PAYMENT_REQUEST = "payment_request";
const String FORGOT_PWD = 'forget_password';
const String GET_NOTIFICATION = 'get_notifications';

const String MAIN_EVENT_NEW = 'get_main_event_new';
const String ELIGIBLE_FOR_ROUND = "eligible_for_main_event";
//const String GET_MAIN_EVENT_FACEOFROUND = "get_4th_round_by_main_event";

const String STATUS = "status";
const String EVENT_NAME = "event_name";
const String EVENT_ID = "event_id";
const String EVENT_DATE = "event_date";
const String MATCH_ID = "match_id";
const String OPPONENT_ID = "opponent_id";
const String DESTROY_MATCH = "destroy_match";
const String DETAIL = "detail";
const String REQUEST_AMOUNT = "request_amount";
const String REQUEST_TYPE = "request_type";
const String TOTAL_QUESTION = "total_question";
const String TOTAL_TIME = "total_time";
const String AMOUNT = "amount";
const String TRANSACTION_ID = "transaction_id";
const String SCORE = "score";
const String IS_PAID = "is_paid";
const String CORRECT_ANSWERS = "correct_answers";
const String INCORRECT_ANSWERS = "incorrect_answers";
const String ATTEMPT_QUESTION = "attempt_question";
const String ROUND_ID = "round_id";
const String COUNT = "count";
const String ROUND = "round";
const String TIME = "time";
const String TOTAL_QUESTIONS = "total_questions";
const String MAIN_EVENT = "main_event";
const String MAIN_EVENT_ID = "main_event_id";
const String GROUP_EVENT_ID = "group_event_id";
const String TIME_ID = "time_id";
const String EMAIL = "email";
const String LMOBILE = "mobile";
const String NAME = "name";
const String profile = "profile";
const String FCMID = "fcm_id";
const String TYPE = "type";
const String IS_ADD = "is_add";
const String REFER_CODE = "refer_code";
const String FRIEND_CODE = "friends_code";
const String IPADDRESS = "ip_address";
const String status = "status";
const String active = "1";
const String get_categories = "get_categories";
const String GET_LANGUAGES = "get_languages";

const String PASSWORD = 'password';
const String ORDER = "order";
const String COINS = "coins";
const String userId = "user_id";
const String ID = "id";
const String CATEGORY_NAME = "category_name";
const String IMAGE = "image";
const String MAX_LEVEL = "maxlevel";
const String NO_OF_CATE = "no_of";
const String getSubCategory = "get_subcategory_by_maincategory";
const String categoryId = "main_id";
const String SUBCAT_NAME = "subcategory_name";
const String LANG_ID = "language_id";
const String MAIN_CAT_ID = "maincat_id";
const String NOTE = "note";
const String QUESTION = "question";
const String LEVEL1 = "level";
const String ANSWER = "answer";
const String OPTION_A = "optiona";
const String OPTION_B = "optionb";
const String OPTION_C = "optionc";
const String OPTION_D = "optiond";
const String OPTION_E = "optione";
const String CATEGORY = "category";
const String SUB_CAT = "subcategory";
const String system_config = "get_system_configurations";
const String event_config = "get_event_configurations";
const String eType = 'event_type';

const String KEY_APP_LINK = "app_link";
const String KEY_APP_LINK2 = "key";
const String KEY_LANGUAGE_MODE = "language_mode";
const String KEY_OPTION_E_MODE = "option_e_mode";
const String KEY_APP_VERSION = "app_version";
const String KEY_SHARE_TEXT = "shareapp_text";
const String CURRENCY = "currency";
const String CURRENCY_CODE = "currency_code";
const String COUNTRY = "country";
const String PAYMENT_TYPE = "payment_type";
const String FLT_TOKEN = "flutter_quiz_token";
const String FCM_ID = "fcm_id";
const String UPDATE_FCM_ID = "update_fcm_id";
const String SET_MONTH_LEADERBOARD = "set_monthly_leaderboard";
const String SET_USER_STATISTICS = "set_users_statistics";
const String GET_USER_STATISTICS = "get_users_statistics";
const String QUESTION_ANSWERED = "questions_answered";
const String RATIO = "ratio";
const String CAT_ID = "category_id";
const String IS_LAST_LEVEL_COMPLETED = "is_last_level_completed";

const String GET_GLOBAL_LB = "get_global_leaderboard";
const String GET_DAILY_LB = "get_datewise_leaderboard";
const String GET_MONTHLY_LB = "get_monthly_leaderboard";
const String SET_MONTHLY_LB = "set_monthly_leaderboard";
const String DATE = "date";
const String OFFSET = "offset";
const String LIMIT = "limit";
const String STARTING = "starting";
const String RANK = "rank";
const String FROM = "from";
const String TO = "to";
const GLOBAL_SCORE = "all_time_score";
const String GLOBAL_RANK = "all_time_rank";
const String STRONG_CATE = "strong_category";
const String WEAK_CATE = "weak_category";
const String RATIO_1 = "ratio1";
const String RATIO_2 = "ratio2";
const String TITLE = "title";
const String MESSAGE = "message";
const String GET_ABOUTUS = "get_about_us";
const String GET_USER_BY_ID = "get_user_by_id";
const String GET_NOTIFICATIONS = "get_notifications";

String APP_LINK = "http://play.google.com/store/apps/details?id=";
String MORE_APP_URL = "https://play.google.com/store/apps/developer?id=";
String Web_URL = Main_URL.toString();
String IOS_URL = Main_URL.toString();

String LANGUAGE_MODE = "";
String OPTION_E_MODE = "";
String SHARE_APP_TEXT = "";
String KEY = "";

class Constant {
  static AssetsAudioPlayer? assetsBackgorundPlayer,
      assetsTimerPlayer,
      rightsound,
      wrongsound,
      timerendsound;

  static String cls_type = "";
  static List<dynamic> PAYTYPELIST = [];
  static String CURRENCYSYMBOL = "KSh";
  static String FlutterWaveCurrencySymbol = "KSh";
  static String CURRENCYCODE = "KES";
  static String COUNTRY = "KE";
  static String FlutterwaveCurrency = "KES";
  static String FlutterwaveCountry = "KE";
  static int MAX_QUE_PER_LEVEL = 10;
  static int FindMatchSecond = 10;
  static int TIME_PER_QUESTION = 25;
  static int LOAD_DATA_LIMIT = 10;
  static String REFER_AMOUNT = "1";
  static String REFER_EARN_AMOUNT = "1";
  static String MINIMUM_WITHDRAW_AMT = "1";

  //static String mpesatesturl = "https://ravesandboxapi.flutterwave.com/v3/charges?type=mpesa";
  // static String mpesaliveurl = "https://api.flutterwave.com/v3/charges?type=mpesa";
  // static String FlutterwaveVerifyUrl = "https://api.ravepay.co/flwv3-pug/getpaidx/api/v2/verify";

  static bool isFlutterwaveTest = true;

  //clientid
  // static String FlutterwavePubKey = "FLWPUBK_TEST-aa200332038a448ccbc51c9b4dfb07ae-X";
  // static String FlutterwaveEncKey = "FLWSECK_TESTc28c95946945";
  // static String FlutterwaveSecKey ="FLWSECK_TEST-ec5858caa4e66f7d126f2e8ee51baaa2-X";

  static String lblgroupevent = "GroupEvent";
  static String lbloneononeevent = "OneOnOneEvent";
  static String lblmainevent = "MainEvent";
  static String lblDaily = "DaillyEvent";
  static String lblWallet = 'Wallet';

  static String lblPractice = "Practice";

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;

  static String notification_chat = "chat";
  static String notification_main = "MainEvent";
  static String notification_group = "GroupEvent";
  static String notification_simple = "notifications";
  static String notification_mainleaderboard = "MainEventLeaderboard";
  static String notification_groupleaderboard = "GroupEventLeaderboard";

  //wrteam02id
  /*static String FlutterwavePubKey = "FLWPUBK_TEST-19703bf65ef01fd664e68631423e51f5-X";
  static String FlutterwaveEncKey = "FLWSECK_TEST9dd3c49c7b56";
  static String FlutterwaveSecKey = "FLWSECK_TEST-3b1cb0fdc47d03e031c6c1ca6ae72760-X";*/

  static String dttoday = DateFormat('ddMMyyyy').format(
      DateTime.fromMillisecondsSinceEpoch(
          int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
  static String dtyesterday = DateFormat('ddMMyyyy').format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now()
          .add(new Duration(days: -1))
          .millisecondsSinceEpoch
          .toString())));

  static SetCurrentDateData() {
    dttoday = DateFormat('ddMMyyyy').format(DateTime.fromMillisecondsSinceEpoch(
        int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
    dtyesterday = DateFormat('ddMMyyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now()
            .add(new Duration(days: -1))
            .millisecondsSinceEpoch
            .toString())));
  }

  static String setFirstLetterUppercase(String value) {
    return value.isEmpty
        ? ""
        : "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }

  static Future<bool> CheckInternet() async {
    bool check = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      //print("===check==true");
      // return true;
      check = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      //print("===check=***=true");
      //return true;
      check = true;
    }
    //print("===check==false");
    //return false;
    return check;
  }

  static Future<bool> CheckNewUser(
      String email, String phone, String type) async {
    Map<String, String> body = {
      CHECK_USER: "1",
      EMAIL: email,
      LMOBILE: phone,
      TYPE: type,
    };

    var response = await Constant.getApiData(body);

    final res = json.decode(response);

    String isnew = res['isnew'].toString();
    if (isnew.toLowerCase() == "true") {
      return true;
    } else {
      return false;
    }
  }

  static String DisplayMsgTime(String senddate) {
    String msgdate = DateFormat('ddMMyyyy').format(DateTime.parse(senddate));
    if (msgdate == dttoday) {
      return DateFormat('hh:mm a').format(DateTime.parse(senddate));
    } else if (msgdate == dtyesterday) {
      return StringRes.yesterday;
    } else {
      return DateFormat('dd/MM/yy').format(DateTime.parse(senddate));
    }
  }

  static Future getApiData(Map<String?, String?> body) async {
    body[ACCESS_KEY] = ACCESS_KEY_VAL;

    Response response = await post(Uri.parse(BASE_URL),
        body: body, headers: headers
        /*headers: {
        "accept": "application/json",
        "Authorization": "Bearer " + token
      },*/
        );

    if (response.statusCode == 200) {
      return response.body;
    } else {}
  }

  static Future postApiImage(
      File file, BuildContext context, String userid) async {
    var request = http.MultipartRequest('POST', Uri.parse(BASE_URL));
    request.fields[ACCESS_KEY] = ACCESS_KEY_VAL;
    request.fields[UPLOAD_PROFILE_IMAGE] = "1";
    request.fields[userId] = userid;
    request.headers.addAll(headers);
    var pic = await http.MultipartFile.fromPath(IMAGE, file.path);
    request.files.add(pic);
    var res = await request.send();

    var responseData = await res.stream.toBytes();
    var response = String.fromCharCodes(responseData);

    if (res.statusCode == 200) {
      return response;
    } else {}
  }

  static SetRightWrongSound() {
    if (rightsound != null) rightsound = null;
    if (wrongsound != null) wrongsound = null;

    rightsound = AssetsAudioPlayer();
    rightsound!.open(
        Audio(
          "assets/audios/rightsound.wav",
        ),
        autoStart: false);
    wrongsound = AssetsAudioPlayer();
    wrongsound!.open(
        Audio(
          "assets/audios/wrongsound.wav",
        ),
        autoStart: false);
  }

  static Future<void> PlayRightWrongSound(bool isright) async {
    bool? othersound = await getPrefrenceBool(OtherSound);
    if (othersound == null) {
      othersound = true;
      setPrefrenceBool(OtherSound, othersound);
    }

    if (othersound) {
      if (rightsound == null || wrongsound == null) SetRightWrongSound();
      if (isright) {
        rightsound!.play();
      } else {
        wrongsound!.play();
      }
    }
  }

  static Future<void> PlayTimerEndSound(bool isplayendtime) async {
    bool? istimer = await getPrefrenceBool(TimerSound);
    if (istimer == null) {
      istimer = true;
      setPrefrenceBool(TimerSound, istimer);
    }

    if (istimer) {
      if (timerendsound == null) {
        timerendsound = AssetsAudioPlayer();
        timerendsound!.open(Audio(
          "assets/audios/timerendticker.mp3",
        ));
      }

      assetsTimerPlayer!.stop();

      if (isplayendtime) {
        timerendsound!.play();
      } else {
        timerendsound!.stop();
      }
    }
  }

  static Future<void> PlayBGMusic(bool isbg, bool istimer, int from) async {
    /*if(isbg) {
      bool bgmusic = await getPrefrenceBool(Backgroundmusic);
      if (bgmusic == null) {
        bgmusic = false;
        setPrefrenceBool(Backgroundmusic, false);
      }


      if (bgmusic) {
        if(assetsBackgorundPlayer != null){
          assetsBackgorundPlayer = null;
        }
        assetsBackgorundPlayer = AssetsAudioPlayer();
        assetsBackgorundPlayer.open(
            Audio("assets/audios/backgroundmusic.mp3",), autoStart: true
        );
        // _assetsBackgorundPlayer.playOrPause();
        //_assetsBackgorundPlayer = null;

        assetsBackgorundPlayer.playlistAudioFinished.listen((data) {
          print("playlistAudioFinished : $data");
          if (assetsBackgorundPlayer != null)
            assetsBackgorundPlayer.play();
        });
      }
    }*/

    if (istimer) {
      bool? timermusic = await getPrefrenceBool(TimerSound);
      if (timermusic == null) {
        timermusic = true;
        setPrefrenceBool(TimerSound, true);
      }

      if (timermusic) {
        /*if(assetsTimerPlayer != null){
          assetsTimerPlayer = null;
        }*/
        if (assetsTimerPlayer != null) {
          assetsTimerPlayer!.play();
        } else {
          assetsTimerPlayer = null;
          assetsTimerPlayer = AssetsAudioPlayer();
          assetsTimerPlayer!.open(
              Audio(
                "assets/audios/${GetTimerName(from)}.mp3",
              ),
              autoStart: true);
          // _assetsTimerPlayer.playOrPause();
          //_assetsTimerPlayer = null;
        }
        assetsTimerPlayer!.playlistAudioFinished.listen((data) {
          if (assetsTimerPlayer != null) assetsTimerPlayer!.play();
        });
      }
    }
  }

  static String? GetTimerName(int from) {
    if (from == 4) {
      return "timer_oneonone";
    } else if (from == 3) {
      return "timer_groupevent";
    } else if (from == 2) {
      return "timer_faceof";
    } else if (from == 1) {
      return "timer_mainevent";
    }
    return null;
  }

  static void StopBgMusic(bool isbg, bool istimer) {
    if (isbg && assetsBackgorundPlayer != null) {
      assetsBackgorundPlayer!.stop();
      assetsBackgorundPlayer = null;
    }
    if (istimer) {
      if (assetsTimerPlayer != null) {
        assetsTimerPlayer!.stop();
        assetsTimerPlayer = null;
      }
      if (timerendsound != null) {
        timerendsound!.stop();
        timerendsound = null;
      }
    }
  }

  static String validateEmail(String value) {
    Pattern pattern =
        r'/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return '';
  }

  static String validateMobile(String value) {
    if (value.length < 6 || value.length > 14)
      return 'Enter Valid MobileNumber';
    else
      return '';
  }
}
