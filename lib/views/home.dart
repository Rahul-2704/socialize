import 'package:flutter/material.dart';
import 'package:socialize/controller/fetchNews.dart';
import 'package:socialize/model/newsArt.dart';
import 'package:socialize/views/widgets/newsContainer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  late NewsArt newsArt;
  GetNews() async{
    newsArt = await FetchNews.fetchNews();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    GetNews();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: 0),
        scrollDirection: Axis.vertical,
        onPageChanged: (value){
          setState(() {
            isLoading = true;
          });
          GetNews();
        },
        itemBuilder: (context, index){
          return isLoading ? Center(child: CircularProgressIndicator(),) : NewsContainer(
            imgUrl: newsArt.imgUrl,
            newsHead: newsArt.newsHead,
            newsDescription: newsArt.newsDescription,
            newsContent: newsArt.newsContent,
            newsUrl: newsArt.newsUrl,
          );
      }),
    );
  }
}
