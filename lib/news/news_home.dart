import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:socialize/news/newsView.dart';
import 'package:socialize/news/news_model.dart';
import 'package:socialize/news/category_news.dart';

import '../pages/globals.dart';

class HomeNews extends StatefulWidget {
  const HomeNews({Key? key}) : super(key: key);

  @override
  State<HomeNews> createState() => _HomeNewsState();
}

class _HomeNewsState extends State<HomeNews> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List <String> navBarItem = [
    'Top News',
    'India',
    'World',
    'Finance',
    'Health',
  ];
  bool isLoading = true;
  getNewsByQuery(String query) async{
    Map element;
    int i = 0;
    String url = 'https://newsapi.org/v2/everything?q=$query&from=2023-04-05&sortBy=publishedAt&apiKey=b56950e88a0b46f3b4b633ec2829bc59';
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for(element in data['articles']) {
        try {
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if (i == 5) {
            break;
          }
        }
        catch(e){
          print(e);
        }
      };
    });
  }
  getNewsOfIndia() async {
    String url = 'https://newsapi.org/v2/top-headlines?country=in&apiKey=b56950e88a0b46f3b4b633ec2829bc59';
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data['articles'].forEach((element){
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    getNewsByQuery('India');
    getNewsOfIndia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            child: AppBar(
              iconTheme: IconThemeData(
                color: !mode ? Colors.black87 : Colors.white,
              ),
              backgroundColor: mode ? Colors.black87 : Colors.white,
              elevation: 0,
              title: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'News',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: mode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),
        ),
        body: Container(
          color: !mode ? Colors.white : Colors.grey[900],
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  decoration: BoxDecoration(
                    color: !mode ? Colors.black12 : Colors.grey[800],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if((searchController.text).replaceAll(" ", "") == "") {
                            print('Blank news');
                          }
                          else{
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => CategoryNews(query: searchController.text),
                              )
                            );
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                          child: Icon(
                            Icons.search,
                            color: mode ? Colors.white : Colors.blueAccent,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) {
                            Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => CategoryNews(query: value),
                              )
                            );
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search News',
                            hintStyle: TextStyle(
                              color: mode ? Colors.white : Colors.black,
                            )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => CategoryNews(query: navBarItem[index]),
                            )
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: !mode ? Colors.blueAccent : Colors.grey[800],
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              navBarItem[index],
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: isLoading
                  ?
                  Container(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator()
                    )
                  )
                  :
                  CarouselSlider(
                    items: newsModelListCarousel.map((instance) {
                      return Builder(
                        builder: (BuildContext context) {
                          try {
                            return Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) => NewsView(instance.newsUrl),
                                      )
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          instance.newsImg,
                                          fit: BoxFit.fitHeight,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              ),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5, vertical: 10),
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 10),
                                                child: Text(
                                                  instance.newsHead,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          catch(e){
                            print(e);
                            return Container();
                          }
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'LATEST NEWS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: mode ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      isLoading ?
                      Container(
                        height: MediaQuery.of(context).size.height - 450,
                        child: Center(
                          child: CircularProgressIndicator()
                        )
                      )
                      :
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: newsModelList.length,
                        itemBuilder: (context, index) {
                          try {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsView(newsModelList[index].newsUrl),
                                    )
                                  );
                                },
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        child: Image.network(
                                          newsModelList[index].newsImg,
                                          fit: BoxFit.fitHeight,
                                          width: double.infinity,
                                          height: 230,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  15),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black,
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                              )
                                          ),
                                          padding: EdgeInsets.fromLTRB(
                                              15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                newsModelList[index].newsHead,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                newsModelList[index].newsDes
                                                    .length > 50 ?
                                                '${newsModelList[index].newsDes
                                                    .substring(0, 55)}....'
                                                    : newsModelList[index].newsDes,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            );
                          }
                          catch(e){
                            print(e);
                            return Container();
                          }
                        }
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryNews(query: "Technology"),
                                  )
                                );
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  !mode ? Colors.blue : Colors.black54,
                                ), // set the background color
                              ),
                              child: Text(
                                'SHOW MORE',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
