import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/resources/firestore_methods.dart';
import 'package:socialize/widgets/comment_screen.dart';

class PostCard extends StatelessWidget{
  final snap;
  const PostCard({Key?key,
    required this.snap,
  }):super(key:key);

  Widget build(BuildContext context){
    late String id='';
    String? username;
    late String pfp='';
    late String feedImage='';
    late String caption='';
    late String date='';
    FirebaseFirestore.instance.collection("users").
    doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value){
      id=value.data()!["id"];
       username=value.data()!["firstname"];
      pfp=value.data()!["photoUrl"];
        });
    FirebaseFirestore.instance
        .collection('userPost')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('post')
        .doc(DateTime.now().toString()).get().then((value){
          feedImage=value.data()!["image"];
          caption=value.data()!['caption'];
          date=value.data()!['date'];
    });
    //Header section
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
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
                           username!,
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                         color: Colors.black
                         ),)
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
            height: MediaQuery.of(context).size.height*0.25,
            width: MediaQuery.of(context).size.width*0.95,
            child: Image.network(
                feedImage,
              fit:BoxFit.cover,
            ),
          ),

          //Like comment section
          Row(
            children: [
              // IconButton(
              //   onPressed: (){},
              //   // onPressed:() async{
              //   //   await APIs().likePost(
              //   //      snap['postId'],
              //   //    //  uid!,
              //   //      snap['likes'],
              //   //   );
              //   // },
              //   //   icon:snap['likes'].contains(FirebaseAuth.instance.currentUser!.uid)?const Icon(
              //   //     Icons.favorite,
              //   //     color: Colors.red,
              //   //   ):const Icon(Icons.favorite_border,),
              // ),
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
                        text:username!,
                        style:const TextStyle(fontWeight: FontWeight.bold,
                        color: Colors.black,
                        ),
                        ),
                        TextSpan(
                          text:caption,
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