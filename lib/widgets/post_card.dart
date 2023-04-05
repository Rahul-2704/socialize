import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/comment_screen.dart';
import 'package:socialize/widgets/like_animation.dart';

class PostCard extends StatefulWidget{
  final snap;
  const PostCard({Key?key,
    required this.snap,
  }):super(key:key);

  @override
  State<PostCard> createState() => _PostCardState();
}
class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  bool isLoading = false;

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
                  isLoading ? CircularProgressIndicator() :
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(
                      widget.snap['profUrl'],
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
                                    builder: (BuildContext context) => MyAccount(id: widget.snap['id']),));
                            },
                            child : Text(
                              widget.snap['name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
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
                    icon:const Icon(Icons.more_vert),
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
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: isLoading ? Center(child: CircularProgressIndicator())
                        :
                    Image.network(
                      widget.snap['image'],
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          alignment: Alignment.center,
                          child: const Text(
                            'Whoops!',
                            style: TextStyle(fontSize: 30),
                          ),
                        );
                      },
                      fit:BoxFit.cover,
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
                    const Icon(
                      Icons.favorite_border,
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
                      '${widget.snap['likes'].length} likes',
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
                              text : widget.snap['name'],
                              style:const TextStyle(fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.snap['caption']}',
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
                      widget.snap['date'],
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