import 'package:flutter/material.dart';

class TopUpPoints extends StatefulWidget{
  TopUpPointsState createState()=>TopUpPointsState();
}
class TopUpPointsState extends State<TopUpPoints>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(
       elevation: 0,
       backgroundColor: AppBarTheme.of(context).backgroundColor,
       //brightness: Brightness.dark,
     ),
     body: SingleChildScrollView(

     ),
   );
  }

}

class AmountWidgets extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [

         ],
       )
     ],
   );
  }

  Widget itemAmounts(String amount){
    return MaterialButton(onPressed: null,
    child: Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Text(
        amount,textAlign: TextAlign.center,

      ),
    ),
    );
  }

}