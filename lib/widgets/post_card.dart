import 'dart:ui';

import 'package:flutter/material.dart';

class PostCard extends StatelessWidget{
  const PostCard({Key?key}):super(key:key);

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
                    'https://www.google.com/imgres?imgurl=https%3A%2F%2Fi.pinimg.com%2Foriginals%2F03%2F10%2F66%2F0310664ebc776d10a0b26a4ca41f4b73.png&tbnid=jpAjQN-S4nyRPM&vet=12ahUKEwjq4av32f79AhX61HMBHXQkCPoQMygAegUIARC1AQ..i&imgrefurl=https%3A%2F%2Fwww.pinterest.com%2Fpin%2F311381761734282257%2F&docid=0sr8GtWRx2c9JM&w=800&h=600&q=random%20insta%20post&ved=2ahUKEwjq4av32f79AhX61HMBHXQkCPoQMygAegUIARC1AQ'
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
                         Text('username',style: TextStyle(
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
            child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYtCDxq2JnxZk5XUvsn6dNrvlPQaYqvfBqIaPMOxsB&s',
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
                  '1000 likes',
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
                        text:"username",
                        style:const TextStyle(fontWeight: FontWeight.bold,),
                        ),
                        TextSpan(
                          text:" Hey this is some description to be placed",),
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
                    color: Colors.black38,
                  ),
                  ),
                ),
                ),
              ],
            ),
          )
        ],
      )
    );
  }
}