class Cast {
  String castId;
  String personId;
  String character;
  String personName;
  String? personProfilePath;

  Cast({
    required this.castId,
    required this.personId,
    required this.character,
    required this.personName,
    required this.personProfilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      castId: json['castId'],
      personId: json['personId'],
      character: json['character'],
      personName: json['personName'],
      personProfilePath: json['personProfilePath'],
    );
  }
}
