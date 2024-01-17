import 'package:flutter/material.dart';


class LoadingOverlay extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),

    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return WillPopScope(child: Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Container(
              child: SizedBox(
                width: 60.0,
                child: Image.asset(
                  'assets/images/loading.gif',
                ),
              ),
            )),
      ],
    ), onWillPop: onBackPress);
  }

  Future<bool> onBackPress() {

      return Future.value(false);
    }

}
