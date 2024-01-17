

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/DesignConfig.dart';
import 'package:smartapp/Helper/Session.dart';
import 'package:smartapp/Helper/StringRes.dart';
import 'package:smartapp/Model/OneOnOneModel.dart';
import 'package:smartapp/Model/User.dart';
import 'package:smartapp/activity/HomeActivity.dart';
import 'package:smartapp/activity/OneOnOneEvent/OneOnOneEventDetailActivity.dart';

import '../Login.dart';



class OneOnOneEventActivity extends StatefulWidget{
    @override
    OneOnOneEventState createState() => OneOnOneEventState();
}

class OneOnOneEventState extends State<OneOnOneEventActivity>{


    @override
    void initState() {
        super.initState();

        oneononeeventlist = [];
        GetUserStatus();
        loadOneOnOneEventData();
    }


    @override
    void dispose() {


        super.dispose();
    }


    Future<void> GetUserStatus() async {
        String? userid = await getPrefrence(USER_ID);

        var parameter = {
            GET_USER_BY_ID: "1",
            userId: userid
        };
        var response = await Constant.getApiData(parameter);

        final getdata = json.decode(response);

        String error = getdata["error"];

        if (error == ("false")) {
            String status = getdata["data"]["status"];


            if (status != active) {
                clearUserSession();
                FirebaseAuth.instance.signOut();
                  //facebookSignIn.logOut();

                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => Login()), ModalRoute.withName('/'));
            } else {
                UserModel user = new UserModel.fromJson(getdata["data"]);
                setState(() {
                    uamount = getdata['data']['amount'];
                });

                saveUserDetail(user.user_id!, user.name!, user.email!, user.mobile!, user.profile ?? '', user.refer_code ?? '',user.type ?? '',user.location ?? '',user.fid ?? '');


                //RemoveGameRoomId();
            }
        }
    }

    Future loadOneOnOneEventData() async {
        bool checkinternet = await Constant.CheckInternet();
        if (!checkinternet) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(StringRes.checknetwork)));
        }else {
       
            // if (tradeisloadmore) {
            setState(() {
                isgettingoneononedata = true;
                isnodataoneonone = false;
            });

            if(uuserid == null){
                uname = await getPrefrence(NAME);
                uemail = await getPrefrence(EMAIL);
                uuserid = await getPrefrence(USER_ID);
                uprofile = await getPrefrence(PROFILE);
                umobile = await getPrefrence(MOBILE);
                ulocation = await getPrefrence(LOCATION);
            }
            Map<String, String> body = {
                GET_ONEONONE_EVENT : "1",
                userId : uuserid!
            };


            var response = await Constant.getApiData(body);
            print("loadmain---res-$response");
            final res = json.decode(response);

            String error = res['error'];
            isgettingoneononedata = false;

            if (error == "false") {

                if (mounted) {
                    new Future.delayed(Duration.zero, () =>
                        setState(() {
                            oneononeeventlist!.clear();
                            oneononeeventlist!.addAll((res['data'] as List).map((model) => OneOnOneModel.fromJson(model)).toList());
                            print("loadgroup---res-${oneononeeventlist!.length}");
                        }));
                }
            } else {
                isnodataoneonone = true;
                setState(() {
                });
            }
            //}
        }
    }



    @override
    Widget build(BuildContext context) {

        return Scaffold(
            backgroundColor: white,
            appBar: AppBar(
                //brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
                centerTitle: true,
                // backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                    color: Colors.white,
                ),
                flexibleSpace: Container(decoration: DesignConfig.gradientbackground,),
                title: Text(StringRes.oneonone,style: TextStyle(fontFamily: 'TitleFont',color: white),),
                actions: <Widget>[

                ],
            ),
            body: Builder(
                builder: (context) =>  isgettingoneononedata ? Center(child: new CircularProgressIndicator(backgroundColor: appcolor,)) : Container(
                    padding: const EdgeInsets.only(top:8.0,left: 5,right: 5,bottom: 5),
                    decoration: DesignConfig.gradientbackground,
                    child: isnodataoneonone ? Center(child: Text(StringRes.nodatafound,style: Theme.of(context).textTheme.titleMedium?.merge(TextStyle(color: appcolor,fontWeight: FontWeight.bold)),)) : ListView.builder(
                        itemCount: oneononeeventlist!.length,
                        itemBuilder: (BuildContext context, int index){
                            OneOnOneModel item = oneononeeventlist![index];
                            //DateTime datee = DateTime.parse("${item.date.split("-")[2]}-${item.date.split("-")[1]}-${item.date.split("-")[0]} ${item.end_time}");
                            //String endtime = DateFormat('hh:mm a').format(datee);
                            String buyamt = int.parse(item.entryamount!) <= 0 ? StringRes.free : "${item.entryamount}${Constant.CURRENCYSYMBOL.toLowerCase()}";

                            return GestureDetector(onTap: (){
                                selectedoneononeevent = item;
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => OneOnOneEventDetailActivity()));
                            },
                                child: Card(
                                    margin: EdgeInsets.only(bottom: 10,left: 5,right: 5),

                                    shape: RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(10.0),)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Row(
                                        children: <Widget>[
                                            ClipRRect(
                                                borderRadius: BorderRadius.circular(8.0),
                                                child: FadeInImage.assetNetwork(
                                                    image: item.image!,
                                                    placeholder: "assets/images/placeholder.png",
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                ),
                                            ),
                                            Expanded(
                                                child: Padding(
                                                    padding: const EdgeInsets.only(left:5.0,right: 5),
                                                    child: Column(mainAxisAlignment: MainAxisAlignment.start,
                                                        children: <Widget>[
                                                            Text("${item.title}",maxLines: 1,overflow: TextOverflow.ellipsis,style: Theme.of(context).textTheme.titleLarge?.merge(TextStyle(color: black,fontWeight: FontWeight.w600))),
                                                            Text("Buy Ticket at $buyamt and Win ${item.winning_amount}${Constant.CURRENCYSYMBOL.toLowerCase()}",textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleSmall?.merge(TextStyle(color: appcolor))),
                                                            Text("${item.description}",maxLines: 1,overflow: TextOverflow.ellipsis,)


                                                        ],
                                                    ),
                                                ),
                                            ),


                                        ],
                                    ),
                                ),
                            );
                        },
                    ),

                ))

        );
    }



}
