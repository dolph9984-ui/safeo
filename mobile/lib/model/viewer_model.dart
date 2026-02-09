class Viewer {
  final String id;
  final String name;
  final String email;

  const Viewer({required this.id, required this.name, required this.email});

  factory Viewer.fromJson(Map<String, dynamic> json) {
    return Viewer(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }
}
