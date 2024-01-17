import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:http/http.dart' as http;
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';

class Privacy_Policy extends StatefulWidget {
  @override
  _Privacy_PolicyState createState() => _Privacy_PolicyState();
}

class _Privacy_PolicyState extends State<Privacy_Policy> {
  String? privacy_url;
  double progress = 0;
  String loading = "true";
  String title = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      title = getTitle();
    });
  }

  @override
  Widget build(BuildContext context) {
    String imgType;
    Color back, fontColor;
    if (Constant.cls_type == "privacy") {
      imgType = "assets/images/privacy-policy.png";
      back = backPich;
      fontColor = black;
    } else if (Constant.cls_type == "terms") {
      imgType = "assets/images/t&c.png";
      back = white;
      fontColor = black;
    } else {
      imgType = "assets/images/about-us.png";
      back = orangeTheme;
      fontColor = black;
    }
    return FutureBuilder<String>(
        future: getType(),

        /* cls_type=="privacy"?_loadLocalHTML(GET_PRIVACY):_loadLocalHTML(GET_TERMS),*/
        builder: (context, snapshot) {
          double top = MediaQuery.of(context).padding.top;
          return Scaffold(
            body: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: back,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: loading.compareTo("true") == 0
                          ? Center(
                              child: Padding(
                              padding: const EdgeInsets.all(80.0),
                              child: CircularProgressIndicator(),
                            ))
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: top),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        imgType,
                                        width: 50,
                                        color: lovandar,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          title,
                                          style: TextStyle(
                                              color: lovandar,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: lovandar,
                                    thickness: 2,
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Html(data: privacy_url, style: {
                                      "p": Style(
                                 color: fontColor
                                      ),
                                    })),

                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: btnColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 30)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Back to Menu')),
                                ),
                                // WebviewScaffold(
                                //   // appBar: AppBar(
                                //   //     centerTitle: true,
                                //   //  backgroundColor: practiceColor,
                                //   //  //   flexibleSpace: Container(decoration: DesignConfig.gradientbackground,),
                                //   //     title: Text(
                                //   //       title,
                                //   //       style: TextStyle(fontFamily: 'TitleFont'),
                                //   //     )),
                                //   withJavascript: true,
                                //   appCacheEnabled: true,
                                //   url: new Uri.dataFromString(privacy_url, mimeType: 'text/html')
                                //       .toString(),
                                // ),
                              ],
                            ),
                    ),
                  ),
                )),
          );
        });
  }

  Future<String?> _loadLocalHTML(String type) async {
    var data = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      type: "1",
    };

    var response = await http.post(Uri.parse(BASE_URL), body: data, headers: headers);

    var getdata = json.decode(response.body);
    String error = getdata["error"];
    if (error.compareTo("false") == 0) {
      if (this.mounted) {
        setState(() {
          privacy_url = getdata["data"];
          loading = "false";
        });
      }
    }
    return null;
  }

  getType() {
    if (Constant.cls_type == "privacy")
      _loadLocalHTML(GET_PRIVACY ?? '');
    else if (Constant.cls_type == "terms")
      _loadLocalHTML(GET_TERMS ?? '');
    else if (Constant.cls_type == "aboutus") _loadLocalHTML(GET_ABOUT ?? '');
  }

  getTitle() {
    String? title;

    if (Constant.cls_type.isEmpty ||
        Constant.cls_type == "privacy")
      title = "Privacy Policy";
    else if (Constant.cls_type == "terms")
      title = "Terms & Conditions";
    else if (Constant.cls_type == "aboutus") title = "About Us";

    return title ?? '';
  }
}
