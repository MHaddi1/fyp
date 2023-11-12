class GetUserModel {
  final String? name;
  final String? email;
  final DateTime? dateTime;
  final String? image;
  final String? location;
  final int? type;

  GetUserModel({
    this.name,
    this.email,
    this.dateTime,
    this.image,
    this.location,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'dateTime': dateTime?.toIso8601String(),
      'image': image,
      'location': location,
      'type': type,
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
    );
  }

  @override
  String toString() {
    return 'GetUserModel{name: $name, email: $email, dateTime: $dateTime, image: $image, location: $location, type: $type}';
  }
}
