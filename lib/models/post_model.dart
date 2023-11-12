class PostModel {
  String name;
  String image;
  DateTime date;
  String post;

  PostModel({
    required this.name,
    required this.image,
    required this.date,
    required this.post,
  });

  Map<String, dynamic> toJson() {
    print("Coming2...");
    return {
      'name': name,
      'image': image,
      'date': date.toIso8601String(),
      'post': post,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    print("Coming...");
    return PostModel(
      name: json['name'] ?? '', // Add a null check and fallback value if needed
      image: json['image'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(), // Fallback to current date if 'date' is null
      post: json['post'] ?? '',
    );
  }
}
