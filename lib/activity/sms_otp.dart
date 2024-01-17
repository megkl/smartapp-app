import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/payments.dart';
import 'package:http/http.dart' as http;
import 'package:smartapp/services/authentication.dart';


import 'HomeActivity.dart';
import 'ProfileActivity.dart';

class SmsOtp extends StatefulWidget{
  final String? mobileNumber;
  final BaseAuth? auth;


  const SmsOtp({Key? key, this.mobileNumber,this.auth}) : super(key: key);

  SmsOtpState createState()=>SmsOtpState();

}

class SmsOtpState extends State<SmsOtp> {

  String? smsOTP = "";
  String? verificationId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightSpace = size.width / 10;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        //brightness: Brightness.dark,
        title: Text("OTP Verification"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/images/jibupesa.png"),
              height: (270 / 896) * size.height,
            ),
            AutoSizeText(
              "SmartApp",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kTextHeadBoldStyle.apply(color: primary),
            ),
            SizedBox(height: heightSpace/2,),
            AutoSizeText(
              " OTP Verification Code\n has been set to mobile number\n ${widget.mobileNumber}",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: kTextHeadBoldStyle.apply(color: orangeTheme),
            ),

            // Padding(
            //   padding: EdgeInsets.only(left: 10, top: 10, right: 10),
            //   child: PinFieldAutoFill(
            //     codeLength: 6,
            //     decoration: UnderlineDecoration(
            //         colorBuilder: FixedColorBuilder(Colors.black),
            //         textStyle: TextStyle(fontSize: 20, color: Colors.black)),
            //     //currentCode: pinS,
            //     onCodeChanged: (val) {
            //       if (val != null) {
            //         if (val.length == 6) {
            //           // pinS = val;
            //           // validateCode(val);
            //         }
            //       }
            //     },
            //     // end onSubmit
            //   ),
            // ),



          ],
        ),
      ),

    );
  }

  Future<void> verifyPhone() async {

    final PhoneCodeSent smsOTPSent = (String verId, [int? forceCodeResend]) {
      this.verificationId = verId;


      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return Dialog(
      //         //backgroundColor: ColorsRes.Grey_primary,
      //         child: smsOTPDialog(),
      //       );
      //     });
    //};
    // try {
    //   await _auth.verifyPhoneNumber(
    //       phoneNumber: this.phoneNo,
    //       // PHONE NUMBER TO SEND OTP
    //       codeAutoRetrievalTimeout: (String verId) {
    //         //Starts the phone number verification process for the given phone number.
    //         //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
    //         this.verificationId = verId;
    //       },
    //       codeSent: smsOTPSent,
    //
    //       // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
    //       timeout: const Duration(seconds: 20),
    //       verificationCompleted: (AuthCredential phoneAuthCredential) {
    //         // setState(() {
    //         //   _isLoading = false;
    //         // });
    //       },
    //       verificationFailed: (Exception exceptio) {
    //         // setState(() {
    //         //   _isLoading = false;
    //         //   _errorMessage = exceptio.toString();
    //         // });
    //       });
    // } catch (e) {
    //   // setState(() {
    //   //   _isLoading = false;
    //   // });
    //   handleError(e);
    };
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


    String? fcm = await getPrefrence(FCM) ?? "";
    String? ipAddress = await IpAddress().getIp();

    referCode = referCode!.replaceAll(".", "").trim();

    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      USER_SIGNUP: "1",
      NAME: uname,
      EMAIL: uemail,
      TYPE: atype,
      FCMID: fcm,
      REFER_CODE: referCode,
      FRIEND_CODE: fCode ?? '',
      IPADDRESS: ipAddress ?? '',
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
            user.profile!, referCode, atype??'', user.location??'', user.fid ??'');

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


        //Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, anim1, anim2) => HomeActivity(auth: widget.auth)),);
        if (uemail == null || uemail.isEmpty || uemail == "") {
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
      }
    } else {
      if (widget.auth != null)

        widget.auth!.signOut();

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

    String error = getdata["error"];

    if (error == ("false")) {
      String status = getdata["data"]["status"];

      if (status != active) {
        clearUserSession();
        widget.auth!.signOut();

        //facebookSignIn.logOut();

      } else {

        uamount = getdata['data']['amount'];
        try{
          double amount=double.parse(uamount!.replaceAll(",", "").trim());
          UserModel.amount=amount;

        }catch(e){

        }

      }
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: new Text(msg),backgroundColor: redgradient2,));
  }



}