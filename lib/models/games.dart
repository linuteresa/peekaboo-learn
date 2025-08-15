class Games {
  String letter;
  int points;
  String url;
  String nextUnlock;
  String type;
  bool isCompleted = false;
  bool isUnlocked = false;
  int unlockAt;
  Games(
      {required this.letter,
      required this.points,
      required this.url,
      required this.nextUnlock,
      required this.type,
      required this.unlockAt});

  // from json
  Games.fromJson(Map<String, dynamic> json)
      : letter = makeToString(json['letter']),
        points = json['points'],
        url = json['url'],
        type = json['type'],
        nextUnlock = makeToString(json['next_unlock']),
        unlockAt = json['unlockAt'];
}

makeToString(dynamic s) {
  return s.toString();
}
