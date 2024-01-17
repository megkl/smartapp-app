import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';

class WithdrawDialog extends StatelessWidget {
  final String? title, labelText;
  final Widget? iconImage;
  final Color? color;
  final VoidCallback? navigateTo;

  WithdrawDialog(
      {@required this.title,
      @required this.iconImage,
      @required this.labelText,
      @required this.color,
      this.navigateTo});
  TextEditingController detailsController = new TextEditingController();

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
                    style: kTextNormalStyle.apply(
                      color: primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      controller: detailsController,
                      style: kTextNormalStyle.apply(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: 'Account Info',
                          labelStyle: kTextNormalStyle.apply(color: primary),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonBar(
                    buttonMinWidth: 200,
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context, detailsController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redgradient2,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Withdraw',
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
            // Navigator.pop(context);
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
