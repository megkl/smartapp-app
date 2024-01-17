import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';

import '../activity/payments.dart';

class MessageDialog extends StatelessWidget {
  final String? title, labelText;
  final Widget? iconImage;
  final Color? color;
  final VoidCallback? navigateTo;

  MessageDialog(
      {@required this.title,
      @required this.iconImage,
      @required this.labelText,
      @required this.color,
      this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.only(top: 60, left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title ?? "",
                    style: kTextHeadBoldStyle.apply(
                      color: primary,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "$labelText ",
                    textAlign: TextAlign.center,
                    style: kTextSmallStyle.apply(
                      color: primary,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonBar(
                    buttonMinWidth: 200,
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // FlatButton(
                      //   child: Text(
                      //     'Buy GCoins',
                      //     style:kTextNormalBoldStyle.apply(color: Colors.white),
                      //   ),
                      //   padding: const EdgeInsets.all(15),
                      //   color: redgradient2,
                      //   onPressed: () =>
                      //   Navigator.pop(context,"daily"),
                      //   shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10)),
                      // ),
                      ElevatedButton(
                        //onPressed: () => Navigator.pop(context, "daily"),
                        onPressed: (){
                          Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddPaymentEntry()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redgradient2,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Buy GCoins',
                          style:
                              kTextNormalBoldStyle.apply(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            )),
        GestureDetector(
          child: CircleAvatar(
              backgroundColor: Colors.white, maxRadius: 40.0, child: iconImage),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }

// navigateTo(String choice){
//   Navigator.of(context).pop();
//
// }
}
