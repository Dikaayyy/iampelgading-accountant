class User {
  final String? id;
  final String? username;
  final String? email;
  final String? name;

  User({this.id, this.username, this.email, this.name});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^ username.hashCode ^ email.hashCode ^ name.hashCode;
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, name: $name)';
  }
}
