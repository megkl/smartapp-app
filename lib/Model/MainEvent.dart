import 'package:smartapp/Model/MainEventRound.dart';

class MainEvent{


  String? id,title,date,image,description,no_of,no_of_round,hours,min,sec;//amount,time
  //List<MainEventRound>? roundlist = new List<MainEventRound>();
  List<MainEventRound>? roundlist = [];

  MainEvent({this.id,this.title,this.date,this.image,this.description,this.no_of,this.no_of_round,this.roundlist,this.hours,this.min,this.sec});//,this.amount,,this.time

  factory MainEvent.fromJson(Map<String, dynamic> parsedJson) {
    return new MainEvent(
        id: parsedJson['id'],
        title: parsedJson['title'],
        //amount: parsedJson['amount'],
        date: parsedJson['date'],
        //time: parsedJson['time'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        no_of: parsedJson['no_of'],
        hours: parsedJson['hour'],
        min: parsedJson['minute'],
        sec: parsedJson['seconds']
        //no_of_round: parsedJson['no_of_round']
    );
  }

  factory MainEvent.fromLeaderboardJson(Map<String, dynamic> parsedJson) {
    //todo check eventdate
    return new MainEvent(
        id: parsedJson['id'],
        title: parsedJson['title'],
        date: parsedJson['date'],
        image: parsedJson['image'],
        description: parsedJson['description'],
       // roundlist : (parsedJson['rounds'] as List).map((model) => MainEventRound.fromLeaderboardJson(model)).toList(),
    );
  }

}