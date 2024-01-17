import 'package:flutter/material.dart';
import 'package:smartapp/Helper/Color.dart';
import 'package:smartapp/Helper/DesignConfig.dart';

class PaymentActivity extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return statePayment();
  }
}

class statePayment extends State<PaymentActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: DesignConfig.gradientbackground,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Payment',
          style: TextStyle(color: white, fontFamily: 'TitleFont'),
        ),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding:
              const EdgeInsets.only(top: 8.0, left: 5, right: 5, bottom: 5),
          decoration: DesignConfig.gradientbackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
               Text(
                'Select Payment Method',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              InkWell(
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8),
                  child:  Text(
                    '1. Paypal',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                onTap: (){


                },
              ),
            ],
          )),
    );
  }
}
