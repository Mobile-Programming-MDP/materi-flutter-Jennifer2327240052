class Dog {
  final String imageUrl;

  Dog({required this.imageUrl});

  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(imageUrl: json['message']);
  }
}
