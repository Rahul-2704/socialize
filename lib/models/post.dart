class PostPhoto {
  PostPhoto({
    required this.image,
    required this.caption,
   required this.date,
    required this.name,
    required this.id,
    required this.time,
  });
  late String image;
  late String caption;
  late String date;
  late String name;
  late String id;
  late String time;

  PostPhoto.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    caption = json['caption'] ?? '';
    id = json['id'] ?? '';
    date = json['date'] ?? '';
    name = json['name'] ?? '';
    time = json['time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['caption'] = caption;
    data['name'] = name;
    data['id'] = id;
    data['date'] = date;
    data['time'] =time;
    return data;
  }
}