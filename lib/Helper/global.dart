import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartapp/Helper/Color.dart';

class WithdrawalItemList extends StatelessWidget {
  final String activity;
  final String amount;
  final String sdate;
  final String status;

  WithdrawalItemList(this.sdate, this.activity, this.amount, this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.0, top: 5, left: 5, bottom: 5),
      child: Material(
        color: Colors.white,
        elevation: 0.4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: MaterialButton(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 1),
              child: Row(
                children: <Widget>[
                 ConstrainedBox(constraints: BoxConstraints(
                   minHeight: 60,
                   maxHeight: 70
                 ),
                 child: Container(
                   color: Colors.green,
                   width: 5,
                 ),
                 ),

                  SizedBox(width: 5,),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          activity.toUpperCase(),
                          style:
                          kTextNormalBoldStyle.apply(color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${DateFormat.yMMMEd().format(DateTime.parse(sdate))}",
                          style:
                          kTextNormalBoldStyle.apply(color: Colors.black54),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                    flex: 3,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  // Icon(Icons.arrow_forward_ios)

                  Text(
                    "Ksh $amount",
                    style: kTextNormalBoldStyle.apply(color: Colors.black54),
                  ),
                ],
              )),
          onPressed: () {

          },
        ),
      ),
    );
  }
}

class DepositItemList extends StatelessWidget {
  final String activity;
  final String amount;
  final String sdate;

  DepositItemList(this.sdate, this.activity, this.amount);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 5.0, top: 5, left: 5, bottom: 5),
      child: Material(
        color: Colors.white,
        elevation: 0.4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: MaterialButton(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 1),
              child: Row(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      child: Text("${getLetters(activity).toUpperCase()}",
                          style: kTextHeadStyle.apply(color: primary)),
                      backgroundColor: orangeTheme,
                    ),
                  ),

                  SizedBox(
                    width: 20,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          activity.toUpperCase(),
                          style:
                              kTextNormalBoldStyle.apply(color: Colors.black),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${DateFormat.yMMMEd().format(DateTime.parse(sdate))}",
                          style:
                              kTextNormalBoldStyle.apply(color: Colors.black54),
                          textAlign: TextAlign.justify,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                      ],
                    ),
                    flex: 3,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  // Icon(Icons.arrow_forward_ios)

                  Text(
                    "Ksh $amount",
                    style: kTextNormalBoldStyle.apply(color: Colors.black54),
                  ),
                ],
              )),
          onPressed: () {},
        ),
      ),
    );
  }
}

showColor(String item) {
  if (item == "Pending") {
    return Colors.deepOrange;
  } else if (item == "Completed") {
    return Colors.green;
  } else {
    return primary;
  }
}

String getLetters(String dateNumber) {
  try {
    if (dateNumber.contains(" ")) {
      var account = dateNumber.split(' ');
      if (account.length > 1) {
        try {
          return account[0].substring(0, 1) + account[1].substring(0, 1);
        } catch (e) {
          return account[1].trim().substring(1, 2);
        }
      } else {
        try {
          return account[0].substring(0, 1);
        } catch (e) {
          return account[1].trim().substring(1, 2);
        }
      }
    } else {
      return dateNumber.substring(0, 1);
    }
  } catch (e) {
    return "-";
  }
}
class EventsLoadingEffect extends StatelessWidget {
  double containerWidth = 280;
  double containerHeight = 35;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),bottomLeft: Radius.circular(8.0)),
            ),
            height: 100,
            width: 100,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: MediaQuery.of(context).size.width - 120,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: MediaQuery.of(context).size.width - 150,
                color: Colors.grey,
              )
            ],
          ))
        ],
      ),
    );
  }
}

class LoadingEffect extends StatelessWidget {
  double containerWidth = 280;
  double containerHeight = 15;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            height: 50,
            width: 50,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: MediaQuery.of(context).size.width - 100,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: MediaQuery.of(context).size.width - 150,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
class LoadingEffectWith extends StatelessWidget {
  double containerWidth = 280;
  double containerHeight = 15;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            height: 50,
            width: 5,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: MediaQuery.of(context).size.width - 100,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: MediaQuery.of(context).size.width - 150,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}

getGpoints(String uamount){
  if(uamount != "null") {
    var dAmount = double.parse(uamount);
    if(dAmount>=100){
      double bonusTobeOffered=dAmount/100;
      double bonusPoints=bonusTobeOffered*2;

      double dPoints=dAmount/5;
      double dGcoins=dPoints+bonusPoints;
     // print("bonusTobeOffered $bonusTobeOffered | bonusPoints $bonusPoints | originalPoints $d_points | gcoins $d_gcoins");
      return "${dGcoins.toStringAsFixed(0)}";
    }
    else{
      double dPoints=dAmount/5;
      return "${dPoints.toStringAsFixed(0)}";
    }
  }
  else{
    return "$uamount";
  }

}

class CustomInputField extends StatelessWidget {
  final String? label;
  final IconData? prefixIcon;
  final bool? obscureText;
  final TextInputType? textInputFormat;
  final TextEditingController? editingController;

  const CustomInputField(
      {this.label,
        this.prefixIcon,
        this.obscureText = false,
        this.textInputFormat,
        this.editingController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: textInputFormat,
      controller: editingController,
      validator: (val) =>
    val.toString().trim().isEmpty ? "$label required" : null,

      readOnly: obscureText!,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
        ),
        hintText: label,
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.black,
        ),
      ),


    );
  }
}

getImagePlaceHolder(String imageurl,String title){
  if(imageurl!=null){
    return Image.network(
      imageurl,
      fit: BoxFit.cover,
      width: 100,
      height: 100,
    );
  }
  else{
    return
      Container(
        width: 100,
        height: 100,
        color: lightPink,
        child:  Text("${getLetters(title).toUpperCase()}",
            style: kTextHeadBoldStyle.apply(color: orangeTheme)),

      );
  }
}

showScaffoldMessage(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$msg",style: kTextNormalStyle.apply(color: Colors.white),),
    backgroundColor: orangeTheme,
  ));
}

getNumberOfGames(String points){
  double dPoints=double.parse(points);
  double dNoGames=dPoints/5;
  return dNoGames.toStringAsFixed(0);
}

// class EventItemList extends StatelessWidget {
//    String title;
//    String desc;
//    String date;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.only(right: 5.0, top: 5, left: 5, bottom: 5),
//       child: Material(
//         color: Colors.white,
//         elevation: 0.4,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: MaterialButton(
//           child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 7, horizontal: 1),
//               child: Row(
//                 children: <Widget>[
//                   ClipRRect(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(8.0),
//                           bottomLeft:
//                           Radius.circular(8.0)),
//                       child: getImagePlaceHolder(
//                           snapshot.data[index].image,
//                           snapshot.data[index].title)),
//
//                   SizedBox(
//                     width: 20,
//                   ),
//
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           "${snapshot.data[index].title.toString().toUpperCase()}",
//                           maxLines: 2,
//                           style:
//                           kTextNormalBoldStyle.apply(color: Colors.black),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "${snapshot.data[index].description}",
//                           style:
//                           kTextNormalBoldStyle.apply(color: Colors.black54),
//                           textAlign: TextAlign.justify,
//                         ),
//                         SizedBox(
//                           height: 3,
//                         ),
//                       ],
//                     ),
//                     flex: 3,
//                   ),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   // Icon(Icons.arrow_forward_ios)
//
//                   Text(
//                     "Starts Today: ${snapshot.data[index].start_time}",
//                     maxLines: 1,
//                     style: kTextNormalBoldStyle.apply(color: Colors.black54),
//                   ),
//                 ],
//               )),
//
//     onPressed: (){
//                                           selectedDailyEvent = snapshot.data[index];
//                                           print(" selected ${selectedDailyEvent.title}");
//
//                                           //todo open main event
//                                           Navigator.of(context).push(MaterialPageRoute(
//                                               builder: (context) => MainEventDetail(sDate: snapshot.data[index].start_time,selectedmainevent: selectedDailyEvent,)));
//
// //showScaffoldMessage("On reworks..", context);
//
//           },
//         ),
//       ),
//     );
//   }
// }
