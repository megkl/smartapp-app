import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Helper/global.dart';
import 'package:smartapp/Model/Withdraw.dart';
import 'package:shimmer/shimmer.dart';

import 'HomeActivity.dart';

class WithdrawHistory extends StatefulWidget {
  const WithdrawHistory({Key? key}) : super(key: key);

  @override
  _WithdrawHistoryState createState() => _WithdrawHistoryState();
}

class _WithdrawHistoryState extends State<WithdrawHistory> {
  bool iswithloading = false, iswithnodata = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightSpace = size.width / 10;
    return Scaffold(
        appBar: AppBar(
          title: Text("Withdraw History", style: TextStyle(color: white),),
          //brightness: Brightness.dark,
          foregroundColor: white,
          centerTitle: true,
          backgroundColor: primary,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Text("data"),
            SizedBox(height: heightSpace/2,),
            Flexible(child:  FutureBuilder(
                future: GetWithdrawData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
    
                  if(snapshot.hasData || snapshot.connectionState == ConnectionState.done){
                    // print(snapshot.data[0].details + snapshot.data[0].date);

                    if(snapshot.data != null){
                      return  ListView.builder(
                          itemCount: snapshot.data.length,
                          scrollDirection: Axis.vertical,
                          primary: true,
                          itemBuilder: (BuildContext context, int index) {
                            return  Padding(
                              padding: EdgeInsets.only(
                                  left: 2, bottom: 2, right: 2),
                              child: WithdrawalItemList(snapshot.data[index].date.toString(),snapshot.data[index].details.toString(),snapshot.data[index].request_amount.toString(),snapshot.data[index].status.toString()),
                            );
                          });
                    }
                    else{
                      return Align(alignment:Alignment.center,child:Column(
                        children: [
                          SizedBox(height: size.width/2,),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text("Unable to load your Withdrawal history or no history found.",
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.fade,
                                style: kTextHeadStyle.apply(color: primary)),
                          ),
                          SizedBox(height: size.width/3,),

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
                              return LoadingEffectWith();
                            }));
                  }

                }))
          ],
        ));
  }

  // Widget WithdrawData() {
  //   return SingleChildScrollView(
  //       child: Container(
  //           decoration: BoxDecoration(
  //               color: primary,
  //               borderRadius: BorderRadius.only(
  //                   bottomLeft: Radius.circular(30),
  //                   bottomRight: Radius.circular(30))),
  //           child: iswithloading
  //               ? Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 80.0),
  //                   child: Center(child: new CircularProgressIndicator()),
  //                 )
  //               : iswithnodata || withdrawlist.length == 0
  //                   ? Padding(
  //                       padding: const EdgeInsets.symmetric(vertical: 80.0),
  //                       child: Center(
  //                           child: Text(
  //                         StringRes.nodatafound,
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .subtitle1
  //                             .merge(TextStyle(fontWeight: FontWeight.bold)),
  //                       )),
  //                     )
  //                   : Padding(
  //                       padding: const EdgeInsets.all(20.0),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: <Widget>[
  //
  //
  //  Padding(
  //                         padding: EdgeInsets.only(
  //                             top: MediaQuery.of(context).padding.top),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //
  //                             Padding(
  //                               padding: const EdgeInsets.only(left: 8.0),
  //                               child: Text(
  //                                 "Withdraw",
  //                                 style: TextStyle(
  //                                     color: white, fontWeight: FontWeight.bold),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Divider(
  //                           color: white,
  //                           thickness: 2,
  //                         ),
  //                       ),
  //
  //                           Padding(
  //                             padding: EdgeInsets.only(
  //                                 top: 8),
  //                             child: Row(
  //                               children: <Widget>[
  //                                 Expanded(
  //                                     flex: 2,
  //                                     child: Padding(
  //                                       padding:
  //                                           const EdgeInsets.only(left: 8.0),
  //                                       child: Text(
  //                                         StringRes.details,
  //                                         style: Theme.of(context)
  //                                             .textTheme
  //                                             .subtitle1
  //                                             .merge(TextStyle(
  //                                                 fontWeight: FontWeight.bold,
  //                                                 color: white)),
  //                                       ),
  //                                     )),
  //                                 Expanded(
  //                                     flex: 1,
  //                                     child: Center(
  //                                         child: Text(StringRes.date,
  //                                             style: Theme.of(context)
  //                                                 .textTheme
  //                                                 .subtitle1
  //                                                 .merge(TextStyle(
  //                                                     fontWeight:
  //                                                         FontWeight.bold,
  //                                                     color: white))))),
  //                                 Expanded(
  //                                     flex: 1,
  //                                     child: Padding(
  //                                       padding:
  //                                           const EdgeInsets.only(right: 8.0),
  //                                       child: Text(StringRes.amount,
  //                                           textAlign: TextAlign.end,
  //                                           style: Theme.of(context)
  //                                               .textTheme
  //                                               .subtitle1
  //                                               .merge(TextStyle(
  //                                                   fontWeight: FontWeight.bold,
  //                                                   color: white))),
  //                                     ))
  //                               ],
  //                             ),
  //                           ),
  //                           // Divider(
  //                           //   thickness: 1,
  //                           //   height: 20,
  //                           //   color: grey,
  //                           // ),
  //                           ListView.builder(
  //                               shrinkWrap: true,
  //                               physics: const NeverScrollableScrollPhysics(),
  //                               itemCount: withdrawlist.length,
  //                               itemBuilder: (BuildContext ctxt, int index) {
  //                                 Withdraw item = withdrawlist[index];
  //                                 String status = item.status.trim() == "0"
  //                                     ? "Pending"
  //                                     : "Completed";
  //                                 Color scolor = item.status.trim() == "0"
  //                                     ? orange
  //                                     : green;
  //                                 String wdate = DateFormat('dd-MM-yyyy')
  //                                     .format(DateTime.parse(item.date));
  //                                 return GestureDetector(
  //                                   onTap: () {
  //                                     showDialog<void>(
  //                                         context: context,
  //                                         builder: (BuildContext context) {
  //                                           return AlertDialog(
  //                                               title: Text(
  //                                                 '${Constant.setFirstLetterUppercase(item.details)}',
  //                                                 style: TextStyle(
  //                                                     color: appcolor,
  //                                                     fontWeight:
  //                                                         FontWeight.bold),
  //                                               ),
  //                                               content: Text(
  //                                                 'Status : $status\nAmount : ${item.request_amount}\nDetail : ${item.details}',
  //                                                 style: TextStyle(
  //                                                     color: appcolor),
  //                                               ),
  //                                               actions: <Widget>[
  //                                                 FlatButton(
  //                                                   child: Text('Ok'),
  //                                                   onPressed: () {
  //                                                     Navigator.of(context)
  //                                                         .pop();
  //                                                   },
  //                                                 ),
  //                                               ]);
  //                                         });
  //                                   },
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.only(
  //                                         top: 5.0, bottom: 5),
  //                                     child: Row(children: <Widget>[
  //                                       Expanded(
  //                                           flex: 2,
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.only(
  //                                                 left: 8.0),
  //                                             child: Row(
  //                                               children: <Widget>[
  //                                                 Icon(
  //                                                   Icons.brightness_1,
  //                                                   color: scolor,
  //                                                   size: 12,
  //                                                 ),
  //                                                 Flexible(
  //                                                   child: Padding(
  //                                                     padding:
  //                                                         const EdgeInsets.only(
  //                                                             left: 8.0),
  //                                                     child: Text(
  //                                                       "${Constant.setFirstLetterUppercase(item.details)}",
  //
  //                                                     ),
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           )),
  //                                       Expanded(
  //                                           flex: 1,
  //                                           child: Center(
  //                                               child: Text(
  //                                             wdate,
  //                                           ))),
  //                                       Expanded(
  //                                           flex: 1,
  //                                           child: Padding(
  //                                             padding: const EdgeInsets.only(
  //                                                 right: 8.0),
  //                                             child: Text(
  //                                               item.request_amount,
  //                                               textAlign: TextAlign.end,
  //                                             ),
  //                                           ))
  //                                     ]),
  //                                   ),
  //                                 );
  //                               }),
  //                         ],
  //                       ),
  //                     )));
  // }

  Future GetWithdrawData() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));

    } else {

      Map<String, String> body = {
        GET_WITHDRAW_DETAIL: "1",
        userId: uuserid!,
      };

      var response = await Constant.getApiData(body);

      final res = json.decode(response);

     // print("${res.toString()}");

      String error = res['error'];
      List<Withdraw> withdrawlist=[];
      withdrawlist.addAll((res['data'] as List)
          .map((model) => Withdraw.fromJson(model))
          .toList());
      if (error == "false"){
        return  withdrawlist;
      }
      else{
        return "No data";
      }
    }
  }
}
