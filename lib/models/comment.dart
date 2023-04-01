class Comment {
  Comment({
   required this.id,
    required this.comment,
    required this.username,
    required this.time,
  });
  late String username;
  late String id;
  late String time;
  late String comment;

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    username = json['username'] ?? '';
    time = json['time'] ?? '';
    comment=json['comment']??'';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['id'] = id;
    data['time'] =time;
    data['comment']=comment;
    return data;
  }
}