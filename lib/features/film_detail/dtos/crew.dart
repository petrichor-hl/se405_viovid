class Crew {
  String crewId;
  String role;
  String personName;
  String? personProfilePath;

  Crew({
    required this.crewId,
    required this.role,
    required this.personName,
    required this.personProfilePath,
  });

  factory Crew.fromJson(Map<String, dynamic> json) {
    return Crew(
      crewId: json['crewId'],
      role: json['role'],
      personName: json['personName'],
      personProfilePath: json['personProfilePath'],
    );
  }
}
