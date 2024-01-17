import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? status,
      email,
      name,
      profile,
      fcm_id,
      user_id,
      opponentName,
      opponentProfile,
      resut,
      mobile,
      type,
      refer_code,location,matchwith,matchid,fid;
  bool? isplaypress = false;


  UserModel(
      {this.name,
      this.email,
      this.profile,
      this.fcm_id,
      this.user_id,
      this.mobile,
      this.type,
      this.refer_code,
      this.status,this.location,this.matchwith,this.isplaypress,this.matchid,this.fid
      });

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) {
    return new UserModel(
        profile: parsedJson['profile'],
        user_id: parsedJson.containsKey('user_id') ? parsedJson['user_id'] : parsedJson.containsKey('id') ? parsedJson['id'] : '',
        name: parsedJson['name'],
        email: parsedJson['email'],
        mobile: parsedJson['mobile'],
        type: parsedJson['type'],
        fcm_id: parsedJson['fcm_id'],
        refer_code: parsedJson['refer_code'],
        status: parsedJson['status'],
        location: parsedJson['location'] ?? ''
    );
  }

  factory UserModel.fromMatchJson(DataSnapshot snapshot) {
final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;
    return new UserModel(
        profile: data['profile'],
        user_id: data['user_id'].toString(),
        name: data['name'].toString() ?? '',
        email: data['email'].toString() ?? '',
        type: data['type'].toString() ?? '',
        status: data['status'].toString() ?? '0',
        matchwith: data['matchwith'].toString() ?? '0',
        isplaypress: data['isplaypress'] ??  false,
        matchid: data['matchid'].toString() ?? ''
    );
  }
  factory UserModel.fromMatchJsonTest(LinkedHashMap<dynamic, dynamic> snapshot) {
      return new UserModel(
        profile: snapshot['profile'].toString() ?? '',
        user_id: snapshot['user_id'].toString(),
        name: snapshot['name'].toString() ?? '',
        email: snapshot['email'].toString() ?? '',
        type: snapshot['type'].toString() ?? '',
        status: snapshot['status'].toString() ?? '0',
        matchwith: snapshot['matchwith'].toString() ?? '0',
        isplaypress: snapshot['isplaypress'] ??  false,
        matchid: snapshot['matchid'].toString() ?? ''
    );
  }

  factory UserModel.fromLiveMatchJson(DataSnapshot snapshot) {
     final Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;
  return UserModel(
    profile: data['profile']?.toString() ?? '',
    user_id: data['user_id']?.toString() ?? '',
    name: data['name']?.toString() ?? '',
    email: data['email']?.toString() ?? '',
    type: data['type']?.toString() ?? '',
    status: data['status']?.toString() ?? '0',
    matchwith: data['matchwith']?.toString() ?? '0',
    matchid: data['matchid']?.toString() ?? ''
  );
}

  static double? amount, coins;
}


