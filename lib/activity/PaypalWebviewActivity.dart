import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/services/authentication.dart';

import 'HomeActivity.dart';
import 'TheMainEvent/DailChallenge.dart';
import 'TheMainEvent/MainEventActivity.dart';

class PaypalWebviewActivity extends StatefulWidget {
  String? mainurl, from, amount, detail;
  String? navigate;
  BaseAuth? auth;
  VoidCallback? refresh, homeRefresh;

  PaypalWebviewActivity(this.mainurl, this.from, this.amount, this.detail,
      this.refresh, this.homeRefresh,this.navigate,this.auth);

  @override
  State<StatefulWidget> createState() {
    return PayPalWebview(this.mainurl, this.from, this.amount, this.detail,this.navigate,this.auth);
  }
}

class PayPalWebview extends State<PaypalWebviewActivity> {
  String? mainurl, from, amount, detail;
  String? message = "";
  String? navigate;
  BaseAuth? auth;
  bool? ispaid = false;
  
  PayPalWebview(this.mainurl, this.from, this.amount, this.detail,this.navigate,this.auth);

  bool isloading = false;
  GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();
  // final Completer<WebViewController> _controller =  Completer<WebViewController>();

  final GlobalKey? webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions? options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController? pullToRefreshController;
  ContextMenu? contextMenu;
  String? url = "";
  double? progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: primary,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    //mainurl = mainurl + "&hash=" + Constant.CreatesJwt("paypal");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: BlankBar(),
        body:
            //isloading ? Center(child: new CircularProgressIndicator(),) :
            Stack(
          children: <Widget>[
            InAppWebView(
              key: webViewKey,
              // contextMenu: contextMenu,
              initialUrlRequest: URLRequest(url: WebUri(mainurl??'')),
              // initialFile: "assets/index.html",
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url!;
                });
              },
              androidOnPermissionRequest:
                  (controller, origin, resources) async {
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                String uri = navigationAction.request.url.toString();
           
                // if (![
                //   "http",
                //   "https",
                //   "file",
                //   "chrome",
                //   "data",
                //   "javascript",
                //   "about"
                // ].contains(uri.scheme)) {
                //  if (await canLaunch(url)) {
                // Launch the App
                // await launch(
                //   url,
                // );

                if (uri.startsWith(PAYPAL_RESPONSE_URL)) {
                  setState(() {
                    isloading = true;
                  });

                  String responseurl = uri;

                  if (responseurl.contains("Failed") ||
                      responseurl.contains("failed")) {
                    setState(() {
                      isloading = false;
                      message = "Transaction Failed";
                    });
                    Timer(Duration(seconds: 1), () {
                      Navigator.pop(context);
                    });
                  } else if (responseurl.contains("Completed") ||
                      responseurl.contains("completed")) {
                    setState(() {
                      setState(() {
                        message = "Transaction Successfull";
                      });
                    });
                    List<String> testdata = responseurl.split("&");
                    for (String data in testdata) {
                      if (data.split("=")[0].toLowerCase() == "tx") {
                        String txid = data.split("=")[1];
                        //print("==id=********=$data===$txid");

                        if (from == Constant.lblWallet) {
                          AddMoneyToWallet();
                        } else
                          SetTransactionData(txid, "Paypal");
                        break;
                      }
                    }
                  }

                  return NavigationActionPolicy.CANCEL;
                } else if (uri.startsWith(CARD_SUCCESS)) {
                  print("test***success card");
                  setState(() {
                    isloading = true;
                  });

                  String responseurl = uri;

                  if (responseurl.contains("st=successful")) {
                    setState(() {
                      message = "Transaction Successfull";
                    });

                    List<String> testdata = responseurl.split("&");

                    for (String data in testdata) {
                      if (data.split("=")[0].toLowerCase() == "tx") {
                        String txid = data.split("=")[1];
                        //print("==id=********=$data===$txid");

                        if (from == Constant.lblWallet) {
                          AddMoneyToWallet();
                        } else
                          SetTransactionData(txid, widget.detail!);
                        break;
                      }
                    }
                  } else {
                    setState(() {
                      isloading = false;
                      message = "Transaction Failed";
                    });
                    Timer(Duration(seconds: 1), () {
                      Navigator.pop(context);
                    });
                  }

                  return NavigationActionPolicy.CANCEL;
               
                } else
                  return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController!.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url!;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController!.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController!.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = this.url!;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url!;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
              
              },
            ),

            // WebView(
            //   initialUrl: mainurl,
            //   javascriptMode: JavascriptMode.unrestricted,
            //   onWebViewCreated: (WebViewController webViewController) {
            //     _controller.complete(webViewController);
            //   },
            //   javascriptChannels: <JavascriptChannel>[
            //     _toasterJavascriptChannel(context),
            //   ].toSet(),
            //   navigationDelegate: (NavigationRequest request) async
            //   {
            //     if (request.url.startsWith(PAYPAL_RESPONSE_URL)) {
            //       setState(() {
            //         isloading = true;
            //       });

            //       String responseurl = request.url;

            //       if (responseurl.contains("Failed") ||
            //           responseurl.contains("failed")) {
            //         setState(() {
            //           isloading = false;
            //           message = "Transaction Failed";
            //         });
            //         Timer(Duration(seconds: 1), () {
            //           Navigator.pop(context);
            //         });
            //       } else if (responseurl.contains("Completed") ||
            //           responseurl.contains("completed")) {
            //         setState(() {
            //           setState(() {
            //             message = "Transaction Successfull";
            //           });
            //         });
            //         List<String> testdata = responseurl.split("&");
            //         for (String data in testdata) {
            //           if (data.split("=")[0].toLowerCase() == "tx") {
            //             String txid = data.split("=")[1];
            //             //print("==id=********=$data===$txid");

            //             if (from == Constant.lblWallet) {
            //               AddMoneyToWallet();
            //             } else
            //               SetTransactionData(txid, "Paypal");
            //             break;
            //           }
            //         }
            //       }

            //       return NavigationDecision.prevent;
            //     } else if (request.url.startsWith(CARD_SUCCESS)) {
            //       setState(() {
            //         isloading = true;
            //       });

            //       String responseurl = request.url;

            //       if (responseurl.contains("st=successful")) {
            //         setState(() {
            //           setState(() {
            //             message = "Transaction Successfull";
            //           });
            //         });

            //         List<String> testdata = responseurl.split("&");

            //         for (String data in testdata) {
            //           if (data.split("=")[0].toLowerCase() == "tx") {
            //             String txid = data.split("=")[1];
            //             //print("==id=********=$data===$txid");

            //             if (from == Constant.lblWallet) {
            //               AddMoneyToWallet();
            //             } else
            //               SetTransactionData(txid, widget.detail);
            //             break;
            //           }
            //         }
            //       } else {
            //         setState(() {
            //           isloading = false;
            //           message = "Transaction Failed";
            //         });
            //         Timer(Duration(seconds: 1), () {
            //           Navigator.pop(context);
            //         });
            //       }

            //       return NavigationDecision.prevent;
            //     }

            //     return NavigationDecision.navigate;
            //   },
            //   onPageFinished: (String url) {
            //     // print('Page finished loading: $url');
            //   },
            // ),
            isloading
                ? Center(
                    child: new CircularProgressIndicator(),
                  )
                : Container(),
            message!.trim().isEmpty
                ? Container()
                : Center(
                    child: Container(
                        color: appcolor,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        child: Text(
                          message ??'',
                          style: TextStyle(color: white),
                        )))
          ],
        ));
  }

  // JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
  //   return JavascriptChannel(
  //       name: 'Toaster',
  //       onMessageReceived: (JavascriptMessage message) {
  //         Scaffold.of(context).showSnackBar(
  //           SnackBar(content: Text(message.message)),
  //         );
  //       });
  // }

  Future SetTransactionData(String transid, String type) async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      if (!isloading) {
        setState(() {
          isloading = true;
        });
      }

      Map<String, String> body = {
        userId: uuserid!,
        TRANSACTION_ID: transid,
        TYPE: type,
      };

      if (from == Constant.lblmainevent) {
        body[SET_USER_PAID_MAIN_EVENT_NEW] = "1";
        body[EVENT_ID] = selectedmainevent!.id!;
        // body[ROUND] = selectedmaineventround.round_number;
        body[AMOUNT] = selectedmainevent!.amount!;
      } else if (from == Constant.lblDaily) {
        body[SET_USER_PAID_MAIN_EVENT] = "1";
        body[userId] = uuserid!;
        body[MAIN_EVENT_ID] = selectedDailyEvent!.id!;
        body[AMOUNT] = selectedDailyEvent!.amount!;
      } else if (from == Constant.lblgroupevent) {
        body[SET_USER_PAID_GROUP_EVENT] = "1";
        body[GROUP_EVENT_ID] = selectedgroupevent!.id!;
        body[AMOUNT] = selectedgroupevent!.entryamount!;
      } else if (from == Constant.lbloneononeevent) {
        body[SET_USER_PAID_ONEONONE_EVENT] = "1";
        body[EVENT_ID] = selectedoneononeevent!.id!;
        body[AMOUNT] = selectedoneononeevent!.entryamount!;
        body[IS_ADD] = "true";
      }

      var responseapi = await Constant.getApiData(body);
      final res = json.decode(responseapi);

      String error = res['error'];
      isloading = false;

      setState(() {});

      if (error == "false") {
        FinishPage(res['message']);

        ispaid = true;
        widget.refresh!();
       print("successfully Paid");
       navigateTo();


      } else {
        FinishPage(res['message']);
      }
    }
  }

  void navigateTo(){
    if(navigate!.isNotEmpty){
      print("successfully Paid $navigate");
      if(navigate=="daily"){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DailyChallengeActivity()));
      }
      else{
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainEventActivity()));
      }
    }
  }

  void FinishPage(String finishmessage) {
    setState(() {
      message = finishmessage;
    });
    print("finishing");
    Timer(Duration(seconds: 1), () {
      if(navigate!.isNotEmpty){
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => HomeActivity()));
        // print("successfully Paid $navigate");
        // if(navigate=="daily"){
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => HomeActivity()));
        // }
        // else{
        //   Navigator.of(context).push(MaterialPageRoute(
        //       builder: (context) => HomeActivity(auth: widget.auth,)));
        // }
      }else {
        Navigator.pop(context);
      }
    });
  }

  Future<void> AddMoneyToWallet() async {
    bool checkinternet = await Constant.CheckInternet();
    if (!checkinternet) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
    } else {
      if (!isloading) {
        setState(() {
          isloading = true;
        });
      }
      String? userid = await getPrefrence(USER_ID);

      Map<String, String> body = {
        ADD_WALLET_DATA: "1",
        userId: userid!,
        AMOUNT: amount!,
        DETAIL: detail!,
      };

      var responseapi = await Constant.getApiData(body);
      final res = json.decode(responseapi);

      uamount = res['amount'];
      isloading = false;

      widget.refresh!();
      widget.homeRefresh!();

      FinishPage(res['message']);
    }
  }
}

class BlankBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
