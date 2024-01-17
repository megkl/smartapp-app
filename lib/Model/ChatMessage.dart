
import 'package:intl/intl.dart';

class ChatMessage{
  String? message_id,message,event_id,date,name,email,profile,user_id,from_event,event_title;
  bool? issend = false,isdownloaded = false;
  int? progress = 0;

  ChatMessage({this.issend,this.message_id, this.message, this.event_id, this.date,this.name,this.email,this.profile,this.user_id,this.from_event,this.event_title});

  /*factory ChatMessage.fromJson(Map<String,dynamic> json) {
    return ChatMessage(
      id: json['id'].toString(),
      message: json['message'],
      sender_id: json['sender_id'].toString(),
      attachments: json['attachments'].trim().isEmpty ? '' :  "${Constant.ImagePath}${json['attachments']}",
      attachment_mime_type: json['attachment_mime_type'],
      created_at: json['created_at'],
      issend: true,
     isdownloaded: false,
    );}


  }*/

  factory ChatMessage.SetNewMsg(String smessage,String sid,String type,String path,String date,String group_event_id,String name,String email,String profile,String eventtitle){
    return ChatMessage(
      message: smessage,
      event_id: group_event_id,
      date: DateFormat('yyyy-MM-dd hh:mm:ss').format(date.isEmpty ? new DateTime.now() : DateTime.parse(date)),
      user_id: sid,
      message_id: new DateTime.now().millisecondsSinceEpoch.toString(),
      name:name,
      email:email,
      profile: profile,
      event_title: eventtitle
    );
  }

  /*
  {"error":"false","type":"chat","from_event":"OneOnOneEvent","message_id":11,
  "body":"test","message":"test","user_id":"5",
  "name":"wrteam","email":"wrteam02@gmail.com",
  "profile":"http:\/\/top.thewrteam.in\/uploads\/profile\/1591685869.4361.jpg","event_title":"test","date_created":"2020-06-19 17:22:40"}

   */

  factory ChatMessage.fromThreadJson(Map<String,dynamic> json) {
    return ChatMessage(
      message_id: json['message_id'].toString() ?? '',
      message: json['message'].toString(),
      //event_id: eventid,
      user_id: json['user_id'].toString(),
      date: json.containsKey('date_created') ? json['date_created'].toString() : json.containsKey('date') ? json['date'].toString() : DateFormat('yyyy-MM-dd hh:mm:ss').format(new DateTime.now()),
      //date: json.containsKey('date') ? json['date'].toString() : json.containsKey('date_created') ? json['date_created'].toString() : DateFormat('yyyy-MM-dd hh:mm:ss').format(new DateTime.now()),
      name: json['name'].toString(),
      email: json['email'].toString(),
      profile: json['profile'].toString(),
      from_event: json['from_event'].toString(),
      event_title: json['event_title'].toString(),

    );}
}



/*
{
    "error": "false",
    "type": "chat",
    "from_event": "OneOnOneEvent",
    "message_id": 1,
    "body": "test",
    "message": "test",
    "user_id": "5",
    "name": "wrteam",
    "email": "wrteam02@gmail.com",
    "profile": "http://top.thewrteam.in/uploads/profile/1591685869.4361.jpg",
    "event_title": "test",
    "date_created": "2020-06-19 16:35:03"
}

{
    "error": "false",
    "type": "chat",
    "from_event": "GroupEvent",
    "message_id": 67,
    "body": "test",
    "message": "test",
    "user_id": "5",
    "name": "wrteam",
    "email": "wrteam02@gmail.com",
    "profile": "http://top.thewrteam.in/uploads/profile/1591685869.4361.jpg",
    "event_title": "Buddies ",
    "date_created": "2020-06-19 16:36:13"
}
 */