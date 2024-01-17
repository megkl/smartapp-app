class Transaction{

  String? id,user_id,amount,transaction_id,date,type,eventid;//amount,time

  Transaction({this.id,this.user_id,this.amount,this.transaction_id,this.date,this.type,this.eventid});//,this.amount,,this.time

  factory Transaction.fromJson(Map<String, dynamic> parsedJson,int from) {
    return new Transaction(
      id: parsedJson['id'],
      user_id: parsedJson['user_id'],
      amount: parsedJson['amount'],
      transaction_id: parsedJson['transaction_id'],
      date: parsedJson['date'],
      type: parsedJson['type'],
      eventid: from == 0 ? "${parsedJson['main_event_id']}" : from == 2 ? parsedJson['group_event_id'] : parsedJson['event_id'],
    );
  }

}