import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smartapp/Helper/global.dart';
import 'package:smartapp/activity/payments.dart';
import 'package:smartapp/services/authentication.dart';
import 'package:shimmer/shimmer.dart';

import '../Helper/Color.dart';
import '../Helper/Constant.dart';
import '../Helper/StringRes.dart';
import '../Model/Wallet.dart';
import '../services/language.dart';
import 'HomeActivity.dart';

class WalletHistory extends StatefulWidget {
  final BaseAuth? auth;

  const WalletHistory({Key? key, this.auth}) : super(key: key);

  @override
  _WalletHistoryState createState() => _WalletHistoryState();
}

class _WalletHistoryState extends State<WalletHistory> {

  bool iswalletloading = false, iswalletnodata = false;

  @override
  void initState() {
    super.initState();
   // GetWalletData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightSpace = size.width / 10;
    return Scaffold(
        appBar: AppBar(
          title: Text("Deposit History"),
          //brightness: Brightness.dark,
          centerTitle: true,
          backgroundColor: primary,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Text("data"),
            Flexible(child:  FutureBuilder(
                future: GetWalletData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if(snapshot.connectionState == ConnectionState.done){
                   // print(snapshot.data[0].details + snapshot.data[0].date);

                   if(snapshot.hasData){
                     return  ListView.builder(
                         itemCount: snapshot.data.length,
                         scrollDirection: Axis.vertical,
                         primary: true,
                         itemBuilder: (BuildContext context, int index) {
                           return  Padding(
                             padding: EdgeInsets.only(
                                 left: 2, bottom: 2, right: 2),
                             child: DepositItemList(snapshot.data[index].date.toString(),snapshot.data[index].details.toString(),snapshot.data[index].amount.toString()),
                           );
                         });
                   }
                   else{
                     return Align(alignment:Alignment.center,child:Column(
                       children: [
                         SizedBox(height: size.width/2,),
                         Text("Unable to load your Deposit history\n Top up to view your deposits",
                             textAlign: TextAlign.center,
                             overflow: TextOverflow.fade,
                             style: kTextNormalBoldStyle.apply(color: primary)),
                         SizedBox(height: size.width/3,),
                         Container(
                             width: double.maxFinite,
                             margin: EdgeInsets.symmetric(horizontal: 60),
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                   shape: StadiumBorder(), backgroundColor: redgradient2),
                               child: Padding(
                                   padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                                   child:Text(Languages.of(context)!.topUp?? '',
                                       style: kTextHeadStyle.apply(color: Colors.white))),
                               onPressed: ()  {
                                 Navigator.push(
                                     context,
                                     MaterialPageRoute(
                                         builder: (BuildContext context) =>
                                             AddPaymentEntry(auth:widget.auth)));
                               },
                             )),
                       ],
                     ) );
                   }


                  }else{
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        enabled: true,
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            scrollDirection: Axis.vertical,
                            itemCount: 5,
                            itemBuilder: (BuildContext context, int index) {
                              return LoadingEffect();
                            }));
                  }

                }))
          ],
        ));
  }


  // Widget WalletData() {
  //   return SingleChildScrollView(
  //     child: Container(
  //         decoration: BoxDecoration(
  //             color: primary,
  //             borderRadius: BorderRadius.only(
  //                 bottomLeft: Radius.circular(30),
  //                 bottomRight: Radius.circular(30))),
  //         child: iswalletloading
  //             ? Padding(
  //               padding: const EdgeInsets.symmetric(vertical:80.0),
  //               child: Center(child: new CircularProgressIndicator()),
  //             )
  //             : iswalletnodata || walletlist.length == 0
  //                 ? Padding(
  //                   padding: const EdgeInsets.symmetric(vertical:80.0),
  //                   child: Center(
  //                       child: Text(
  //                       StringRes.nodatafound,
  //                       style: Theme.of(context)
  //                           .textTheme
  //                           .subtitle1
  //                           .merge(TextStyle(fontWeight: FontWeight.bold)),
  //                     )),
  //                 )
  //                 : Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Column(mainAxisSize: MainAxisSize.min, children: [
  //
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Divider(
  //                           color: white,
  //                           thickness: 2,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 8.0),
  //                         child: Row(
  //                           children: <Widget>[
  //                             Expanded(
  //                                 flex: 2,
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(left: 8.0),
  //                                   child: Text(
  //                                     StringRes.details,
  //                                     style: Theme.of(context)
  //                                         .textTheme
  //                                         .subtitle1
  //                                         .merge(TextStyle(
  //                                             fontWeight: FontWeight.bold,
  //                                             color: white)),
  //                                   ),
  //                                 )),
  //                             Expanded(
  //                                 flex: 1,
  //                                 child: Center(
  //                                     child: Text(StringRes.date,
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .subtitle1
  //                                             .merge(TextStyle(
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: white))))),
  //                             Expanded(
  //                                 flex: 1,
  //                                 child: Padding(
  //                                   padding: const EdgeInsets.only(right: 8.0),
  //                                   child: Text(StringRes.amount,
  //                                       textAlign: TextAlign.end,
  //                                       style: Theme.of(context)
  //                                           .textTheme
  //                                           .subtitle1
  //                                           .merge(TextStyle(
  //                                               fontWeight: FontWeight.bold,
  //                                               color: white))),
  //                                 ))
  //                           ],
  //                         ),
  //                       ),
  //
  //                       Flexible( child: FutureBuilder(
  //                           future: GetWalletData(),
  //                           builder: (BuildContext context, AsyncSnapshot snapshot) {
  //                             if(snapshot.hasData){
  //                               print(" snapshot ${snapshot.data}");
  //                               return Text("here snapshot");
  //
  //                             }else{
  //                               return Text("no snapshot");
  //                             }
  //
  //                           }))
  //
  //
  //                     ]))),
  //   );
  //
  //   // return iswalletloading
  //   //     ? Center(child: new CircularProgressIndicator())
  //   //     : iswalletnodata || walletlist.length == 0
  //   //         ? Center(
  //   //             child: Text(
  //   //             StringRes.nodatafound,
  //   //             style: Theme.of(context)
  //   //                 .textTheme
  //   //                 .subtitle1
  //   //                 .merge(TextStyle(fontWeight: FontWeight.bold)),
  //   //           ))
  //   //         : SingleChildScrollView(
  //   //             child: Column(
  //   //               mainAxisSize: MainAxisSize.min,
  //   //               children: <Widget>[
  //   //                 Padding(
  //   //                   padding: const EdgeInsets.only(top: 8.0),
  //   //                   child: Row(
  //   //                     children: <Widget>[
  //   //                       Expanded(
  //   //                           flex: 2,
  //   //                           child: Padding(
  //   //                             padding: const EdgeInsets.only(left: 8.0),
  //   //                             child: Text(
  //   //                               StringRes.details,
  //   //                               style: Theme.of(context)
  //   //                                   .textTheme
  //   //                                   .subtitle1
  //   //                                   .merge(TextStyle(
  //   //                                       fontWeight: FontWeight.bold,
  //   //                                       color: white)),
  //   //                             ),
  //   //                           )),
  //   //                       Expanded(
  //   //                           flex: 1,
  //   //                           child: Center(
  //   //                               child: Text(StringRes.date,
  //   //                                   style: Theme.of(context)
  //   //                                       .textTheme
  //   //                                       .subtitle1
  //   //                                       .merge(TextStyle(
  //   //                                           fontWeight: FontWeight.bold,
  //   //                                           color: white))))),
  //   //                       Expanded(
  //   //                           flex: 1,
  //   //                           child: Padding(
  //   //                             padding: const EdgeInsets.only(right: 8.0),
  //   //                             child: Text(StringRes.amount,
  //   //                                 textAlign: TextAlign.end,
  //   //                                 style: Theme.of(context)
  //   //                                     .textTheme
  //   //                                     .subtitle1
  //   //                                     .merge(TextStyle(
  //   //                                         fontWeight: FontWeight.bold,
  //   //                                         color: white))),
  //   //                           ))
  //   //                     ],
  //   //                   ),
  //   //                 ),
  //   //                 Divider(
  //   //                   thickness: 1,
  //   //                   height: 20,
  //   //                   color: Colors.grey,
  //   //                 ),
  //   //                 ListView.builder(
  //   //                     shrinkWrap: true,
  //   //                     physics: const NeverScrollableScrollPhysics(),
  //   //                     itemCount: walletlist.length,
  //   //                     itemBuilder: (BuildContext ctxt, int index) {
  //   //                       Wallet item = walletlist[index];
  //   //                       String wdate = DateFormat('dd-MM-yyyy')
  //   //                           .format(DateTime.parse(item.date));
  //   //                       return Padding(
  //   //                         padding: const EdgeInsets.only(top: 5.0, bottom: 5),
  //   //                         child: Row(children: <Widget>[
  //   //                           Expanded(
  //   //                               flex: 2,
  //   //                               child: Padding(
  //   //                                 padding: const EdgeInsets.only(left: 8.0),
  //   //                                 child: Text(item.details),
  //   //                               )),
  //   //                           Expanded(
  //   //                               flex: 1,
  //   //                               child: Center(
  //   //                                   child: Text(
  //   //                                 wdate,
  //   //                               ))),
  //   //                           Expanded(
  //   //                               flex: 1,
  //   //                               child: Padding(
  //   //                                 padding: const EdgeInsets.only(right: 8.0),
  //   //                                 child: Text(item.amount,
  //   //                                     textAlign: TextAlign.end),
  //   //                               ))
  //   //                         ]),
  //   //                       );
  //   //                     }),
  //   //               ],
  //   //             ),
  //   //           );
  // }

  Future<dynamic> GetWalletData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {


      Map<String, String> body = {
        GET_WALLET_DETAIL: "1",
        userId: uuserid!,
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

      String error = res['error'];

      List<Wallet> walletlist=[];
      walletlist.addAll((res['data'] as List)
          .map((model) => Wallet.fromJson(model))
          .toList());
     // print("size ${walletlist.length}");
      if (error == "false"){
        return  walletlist;
      }
      else{
        return "No data";
      }


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
}
