class Blog {
  final String blogId;
  final String description;
  final String createAt;
  final String idUser;
  final List<String> images;
  final String nameAuthor;
  final String avatarAuthor;

  Blog({
    required this.blogId,
    required this.description,
    required this.createAt,
    required this.idUser,
    required this.images,
    required this.nameAuthor,
    required this.avatarAuthor,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      blogId: json['id_blog'],
      description: json['description'],
      createAt: json['created_at'],
      idUser: json['id_user'],
      images: List<String>.from(json['images']),
      nameAuthor: json['username'],
      avatarAuthor: json['avatar'],
    );
  }
}