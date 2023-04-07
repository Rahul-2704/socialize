import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../pages/accountPage.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key,required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical:18,horizontal:16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              width: 35,
              height: 35,
              fit: BoxFit.cover,
              imageUrl: widget.snap['profUrl'],
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
              const CircleAvatar(
                  child: Icon(Icons.person)
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left:16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // RichText(
                  //   text: TextSpan(
                  //     children: [
                  //       TextSpan(
                  //         text:widget.snap['username'],
                  //         style: const TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //       TextSpan(
                  //           text:' ${widget.snap['comment']}',
                  //           style: const TextStyle(
                  //             color: Colors.black,
                  //           )
                  //       ),
                  //     ]
                  //   )
                  // ),
                  Row(
                      children:[
                        TextButton(
                            onPressed:(){
                              Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => MyAccount(id: widget.snap['id']),
                                )
                              );
                            },
                            child:Row(
                              children: [
                                Text(
                                  widget.snap['username'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  widget.snap['comment'],
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            )
                        )
                      ]
                  ),
                  Padding(padding:const EdgeInsets.only(top:4.0),
                    child: Text(
                      '${DateFormat.MMMMEEEEd().format(
                          widget.snap['datePublished'].toDate()
                      )}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.favorite_border,size: 16,),
          )
        ],
      ),

    );
  }
}