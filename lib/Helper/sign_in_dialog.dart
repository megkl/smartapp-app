import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';

class SignInDialog extends StatefulWidget {
  final String? title, labelText;
  final Widget? iconImage;
  final Color? color;
  final VoidCallback? navigateTo;

  SignInDialog(
      {@required this.title,
      @required this.iconImage,
      @required this.labelText,
      @required this.color,
      this.navigateTo});

  SignInDialogState createState() => SignInDialogState();
}

class SignInDialogState extends State<SignInDialog> {
  TextEditingController phoneController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  String cCode = "+254", phoneNumber = "";
  var height_spacing = 30;

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
                    widget.title ?? "",
                    style: kTextNormalStyle.apply(
                      color: primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Select Country",
                              style: kTextNormalStyle.apply(
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  /*
                                    width: 67.0,
                                    height: 47.0,*/
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    color: Colors.grey[200],
                                  ),
                                  child: CountryListPick(
                                    theme: CountryTheme(
                                      isShowFlag: true,
                                      isShowTitle: false,
                                      isShowCode: false,
                                      isDownIcon: false,
                                      showEnglishName: true,
                                    ),
                                    initialSelection: "+254",
                                    // countryBuilder: _buildDropdownItem(Country),
                                    onChanged: (CountryCode? code) {
                                      setState(() {
                                        countryController.text = code!.name!;
                                        cCode = code.dialCode!;
                                        // cName = code.name;
                                        // print(code.name);
                                        // print(code.code);
                                        // print(code.dialCode);
                                        // print(code.flagUri);
                                      });
                                    },
                                  ),
                                ),
                                /* Flexible(
                                    child: Icon(Icons.keyboard_arrow_down),
                                  ), */
                                SizedBox(
                                  width: 15.0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0),
                                  child: Text(
                                    "Country",
                                    textAlign: TextAlign.center,
                                    style: kTextNormalStyle.apply(
                                      color: primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Enter Mobile Number",
                              style: kTextNormalStyle.apply(
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                    color: Colors.grey[200],
                                  ),
                                  width: 70.0,
                                  child: TextFormField(
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      // contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                    ),
                                    textAlign: TextAlign.center,
                                    readOnly: true,
                                    controller: phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: kTextNormalStyle.apply(
                                      color: Colors.black45,
                                    ),
                                    //onEditingComplete: checkCorporateNo,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                      color: Colors.grey[200],
                                    ),
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                          hintText: "7xxxxxxxx",
                                          hintStyle: kTextHeadStyle.apply(
                                            color: primary,
                                          ),
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          counterText: ""
                                          // contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                          ),
                                      keyboardType: TextInputType.phone,
                                      style: kTextHeadStyle.apply(
                                        color: primary,
                                      ),
                                      maxLength: 10,
                                      controller: phoneController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ])),
                  SizedBox(
                    height: 20,
                  ),
                  ButtonBar(
                    buttonMinWidth: 200,
                    alignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pop(context, phoneController.text),
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
              backgroundColor: Colors.white,
              maxRadius: 40.0,
              child: widget.iconImage),
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
