import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/Model/Wallet.dart';
import 'package:smartapp/Model/Withdraw.dart';
import 'package:smartapp/activity/AddMoney.dart';
import 'package:smartapp/activity/HomeActivity.dart';


import 'Login.dart';

class WalletActivity extends StatefulWidget {
  VoidCallback refresh;

  WalletActivity(this.refresh);

  @override
  WalletActivityState createState() => new WalletActivityState();
}

class WalletActivityState extends State<WalletActivity> {
  bool iswalletloading = false,
      iswithloading = false,
      iswalletnodata = false,
      iswithnodata = false;
  List<Wallet> walletlist=[];
  List<Withdraw> withdrawlist=[];

  @override
  void initState() {

    GetUserStatus();
    GetWalletData();
    GetWithdrawData();

    super.initState();
  }

  Future<void> GetUserStatus() async {
    String? userid = await getPrefrence(USER_ID);

    var parameter = {GET_USER_BY_ID: "1", userId: userid!};
    var response = await Constant.getApiData(parameter);

    final getdata = json.decode(response);

    String error = getdata["error"];

    if (error == ("false")) {
      String status = getdata["data"]["status"];

      if (status != active) {
        clearUserSession();
        FirebaseAuth.instance.signOut();
        //facebookSignIn.logOut();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => Login()),
            ModalRoute.withName('/'));
      } else {
        UserModel user = new UserModel.fromJson(getdata["data"]);
        setState(() {
          uamount = getdata['data']['amount'];
        });

        saveUserDetail(user.user_id!, user.name!, user.email!, user.mobile!,
            user.profile!, user.refer_code!, user.type!, user.location!, user.fid!);

        //RemoveGameRoomId();
      }
    }
  }

  Future GetWalletData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      setState(() {
        iswalletloading = true;
      });

      Map<String, String> body = {
        GET_WALLET_DETAIL: "1",
        userId: uuserid!,
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
                  () => setState(() {
                iswalletloading = false;
                walletlist.addAll((res['data'] as List)
                    .map((model) => Wallet.fromJson(model))
                    .toList());
            
              }));
        }
      } else {
        iswalletnodata = true;
        iswalletloading = false;
        setState(() {});
      }
    }
  }

  refreshUI() {
    setState(() {});
  }

  Future GetWithdrawData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      setState(() {
        iswithloading = true;
      });

      Map<String, String> body = {
        GET_WITHDRAW_DETAIL: "1",
        userId: uuserid!,
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      if (error == "false") {
        if (mounted) {
          new Future.delayed(
              Duration.zero,
                  () => setState(() {
                iswithloading = false;
                withdrawlist.addAll((res['data'] as List)
                    .map((model) => Withdraw.fromJson(model))
                    .toList());
                print("loadmain---res-${withdrawlist.length}");
              }));
        }
      } else {
        iswithnodata = true;
        iswithloading = false;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: white,
          ),
          bottom: TabBar(
            indicatorColor: white,
            labelColor: white,
            unselectedLabelColor: black,
            tabs: [
              Tab(child: Text("Earning", style: TextStyle(fontSize: 15))),
              Tab(
                  child: Text(
                    "Withdraw",
                    style: TextStyle(fontSize: 15),
                  )),
            ],
          ),
          backgroundColor: practiceColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            StringRes.wallet,
            style: TextStyle(color: white, fontFamily: 'TitleFont'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {  },
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add_box, color: white),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddMoney(refreshUI,widget.refresh)));
                    },
                  ),
                  Icon(
                    Icons.account_balance_wallet,
                    color: white,
                  ),
                  Text(
                    uamount == null || uamount!.trim().isEmpty ? "0" : uamount!,
                    style: TextStyle(fontWeight: FontWeight.bold, color: white),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            Container(
              // padding: EdgeInsets.only(top: kToolbarHeight*2),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                //decoration: DesignConfig.gradientbackground,
                child: WalletData()),
            Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/back.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                //decoration: DesignConfig.gradientbackground,
                child: WithdrawData()),
          ],
        ),
      ),
    );
  }



  Widget WalletData() {
    return iswalletloading
        ? Center(child: new CircularProgressIndicator())
        : iswalletnodata || walletlist.length == 0
        ? Center(
        child: Text(
          StringRes.nodatafound,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.merge(TextStyle(fontWeight: FontWeight.bold)),
        ))
        : SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        StringRes.details,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.merge(TextStyle(
                            fontWeight: FontWeight.bold,
                            color: white)),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(StringRes.date,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                            ?.merge(TextStyle(
                                fontWeight: FontWeight.bold,
                                color: white))))),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(StringRes.amount,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                            ?.merge(TextStyle(
                              fontWeight: FontWeight.bold,
                              color: white))),
                    ))
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 20,
            color: Colors.grey,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: walletlist.length,
              itemBuilder: (BuildContext ctxt, int index) {
                Wallet item = walletlist[index];
                String wdate = DateFormat('dd-MM-yyyy')
                    .format(DateTime.parse(item.date!));
                return Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                  child: Row(children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(item.details!),
                        )),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                              wdate,
                            ))),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(item.amount!,
                              textAlign: TextAlign.end),
                        ))
                  ]),
                );
              }),
        ],
      ),
    );
  }

  Widget WithdrawData() {
    return iswithloading
        ? Center(child: new CircularProgressIndicator())
        : iswithnodata || withdrawlist.length == 0
        ? Center(
        child: Text(
          StringRes.nodatafound,
          style: Theme.of(context)
              .textTheme
              .titleMedium
                            ?.merge(TextStyle(fontWeight: FontWeight.bold)),
        ))
        : SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        StringRes.details,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.merge(TextStyle(
                            fontWeight: FontWeight.bold,
                            color: white)),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Center(
                        child: Text(StringRes.date,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                            ?.merge(TextStyle(
                                fontWeight: FontWeight.bold,
                                color: white))))),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(StringRes.amount,
                          textAlign: TextAlign.end,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                            ?.merge(TextStyle(
                              fontWeight: FontWeight.bold,
                              color: white))),
                    ))
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 20,
            color: grey,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: withdrawlist.length,
              itemBuilder: (BuildContext ctxt, int index) {
                Withdraw item = withdrawlist[index];
                String status = item.status!.trim() == "0"
                    ? "Pending"
                    : "Completed";
                Color scolor =
                item.status!.trim() == "0" ? orange : green;
                String wdate = DateFormat('dd-MM-yyyy')
                    .format(DateTime.parse(item.date!));
                return GestureDetector(
                  onTap: () {
                    showDialog<void>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text(
                                '${Constant.setFirstLetterUppercase(item.details!)}',
                                style: TextStyle(
                                    color: appcolor,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: Text(
                                'Status : $status\nAmount : ${item.request_amount}\nDetail : ${item.details}',style: TextStyle(color: appcolor),),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: Text('Ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ]);
                        });
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 5.0, bottom: 5),
                    child: Row(children: <Widget>[
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.brightness_1,
                                  color: scolor,
                                  size: 12,
                                ),
                                Flexible(
                                  child: Text(
                                    "${Constant.setFirstLetterUppercase(item.details!)}",
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Center(
                              child: Text(
                                wdate,
                              ))),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding:
                            const EdgeInsets.only(right: 8.0),
                            child: Text(
                              item.request_amount!,
                              textAlign: TextAlign.end,
                            ),
                          ))
                    ]),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
