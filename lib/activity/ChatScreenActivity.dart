import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

//import 'package:path_provider/path_provider.dart';
//import 'package:file_picker/file_picker.dart';
//import 'package:http/http.dart' as http;
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/DesignConfig.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/ChatMessage.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Helper/Session.dart';


bool ischatscreen = false, issendfirst = false;
String chatgroupid = "", chatfrom = "";

final List<ChatMessage> _messages = <ChatMessage>[];

StreamController<String>? chatstreamdata;
String title = "Chat";

class ChatScreenActivity extends StatefulWidget {
    @override
    ChatScreenState createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreenActivity> {
    bool isLoading = false, isloadmore = true;
    int pageno = 0;
    final TextEditingController textEditingController =
    new TextEditingController();
    ScrollController _scrollController = new ScrollController();

    //String myid = Constant.session.getData(UserSessionManager.KEY_ID);
    String? selectedtype;
    File? sendfile;
    bool issending = false;
    String _filePath = "", lastmsg = "";
    Map<String, String>? downloadlist;

    bool? _isLoading;
    bool? _permissionReady;
    String? _localPath;


    final StreamController<bool> streamController =
    StreamController<bool>.broadcast();
    final _scaffoldKeychat = GlobalKey<ScaffoldState>();

    @override
    void initState() {
        super.initState();


        ischatscreen = true;
        issendfirst = true;
        SetUserData();
        setState(() {
            if (chatfrom.toLowerCase() == Constant.lblgroupevent.toLowerCase()) {
                title = selectedgroupevent!.title!;
            } else if (chatfrom.toLowerCase() ==
                Constant.lbloneononeevent.toLowerCase()) {
                title = selectedoneononeevent!.title!;
            }
        });
        downloadlist = new Map<String, String>();
        Constant.SetCurrentDateData();
        setupChannel();

        pageno = 0;
        _getMoreData();

        _scrollController.addListener(() {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent) {
                _getMoreData();
            }
        });

        //Checkpermission();
    }

    Future<void> SetUserData() async {
        User? currentUser = FirebaseAuth.instance.currentUser!;
        if (currentUser != null) firebaseuserid = currentUser.uid;
        else
            firebaseuserid=(await getPrefrence(FIR_ID))!;

        utype = (await getPrefrence(LOGIN_TYPE))!;
        uname = (await getPrefrence(NAME))!;
        uemail = (await getPrefrence(EMAIL))!;
        uuserid = (await getPrefrence(USER_ID))!;
        uprofile = (await getPrefrence(PROFILE))!;
        umobile = (await getPrefrence(MOBILE))!;
        ulocation = (await getPrefrence(LOCATION))!;
        setState(() {});
    }



    void setupChannel() {

       // chatstreamdata = StreamController<String>(); //.broadcast();
        chatstreamdata = StreamController<String>.broadcast();
        chatstreamdata?.stream.listen((response) {

            setState(() {
                final res = json.decode(response);
                ChatMessage message;
                String mid;

                message = ChatMessage.fromThreadJson(res);


                _messages.insert(0, message);
                selectedtype = null;
                sendfile = null;
            });
        });
    }

    void InsertItem(String response) {
        if (ischatscreen &&
            (selectedgroupevent != null || selectedoneononeevent != null)) {

            if (chatstreamdata != null) chatstreamdata!.sink.add(response);
            _scrollController.animateTo(0.0,
                duration: Duration(milliseconds: 300), curve: Curves.easeOut);
        }
    }

    Future<bool> onBackPress() {
        RemoveData();

        return Future.value(true);
    }

    Future _getMoreData() async {
        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
        } else {
            if (isloadmore) {
                setState(() {
                    isloadmore = false;
                    if (pageno == 0) {
                        isLoading = true;
                        _messages.clear();
                    }
                });

                Map<String, String> body = {
                    LOAD_ALL_MESSAGE: "1",
                    userId: userId,
                    ORDER: "DESC",
                    LIMIT: Constant.LOAD_DATA_LIMIT.toString(),
                    STARTING: pageno.toString(),
                };

                if (chatfrom.toLowerCase() == Constant.lblgroupevent.toLowerCase()) {
                    body[EVENT_ID] = selectedgroupevent!.id!;
                    body[TYPE] = "group_event";
                } else if (chatfrom.toLowerCase() ==
                    Constant.lbloneononeevent.toLowerCase()) {
                    body[EVENT_ID] = selectedoneononeevent!.id!;
                    body[TYPE] = "one_on_one_contest";
                }

                var response = await Constant.getApiData(body);
                if (response == null || response.toString().trim().length == 0) {
                    isloadmore = true;
                    _getMoreData();
                } else {
                    final res = json.decode(response);
                    if (!mounted)
                        return;
                    else if (pageno == 0) {
                        setState(() {
                            isLoading = false;
                        });
                    }

                    if (res['error'].toString() == "false") {
                        isloadmore = true;
                        pageno = pageno + Constant.LOAD_DATA_LIMIT;

                        new Future.delayed(
                            Duration.zero,
                                () => setState(() {
                                _messages.addAll((res['data'] as List)
                                    .map((model) => ChatMessage.fromThreadJson(model))
                                    .toList());
                            }));
                    } else {
                        setState(() {
                            isloadmore = false;
                        });
                    }
                }
            }
        }
    }

    @override
    Widget build(BuildContext context) {
        return WillPopScope(
            onWillPop: onBackPress,
            child: Scaffold(
                key: _scaffoldKeychat,
                //backgroundColor: ColorsRes.bgcolor,
                appBar: AppBar(
                    centerTitle: true,
                    flexibleSpace: Container(
                        decoration: DesignConfig.gradientbackground,
                    ),
                    title: Text(
                        title,
                        style: TextStyle(fontFamily: 'TitleFont'),
                    ),
                    actions: <Widget>[
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                                return await showDialog<void>(
                                    context: context,
                                    //barrierDismissible: false,
                                    builder: (BuildContext context) {
                                        return AlertDialog(
                                            title: Text('Remove Notification'),
                                            content: Text(
                                                'Are you sure you don\'t want to hear Notification from $title Group ?'),
                                            actions: <Widget>[
                                                ElevatedButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                        Navigator.of(context).pop();
                                                    },
                                                ),
                                                ElevatedButton(
                                                    child: Text('Remove'),
                                                    onPressed: () async {
                                                        Navigator.of(context).pop();
                                                        Map<String, String> addbody = {
                                                            userId: uuserid!,
                                                            REMOVE_MEMBER_GROUP: "1",
                                                        };


                                                        if (chatfrom.toLowerCase() ==
                                                            Constant.lblgroupevent.toLowerCase()) {
                                                            addbody[EVENT_ID] = selectedgroupevent!.id!;
                                                            addbody[TYPE] = "group_event";
                                                        } else if (chatfrom.toLowerCase() ==
                                                            Constant.lbloneononeevent.toLowerCase()) {
                                                            addbody[EVENT_ID] = selectedoneononeevent!.id!;
                                                            addbody[TYPE] = "one_on_one_contest";
                                                        }
                                                        var addresponse =
                                                        await Constant.getApiData(addbody);
                                                        final res = json.decode(addresponse);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text(res['message'])));
                                                        Timer(Duration(seconds: 1), () {
                                                            Navigator.of(_scaffoldKeychat.currentContext!)
                                                                .pop();
                                                        });
                                                    },
                                                ),
                                            ],
                                        );
                                    },
                                );
                            },
                        )
                    ],
                ),
                body: Stack(children: <Widget>[
                    Column(
                        children: <Widget>[
                            buildListMessage(),
                            buildInput(),
                        ],
                    ),
                    buildLoading()
                ]),
            ),
        );
    }

    @override
    void dispose() {
        RemoveData();
        super.dispose();
    }

    void RemoveData() {


        chatfrom = "";
        chatgroupid = "";
        ischatscreen = false;
        if (chatstreamdata != null) chatstreamdata!.sink.close();


    }

    Widget buildListMessage() {
        return Flexible(
            child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemBuilder: (context, index) => buildItem(index, _messages[index]),
                itemCount: _messages.length,
                reverse: true,
                controller: _scrollController,
            ),
        );
    }

    Widget buildItem(int index, ChatMessage message) {

        if (message.user_id == uuserid) {
            //Own message
            return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                    Flexible(
                        flex: 1,
                        child: Container(),
                    ),
                    Flexible(
                        flex: 2,
                        child: MsgContent(index, message),
                    ),
                ],
            );
        } else {
            //Other's message
            return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                    Flexible(
                        flex: 2,
                        child: MsgContent(index, message),
                    ),
                    Flexible(
                        flex: 1,
                        child: Container(),
                    ),
                ],
            );
        }
    }

    Widget MsgContent(int index, ChatMessage message) {
        /*String filetype = message.attachment_mime_type.trim();
    String file = message.attachments;*/
        return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: message.user_id == uuserid
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: <Widget>[
                message.user_id == uuserid
                    ? Container()
                    : Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                            ClipOval(
                                child: message.profile == null ||
                                    message.profile!.isEmpty
                                    ? Image.asset(
                                    "assets/images/placeholder.png",
                                    width: 25,
                                    height: 25,
                                )
                                    : FadeInImage.assetNetwork(
                                    image: message.profile!,
                                    placeholder: "assets/images/placeholder.png",
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                )),
                            Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Text(
                                    Constant.setFirstLetterUppercase(message.name ??''),
                                    style: TextStyle(color: appcolor, fontSize: 12)),
                            )
                        ],
                    ),
                ),
                Card(
                    //margin: EdgeInsets.only(right: message.sender_id == myid ? 10 : 50, left: message.sender_id == myid ? 50 : 10, bottom: 10),
                    elevation: 5.0,
                    color: message.user_id == uuserid ? chatbg : white,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: message.user_id == uuserid
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: <Widget>[

                                Text("${message.message}", style: TextStyle(color: black)),
                                Padding(
                                    padding: const EdgeInsetsDirectional.only(top: 5),
                                    child: Text(Constant.DisplayMsgTime(message.date??''),
                                        style: TextStyle(color: grey, fontSize: 10)),
                                ),
                            ],
                        ),
                    ),
                ),
            ],
        );
    }

    Widget buildLoading() {
        return Positioned(
            child: isLoading
                ? Container(
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(appcolor)),
                ),
                color: Colors.white.withOpacity(0.8),
            )
                : Container(),
        );
    }

    Widget buildInput() {
        return Column(
            children: <Widget>[

                Container(
                    child: Row(
                        children: <Widget>[
                            Flexible(
                                child: Container(
                                    margin: new EdgeInsets.symmetric(horizontal: 8.0),
                                    child: TextField(
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(color: appcolor, fontSize: 15.0),
                                        controller: textEditingController,
                                        decoration: InputDecoration.collapsed(
                                            hintText: StringRes.lbl_type_your_message,
                                            hintStyle: TextStyle(color: grey),
                                        ),
                                        //focusNode: focusNode,
                                    ),
                                ),
                            ),

                            Material(
                                child: new Container(
                                    margin: new EdgeInsets.symmetric(horizontal: 8.0),
                                    child: new IconButton(
                                        icon: new Icon(Icons.send),
                                        onPressed: () =>
                                            onSendMessage(textEditingController.text, 0),
                                        color: appcolor,
                                    ),
                                ),
                                color: Colors.white,
                            )
                        ],
                    ),
                    width: double.infinity,
                    height: 50.0,
                    decoration: new BoxDecoration(
                        border: new Border(top: new BorderSide(color: grey, width: 0.5)),
                        color: Colors.white),
                ),
            ],
        );
    }



    void onSendMessage(String content, int type) {
        //if (selectedtype != null || content.trim() != '') {
        if (content.trim() != '') {
            SendMsgToServer(content);
            textEditingController.clear();
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(StringRes.lbl_type_your_message)));
        }
    }

    Future SendMsgToServer(String msg) async {
        if (issendfirst) {
            Map<String, String> addbody = {
                userId: uuserid!,
                ADD_MEMBER_TO_GROUP_CHAT: "1",
            };


            if (chatfrom.toLowerCase() == Constant.lblgroupevent.toLowerCase()) {
                addbody[EVENT_ID] = selectedgroupevent!.id!;
                addbody[TYPE] = "group_event";
            } else if (chatfrom.toLowerCase() ==
                Constant.lbloneononeevent.toLowerCase()) {
                addbody[EVENT_ID] = selectedoneononeevent!.id!;
                addbody[TYPE] = "one_on_one_contest";
            }

            var addresponse = await Constant.getApiData(addbody);

            issendfirst = false;
        }

        Map<String, String> body = {
            userId: uuserid!,
            MESSAGE: msg,
            SEND_MESSAGE_TO_GROUP: "1"
        };


        if (chatfrom.toLowerCase() == Constant.lblgroupevent.toLowerCase()) {
            body[EVENT_ID] = selectedgroupevent!.id!;
            body[TYPE] = "group_event";
        } else if (chatfrom.toLowerCase() ==
            Constant.lbloneononeevent.toLowerCase()) {
            body[EVENT_ID] = selectedoneononeevent!.id!;
            body[TYPE] = "one_on_one_contest";
        }

        setState(() {
            issending = true;
        });

        var response;
        lastmsg = msg;


        response = await Constant.getApiData(body);

        final res = json.decode(response);
        setState(() {
            issending = false;
        });

        if (res['error'].toString() == "false") {
            Map<String, dynamic> sendata;


            InsertItem(response);
            //InsertItem(jsonEncode(sendata));

        } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(StringRes.lbl_msgfailed)));

        }
    }


}
