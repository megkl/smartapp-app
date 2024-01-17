import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Helper/global.dart';
import 'package:smartapp/Helper/loading.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/payments.dart';
import 'package:smartapp/services/authentication.dart';

import '../Helper/Color.dart';
import 'Login.dart';

final _scaffoldKey = GlobalKey<ScaffoldState>();

class ProfileActivity extends StatefulWidget {
  final bool? isFirst;
  final BaseAuth? auth;

  const ProfileActivity({Key? key, this.isFirst, this.auth}) : super(key: key);

  ProfileActivityState createState() => ProfileActivityState();
}

class ProfileActivityState extends State<ProfileActivity> {
  bool isLoading = false, isdialogloading = false;
  TextEditingController edtname = TextEditingController();
  TextEditingController edtmobile = TextEditingController();
  TextEditingController edtlocation = TextEditingController();
  TextEditingController edtemail = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightSpace = size.width / 10;
    return Scaffold(
      key: _scaffoldKey,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                //brightness: Brightness.dark,
                backgroundColor: primary,
                expandedHeight: MediaQuery.of(context).size.width / 1.95,
                floating: false,
                centerTitle: true,
                pinned: true,
                title: Text(
                  StringRes.profile,
                  style: TextStyle(color: Colors.white),
                ),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40))),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.input),
                      onPressed: () {
                        clearUserSession();
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Login()),
                            (Route<dynamic> route) => false);
                      })
                ],
                flexibleSpace: FlexibleSpaceBar(background: Align(
                  alignment: Alignment.bottomCenter,
                  child: getClipper(),
                )),
              ),
            ];
          },
          
          body: SingleChildScrollView(
            // height: double.maxFinite,
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: heightSpace / 1.3,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Visibility(
                      visible: isLoading,
                      child: CircularProgressIndicator(
                        color: orangeTheme,
                      )),
                ),
                Column(
                  // scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(top: 0, right: 10, left: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                "Name",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                minFontSize: 18,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),


                              SizedBox(
                                height: heightSpace / 3,
                              ),


                              CustomInputField(
                                label: 'Name',
                                prefixIcon: Icons.person_outline,
                                obscureText: false,
                                textInputFormat: TextInputType.text,
                                editingController: edtname,
                              ),
                              SizedBox(
                                height: heightSpace,
                              ),
                              AutoSizeText(
                                "Mobile number",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                minFontSize: 18,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: heightSpace / 3,
                              ),
                              CustomInputField(
                                label: 'Mobile Number',
                                prefixIcon: Icons.phone_android,
                                obscureText: true,
                                textInputFormat: TextInputType.phone,
                                editingController: edtmobile,
                              ),
                              SizedBox(
                                height: heightSpace,
                              ),
                              AutoSizeText(
                                "Email",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                minFontSize: 18,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: heightSpace / 3,
                              ),
                              CustomInputField(
                                label: 'Email',
                                prefixIcon: Icons.mail_outline,
                                obscureText: false,
                                textInputFormat: TextInputType.emailAddress,
                                editingController: edtemail,
                              ),
                              SizedBox(
                                height: heightSpace,
                              ),
                              AutoSizeText(
                                "Location",
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                minFontSize: 18,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                height: heightSpace / 3,
                              ),
                              CustomInputField(
                                label: 'Location',
                                prefixIcon: Icons.location_on_outlined,
                                obscureText: false,
                                textInputFormat: TextInputType.text,
                                editingController: edtlocation,
                              ),
                              SizedBox(
                                height: heightSpace,
                              ),
                              Container(
                                  width: double.maxFinite,
                                  margin: EdgeInsets.symmetric(horizontal: 60),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: StadiumBorder(), backgroundColor: primary),
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        child: Text(
                                          'UPDATE PROFILE',
                                          style: kTextNormalBoldStyle.apply(
                                              color: Colors.white),
                                        )),
                                    onPressed: () {
                                      updateProfile();
                                    },
                                  )),
                              SizedBox(
                                height: heightSpace,
                              ),
                            ],
                          ),
                        ))
                  ],
                )
              ],
            ),
          )),
    );
  }

  //
  TopContainer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
          )),
    );
  }

  getClipper() {
    return Center(
      child: GestureDetector(
        onTap: () async {
          FilePickerResult? result =
          await FilePicker.platform.pickFiles(allowMultiple: false);
          // File image = await FilePicker.platform.pickFiles(type: FileType.image);
          UpdateProfileImage(File(result!.paths[0]!));
        },
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 100,
            height: 100,
            margin: EdgeInsets.only(top: 50),
            child: Stack(
              children: <Widget>[
                Container(
                  //alignment: Alignment.center,
                    margin: EdgeInsetsDirectional.only(bottom: 5),
                    child: CachedNetworkImage(
                      imageUrl: uprofile??"",
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
                                image:
                                AssetImage('assets/images/user.jpg'),
                                fit: BoxFit.cover)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(100.0)),
                            image: DecorationImage(
                                image:
                                AssetImage('assets/images/user.jpg'),
                                fit: BoxFit.cover)),
                      ),
                      width: 100,
                      height: 100,
                    )),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: white
                        //border: Border.all(width: 2, color: Colors.white)
                      ),
                      //decoration: DesignConfig.circulargradient_box,
                      child: Icon(
                        Icons.photo_camera,
                        color: primary,
                        size: 14,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
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
        //return null;
        return LoadingOverlay();
      },
    );
  }

  Future<void> updateProfile() async {
    if (_formKey.currentState!.validate() && isLoading == false) {
      bool checkinternet = await Constant.CheckInternet();
      if (!checkinternet) {
      showScaffoldMessage(StringRes.checknetwork, context);
      } 
      else if (edtemail.text.trim().isEmpty) {

        showScaffoldMessage("Enter Valid Email", context);
      } else if (edtmobile.text.trim().isEmpty) {
        showScaffoldMessage("Enter Valid Mobile Number", context);

      } else {
        loadingOverlay();
        Map<String, String> body = {
          ACCESS_KEY: ACCESS_KEY_VAL,
          UPDATE_PROFILE: "1",
          EMAIL: edtemail.text,
          NAME: edtname.text,
          MOBILE: edtmobile.text,
          LOCATION: edtlocation.text,
          userId: uuserid!
        };

        var response = await Constant.getApiData(body);

        final res = json.decode(response);
        String error = res['error'];

        showScaffoldMessage(res['message'], context);
        if (error == "false") {
          uname = edtname.text;
          umobile = edtmobile.text;
          ulocation = edtlocation.text;
          uemail = edtemail.text;
          setPrefrence(NAME, edtname.text);
          setPrefrence(MOBILE, edtmobile.text);
          setPrefrence(LOCATION, edtlocation.text);
          setPrefrence(EMAIL, edtemail.text);

          FirebaseDatabase.instance
              .reference()
              .child("user")
              .child(firebaseuserid!)
              .set({
            "name": uname,
            "mobile": umobile,
            "location": ulocation,
            "email": uemail,
            "profile": uprofile,
            "user_id": uuserid,
            "type": utype
          });
          Navigator.pop(context);
          if (widget.isFirst!) {
            if (UserModel.amount! < 25) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => AddPaymentEntry()),
                  (Route<dynamic> route) => false);
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => HomeActivity()),
                  (Route<dynamic> route) => false);
            }
          }
        }
      }
    }
  }

  Future UpdateProfileImage(File file) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      showScaffoldMessage(StringRes.checknetwork, context);
    } else if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var response = await Constant.postApiImage(file, context, uuserid!);
      final res = json.decode(response);
      bool error = res['error'];
      showScaffoldMessage(res['message'], context);
      if (!error) {
        setPrefrence(PROFILE, res['file_path']);
        uprofile = res['file_path'];

        FirebaseDatabase.instance
            .ref()
            .child("user")
            .child(firebaseuserid!)
            .set({
          "profile": uprofile,
          "name": uname,
          "mobile": umobile,
          "location": ulocation,
          "email": uemail,
          "user_id": uuserid,
          "type": utype
        });
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    SetUserData();
    super.initState();
  }

  Future<void> SetUserData() async {
    edtname.text = (await getPrefrence(NAME))!;
    edtmobile.text = (await getPrefrence(MOBILE))!;
    edtlocation.text = (await getPrefrence(LOCATION))!;
    edtemail.text = (await getPrefrence(EMAIL))!;
    utype = (await getPrefrence(LOGIN_TYPE))!;
    uuserid = (await getPrefrence(USER_ID))!;

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null)
      firebaseuserid = currentUser.uid;
    else
      firebaseuserid = (await getPrefrence(FIR_ID))!;

    setState(() {});
  }
}
