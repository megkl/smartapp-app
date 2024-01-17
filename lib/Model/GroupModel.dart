class GroupModel{

  String? id,title,date,image,description,no_of,join_user,start_time,end_time,entryamount,winningamount,no_of_user,hours,min,sec;

  GroupModel({this.no_of_user,this.id,this.title,this.date,this.image,this.description,this.no_of,this.join_user,this.start_time,this.end_time,this.entryamount,this.winningamount,this.sec,this.hours,this.min
  });//,this.amount,,this.time

  factory GroupModel.fromJson(Map<String, dynamic> parsedJson) {
    return new GroupModel(
        id: parsedJson['id'].toString(),
        title: parsedJson['title'],
        entryamount: parsedJson['ticket'],
        date: parsedJson['date'],
        start_time:parsedJson['start_time'],
        end_time:parsedJson['end_time'],
        winningamount:parsedJson['amount'],
        no_of_user:parsedJson['no_of_user'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        no_of: parsedJson['no_of'],
        join_user: parsedJson['join_user'],
      hours: parsedJson['hour'],
      min: parsedJson['minute'],
      sec: parsedJson['seconds']
    );
  }


  factory GroupModel.SetData(String id,String title){
    return GroupModel(
      id: id,
      title: title,
    );
  }

  factory GroupModel.fromLeaderboardJson(Map<String, dynamic> parsedJson) {
    return new GroupModel(
        id: parsedJson['id'].toString(),
        title: parsedJson['title'],
        entryamount: parsedJson['ticket'],
        date: parsedJson['date'],
        start_time:parsedJson['start_time'],
        end_time:parsedJson['end_time'],
        winningamount:parsedJson['amount'],
        no_of_user:parsedJson['no_of_user'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        //no_of: parsedJson['no_of'],
        //join_user: parsedJson['join_user']
    );
  }

}