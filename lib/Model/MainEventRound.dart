class MainEventRound {
  String? event_title,
      id,
      main_event_id,
      date,
      start_time,
      end_time,
      title,
      amount,
      round,
      round_number,
      no_of,
      point,
      count,
      hours,
      min,
      sec,
      image,
      description; //amount,time
  bool? isprocess = false;

  MainEventRound(
      {this.event_title,
      this.count,
      this.isprocess,
      this.id,
      this.main_event_id,
      this.date,
      this.start_time,
      this.end_time,
      this.title,
      this.amount,
      this.round,
      this.round_number,
      this.no_of,
      this.point,
      this.hours,
      this.min,
      this.sec,
      this.image,
      this.description}); //,this.amount,,this.time

  factory MainEventRound.fromJson(Map<String, dynamic> parsedJson) {
    return new MainEventRound(
      id: parsedJson['id'],
      //  main_event_id: parsedJson['main_event_id'],
      // round: parsedJson['round'],
      date: parsedJson['date'],
      image: parsedJson['image'],
      start_time: parsedJson['start_time'],
      end_time: parsedJson['end_time'],
      title: parsedJson['title'],
      amount: parsedJson['amount'],
      point: parsedJson['winning_amount'] ?? "0",
      no_of: parsedJson['no_of'],
      hours: parsedJson['hour'],
      min: parsedJson['minute'],
      sec: parsedJson['seconds'],
      description: parsedJson['description'],
      isprocess: false,
    );
  }

  factory MainEventRound.fromFaceofJson(Map<String, dynamic> parsedJson) {
    return new MainEventRound(
      id: parsedJson['id'],
      main_event_id: parsedJson['main_event_id'],
      round: parsedJson['round'],
      date: parsedJson['date'],
      round_number: parsedJson['round_number'],
      start_time: parsedJson['start_time'],
      end_time: parsedJson['end_time'],
      title: parsedJson['title'],
      amount: parsedJson['amount'],
      point: parsedJson['point'] ?? "0",
      no_of: parsedJson['no_of'],
      event_title: parsedJson['event_title'],
      isprocess: false,
      hours: parsedJson['hour'],
      min: parsedJson['minute'],
      sec: parsedJson['seconds'],
    );
  }

  factory MainEventRound.fromLeaderboardJson(Map<String, dynamic> parsedJson) {
    return new MainEventRound(
      id: parsedJson['id'],
      main_event_id: parsedJson['main_event_id'],
      round: parsedJson['round'],
      date: parsedJson['date'],
      round_number: parsedJson['round_number'],
      start_time: parsedJson['start_time'],
      end_time: parsedJson['end_time'],
      title: parsedJson['title'],
      amount: parsedJson['amount'],
      point: parsedJson['point'] ?? "0",
    );
  }



  factory MainEventRound.fromDaily(Map<String, dynamic> parsedJson) {
    return new MainEventRound(
      id: parsedJson['id'],
      main_event_id: parsedJson['main_event_id'],
      round: parsedJson['round'],
      date: parsedJson['date'],
      round_number: parsedJson['round_number'],
      start_time: parsedJson['start_time'],
      end_time: parsedJson['end_time'],
      title: parsedJson['title'],
      amount: parsedJson['amount'],
      point: parsedJson['point'] ?? "0",
      no_of: parsedJson['no_of'],
      hours:parsedJson['hour'],
      min: parsedJson['min'],
      sec: parsedJson['seconds'],
      isprocess: false,
    );
  }


}
