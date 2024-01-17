import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Model/NotificationModel.dart';

class Notifiction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StateNotification();
  }
}

class _StateNotification extends State<Notifiction> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<NotificationModel> notiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBar(
        //brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Notifications',
          style: TextStyle(fontFamily: 'TitleFont'),
        ),
      ),
      body: Container(
        height: double.maxFinite,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/gameback.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: primary,
              ))
            : notiList.length == 0
                ? Center(
                    child: Text(
                    "No Notifications Found..!!",
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: notiList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return getItem(index);
                      // return Container();
                    }),
      ),
    );
  }

  Future<void> getNotification() async {
    var parameter = {
      ACCESS_KEY: ACCESS_KEY_VAL,
      GET_NOTIFICATION: "1",
    };

    Response response =
        await post(Uri.parse(BASE_URL), body: parameter, headers: headers);

    var getdata = json.decode(response.body);

    String error = getdata["error"];
    String msg = getdata["message"];
    if (error == 'false') {
      var data = getdata["data"];

      notiList = (data as List)
          .map((data) => new NotificationModel.fromJson(data))
          .toList();
    } else {
      setSnackbar(msg);
    }
    setState(() {
      _isLoading = false;
    });
  }

  setSnackbar(String msg) {
    // _scaffoldKey.currentState?.showSnackBar(new SnackBar(
    //   content: new Text(
    //     msg,
    //     textAlign: TextAlign.center,
    //     style: TextStyle(color: Colors.black),
    //   ),
    //   backgroundColor: Colors.white,
    //   elevation: 1.0,
    // ));
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 1.0,
    ));
  }

  Widget getItem(int index) {
    NotificationModel model = notiList[index];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              DateFormat('dd-MM-yyyy').format(DateTime.parse(model.date!)),
              style: TextStyle(fontWeight: FontWeight.bold, color: primary),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Event Type: " + model.etype!,
                  style: TextStyle(color: primary),
                ),

              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width * 0.1,
                      child: Text('Rank',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: primary))),
                  Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: primary),
                    ),
                  ),
                  Text(
                    'Winning Amount',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: primary),
                  )
                ],
              ),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: _getList(model),
            )
          ],
        ),
      ),
    );
  }

  _getList(NotificationModel model) {

    List<Widget> rowList = [];

    for (int i = 0; i < model.userList!.length; i++) {
      rowList.add(Row(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                model.userList![i].rank!,
                style: TextStyle(color: primary),
              )),
          Expanded(
            child: Text(
              model.userList![i].name!,
              style: TextStyle(color: primary),
            ),
          ),
          Text(
            model.userList![i].amount!,
            style: TextStyle(color: primary),
          ),
        ],
      ));
    }

    return rowList;
  }
}
