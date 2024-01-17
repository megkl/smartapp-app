class Withdraw{
  String? id,user_id,request_amount,date,status,details;//amount,time

  Withdraw({this.id,this.user_id,this.request_amount,this.date,this.status,this.details});//,this.amount,,this.time

  factory Withdraw.fromJson(Map<String, dynamic> parsedJson) {
    return new Withdraw(
      id: parsedJson['id'],
      user_id: parsedJson['user_id'],
     // request_type: parsedJson['request_type'],
      request_amount: parsedJson['amount'],
      date: parsedJson['date'],
      status: parsedJson['status'],
      details: parsedJson['details'],
    );
  }
}