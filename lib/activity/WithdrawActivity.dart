import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Helper/loading.dart';
import 'package:smartapp/Helper/withdraw_dialog.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/Login.dart';

class WithdrawActivity extends StatefulWidget {
  VoidCallback refresh;

  WithdrawActivity(this.refresh);

  @override
  WithdrawStateActivity createState() => new WithdrawStateActivity();
}

class WithdrawStateActivity extends State<WithdrawActivity> {
  int amount = 1;
  int _currentIndex = 0;
  String? selecteditem;
  TextEditingController edtinfo = TextEditingController();
  double minimumamt = 0;
  String selectedGender = "";
  bool isloading = false;
  // bool canWithdraw=false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    minimumamt = double.parse(Constant.MINIMUM_WITHDRAW_AMT);
    if (Constant.PAYTYPELIST.length != 0) {
      selecteditem = Constant.PAYTYPELIST[0];
    }

    GetUserStatus();
  }

  Future<void> GetUserStatus() async {
    String? userid = await getPrefrence(USER_ID);

    var parameter = {GET_USER_BY_ID: "1", userId: userid!};
    var response = await Constant.getApiData(parameter);

    final getdata = json.decode(response);
    // print("data  withdrawactivity ${getdata.toString()}");
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
        // if(double.parse(uamount!) > minimumamt){
        //   canWithdraw=true;
        // }

        saveUserDetail(
            user.user_id!,
            user.name!,
            user.email!,
            user.mobile!,
            user.profile!,
            user.refer_code!,
            user.type!,
            user.location!,
            user.fid!);

        //RemoveGameRoomId();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Withdraw"),
          //brightness: Brightness.dark,
          centerTitle: true,
          backgroundColor: primary,
          elevation: 0,
        ),
        body: Container(
            height: size.height,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                SizedBox(
                  height: size.height / 22,
                ),
                Text(
                  'Balance',
                  textAlign: TextAlign.center,
                  style: kTextNormalStyle.apply(color: primary),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 30),
                  child: Text(
                    " ${uamount == null || uamount!.trim().isEmpty ? "0" : getGpoints()}",
                    textAlign: TextAlign.center,
                    style: kTextHeadBoldStyle.apply(color: primary),
                  ),
                ),

                Text(
                  'Select Withdrawal option',
                  textAlign: TextAlign.center,
                  style: kTextNormalStyle.apply(color: primary),
                ),
                SizedBox(
                  height: size.height / 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 2,
                      width: size.width / 3,
                      decoration: BoxDecoration(
                          color: redgradient2,
                          borderRadius: BorderRadius.circular(5)),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height / 17,
                ),
                _buildSelectorGender(
                  context: context,
                  name: "PayPal",
                ),
                SizedBox(
                  height: size.height / 13,
                ),
                _buildSelectorGender(
                  context: context,
                  name: "PayUMoney",
                ),
                SizedBox(
                  height: size.height / 13,
                ),
                _buildSelectorGender(
                  context: context,
                  name: "M-Pesa",
                ),
                // ListView.builder(
                //     shrinkWrap: true,
                //     physics:
                //     const NeverScrollableScrollPhysics(),
                //     padding: EdgeInsets.all(8.0),
                //     itemCount: Constant.PAYTYPELIST.length,
                //     itemBuilder:
                //         (BuildContext ctxt, int index) {
                //       //selecteditem = Constant.PAYTYPELIST[index];
                //       String item =
                //           "${Constant.setFirstLetterUppercase(Constant.PAYTYPELIST[index])}";
                //       return Theme(
                //           data: Theme.of(context).copyWith(
                //             unselectedWidgetColor:
                //             Colors.white,
                //           ),
                //           child: Column(
                //             mainAxisSize: MainAxisSize.min,
                //             children: <Widget>[
                //
                //               RadioListTile(
                //                 groupValue: _currentIndex,
                //                 title: Text("${item}"),
                //                 value: index,
                //                 onChanged: (val) {
                //                   setState(() {
                //                     selecteditem = Constant
                //                         .PAYTYPELIST[index];
                //                     _currentIndex = val;
                //                     //edtinfo.text = item;
                //                   });
                //                 },
                //               ),
                //               _currentIndex == index
                //                   ? Padding(
                //                 padding:
                //                 EdgeInsets.only(
                //                     left: 10,
                //                     right: 10),
                //                 child: TextField(
                //                   controller: edtinfo,
                //                   decoration:
                //                   InputDecoration(
                //                     contentPadding:
                //                     const EdgeInsets
                //                         .symmetric(
                //                         vertical:
                //                         0.0),
                //                     hintText:
                //                     "Enter $item Info",
                //                     labelText:
                //                     "Enter $item Info",
                //                     prefixIcon: Icon(
                //                       Icons
                //                           .account_balance_wallet,
                //                       color: white,
                //                     ),
                //                   ),
                //                   cursorColor:
                //                   appcolor,
                //                   keyboardType:
                //                   TextInputType
                //                       .multiline,
                //                   maxLines: null,
                //                 ),
                //               )
                //                   : Container(),
                //             ],
                //           ));
                //     }),
                SizedBox(
                  height: size.height / 13,
                ),
                Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(), backgroundColor: redgradient2),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          child: Text("Withdraw",
                              style: kTextNormalBoldStyle.apply(
                                  color: Colors.white))),
                      onPressed: () {
                        withdrawPayment();
                      },
                    )),
                SizedBox(
                  height: size.height / 18,
                ),

                //isloading ? new SizedBox(height: 40,width: 40,child: CircularProgressIndicator(),) : Container(),
                SizedBox(
                  height: size.height / 22,
                ),
              ],
            )));
  }

  displayWithdrawDialog() {
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
            child: WithdrawDialog(
              title: 'Complete Withdrawal',
              iconImage: Icon(
                Icons.monetization_on,
                size: 40,
              ),
              labelText: 'Indicate Account Number or Phone Number for M-Pesa',
              color: redgradient2,
            ));
      },
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        //return null;
        return WithdrawDialog(
          title: 'Complete Withdrawal',
          iconImage: Icon(
            Icons.monetization_on,
            size: 40,
          ),
          labelText: 'Indicate Account Number or Phone Number for M-Pesa',
          color: redgradient2,
        );
      },
    );
  }

  void withdrawPayment() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!isloading) {
      if (double.parse(uamount!) < minimumamt) {
        showMessage(
            "Minimum Withdraw Amount is ${Constant.MINIMUM_WITHDRAW_AMT}${Constant.CURRENCYSYMBOL}");
      } else if (!checkinternet) {
        showMessage("${StringRes.checknetwork}");
      } else {
        setState(() {
          isloading = true;
        });

        var data = await displayWithdrawDialog();
        if (data != null) {
          var parameter = {
            PAYMENT_REQUEST: "1",
            userId: uuserid,
            REQUEST_TYPE: selecteditem,
            REQUEST_AMOUNT: "-$uamount!",
            DETAIL: data.toString(),
          };

          // print("=====${parameter.toString()}");

          // print("data $data");
          performWithdrawalRequest(parameter);
        } else {
          showMessage("account info is empty");
        }
        // performWithdrawalRequest(parameter);
        // var response =
        // await Constant.getApiData(parameter);
        // final getdata = json.decode(response);
        // String error = getdata["error"];
        //
        // setState(() {
        //   isloading = false;
        // });

        // if (error == "false") {
        //   setState(() {
        //     edtinfo.text = "";
        //     uamount! = "0";
        //     widget.refresh();
        //   });
        //   scaffoldKey.currentState.showSnackBar(
        //       SnackBar(
        //           content: Text(
        //               "Request Submitted Successfully")));
        // } else {
        //   scaffoldKey.currentState.showSnackBar(
        //       SnackBar(
        //           content:
        //           Text(getdata['message'])));
        // }
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
        //return null;
        return LoadingOverlay();
      },
    );
  }

  showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$msg", style: kTextNormalStyle.apply(color: Colors.white)),
      backgroundColor: redgradient2,
    ));
  }

  performWithdrawalRequest(var parameter) async {
    loadingOverlay();
    var response = await Constant.getApiData(parameter);
    final getdata = json.decode(response);
    String error = getdata["error"];
    Navigator.pop(context);

    setState(() {
      isloading = false;
    });

    if (error == "false") {
      setState(() {
        edtinfo.text = "";
        uamount = "0";
        widget.refresh();
      });
      showMessage("Request Submitted Successfully");
    } else {
      showMessage("${getdata['message']}");
    }
  }

  Widget _buildSelectorGender({
    BuildContext? context,
    String? name,
  }) {
    bool isActive = name == selectedGender;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 80, minHeight: 60),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isActive ? primary : null,
            border: Border.all(
              width: 0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: RadioListTile<String?>(
            value: name,
            activeColor: Colors.white,
            groupValue: selectedGender,
            onChanged: (String? v) {
              setState(() {
                selectedGender = v!;
                selecteditem = v.toString().replaceAll("-", "").toLowerCase();
              });
            },
            title: Text(
              name!,
              style: kTextNormalBoldStyle.apply(
                color: isActive ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  getGpoints() {
    double dAmount = double.parse(uamount!);
    print("balance is $dAmount");
    if (dAmount < 100) {
      double dGcoin = dAmount / 5;
      return "${dGcoin.toStringAsFixed(0)} Gcoins";
    } else if (dAmount >= 100 && dAmount < 200) {
      double dGcoin = (dAmount / 5) + 2;

      return "${dGcoin.toStringAsFixed(0)} Gcoins";
    } else {
      return "$uamount! Ksh";
    }
  }
}
