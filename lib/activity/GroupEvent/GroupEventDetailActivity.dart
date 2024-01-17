import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/GroupModel.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/PlayActivity.dart';
import 'package:smartapp/activity/ChatScreenActivity.dart';



import '../PaypalWebviewActivity.dart';

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class GroupEventDetailActivity extends StatefulWidget {
  @override
  GroupEventDetailState createState() => new GroupEventDetailState();
}

class GroupEventDetailState extends State<GroupEventDetailActivity> {
  bool isloading = false;
  String? dttoday, dttomorrow, buyamt;

  @override
  void initState() {
    dttoday = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(
            int.parse(DateTime.now().millisecondsSinceEpoch.toString())));
    dttomorrow = DateFormat('dd-MM-yyyy').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(DateTime.now()
            .add(new Duration(days: 1))
            .millisecondsSinceEpoch
            .toString())));

    buyamt = int.parse(selectedgroupevent!.entryamount!) <= 0
        ? StringRes.free
        : "${selectedgroupevent!.entryamount!}${Constant.CURRENCYSYMBOL.toLowerCase()}";

    super.initState();
  }

  Future<bool> onBackPress() {
    setState(() {
      if (isloading) isloading = false;
    });
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPress,
      child: Scaffold(
        key: scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          //brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            StringRes.groupplayer,
            style: TextStyle(color: white, fontFamily: 'TitleFont'),
          ),

          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                "assets/images/chat.png",
                color: white,
              ),
              onPressed: () {
                chatfrom = Constant.lblgroupevent;
                //ischatscreen = true;
                chatgroupid = selectedgroupevent!.id!;
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreenActivity()));
              },
            )
          ],
        ),
           body: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/gameback.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(

                child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top:kToolbarHeight*1.5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      selectedgroupevent!.image!.isEmpty
                          ? Container()
                          : FadeInImage.assetNetwork(
                              image: selectedgroupevent!.image!,
                              placeholder: "assets/images/placeholder.png",
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                          child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              selectedgroupevent!.title!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                 ,
                            )),
                            Card(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    "\t${selectedgroupevent!.join_user}/${selectedgroupevent!.no_of_user}\t",
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ],
                              ),
                              color: green,

                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${StringRes.entry}: $buyamt",

                            ),
                            Text(
                                "${StringRes.winningamount}: ${selectedgroupevent!.winningamount}${Constant.CURRENCYSYMBOL.toLowerCase()}",
                               ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(selectedgroupevent!.description!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                              ),
                      ),
                    ])),
              ),
              isloading
                  ? Padding(
                      padding: const EdgeInsets.all(5),
                      child: new CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(primary),
                      ),
                    )
                  : Container(),
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.all(30),

                child: CupertinoButton(
                  color: white,
                  borderRadius: BorderRadius.circular(50.0),
                  child: Text(
                    StringRes.play,
                    style: TextStyle(color: primary, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (!isloading) {
                      if (int.parse(selectedgroupevent!.no_of!) <
                          Constant.MAX_QUE_PER_LEVEL) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(StringRes.notenoughque),
                            backgroundColor: appcolor,
                          ),
                        );
                      } else {
                        CheckEligibility();
                      }
                      // CheckEligibility(event);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _asyncSimpleDialog(BuildContext? context) async {
    return await showDialog<String>(
        context: context!,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Payment Method',
                style: TextStyle(color: appcolor)),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  String paypalurl = PAYPAL_URL +
                      "amount=" +
                      selectedgroupevent!.entryamount! +
                      "&title=" +
                      selectedgroupevent!.title!.replaceAll(" ", "") +
                      "&id=" +
                      selectedgroupevent!.id!;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PaypalWebviewActivity(
                          paypalurl, Constant.lblgroupevent,"",'',null,null,"",null)));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5),
                  child: const Text(
                    '1. Paypal',
                    style: TextStyle(color: primary),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);

                  if (uemail!.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Add Email from Profile")));
                  }
                  //else
                   // CardPayment();
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5),
                  child: const Text('2. Card Payment',
                      style: TextStyle(color: primary)),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                  if (umobile!.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Add Phone Number from Profile")));
                  } else {
                    //showMpesaAlertDialog(context,event);

                    showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            //backgroundColor: ColorsRes.Grey_primary,
                            child: PhoneNumberialog(),
                          );
                        });

                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5),
                  child:
                      const Text('3. Mpesa', style: TextStyle(color: primary)),
                ),
              ),
            ],
          );
        });
  }

  Widget PhoneNumberialog() {
    String errmsg = "";
    String? phno = "";
    TextEditingController edtmobile =
        TextEditingController(text: umobile!.replaceAll("+", "") ?? '');

    return StatefulBuilder(

        builder: (BuildContext context, StateSetter setState) {
       return Container(
        padding: EdgeInsets.all(15),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            'Mpesa',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.merge(TextStyle(color: appcolor, fontWeight: FontWeight.bold)),
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Enter Phone number'),
            controller: edtmobile,
            cursorColor: appcolor,
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.phone,
            onChanged: (value) {
              phno = value;
            },
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
                    if (phno == null ||
                        phno!.trim().isEmpty ||
                        Constant.validateMobile(phno!) != null) {
                      setState(() {
                        errmsg = "Enter Valid Phone number";
                      });
                    } else {
                      Navigator.of(context).pop();
                     // MPesaPayment(phno);
                    }
                  },
                  child: Text(
                    'Send',
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


  Future CheckEligibility() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(StringRes.checknetwork), backgroundColor: appcolor));
    } else {
      setState(() {
        isloading = true;
      });

      Map<String, String> body = {
        ELIGIBLE_FOR_GROUPEVENT: "1",
        userId: uuserid!,
        GROUP_EVENT_ID: selectedgroupevent!.id!,
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);
      isloading = false;

      String error = res['error'];

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message']), backgroundColor: appcolor));
      if (error == "false") {
        bool ispaid = res[IS_PAID].toString().toLowerCase() == "true"
            ? true
            : false ?? false;
        if (ispaid) {
          if (mounted) {
            new Future.delayed(Duration.zero, () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        PlayActivity(cls: Constant.lblgroupevent),
                  ));
            });
          }
        } else {
          //CardPayment(event.id, event.amount,event);
          GoToPayPage();
        }
      } else {
        //tradeisloadmore = false;
     
        if (res[IS_PAID] != null) {
          bool ispaid = res[IS_PAID].toString().toLowerCase() == "true"
              ? true
              : false ?? false;
          if (!ispaid) {
            /*if(int.parse(event.amount) <= 0)
              SetTransactionData(event,"${uuserid}_${event.main_event_id}_${event.id}");
            else
              CardPayment(event.id, event.amount,event);*/
            GoToPayPage();
          }
        }
      }
      setState(() {});
      //}
    }
  }

  void GoToPayPage() {
    //print("===count-**-${event.count}");
    if (int.parse(selectedgroupevent!.entryamount!) <= 0)
      SetTransactionData(selectedgroupevent!,
          "${uuserid}_${selectedgroupevent!.id}", "Free(0 amount)");
    else {
      //CardPayment();
      _asyncSimpleDialog(context);
    }
  }

  Future SetTransactionData(
      GroupModel event, String transid, String paytype) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      setState(() {
        isloading = true;
      });

      Map<String, String> body = {
        SET_USER_PAID_GROUP_EVENT: "1",
        userId: uuserid!,
        GROUP_EVENT_ID: selectedgroupevent!.id!,
        TRANSACTION_ID: transid,
        AMOUNT: selectedgroupevent!.entryamount!,
        TYPE: paytype,
      };

      var responseapi = await Constant.getApiData(body);
      final res = json.decode(responseapi);

      String error = res['error'];
      isloading = false;

      setState(() {});
      if (error == "false") {
        //selectedmaineventround = event;
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, anim1, anim2) =>
                  PlayActivity(cls: Constant.lblgroupevent),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
      }
      //}
    }
  }



}
