class Wallet{

  String? id,user_id,amount,details,date,status;//amount,time

  Wallet({this.id,this.user_id,this.amount,this.details,this.date,this.status});//,this.amount,,this.time

  factory Wallet.fromJson(Map<String, dynamic> parsedJson) {
    return new Wallet(
        id: parsedJson['id'],
        user_id: parsedJson['user_id'],
        amount: parsedJson['amount'],
        details: parsedJson['details'],
        date: parsedJson['date'],
        status: parsedJson['status'],
    );
  }

}