class OneOnOneModel{

  String? id,title,image,description,no_of,entryamount,winning_amount,no_of_user;

  OneOnOneModel({this.no_of_user,this.id,this.title,this.image,this.description,this.no_of,this.entryamount,this.winning_amount});

  factory OneOnOneModel.fromJson(Map<String, dynamic> parsedJson) {
    return new OneOnOneModel(
        id: parsedJson['id'].toString(),
        title: parsedJson['title'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        entryamount: parsedJson['amount'],
        winning_amount:parsedJson['winning_amount'],
        no_of: parsedJson['no_of']
    );
  }


  factory OneOnOneModel.SetData(String id,String title){
    return OneOnOneModel(
      id: id,
      title: title,
    );
  }


  factory OneOnOneModel.fromLeaderboardJson(Map<String, dynamic> parsedJson) {
    return new OneOnOneModel(
        id: parsedJson['id'].toString(),
        title: parsedJson['title'],
        image: parsedJson['image'],
        description: parsedJson['description'],
        entryamount: parsedJson['amount'],
        winning_amount:parsedJson['winning_amount'],
    );
  }

}