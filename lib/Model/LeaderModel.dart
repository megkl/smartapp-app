import 'package:smartapp/Helper/Constant.dart';
import 'package:smartapp/Helper/Session.dart';


class LeaderModel{

String? user_id,rank,name,score,profile;


LeaderModel({this.user_id,this.rank,this.name,this.score,this.profile});

factory LeaderModel.fromJson(Map<String, dynamic> parsedJson) {
  return new LeaderModel(

    user_id:parsedJson[userId],
    rank:parsedJson[RANK].toString(),
    name: parsedJson[NAME],
    score: parsedJson[SCORE],
    profile: parsedJson[PROFILE]
  );
}


}