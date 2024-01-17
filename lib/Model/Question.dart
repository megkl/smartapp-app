import 'package:smartapp/Helper/Constant.dart';

class Question {
  int? id;
  String? question,main_event_id,time_id,group_event_id,event_id,
      note,
      level,
      trueAns,
      image,
      ansOption,
      selectedAns,
      langId,
      answer,
      optiona,
      optionb,
      optionc,
      optiond,
      optione,queindex;


  Question(
      {this.id,this.main_event_id,this.time_id,this.group_event_id,this.event_id,
      this.question,
      this.image,
      this.level,
      this.trueAns,
      this.note,
      this.answer,
      this.langId,
      this.optiona,
      this.optionb,
      this.optionc,
      this.optiond,
      this.optione,this.queindex});

  String get userSelected => selectedAns!;

  set userSelected(String ans) {
    selectedAns = ans;
  }


  set setRightAns(String ans) {
    trueAns = ans;
  }

  factory Question.fromJson(Map<String, dynamic> parsedJson) {
    String id=parsedJson[ID].toString();
    return new Question(
        id: int.parse(id),
        main_event_id: parsedJson.containsKey(MAIN_EVENT_ID) ? parsedJson[MAIN_EVENT_ID] : '',
        group_event_id: parsedJson.containsKey(GROUP_EVENT_ID) ? parsedJson[GROUP_EVENT_ID] : '',
        event_id: parsedJson.containsKey(EVENT_ID) ? parsedJson[EVENT_ID] : '',
        time_id: parsedJson.containsKey(TIME_ID) ? parsedJson[TIME_ID] : '',
        question: parsedJson[QUESTION],
        image: parsedJson[IMAGE] ?? '',
        /*level: parsedJson[LEVEL1],
        langId: parsedJson[LANG_ID],*/
        note: parsedJson[NOTE],
        answer: parsedJson[ANSWER],
        trueAns: "",
        optiona: parsedJson[OPTION_A],
        optionb: parsedJson[OPTION_B],
        optionc: parsedJson[OPTION_C],
        optiond: parsedJson[OPTION_D],
        optione: parsedJson[OPTION_E]);
  }

  /*factory Question.fromJson(Map<String, dynamic> parsedJson) {

    String id=parsedJson[ID].toString();
    return new Question(
        id: int.parse(id),
        question: parsedJson[QUESTION],
        image: parsedJson[IMAGE],
        level: parsedJson[LEVEL1],
        langId: parsedJson[LANG_ID],
        note: parsedJson[NOTE],
        answer: parsedJson[ANSWER],
        trueAns: "",
        optiona: parsedJson[OPTION_A],
        optionb: parsedJson[OPTION_B],
        optionc: parsedJson[OPTION_C],
        optiond: parsedJson[OPTION_D],
        optione: parsedJson[OPTION_E]);
  }*/
}
