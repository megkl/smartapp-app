import 'package:flutter/material.dart';
// final timerProvider = StateNotifierProvider<TimerNotifier, TimerModel>(
//   (ref) => TimerNotifier(),
// );
//
// final _timeLeftProvider = Provider<String>((ref) {
//   return ref.watch(timerProvider).timeLeft;
// });
//
// final timeLeftProvider = Provider<String>((ref) {
//   return ref.watch(_timeLeftProvider);
// });
//
// final _buttonState = Provider<ButtonState>((ref) {
//   return ref.watch(timerProvider).buttonState;
// });
// //not in use
// final buttonProvider = Provider<ButtonState>((ref) {
//   return ref.watch(_buttonState);
// });

handleFormat(var val) {
  if (val.toString().length < 2) {
    return "0$val";
  } else {
    return val;
  }
}

// class TimerTextWidget extends HookWidget {
//    TimerTextWidget({Key key}) : super(key: key);
// BuildContext _context;
//    // WidgetsBinding.instance!.addPostFrameCallback((_) { context.read(timerProvider.notifier).start();});
//   @override
//   Widget build(BuildContext context) {
//     _context=context;
//     final timeLeft = useProvider(timeLeftProvider);
//     print('building TimerTextWidget $timeLeft');
//     return Align(alignment: Alignment.center,child: Text(
//
//       timeLeft,
//       textAlign: TextAlign.center,
//       style: TextStyle(color: Colors.white),
//     ),);
//   }
//   updateTest(){
//     final state = useProvider(buttonProvider);
//
//       print("timer starts 1");
//       if (state == ButtonState.initial){
//         print("timer starts 2");
//         _context.read(timerProvider.notifier).start();
//       }else{
//         print("timer star");
//       }
//   }
//
//
// }

differenceTime(String time) {

  var currentYear = DateTime.now().year;
  var currentMonth = DateTime.now().month;
  var currentDay = DateTime.now().day;
  //2020-01-02 03:04:05
  //print(" bug $currentYear-${handleFormat(currentMonth)}-${handleFormat(currentDay)} $time");
  DateTime startDate =(DateTime.parse(
      "$currentYear-${handleFormat(currentMonth)}-${handleFormat(currentDay)} $time"));
  // print("is after ${startDate.isAfter(DateTime.now())}");
  // print("is Before ${startDate.isAfter(DateTime.now())}");
  print( " time $time");



  //print("unkonwn $startDate");
  print("${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}");



  return startDate.isBefore(DateTime.now());




}
class globals_{
  String _startDate="";
}

PreferredSizeWidget customAppbar(String title, Color color, Color iconColor) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: Colors.white),
      overflow: TextOverflow.fade,
    ),
    centerTitle: true,
    //brightness: Brightness.dark,
    elevation: 0,
    backgroundColor: color,
    iconTheme: IconThemeData(color: iconColor),
    
  );
}



