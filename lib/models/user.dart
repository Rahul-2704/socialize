class UserAccount {
  UserAccount({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.id,
    required this.bio,
    required this.password,
    required this.username,
    required this.following,
    required this.followers,
    required this.photoUrl,
    required this.login,
    required this.mode,
  });

  late String firstname;
  late String lastname;
  late String username;
  late String bio;
  late List following;
  late List followers;
  late String id;
  late String password;
  late String photoUrl;
  late String email;
  late bool login;
  late bool mode;

  UserAccount.fromJson(Map<String, dynamic> json) {
    photoUrl = json['photoUrl'] ?? '';
    followers = json['bio'] ?? '';
    username = json['username'] ?? '';
    following = json['following'] ?? '';
    followers = json['followers'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    firstname = json['firstname'] ?? '';
    lastname = json['lastname'] ?? '';
    login = json['login'] ?? '';
    mode = json['mode'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['photoUrl'] = photoUrl;
    data['followers'] = followers;
    data['following'] = following;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['password'] = password;
    data['username'] = username;
    data['id'] = id;
    data['email'] = email;
    data['bio'] = bio;
    data['login'] = login;
    data['mode'] = mode;
    return data;
  }
}