
class Skill {
  // id: number;
  //   user_id: number;
  //   title: string;
  //   description: string;
  //   creationDate: string;
  //   longitude: number;
  //   latitude: number;

  final int id;
  final String title;
  final String description;
  final int userid;
  final String creationDate;
  final double longitude;
  final double latitude;

  Skill({required this.id, required this.title, required this.description, required this.userid, required this.creationDate, required this.latitude, required this.longitude});

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as int,
      title: json['title'],
      description: json['description'],
      userid: json['user_id'] as int,
      creationDate: json['creationDate'],
      longitude: json['longitude'],
      latitude: json['latitude']
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'user_id': userid,
        'creationDate': creationDate,
        'longitude': longitude,
        'latitude': latitude
      };
}