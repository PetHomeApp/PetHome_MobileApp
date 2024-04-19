class Blog {
  final String blogId;
  final String description;
  final String imageUrl;
  final String createAt;
  final bool isFavorite;
  final int favoriteCount;
  final String nameAuthor;
  final String avatarAuthor;

  Blog({
    required this.blogId,
    required this.description,
    required this.imageUrl,
    required this.createAt,
    required this.isFavorite,
    required this.favoriteCount,
    required this.nameAuthor,
    required this.avatarAuthor,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['blogId'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      createAt: json['createAt'] as String,
      isFavorite: json['isFavorite'] as bool,
      favoriteCount: json['favoriteCount'] as int,
      nameAuthor: json['nameAuthor'] as String,
      avatarAuthor: json['avatarAuthor'] as String,
    );
  }

}