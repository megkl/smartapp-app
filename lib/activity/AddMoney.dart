import 'dart:convert';

import 'dart:math';
import 'package:flutter/services.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';

import 'HomeActivity.dart';
import 'PaypalWebviewActivity.dart';

class AddMoney extends StatefulWidget {
  VoidCallback refresh, homeRefresh;

  AddMoney(this.refresh, this.homeRefresh);

  @override
  State<StatefulWidget> createState() {
    return StateAdd();
  }
}

GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class StateAdd extends State<AddMoney> {
  bool _isLoading = false;
  String errmsg = "";
  String amount = "";
  TextEditingController edtinfo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        //brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 8.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Text(
        //           uname ?? "",
        //           style: TextStyle(color: white, fontSize: 10),
        //         ),
        //         Text(
        //           '${uamount == null || uamount.trim().isEmpty ? "0" : uamount} kshs',
        //           style: TextStyle(color: Colors.white, fontSize: 10),
        //         )
        //       ],
        //     ),
        //   ),
        //   uprofile == null || uprofile.isEmpty
        //       ? Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Icon(Icons.account_circle))
        //       : Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: FadeInImage.assetNetwork(
        //             image: uprofile,
        //             placeholder: "assets/images/home_logo.png",
        //             width: 20,
        //             height: 20, //fit: BoxFit.cover,
        //           ),
        //         ),
        // ],
      ),
      body:
          //Container()
          Container(
        //decoration: DesignConfig.gradientbackground,
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/images/back.png"),
        //     fit: BoxFit.fill,
        //   ),
        // ),

        
        height: double.maxFinite,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            _showForm(),
            _showCircularProgress(),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 12.0),
            //   child: Image.asset("assets/images/walletscreen_bg.png"),
            // ),
            Text(
              'Knowledget is wealth',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: black),
            )
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ));
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  _showForm() {
    return Center(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/top_up_wallet.png',
                width: MediaQuery.of(context).size.width * 0.6,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('Add Money To Wallet',
                    style: TextStyle(color: black,  fontSize: 18 )
                    // style: Theme.of(context).textTheme.headline6,
                    ),
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontSize: 16.0, color: Colors.black),
                  fillColor: Colors.white, 
                  hintText: 'Enter amount'),

                keyboardType: TextInputType.number,
                controller: edtinfo,
                inputFormatters: [
                  new FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                ],
                onChanged: (value) {
                  amount = value;
                },
              ),
              (errmsg != ''
                  ? Text(
                      "\n$errmsg",
                      style: TextStyle(color: Colors.red),
                    )
                  : Container()),
              Container(
                // decoration: DesignConfig.circulargradient_box,
                width: double.maxFinite,
                margin: EdgeInsets.all(30),
                child: CupertinoButton(
                  color: selection,
                  borderRadius: BorderRadius.circular(10.0),
                  child: Text(
                    'Add Money',
                    style: TextStyle(color: white, fontWeight: FontWeight.bold),
                  ),
                  //color: Colors.white,
                  onPressed: () async {
                    if (amount.trim().isEmpty ||
                        int.parse(amount.trim()) <= 0) {
                      setState(() {
                        errmsg = "Enter Valid Amount";
                      });
                    } else {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      setState(() {
                        edtinfo = TextEditingController(text: "");
                        errmsg = "";
                      });
                      _asyncSimpleDialog(context, getRandomId(),
                          'Added in wallet by paypal', amount);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getRandomId() {
    var rng = new Random();
    String code = (rng.nextInt(900000) + 100000).toString();

    return code;
  }

  Future<String?> _asyncSimpleDialog(
      BuildContext context, String id, String title, String mainamt) async {
    return showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            children: <Widget>[
              SimpleDialogOption(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (umobile!.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Add Phone Number from Profile")));
                      } else if (uemail!.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Add Email from Profile")));
                      } else {
                        umobile = umobile!.replaceAll("+", "");
                        String? userid = await getPrefrence(USER_ID);
                        String cardurl = CARD_URL +
                            "amount=" +
                            amount +
                            "&" +
                            userId +
                            "=" +
                            userid! +
                            "&email=" +
                            uemail! +
                            "&mobile=" +
                            umobile! +
                            "&event_id=" +
                            id +
                            "&name=" +
                            uname! +
                            "&country=" +
                            Constant.COUNTRY +
                            "&currency_code=" +
                            Constant.CURRENCYCODE;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PaypalWebviewActivity(
                                cardurl,
                                Constant.lblWallet,
                                mainamt,
                                'Mpesa',
                                widget.refresh,
                                widget.homeRefresh,
                                "",
                                null)));
                      }
                    },
                    icon: Image.asset(
                      'assets/images/mpesa.png',
                      height: 25,
                      fit: BoxFit.fill,
                    ),
                    label: Text(
                      'Mpesa',
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),

              // SimpleDialogOption(
              //   child: ElevatedButton.icon(
              //       style: ElevatedButton.styleFrom(
              //         primary: btnColor.withOpacity(0.5),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.0),
              //         ),
              //       ),
              //       onPressed: () async {
              //         Navigator.pop(context);
              //         //selectedDailyEvent = event;
              //         String paypalurl = PAYPAL_URL +
              //             "amount=" +
              //             mainamt +
              //             "&title=" +
              //             title.replaceAll(" ", "") +
              //             "&id=" +
              //             id;
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (context) => PaypalWebviewActivity(
              //                 paypalurl,
              //                 Constant.lblWallet,
              //                 mainamt,
              //                 'Added in wallet by paypal',
              //                 widget.refresh,
              //                 widget.homeRefresh,
              //                 "",
              //                 null)));
              //       },
              //       icon: Image.asset('assets/images/paypal.png',
              //           height: 25, fit: BoxFit.fill),
              //       label: Text(
              //         'Paypal',
              //         style: Theme.of(context).textTheme.subtitle1,
              //       )),
              // ),

              SimpleDialogOption(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);

                      if (uemail!.trim().isEmpty) {
                         ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Add Email from Profile")));
                      } else {
                        umobile = umobile!.replaceAll("+", "");
                        String? userid = await getPrefrence(USER_ID);
                        String cardurl = CARD_URL +
                            "amount=" +
                            amount +
                            "&" +
                            userId +
                            "=" +
                            userid! +
                            "&email=" +
                            uemail! +
                            "&mobile=" +
                            umobile! +
                            "&event_id=" +
                            id +
                            "&name=" +
                            uname! +
                            "&country=" +
                            Constant.COUNTRY +
                            "&currency_code=" +
                            Constant.CURRENCYCODE;

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PaypalWebviewActivity(
                                cardurl,
                                Constant.lblWallet,
                                mainamt,
                                'Added in wallet by card payment',
                                widget.refresh,
                                widget.homeRefresh,
                                "",
                                null)));
                      }
                    },
                    icon: Image.asset('assets/images/card.png',
                        height: 25, fit: BoxFit.fill),
                    label: Text(
                      'CARD',
                      style: Theme.of(context).textTheme.titleMedium,
                    )),
              ),

//        SimpleDialogOption(
//                 onPressed: () async {
//                   Navigator.pop(context);

//                   if (uemail.trim().isEmpty) {
//                     scaffoldKey.currentState.showSnackBar(
//                         SnackBar(content: Text("Add Email from Profile")));
//                   } else {
//                     umobile=umobile.replaceAll("+", "");
//                     String userid = await getPrefrence(USER_ID);
//                     String cardurl = CARD_URL +
//                         "amount=" +
//                         mainamt +"&"+
//                         userId+"="+userid+"&email="+uemail+"&mobile="+umobile+
//                         "&event_id=" +id+"&name="+uname+"&country="+Constant.COUNTRY+"&currency_code="+Constant.CURRENCYCODE;
// print('url****$cardurl');

//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) =>
//                             PaypalWebviewActivity(cardurl,
//                                 Constant.lblWallet, mainamt,
//                                 'Added in wallet by card payment',
//                                 widget.refresh, widget.homeRefresh)));
//                   }
//                   // CardPayment(id, mainamt, context);
//                 },
//                 child: Padding(
//                     padding: EdgeInsets.only(top: 5.0, bottom: 5),
//                     child: Image.asset('assets/images/visa_icon.png')),
//               )
              //   SimpleDialogOption(
              //     onPressed: () async {

              // Navigator.pop(context);
              // if (umobile.trim().isEmpty) {
              //   scaffoldKey.currentState.showSnackBar(SnackBar(
              //       content: Text("Add Phone Number from Profile")));
              // } else if (uemail.trim().isEmpty) {
              //   scaffoldKey.currentState.showSnackBar(
              //       SnackBar(content: Text("Add Email from Profile")));
              // } else {
              //   umobile = umobile.replaceAll("+", "");
              //   String userid = await getPrefrence(USER_ID);
              //   String cardurl = CARD_URL +
              //       "amount=" +
              //      mainamt +
              //       "&" +
              //       userId +
              //       "=" +
              //       userid +
              //       "&email=" +
              //       uemail +
              //       "&mobile=" +
              //       umobile +
              //       "&event_id=" +
              //       id +
              //       "&name=" +
              //       uname +
              //       "&country=" +
              //       Constant.COUNTRY +
              //       "&currency_code=" +
              //       Constant.CURRENCYCODE;

              //   Navigator.of(context).push(MaterialPageRoute(
              //       builder: (context) => PaypalWebviewActivity(
              //           cardurl,
              //           Constant.lblWallet,
              //        mainamt,
              //           'Mpesa',
              //           widget.refresh, widget.homeRefresh)));}
              //     },
              //     child: Padding(
              //         padding: EdgeInsets.only(top: 5.0, bottom: 5),
              //         child: Image.asset('assets/images/mpesa.png')),
              //   ),
            ],
          );
        });
  }

  Widget PhoneNumberDialog(String amount) {
    String errmsg = "";
    String phno = umobile!.replaceAll("+254", "") ?? '';
    TextEditingController edtmobile =
        TextEditingController(text: umobile!.replaceAll("+254", "") ?? '');

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
            decoration: InputDecoration(
                hintText: 'Enter Phone number',
                hintStyle: TextStyle(color: primary)),
            controller: edtmobile,
            cursorColor: appcolor,
            style: TextStyle(color: primary),
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
                    if (phno.trim().isEmpty ||
                        Constant.validateMobile(phno) != null) {
                      setState(() {
                        errmsg = "Enter Valid Phone number";
                      });
                    } else {
                      Navigator.of(context).pop();
                      // MPesaPayment(amount, phno);
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

  Future<void> AddMoneyToWallet(String mainamt) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      setState(() {
        _isLoading = true;
      });

      String? userid = await getPrefrence(USER_ID);

      Map<String, String> body = {
        ADD_WALLET_DATA: "1",
        userId: userid!,
        AMOUNT: mainamt,
        DETAIL: 'Added in wallet by Mpesa',
      };

      var responseapi = await Constant.getApiData(body);
      final res = json.decode(responseapi);

      setState(() {
        _isLoading = false;
        uamount = res['amount'];
        this.widget.refresh();
        this.widget.homeRefresh();
      });
    }
  }
}
