import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:smartapp/Helper/Color.dart';

import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Helper/loading.dart';
import 'package:smartapp/Helper/sign_in_dialog.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/AddMoney.dart';
import 'package:smartapp/activity/payments.dart';
import 'package:smartapp/services/authentication.dart';

import 'HomeActivity.dart';
import 'Privacy_Policy.dart';
import 'ProfileActivity.dart';

//import '../services/authentication.dart';
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class Login extends StatefulWidget {
  final BaseAuth? auth;

  Login({this.auth});

  @override
  Animated_LoginState createState() => Animated_LoginState();
}

class Animated_LoginState extends State<Login> with TickerProviderStateMixin {
  AnimationController? _animationController;
  AnimationController? _signUpAnimationController;
  Animation<double>? _signUpAnimation;
  AnimationController? _signInAnimationController;
  Animation<double>? _signInAnimation;
  String? _email;
  String? _password;
  bool? _isLoading;
  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String phoneNo = "";
  String smsOTP = "";
  String? verificationId;
  String cCode = "+254", phoneNumber = "", cName = "Kenya";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController phoneController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20));

    _signUpAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));

    _signInAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    countryController.text = cCode;

    Future.delayed(Duration.zero, () {
      _signUpAnimation =
          Tween(begin: MediaQuery.of(context).size.height, end: 420.0).animate(
              _signUpAnimationController!
                  .drive(CurveTween(curve: Curves.easeOut)))
            ..addListener(() {
              setState(() {});
            })
            ..addStatusListener((animationStatus) {
              if (animationStatus == AnimationStatus.completed) {
                _signInAnimationController!.forward();
              }
            });

      _signInAnimation = Tween(begin: -32.0, end: 16.0).animate(
          _signInAnimationController!.drive(CurveTween(curve: Curves.easeOut)))
        ..addListener(() {
          setState(() {});
        });
    });

    _animationController!.forward();

    _signUpAnimationController!.forward();

    _errorMessage = "";
    _isLoading = false;

    GetSystemConfig();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    /*return Future.delayed(Duration.zero, () {
      _handleOnTabBackButton();
    });*/

    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightSpace = size.width / 10;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: white,
          key: _scaffoldKey,
          body: SingleChildScrollView(
            child: Container(
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
                  Colors.white,
                  Colors.white,

                  //Colors.indigo[100],

                  // Colors.blue,

                  // Colors.indigo[400]
                ],
              )),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      child: Image(
                        image: AssetImage("assets/images/jibupesa.png"),
                        height: (270 / 896) * size.height * 0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: heightSpace,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    //color: primary,
                    child: AutoSizeText(
                      "Sign in to become a member and contest to win BIG !!",
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: orangeTheme, fontWeight: FontWeight.bold)
                    ),
                  ),
                  SizedBox(
                    height: 50
                  ),
                  buildPhoneTextField(),
                  Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Center(
                            //   child: Text(
                            //     "Select Country",
                            //     style: kTextNormalStyle.apply(
                            //       color: Colors.black54,
                            //     ),
                            //   ),
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Container(
                                //     /*
                                //     width: 67.0,
                                //     height: 47.0,*/
                                //     alignment: Alignment.center,
                                //     decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.only(
                                //         topLeft: Radius.circular(10),
                                //         bottomLeft: Radius.circular(10),
                                //       ),
                                //       color: Colors.grey[200],
                                //     ),
                                //     child: Theme(
                                //       data: ThemeData.light().copyWith(
                                //           colorScheme: ColorScheme.light(
                                //         primary: Colors.black,
                                //       )),
                                //       child: CountryListPick(
                                //         appBar: AppBar(
                                //           title: Text("Select Country"),
                                //           brightness: Brightness.light,
                                //           backgroundColor: primary,
                                //         ),
                                //         theme: CountryTheme(
                                //           isShowFlag: true,
                                //           isShowTitle: false,
                                //           isShowCode: false,
                                //           isDownIcon: false,
                                //           showEnglishName: true,
                                //         ),
                                //         initialSelection: "+254",
                                //         // countryBuilder: _buildDropdownItem(Country),
                                //         onChanged: (CountryCode code) {
                                //           setState(() {
                                //             cCode = code.dialCode;
                                //             cName = code.name;
                                //             countryController.text = cCode;
                                //             // print(code.name);
                                //             // print(code.code);
                                //             // print(code.dialCode);
                                //             // print(code.flagUri);
                                //           });
                                //         },
                                //       ),
                                //     )),
                                // /* Flexible(
                                //     child: Icon(Icons.keyboard_arrow_down),
                                //   ), */
                                SizedBox(
                                  width: 15.0,
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 2.0),
                                //   child: Text(
                                //     "$cName",
                                //     textAlign: TextAlign.center,
                                //     style: kTextNormalStyle.apply(
                                //       color: primary,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            // Text(
                            //   "Enter Mobile Number",
                            //   textAlign: TextAlign.center,
                            //   style: kTextNormalStyle.apply(
                            //     color: black,
                            //   ),
                            // ),
                            SizedBox(
                              height: 20.0,
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Container(
                            //       decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.only(
                            //           topLeft: Radius.circular(10),
                            //           bottomLeft: Radius.circular(10),
                            //         ),
                            //         color: Colors.grey[200],
                            //       ),
                            //       width: 70.0,
                            //       child: TextFormField(
                            //         decoration: new InputDecoration(
                            //           border: InputBorder.none,
                            //           focusedBorder: InputBorder.none,
                            //           enabledBorder: InputBorder.none,
                            //           errorBorder: InputBorder.none,
                            //           disabledBorder: InputBorder.none,
                            //           // contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            //         ),
                            //         textAlign: TextAlign.center,
                            //         readOnly: true,
                            //         controller: countryController,
                            //         keyboardType: TextInputType.phone,
                            //         style: kTextNormalStyle.apply(
                            //           color: Colors.black87,
                            //         ),
                            //         //onEditingComplete: checkCorporateNo,
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width: 5.0,
                            //     ),
                            //     Expanded(
                            //       child: Container(
                            //         child: TextFormField(
                            //           decoration: new InputDecoration(
                            //               hintText: "7xxxxxxxx",
                            //               hintStyle: kTextHeadStyle.apply(
                            //                 color: primary,
                            //               ),
                            //               border: InputBorder.none,
                            //               focusedBorder: InputBorder.none,
                            //               enabledBorder: InputBorder.none,
                            //               errorBorder: InputBorder.none,
                            //               disabledBorder: InputBorder.none,
                            //               counterText: ""
                            //               // contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                            //               ),
                            //           keyboardType: TextInputType.phone,
                            //           style: kTextHeadStyle.apply(
                            //             color: primary,
                            //           ),
                            //           maxLength: 11,
                            //           controller: phoneController,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          
                          ])),

                  SizedBox(
                    height: heightSpace,
                  ),
                  Visibility(
                    visible: _isLoading!,
                    child: Column(
                      children: [
                        CircularProgressIndicator(
                          color: orangeTheme,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                  _showSocialMedia(),
                  SizedBox(
                    height: heightSpace,
                  ),
                  showErrorMessage(),
               
                ],
              ),
            ),
          )),
    );
  }
  buildPhoneTextField() {
    return Row(
        children: <Widget>[
          Container(
            width: 120,
            child: CountryListPick(
                // To disable option set to false
                theme: CountryTheme(
                  alphabetSelectedBackgroundColor: primary,
                  isShowFlag: true,
                  isShowTitle: false,
                  isShowCode: true,
                  isDownIcon: false,
                  showEnglishName: true,
                ),
                initialSelection: '+254',
                onChanged: (CountryCode? code) {
                  cCode = code!.dialCode!;
                },
                useUiOverlay: true,
                useSafeArea: false),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    border:OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: primary,
                ),
              ),
                    filled: false,
                    labelText: "Enter Mobile Number",
                    hintText: "712******",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  )),
            ),
          )
        ],
    );
  }

  showPhoneSignIn() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 0),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: SignInDialog(
              title: 'Mobile Number SignIn',
              iconImage: Icon(
                Icons.phone_android_rounded,
                size: 40,
              ),
              labelText: '',
              color: redgradient2,
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Container();
      },
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value.trim()))
      return 'Enter Valid Email';
    else
      return '';
  }

  String validatePassword(String value) {
    if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }
    return '';
  }

  Future printIps() async {
    for (var interface in await NetworkInterface.list()) {
      // print('== Interface: ${interface.name} ==');
      for (var addr in interface.addresses) {
        print(
            '${addr.address} ${addr.host} ${addr.isLoopback} ${addr.rawAddress} ${addr.type.name}');
      }
    }
  }

  Future<void> USER_SIGNUPWithSocialMedia(
      final String? fCode,
      String? referCode,
      final String? uname,
      final String? uemail,
      final String? profile,
      final String? atype,
      final String? mobile,
      final String? fid) async {
    if (_isLoading == false) {
      setState(() {
        _isLoading = true;
      });
    }

    String fcm = await getPrefrence(FCM) ?? "";
    String ipAddress = await IpAddress().getIp();
    print("Ip address");
    print(ipAddress);
    referCode = referCode!.replaceAll(".", "").trim();

    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      USER_SIGNUP: "1",
      NAME: uname,
      EMAIL: uemail,
      TYPE: atype ?? '',
      FCMID: fcm,
      REFER_CODE: referCode,
      FRIEND_CODE: fCode ?? '',
      IPADDRESS: ipAddress,
      PROFILE: profile ?? '',
      FIR_ID: fid ?? ''
    };

    if (mobile!.trim().isNotEmpty) {
      parameter[LMOBILE] = mobile;
      //parameter[LMOBILE] = mobile.replaceAll("+", "");
    }

    var response =
        await http.post(Uri.parse(BASE_URL), body: parameter, headers: headers);

    var getdata = json.decode(response.body);

    String error = getdata["error"];

    if (error == ("false")) {
      var data = getdata["data"];

      UserModel user = new UserModel.fromJson(data);

      if (user.status == active) {
        saveUserDetail(user.user_id!, user.name!, user.email!, user.mobile!,
            user.profile!, referCode, atype!, user.location??'', user.fid??'');

        User curuser = FirebaseAuth.instance.currentUser!;

        FirebaseDatabase.instance
            .ref()
            .child("user")
            .child(curuser.uid)
            .set({
          "name": user.name,
          "email": user.email,
          "profile": user.profile,
          "user_id": user.user_id,
          "type": user.type
        });

        await GetUserStatus();
        setState(() {
          _isLoading = false;
        });

        //Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, anim1, anim2) => HomeActivity(auth: widget.auth)),);
        if (curuser.email == null ||
            curuser.email!.isEmpty ||
            curuser.email == "") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      ProfileActivity(isFirst: true, auth: widget.auth)),
              (Route<dynamic> route) => false);
        } else {
          try {
            if (UserModel.amount! < 50) {
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
          } catch (e) {
            setSnackbar("Something went wrong..");
          }
        }
      } else {
        setSnackbar(de_active_msg);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (widget.auth != null) widget.auth!.signOut();
      setState(() {
        _isLoading = false;
      });
      String msg = getdata["message"];
      setSnackbar(msg);
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

    String error = getdata["error"] ?? '';

    if (error == ("false")) {
      String status = getdata["data"]["status"];

      if (status != active) {
        clearUserSession();
        widget.auth!.signOut();

        //facebookSignIn.logOut();
      } else {
        uamount = getdata['data']['amount'];
        try {
          double amount = double.parse(uamount!.replaceAll(",", "").trim());
          UserModel.amount = amount;
        } catch (e) {}
      }
    }
  }

  loadingOverlay() {
    return showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 0),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
            scale: CurvedAnimation(
                parent: a1,
                curve: Curves.elasticOut,
                reverseCurve: Curves.easeOutCubic),
            child: LoadingOverlay());
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return Container();
      },
    );
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.red,
          content: Text(msg),
          duration: Duration(seconds: 10),
          key: scaffoldKey),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _showSocialMedia() {
    double top = _signUpAnimation?.value ?? double.maxFinite;
    return Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 60),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: StadiumBorder(), backgroundColor: primary),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                'SIGN IN',
                style: kTextNormalBoldStyle.apply(color: Colors.white),
              )),
          onPressed: () {
            if (phoneController.text.isNotEmpty && cCode.isNotEmpty) {
              phoneNo = cCode + phoneController.text;
              verifyPhone();
            } else {
              print("empty");
            }
          },
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage!.length > 0 && _errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Text(
          _errorMessage!,
          style: TextStyle(
            fontSize: 13.0,
            color: white,
            height: 1.0,
          ),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Future<void> verifyPhone() async {
    setState(() {
      _isLoading = true;
    });
    final PhoneCodeSent smsOTPSent = (String verId, [int? forceCodeResend]) {
      this.verificationId = verId;
      setState(() {
        _isLoading = false;
        _errorMessage = "";
      });

      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              //backgroundColor: ColorsRes.Grey_primary,
              child: smsOTPDialog(),
            );
          });
    };
    try {
      print("verifying phone number 1");
      if (phoneNo.substring(4, 5) == "0") {
        phoneNo = phoneNo.replaceFirst(RegExp('0'), '');
      }
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo,
          // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          // smsOTPSent,
          // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          // verificationCompleted: (AuthCredential phoneAuthCredential) {
          //  // print("verifying phone number 2 ${phoneAuthCredential.providerId}");
          //   setState(() {
          //     _isLoading = false;
          //   });
          // },
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Navigator.of(context).pop();

            var result = await _auth.signInWithCredential(credential);
            // await auth.signInWithCredential(credential);
            var user = result.user;

            if (user != null) {
              // Navigator.push(context, MaterialPageRoute(
              //   builder: (context) => HomeScreen(user: user,)
              // ));
              PhoneLoginSuccess(result.user!);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeActivity(
                      auth: widget.auth,
                    ),
                  ));
              Fluttertoast.showToast(
                msg: "Sign in Successfully",
                backgroundColor: Colors.green,
                textColor: Colors.white,
                gravity: ToastGravity.CENTER,
              );
            } else {
              print("Error");
            }

            if (_auth.currentUser != null) {
              // Navigator.of(context).pop();
              print("auth success authentication 1");
              //Navigator.of(context).pushReplacementNamed('/homepage');
              PhoneLoginSuccess(_auth.currentUser!);
            } else {
              print("auth success authentication 2");
              // signInWithPhone();

              await _auth.signInWithCredential(credential);
              if (result.user != null) {
                PhoneLoginSuccess(_auth.currentUser!);
              } else {
                Fluttertoast.showToast(
                  msg: "Failed Try Again Later",
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  gravity: ToastGravity.CENTER,
                );
              }
              //   try {
              //     final AuthCredential credential = PhoneAuthProvider.credential(
              //       verificationId: verificationId,
              //       smsCode: smsOTP,
              //     );
              //     //final FirebaseUser user = await _auth.signInWithCredential(credential);
              //     final User user =
              //         (await _auth.signInWithCredential(credential)).user;
              //     final User currentUser = await _auth.currentUser;
              //     assert(user.uid == currentUser.uid);
              //     // Navigator.of(context).pop();
              //     //Navigator.of(context).pushReplacementNamed('/homepage');
              //     PhoneLoginSuccess(user);
              //   } catch (e) {
              //     handleError(e);
              //   }
            }
            //This callback would gets called when verification is done auto maticlly
          },
          verificationFailed: (Exception exceptio) {
            print("verifying phone number 3 ${exceptio.toString()}");
            setState(() {
              _isLoading = false;
              _errorMessage = exceptio.toString();
            });
          });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      handleError(e);
    }
  }

  Widget smsOTPDialog() {
    String errmsg = "";
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              'Enter SMS Code',
              style: Theme.of(context).textTheme.titleMedium?.merge(
                  TextStyle(color: appcolor, fontWeight: FontWeight.bold)),
            ),
            Text(
              'We Sent SMS on ${this.phoneNo}',
              style: TextStyle(color: primary),
            ),
            TextField(
              onChanged: (value) {
                this.smsOTP = value;
                // this.smsOTP.trim()
              },
              keyboardType: TextInputType.number,
              style: TextStyle(color: primary),
            ),
            errmsg != ''
                ? Text(
                    errmsg,
                    style: TextStyle(color: Colors.red),
                  )
                : Container(),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selection,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      if (this.smsOTP.trim().isEmpty) {
                        setState(() {
                          errmsg = "Enter OTP";
                        });
                      } else {
                        if (_auth.currentUser != null) {
                          Navigator.of(context).pop();
                          print("auth success authentication 1");
                          //Navigator.of(context).pushReplacementNamed('/homepage');
                          PhoneLoginSuccess(_auth.currentUser!);
                        } else {
                          print("auth success authentication 2");
                          signInWithPhone();
                        }
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
          ]),
        ),
      );
    });
  }

  Widget PhoneNumberialog() {
    String errmsg = "";
    String countrycode = "254", phno = "";
    this.phoneNo = "";
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Login with Phone Number',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.merge(TextStyle(color: appcolor, fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "+",
                  style: TextStyle(color: primary),
                ),
                Expanded(
                  flex: 1,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Code', hintStyle: TextStyle(color: grey)),
                    style: TextStyle(color: primary),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursorColor: appcolor,
                    onChanged: (value) {
                      countrycode = value;
                    },
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    style: TextStyle(color: primary),
                    decoration: InputDecoration(
                        hintText: 'Enter Phone number',
                        hintStyle: TextStyle(color: grey)),
                    keyboardType: TextInputType.number,
                    cursorColor: appcolor,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      phno = value;
                    },
                  ),
                ),
              ],
            ),
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
                    if (countrycode.trim().isEmpty) {
                      setState(() {
                        errmsg = "Enter Country Code";
                      });
                    } else if (phno.trim().isEmpty ||
                        Constant.validateMobile(phno) != null) {
                      setState(() {
                        errmsg = "Enter Valid Phone number";
                      });
                    } else {
                      Navigator.of(context).pop();
                      String number = "+$countrycode$phno";

                      this.phoneNo = number;
                      print("verifying phone number 0");
                      verifyPhone();
                    }
                  },
                  child: Text(
                    'Verify',
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

  signInWithPhone() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsOTP,
      );
      //final FirebaseUser user = await _auth.signInWithCredential(credential);
      final User user = (await _auth.signInWithCredential(credential)).user!;
      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);
      // Navigator.of(context).pop();
      //Navigator.of(context).pushReplacementNamed('/homepage');
      PhoneLoginSuccess(user);
    } catch (e) {
      //handleError(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Invalid code entered or request failed. Please try again."),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future<void> PhoneLoginSuccess(User user) async {
    bool checknewuser =
        await Constant.CheckNewUser("", this.phoneNo, StringRes.L_PHONE);
    //if (authResult.additionalUserInfo.isNewUser) {
    if (checknewuser) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print("verifying phone number 5");
      showTermDialog(context, '', '', '', '', '', phoneNo,
          this.USER_SIGNUPWithSocialMedia);
    } else {
      print("verifying phone number 6");
      USER_SIGNUPWithSocialMedia("", this.phoneNo, "", "", "",
          StringRes.L_PHONE, this.phoneNo, user.uid);
    }
  }

  handleError(error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          _errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();

        showDialog(
            context: context,
            builder: (context) {
              print("verifying phone number 4 ");
              return Dialog(
                //backgroundColor: ColorsRes.Grey_primary,
                child: smsOTPDialog(),
              );
            });

        break;
      default:
        setState(() {
          _errorMessage = error.message;
        });

        break;
    }
  }

  orText() {
    return Text(
      "OR",
      style: TextStyle(color: white),
    );
  }
}

class ShowReferDialog extends StatefulWidget {
  String refercode, name, email, profile, type, phoneno, fid;

  Function callback;

  ShowReferDialog(this.refercode, this.name, this.email, this.profile,
      this.type, this.phoneno, this.callback, this.fid);

  @override
  _MyDialogState createState() => new _MyDialogState(
      this.refercode,
      this.name,
      this.email,
      this.profile,
      this.type,
      this.phoneno,
      this.callback,
      this.fid);
}

class _MyDialogState extends State<ShowReferDialog> {
  String refercode, name, email, profile, type, fid;
  String inputcode = "";
  String phoneno = "";
  Function callback;
  String errmsg = "";

  _MyDialogState(this.refercode, this.name, this.email, this.profile, this.type,
      this.phoneno, this.callback, this.fid);

  @override
  Widget build(BuildContext context) {
    return new CupertinoAlertDialog(
      title: new Text(
        "Apply Referral Code",
        style: TextStyle(fontWeight: FontWeight.bold, color: appcolor),
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
                  child: TextFormField(
                    cursorColor: appcolor,
                    decoration: InputDecoration(
                        hintText: "Referral Code",
                        border: OutlineInputBorder()),
                    onChanged: (String value) {
                      inputcode = value.trim();
                    },
                    //onSaved: (value) => inputcode = value.trim(),
                  ),
                ),
                errmsg.trim().isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                        child: Text(
                          errmsg,
                          style: TextStyle(
                              color: red, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          )),
      actions: [
        CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "Apply",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              setState(() {
                errmsg = "";
              });
              if (inputcode.trim().isEmpty) {
                setState(() {
                  errmsg = StringRes.refercodemsg;
                });
              } else {
                this.widget.callback(inputcode.trim(), refercode, name, email,
                    profile, type, phoneno, fid);
                Navigator.pop(context, 'Cancel');
              }
            }),
        CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "Skip",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () async {
              this.widget.callback(
                  "", refercode, name, email, profile, type, phoneno, fid);
              Navigator.pop(context);
            }),
      ],
    );
  }
}

class PasswordResetAlertDialog extends StatefulWidget {
  final String? title;
  final FirebaseAuth? auth;

  const PasswordResetAlertDialog({Key? key, this.title, this.auth})
      : super(key: key);

  @override
  PasswordResetAlertDialogState createState() {
    return new PasswordResetAlertDialogState();
  }
}

class PasswordResetAlertDialogState extends State<PasswordResetAlertDialog> {
  final _resetKey = GlobalKey<FormState>();
  final _resetEmailController = TextEditingController();
  String? _resetEmail;
  bool _resetValidate = false;

  //StreamController<bool> rebuild = StreamController<bool>();

  bool _sendResetEmail() {
    _resetEmail = _resetEmailController.text;

    if (_resetKey.currentState!.validate()) {
      _resetKey.currentState!.save();

      try {
        // You could consider using async/await here
        widget.auth!.sendPasswordResetEmail(email: _resetEmail!);
        return true;
      } catch (exception) {
        return false;
      }
    } else {
      setState(() {
        _resetValidate = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: new Text(
          widget.title!,
          style: TextStyle(color: primary),
        ),
        content: new SingleChildScrollView(
          child: Form(
            key: _resetKey,
            // autovalidateMode: _resetValidate == true
            //     ? AutovalidateMode.always
            //     : AutovalidateMode.disabled,
            child: ListBody(
              children: <Widget>[
                Container(
                  child: new Text(
                    'Enter the Email Address associated with your account.',
                    style: TextStyle(fontSize: 14.0, color: primary),
                  ),
                  color: Colors.yellow,
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.email,
                        size: 20.0,
                        color: appcolor,
                      ),
                    ),
                    new Expanded(
                      child: TextFormField(
                        validator: validateEmail,
                        onSaved: (String? val) {
                          _resetEmail = val;
                        },
                        controller: _resetEmailController,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        cursorColor: appcolor,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            contentPadding:
                                EdgeInsets.only(left: 20.0, top: 15.0),
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 14.0)),
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                new Column(children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(
                                width: 0.5, color: Colors.black))),
                  )
                ]),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          new ElevatedButton(
            child: new Text(
              'CANCEL',
              style: TextStyle(color: appcolor),
            ),
            onPressed: () {
              Navigator.of(context).pop("");
            },
          ),
          new ElevatedButton(
            child: new Text(
              'SEND EMAIL',
              style: TextStyle(color: appcolor),
            ),
            onPressed: () {
              if (_sendResetEmail()) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: new Text(
                      "We Sent Reset-Password link to your Verified account",
                      style: TextStyle(color: white),
                    ),
                    backgroundColor: appcolor));
                Navigator.of(context).pop(_resetEmail);
              } else {
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: new Text(
                    "Something Went Wrong",
                    style: TextStyle(color: white),
                  ),
                  backgroundColor: appcolor,
                ));
              }
            },
          ),
        ],
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return "Email is required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }
}

showTermDialog(
    BuildContext context,
    String userName,
    String personName,
    String email,
    String photo,
    String uid,
    String phone,
    Future<void> Function(
            String fCode,
            String referCode,
            String uname,
            String uemail,
            String profile,
            String atype,
            String mobile,
            String fid)
        userSignupwithsocialmedia) {
  return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RichText(
                        text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: StringRes.privacyWarnning,
                          style: TextStyle(color: black)),
                      TextSpan(
                          text: 'Privacy Policy ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: black),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _handleOnPressedPrivacy(context);
                            }),
                      TextSpan(
                          text: StringRes.termWarning,
                          style: TextStyle(color: black)),
                      TextSpan(
                          text: 'Terms and Conditions.',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: black),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              _handleOnPressedTerms(context);
                            }),
                    ])),
                  )
                ],
              ),
            ),
            SimpleDialogOption(
                child: Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 5),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Accept'),
                onPressed: () {
                  Navigator.pop(context);

                  userSignupwithsocialmedia("", '', personName, email, '',
                      StringRes.L_PHONE, phone, uid);
                },
              ),
            )),
          ],
        );
      });
}

void _handleOnPressedPrivacy(BuildContext context) {
  Constant.cls_type = "privacy";
  Navigator.push(
    context,
    PageRouteBuilder(pageBuilder: (context, anim1, anim2) => Privacy_Policy()),
  );
}

void _handleOnPressedTerms(BuildContext context) {
  Constant.cls_type = "terms";
  Navigator.push(
    context,
    PageRouteBuilder(pageBuilder: (context, anim1, anim2) => Privacy_Policy()),
  );
}
