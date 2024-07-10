class PostModel {
  String id;
  String name;
  String image;
  DateTime date;
  String post;
  dynamic likes;
  final bool isLiked;

  PostModel({
    required this.name,
    required this.image,
    required this.date,
    required this.post,
    required this.likes,
    required this.id,
    required this.isLiked,
  });

  Map<String, dynamic> toJson() {
    print("Coming2...");
    return {
      'name': name,
      'image': image,
      'date': date.toIso8601String(),
      'post': post,
      'likes': likes,
      'id': id,
      'isLiked': isLiked,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    print("Coming...");
    return PostModel(
      name: json['name'] ?? '', // Add a null check and fallback value if needed
      image: json['image'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      post: json['post'] ?? '',
      likes: json['likes'] ?? 0,
      id: json['id'] ?? '',
      isLiked: json['isLiked'] ?? false,
    );
  }
}
