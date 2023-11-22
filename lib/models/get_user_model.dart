class GetUserModel {
  final String? name;
  final String? email;
  final DateTime? dateTime;
  final String? image;
  final String? location;
  final int? type;
  final String? bio;
  final String? uid;

  GetUserModel({
    this.name,
    this.email,
    this.dateTime,
    this.image,
    this.location,
    this.type,
    this.bio,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dateTime': dateTime?.toIso8601String(),
      'image': image,
      'location': location,
      'type': type,
      'bio': bio,
      'uid': uid,
    };
  }

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      name: json['name'],
      email: json['email'],
      dateTime:
          json['dateTime'] != null ? DateTime.parse(json['dateTime']) : null,
      image: json['image'],
      location: json['location'],
      type: json['type'],
      bio: json['bio'],
      uid: json['uid'],
    );
  }

  @override
  String toString() {
    return 'GetUserModel{name: $name, email: $email, dateTime: $dateTime, image: $image, location: $location, type: $type, bio: $bio, uid: $uid}';
  }
}
