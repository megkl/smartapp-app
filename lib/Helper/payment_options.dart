import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';

class PaymentOptions extends StatefulWidget {
  final VoidCallback? callback;

  const PaymentOptions({Key? key, this.callback}) : super(key: key);


  PaymentOptionsState createState() => PaymentOptionsState();
}

class PaymentOptionsState extends State<PaymentOptions> {
  String? selectedGender = "";
  String? selecteditem;

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
            padding: EdgeInsets.only(top: 60, left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                     "Top Up Via",
                    style: kTextHeadBoldStyle.apply(
                      color: redgradient2,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSelectorGender(
                    context: context,
                    name: "GCoin Wallet",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSelectorGender(
                    context: context,
                    name: "M-Pesa",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSelectorGender(
                    context: context,
                    name: "Visa",
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
        GestureDetector(
          child: CircleAvatar(
              backgroundColor: Colors.white, maxRadius: 40.0, child: Icon(Icons.attach_money_rounded,size: 40,color: orangeTheme,)),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
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
                selectedGender = v;
                selecteditem = v.toString().replaceAll("-", "").toLowerCase();

              });
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pop(context!,v);
              });
              //print("onClick $v");

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
}
