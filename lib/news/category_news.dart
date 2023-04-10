import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'news_model.dart';

class CategoryNews extends StatefulWidget {
  String query;
  CategoryNews({required this.query});
  @override
  State<CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  bool isLoading = true;
  getNewsByQuery(String query) async {
    String url = '';
    if(query == 'Top News' || query == 'India') {
      url = 'https://newsapi.org/v2/top-headlines?country=in&apiKey=b56950e88a0b46f3b4b633ec2829bc59';
    }
    else{
      url = 'https://newsapi.org/v2/everything?q=$query&from=2023-04-05&sortBy=publishedAt&apiKey=b56950e88a0b46f3b4b633ec2829bc59';
    }
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data['articles'].forEach((element){
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }
  @override
  void initState() {
    getNewsByQuery(widget.query);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NEWS',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 12,),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        widget.query,
                        style: TextStyle(
                          fontSize: 39,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
              ?
              Container(
                height: MediaQuery.of(context).size.height - 500,
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
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.black12.withOpacity(0),
                                        Colors.black,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    )
                                ),
                                padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      newsModelList[index].newsDes.length > 50 ?
                                      '${newsModelList[index].newsDes.substring(0, 50)}....'
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
                      )
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
