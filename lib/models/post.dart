class PostPhoto {
  PostPhoto({
    required this.image,
    required this.caption,
    required this.date,
    required this.name,
    required this.id,
    required this.time,
    required this.postId,
    required this.likes,
    required this.profUrl,
    required this.firstname,
    required this.lastname,
  });

  late String image;
  late String caption;
  late String firstname;
  late String lastname;
  late String date;
  late String name;
  late String id;
  late String time;
  late List likes;
  late String postId;
  late String profUrl;

  PostPhoto.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    caption = json['caption'] ?? '';
    id = json['id'] ?? '';
    date = json['date'] ?? '';
    name = json['name'] ?? '';
    time = json['time'] ?? '';
    postId = json['postId'] ?? '';
    likes = json['likes'] ?? '';
    profUrl = json['profUrl'] ?? '';
    firstname = json['firstname'] ?? '';
    lastname = json['lastname'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['caption'] = caption;
    data['name'] = name;
    data['id'] = id;
    data['date'] = date;
    data['time'] = time;
    data['postId'] = postId;
    data['likes'] = likes;
    data['profUrl'] = profUrl;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}