class NewsArt{
  String imgUrl;
  String newsHead;
  String newsDescription;
  String newsContent;
  String newsUrl;
  NewsArt({
    required this.imgUrl,
    required this.newsHead,
    required this.newsDescription,
    required this.newsContent,
    required this.newsUrl,
  });

  static NewsArt fromAPItoApp(Map<String, dynamic> article){
    return NewsArt(
      imgUrl: article["urlToImage"] ?? "images/breaking-news.png",
      newsHead: article["title"] ?? "--",
      newsDescription: article["description"] ?? "--",
      newsContent: article["content"] ?? "--",
      newsUrl: article["url"] ?? "https://news.google.com/home?hl=en-IN&gl=IN&ceid=IN:en",
    );
  }
}