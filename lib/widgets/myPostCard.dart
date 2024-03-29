import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/comment_screen.dart';
import 'package:socialize/widgets/like_animation.dart';
import '../api/dialogs.dart';
import '../pages/globals.dart';
import '../pages/likePage.dart';

class MyPostCard extends StatefulWidget{
  final snap;
  const MyPostCard({Key?key,
    required this.snap,
  }):super(key:key);

  @override
  State<MyPostCard> createState() => _MyPostCardState();
}
class _MyPostCardState extends State<MyPostCard> {
  bool isLikeAnimating = false;
  bool isLoading = false;
  int commentLen = 0;
  late String pfp = '';

  @override
  void initState() {
    FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .get().then((value) {
      pfp = value.data()!['photoUrl'];
    });
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    }
    catch (err) {
      print(err.toString());
    }
    setState(() {});
  }

  Widget build(BuildContext context){
    return Container(
        color: !mode ? Colors.white : Colors.grey[900],
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
                  isLoading ? CircularProgressIndicator() :
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      imageUrl: pfp,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const CircleAvatar(
                          child: Icon(Icons.person)
                      ),
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
                          TextButton(
                            onPressed : (){
                              Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => MyAccount(id: widget.snap['id']),
                                  )
                              );
                            },
                            child : Text(
                              widget.snap['name'],
                              //  'username',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !mode ? Colors.black : Colors.white,
                              ),
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
                            vertical: 16,
                          ),
                          shrinkWrap: true,
                          children: [
                            "Delete",
                          ].map(
                                (e) => InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical:12,
                                    horizontal: 16
                                ),
                                child: Text(e),
                              ),
                            ),
                          ).toList(),
                        ),
                      ));
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: mode ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onDoubleTap: () {
                APIs.likePost(
                  widget.snap['postId'].toString(),
                  widget.snap['id'],
                  widget.snap['likes'],
                );
                setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: double.infinity,
                    child: isLoading ? Center(child: CircularProgressIndicator())
                        :
                    ClipRRect(
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.snap['image'],
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                        const CircleAvatar(
                            child: Icon(Icons.error)
                        ),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: Duration(
                        milliseconds: 200
                    ),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      child: Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 120,
                      ),
                      isAnimating: isLikeAnimating,
                      duration: Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(FirebaseAuth.instance.currentUser?.uid),
                  smallLike: true,
                  child: IconButton(
                    onPressed:() async {
                      await APIs.likePost(
                          widget.snap['postId'],
                          widget.snap['id'],
                          widget.snap['likes']
                      );
                    },
                    icon: widget.snap['likes'].contains(FirebaseAuth.instance.currentUser?.uid)
                        ?
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                        :
                    Icon(
                      Icons.favorite_border,
                      color: mode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:() => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:(context) => CommentScreen(
                        snap: widget.snap,
                      ),
                    ),
                  ),
                  icon: Icon(
                    Icons.comment_outlined,
                    color: mode ? Colors.white : Colors.black,
                  ),
                ),
                IconButton(
                  onPressed:(){},
                  icon: Icon(
                    Icons.send,
                    color: mode ? Colors.white : Colors.black,
                  ),
                ),
                Expanded(
                  child:Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.bookmark_border,
                        color: mode ? Colors.white : Colors.black,
                      ),
                      onPressed: () async{
                        try{
                          print(widget.snap['image']);
                          await GallerySaver.saveImage(widget.snap['image'],
                              albumName: 'Socialize').then((success)
                          {
                            if(success != null && success) {
                              Dialogs.showSnackBar(context,'Image Successfully saved!');
                            }
                          });
                        }
                        catch(e){
                          print(widget.snap['image']);
                          print(e.toString());
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                            LikePage(),
                        )
                      );
                    },
                    child: DefaultTextStyle(
                      style:Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w800),
                      child:Text(
                        '${widget.snap['likes'].length} likes',
                        style: TextStyle(
                          color: mode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
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
                              text : widget.snap['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: mode ? Colors.white : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            TextSpan(
                              text: '  ${widget.snap['caption']}',
                              style: TextStyle(
                                color: mode ? Colors.white70 : Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ]
                      ),
                    ) ,
                  ),
                  InkWell(
                    onTap:() => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:(context) => CommentScreen(
                          snap: widget.snap,
                        ),
                      ),
                    ),
                    child:Container(
                      padding:const EdgeInsets.symmetric(vertical: 4) ,
                      child: Text(
                        "View all ${commentLen} comments",
                        style: TextStyle(
                          fontSize: 16,
                          color: mode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      widget.snap['date'],
                      style: TextStyle(
                        fontSize: 16,
                        color: mode ? Colors.white : Colors.black,
                      ),
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