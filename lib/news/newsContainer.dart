import 'package:flutter/material.dart';
import 'package:socialize/news/detailView.dart';
import 'package:socialize/pages/globals.dart';

class NewsContainer extends StatelessWidget {
  String imgUrl;
  String newsHead;
  String newsDescription;
  String newsContent;
  String newsUrl;
  NewsContainer({
    super.key,
    required this.imgUrl,
    required this.newsHead,
    required this.newsDescription,
    required this.newsContent,
    required this.newsUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: mode ? Colors.grey[900] : Colors.white,
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeInImage.assetNetwork(
            placeholder: "images/breaking-news.png",
            image: imgUrl,
            height: 300,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    newsHead.length < 75 ? newsHead : "${newsHead.substring(0, 75)}...",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: mode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    newsDescription,
                    style: TextStyle(
                      fontSize: 12,
                      color: mode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    newsContent != "--" ?
                    (newsContent.length > 300 ? newsContent.substring(0, 300) : "${newsContent.toString().substring(0, newsContent.length - 15)}....")
                    : newsContent,
                    style: TextStyle(
                      fontSize: 16,
                      color: mode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailViewScreen(newsUrl: newsUrl)));
                  },
                  child: Text(
                    'Read More',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
