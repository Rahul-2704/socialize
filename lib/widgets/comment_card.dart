import 'package:flutter/material.dart';

class CommentCard extends StatefulWidget{
  CommentCard({Key?key}):super(key:key);
  @override
  _CommentCardState createState()=>_CommentCardState();
}
class _CommentCardState extends State<CommentCard>{
  @override
  Widget build(BuildContext context){
    return Container(
     padding: const EdgeInsets.only(
        left:10,
       right: 10,
     ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage:NetworkImage(
                 'https://plus.unsplash.com/premium_photo-1661545896479-554fa782ccd5?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8ZWRpdG9yaWFsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=1000&q=60'
            ),
            radius: 18,
          ),
          Expanded(
          child:
          Padding(
            padding:const EdgeInsets.only(left:16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text:TextSpan(
                      children: [
                        TextSpan(
                          text: 'username',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color:Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Some description here..',
                          style: const TextStyle(
                            color: Colors.black,
                          )
                        ),
                      ]
                    ),
                ),
                Padding(
                  padding:const EdgeInsets.only(top:4),
                  child: Text(
                    '23/05/2005',
                    style: TextStyle(
                      fontSize:12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
          Container(
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.favorite_border,size: 16,)
          ),
        ],
      ),
    );
  }
}