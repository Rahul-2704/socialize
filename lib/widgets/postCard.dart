import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/api/dialogs.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/comment_screen.dart';
import 'package:socialize/widgets/like_animation.dart';
import 'package:gallery_saver/gallery_saver.dart';
import '../pages/globals.dart';

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
  int commentLen = 0;
  late String pfp = '';
  List<String> likeUser = [];
  int likes = 0;
  late String userName = '';
  late String firstName = '';
  late String lastName = '';
  late String img = '';
  late String id = '';

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.snap['id'])
        .get().then((value) {
      pfp = value.data()!['photoUrl'];
    });
    super.initState();
    getComments();
    _loadData();
    updateData(widget.snap['id']);
  }

  Future<void> updateData(String userId) async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get().then((value) {
      id = value.data()!["id"];
      userName = value.data()!["username"];
      firstName = value.data()!["firstname"];
      lastName = value.data()!["lastname"];
      img = value.data()!["photoUrl"];
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      likes = widget.snap['likes'].length;
      for(int i=0;i<likes;i++){
        likeUser.add(widget.snap['likes'][i].toString());
      }
      print(likeUser);
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadData() async {
    await getData();
    setState(() {});
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
    return widget.snap['id'] == FirebaseAuth.instance.currentUser?.uid
        ?
    Container()
        :
    Container(
        color: !mode ? Colors.white : Colors.grey[800],
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
                                    builder: (BuildContext context) => MyAccount(id: widget.snap['id']),));
                            },
                            child : Text(
                              widget.snap['name'],
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
                            'Delete',
                          ].map(
                                (e) => InkWell(
                              onTap: () {
                                APIs.deletePost(widget.snap['postId']);
                                Navigator.of(context).pop();
                              },
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
                  icon:Icon(
                    Icons.send,
                    color: mode ? Colors.white : Colors.black,
                  ),
                ),
                Expanded(
                  child: Align(
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
                    onTap: (){
                      // likesCard();
                      Widget newWidget = likesCard();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => newWidget));
                    },
                    child: DefaultTextStyle(
                      style:Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w800),
                      child:Text(
                        '${widget.snap['likes'].length} likes',
                        // style:Theme.of(context).textTheme.bodyMedium,
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
                          style: const TextStyle(
                              color:Colors.black,
                          ) ,
                          children: [
                            TextSpan(
                              text : widget.snap['name'],
                              style: TextStyle(fontWeight: FontWeight.bold,
                                // color: Colors.black,
                                color: mode ? Colors.white : Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: ' ${widget.snap['caption']}',
                              style: TextStyle(
                                color: mode ? Colors.white : Colors.black,
                              )
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
                      padding:const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "View all ${commentLen} comments",
                        style: TextStyle(
                          fontSize: 16,
                          color: mode ? Colors.white : Colors.black,
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
                          color: mode ? Colors.white : Colors.black,),
                    ),
                  )
                ],
              ),
            )
          ],
        )
    );
  }

  Widget likesCard(){
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*0.098,
          width: double.maxFinite,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.03,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: CachedNetworkImage(
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      imageUrl: pfp,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const CircleAvatar(
                          child: Icon(Icons.person)
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width/20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Text(
                          widget.snap['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.015,
                      ),
                      Container(
                        child: Text(
                          firstName+" "+lastName,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.white,
    //     iconTheme: IconThemeData(
    //       color: Colors.black,
    //     ),
    //     title: Text(
    //       'Likes',
    //       style: TextStyle(
    //         color: Colors.black,
    //       ),
    //     ),
    //   ),
    //   body: StreamBuilder(
    //       stream: FirebaseFirestore.instance.collection('users').snapshots(),
    //       builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
    //         if(snapshot.connectionState==ConnectionState.waiting){
    //           return Center(child: CircularProgressIndicator());
    //         }
    //         return ListView.builder(
    //           itemCount: snapshot.data!.docs.length,
    //           itemBuilder: (context,index){
    //             updateData();
    //             print(userName);
    //             return SingleChildScrollView(
    //                 child: Container(
    //                   height: MediaQuery.of(context).size.height*0.098,
    //                   width: double.maxFinite,
    //                   child: Column(
    //                     children: [
    //                       Row(
    //                         children: [
    //                           SizedBox(
    //                             width: MediaQuery.of(context).size.width*0.03,
    //                           ),
    //                           ClipRRect(
    //                             borderRadius: BorderRadius.circular(45),
    //                             child: CachedNetworkImage(
    //                               width: 60,
    //                               height: 60,
    //                               fit: BoxFit.cover,
    //                               imageUrl: img,
    //                               placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
    //                               errorWidget: (context, url, error) =>
    //                               const CircleAvatar(
    //                                   child: Icon(Icons.person)
    //                               ),
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             width: MediaQuery.of(context).size.width/20,
    //                           ),
    //                           Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               Container(
    //                                 child: Text(
    //                                   userName,
    //                                   style: TextStyle(
    //                                     fontWeight: FontWeight.bold,
    //                                     fontSize: 15,
    //                                   ),
    //                                 ),
    //                               ),
    //                               SizedBox(
    //                                 height: MediaQuery.of(context).size.height*0.015,
    //                               ),
    //                               Container(
    //                                 child: Text(
    //                                   firstName+" "+lastName,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                       Divider(
    //                         color: Colors.black,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               );
    //           },
    //         );
    //       }
    //   ),
    // );
  }
}