class EventLeaderboardModel{

  String? opponent_profile,opponent_name,status,event_id,opponent_id,group_event_id,id,user_id,main_event_id,round,time,total_questions,correct_answers,incorrect_answers,attempt_question,count,rank,name,email,score,profile,date,winning_amount;

  //List<EventLeaderboardModel>? oneononematchlist =  List<EventLeaderboardModel>();
  List<EventLeaderboardModel>? oneononematchlist =  [];

  EventLeaderboardModel({this.oneononematchlist,this.opponent_profile,this.opponent_name,this.status,this.event_id,this.opponent_id,this.group_event_id,this.id,this.user_id,this.main_event_id,this.round,this.time,this.total_questions,this.incorrect_answers,this.email,this.date,this.count,this.attempt_question,this.correct_answers,this.rank,this.name,this.score,this.profile,this.winning_amount});

  factory EventLeaderboardModel.fromDailyEventJson(Map<String, dynamic> parsedJson) {
    return new EventLeaderboardModel(
        id:parsedJson['id'],
        user_id:parsedJson['user_id'],
        main_event_id:parsedJson['main_event_id'],
        round:parsedJson['round'],
        time:parsedJson['time'],
        total_questions:parsedJson['total_questions'],
        correct_answers:parsedJson['correct_answers'],
        incorrect_answers:parsedJson['incorrect_answers'],
        attempt_question:parsedJson['attempt_question'],
        score: parsedJson['score'],
        count: parsedJson['count'],
        date: parsedJson['date'],
        name: parsedJson['name'],
        email: parsedJson['email'],
        profile: parsedJson['profile'],
        rank:parsedJson['rank'].toString(),
        winning_amount:parsedJson['winning_amount'].toString()
    );
  }


  factory EventLeaderboardModel.fromMainEventJson(Map<String, dynamic> parsedJson) {
    return new EventLeaderboardModel(

        user_id:parsedJson['user_id'],

        score: parsedJson['score'],

        date: parsedJson['date'],
        name: parsedJson['name'],
        email: parsedJson['email'],
        profile: parsedJson['profile'],
        rank:parsedJson['rank'].toString(),
        winning_amount:parsedJson['winning_amount'].toString()
    );
  }






  factory EventLeaderboardModel.fromGroupEventJson(Map<String, dynamic> parsedJson) {
    return new EventLeaderboardModel(
        id:parsedJson['id'],
        user_id:parsedJson['user_id'],
        group_event_id:parsedJson['group_event_id'],
        time:parsedJson['time'],
        total_questions:parsedJson['total_questions'],
        correct_answers:parsedJson['correct_answers'],
        incorrect_answers:parsedJson['incorrect_answers'],
        attempt_question:parsedJson['attempt_question'],
        score: parsedJson['score'],
        date: parsedJson['date'],
        name: parsedJson['name'],
        email: parsedJson['email'],
        profile: parsedJson['profile'],
        rank:parsedJson['rank'].toString(),
      winning_amount:parsedJson['winning_amount'].toString()
    );
  }


  factory EventLeaderboardModel.fromOneOnOneEventDataJson(Map<String, dynamic> parsedJson) {
    return new EventLeaderboardModel(
        id:parsedJson['id'],
        user_id:parsedJson['user_id'],
        opponent_id:parsedJson['opponent_id'],
        event_id:parsedJson['event_id'],
        time:parsedJson['time'],
        total_questions:parsedJson['total_questions'],
        correct_answers:parsedJson['correct_answers'],
        incorrect_answers:parsedJson['incorrect_answers'],
        attempt_question:parsedJson['attempt_question'],
        score: parsedJson['score'],
        date: parsedJson['date'],
        status: parsedJson['status'],
        name: parsedJson['user_name'],
        profile: parsedJson['user_profile'],
        opponent_name:parsedJson['opponent_name'],
        opponent_profile:parsedJson['opponent_profile'],
    );
  }
  factory EventLeaderboardModel.fromOneOnOneEventJson(List<dynamic> parsedJson) {
    return new EventLeaderboardModel(
        oneononematchlist : (parsedJson).map((model) => EventLeaderboardModel.fromOneOnOneEventDataJson(model)).toList(),
    );
  }



}