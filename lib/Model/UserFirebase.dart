
class UserFirebase {
  String
      email,
      name,
      user_id,
      profile;



  UserFirebase(
    this.name,
    this.email,
    this.profile,
    this.user_id,
  );


  toJson(Map<String, dynamic> parsedJson){

  return{
     "name": name,
      "email": email,
      "profile":profile,
      "user_id":user_id
  };

  }
}
