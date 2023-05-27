import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../pages/globals.dart';

class ToDoCard extends StatefulWidget {
  const ToDoCard({
    Key? key,
    required this.title,
    required this.iconData,
    required this.iconColor,
    required this.time,
    required this.check,
    required this.iconBgColor,
    required this.index,
    required this.todoId,
  }) : super(key: key);

  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool check;
  final Color iconBgColor;
  final int index;
  final String todoId;

  @override
  State<ToDoCard> createState() => _ToDoCardState();
}

class _ToDoCardState extends State<ToDoCard> {
  late bool check = widget.check;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          IconButton(
            onPressed: (){
              setState(() {
                check = !check;
                FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('Todo')
                .doc(widget.todoId)
                .update({
                  'check': check,
                });
              });
            },
            icon: !check ? Icon(
              Icons.check_box_outline_blank,
              color: !mode ? Colors.black : Colors.white,
              size: 37,
            ) : Icon(
              Icons.check_box,
              color: Colors.green,
              size: 37,
            ),
          ),
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                color: mode ? Colors.black87 : Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color: widget.iconBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.iconData,
                        color: widget.iconColor,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: !mode ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      widget.time,
                      style: TextStyle(
                        fontSize: 15,
                        color: !mode ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
