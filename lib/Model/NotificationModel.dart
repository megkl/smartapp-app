import 'package:smartapp/Helper/Constant.dart';

class NotificationModel {
  String? title, message, image, etype, wamount, rank, name,date;
  List<User>? userList;

  NotificationModel(
      {this.title, this.message, this.image, this.etype, this.userList,this.date});

  factory NotificationModel.fromJson(Map<String, dynamic> parsedJson) {
    var data = parsedJson["user"];

    List<User> userList =
        (data as List).map((data) => new User.fromJson(data)).toList();

    return new NotificationModel(
      title: parsedJson[TITLE],
      //message: parsedJson[MESSAGE],
      //image: parsedJson[IMAGE],
      etype: parsedJson[eType],
      date:parsedJson[DATE],
      userList: userList,
      // wamount: parsedJson[AMOUNT],
      // rank: parsedJson[RANK],
      // name: parsedJson[NAME]);
    );
  }
}

class User {
  String? rank, amount, name;

  User({this.rank, this.amount, this.name});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return new User(
        amount: parsedJson[AMOUNT],
        rank: parsedJson[RANK],
        name: parsedJson[NAME]);
  }
}
