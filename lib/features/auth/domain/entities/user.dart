class User {
  final String id;
  final String username;
  final String? email;
  final String? token;

  const User({
    required this.id,
    required this.username,
    this.email,
    this.token,
  });
}
