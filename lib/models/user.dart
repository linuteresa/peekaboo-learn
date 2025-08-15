class SignupData {
  String? name;
  String? password;
  String? email;

  SignupData({this.name, this.password, this.email});
}

class AppUser {
  String? email;
  String? name;
  int? level;
  String? uid;
  int? score;

  AppUser({this.email, this.name, this.level, this.uid, this.score});
}
