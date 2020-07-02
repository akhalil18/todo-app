class User {
  final String id;
  final String email;
  final String photoUrl;
  final String displayName;

  User({
    this.id,
    this.email,
    this.photoUrl,
    this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> userData) {
    return User(
      id: userData['id'],
      email: userData['email'],
      displayName: userData['displayName'],
      photoUrl: userData['photoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> user = {};
    user['id'] = this.id;
    user['email'] = this.email;
    user['displayName'] = this.displayName;
    user['photoUrl'] = this.photoUrl;

    return user;
  }
}
