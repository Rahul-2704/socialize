import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/widgets/comment_screen.dart';

class MyPostCard extends StatefulWidget{
  final snap;
  const MyPostCard({Key?key,
    required this.snap,
  }):super(key:key);

  @override
  State<MyPostCard> createState() => _MyPostCardState();
}

class _MyPostCardState extends State<MyPostCard> {
  bool isLoading1 = true;
  bool isLoading2 = true;
  late String id = '';
  late String username = '';
  late String pfp = '';
  late String feedImage = '';
  late String caption = '';
  late String date = '';
  @override
  void initState() {
    FirebaseFirestore.instance.collection("users").
    doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value){
      username=value.data()!["username"];
      pfp=value.data()!["photoUrl"];
      setState(() {
        isLoading1 = false;
      });
    });

    var snapshots = FirebaseFirestore.instance
        .collection('userPost')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('post').get();
    snapshots.then((value1){
      final listOfPhotos = value1.docs;
      listOfPhotos.forEach((value) {
        feedImage = value.data()["image"];
        caption = value.data()['caption'];
        date = value.data()['date'];
      });
      setState(() {
        isLoading2 = false;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context){
    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 2,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: [
                  isLoading1 ? CircularProgressIndicator():
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      pfp,
                    ),
                  ),
                  Expanded(
                    child:Padding(
                      padding: const EdgeInsets.only(
                          left:5
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context)=>Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(
                            vertical:16,
                          ),
                          shrinkWrap: true,
                          children: [
                            "Delete",
                          ].map(
                                (e) =>InkWell(
                              onTap: (){},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical:12,horizontal: 16
                                ),
                                child: Text(e),
                              ),
                            ),
                          ).toList(),
                        ),
                      ));
                    },
                    icon:const Icon(Icons.more_vert),
                  ),
                ],
              ),
              //Image section
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.33,
              width: MediaQuery.of(context).size.width*0.93,
              child: isLoading2 ? Center(child: CircularProgressIndicator()): Image.network(
                widget.snap['image'],
                fit:BoxFit.cover,
              ),
            ),

            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.favorite_border),
                    onPressed:() async {
                      //   await APIs().likePost(
                      //      snap['postId'],
                      //    //  uid!,
                      //      snap['likes'],
                      //   );
                      // },
                      //   icon:snap['likes'].contains(FirebaseAuth.instance.currentUser!.uid)?const Icon(
                      //     Icons.favorite,
                      //     color: Colors.red,
                      //   ):const Icon(Icons.favorite_border,),
                    }
                ),
                IconButton(
                  onPressed:() async=>await Navigator.of(context).push(MaterialPageRoute(builder:(context)=> CommentScreen(me:APIs.me),
                  ),
                  ),
                  icon:const Icon(
                    Icons.comment_outlined,
                  ),
                ),
                IconButton(
                  onPressed:(){},
                  icon:const Icon(
                    Icons.send,
                  ),
                ),
                Expanded(
                  child:Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: (){},
                    ),
                  ),
                ),
              ],
            ),
            //Description and comments
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style:Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w800),
                    child:Text(
                      '10 likes',
                      style:Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top:8,
                    ),
                    child:RichText(
                      text: TextSpan(
                          style: const TextStyle(color:Colors.black) ,
                          children: [
                            TextSpan(
                              text: username,
                              style:const TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: widget.snap['caption'],
                            ),
                          ]
                      ),
                    ) ,
                  ),
                  InkWell(
                    onTap: (){},
                    child:Container(
                      padding:const EdgeInsets.symmetric(vertical: 4) ,
                      child: Text(
                        "View all 200 comments",
                        style: TextStyle(
                          fontSize: 16,
                          color:Colors.black38,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      date,
                      style:const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}