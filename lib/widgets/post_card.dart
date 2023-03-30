import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socialize/utils/colors.dart';

class PostCard extends StatelessWidget{
  final snap;
  const PostCard({Key?key,
    required this.snap,
  }):super(key:key);

  Widget build(BuildContext context){
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
                  snap['profImage'],
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
                         Text(snap['username'],style: TextStyle(
                           fontWeight: FontWeight.bold,
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
            height: MediaQuery.of(context).size.height*0.35,
            width: MediaQuery.of(context).size.width*0.95,
            child: Image.network(
               snap['postUrl'],
              fit:BoxFit.cover,
            ),
          ),

          //Like comment section
          Row(
            children: [
              IconButton(
                onPressed:(){},
                  icon:const Icon(
                      Icons.favorite,
                      color:Colors.red,
                  ),
              ),
              IconButton(
                onPressed:(){},
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
                  '${snap['likes'].length} likes',
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
                        text:snap['username'],
                        style:const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(
                          text:' ${snap['description']}',),
                      ]
                    ),
                  ) ,
                ),
                InkWell(
                  onTap: (){},
                child:Container(
                  padding:const EdgeInsets.symmetric(vertical: 4) ,
                  child: Text("View all 200 comments",
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
                    DateFormat.yMMMd().format(snap['datePublished'].toDate(),
    ),
                    style:const TextStyle(fontSize: 16,color: secondaryColor),
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