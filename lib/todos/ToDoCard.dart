import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
              print(check);
            },
            icon: !check ? Icon(
              Icons.check_box_outline_blank,
              color: Colors.white,
              size: 37,
            ) : Icon(
              Icons.check_box,
              color: Colors.greenAccent,
              size: 37,
            ),
          ),
          // Theme(
          //   child: Transform.scale(
          //     scale: 1.5,
          //     child: Checkbox(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(5)
          //       ),
          //         activeColor: Color(0xff6cf8a9),
          //         checkColor: Color(0xff0e3e26),
          //         value:widget.check,
          //         onChanged:(value) {
          //           // check = !check;
          //           value = tick;
          //         },
          //     ),
          //   ),
          //   data: ThemeData(
          //     primarySwatch: Colors.blue,
          //     unselectedWidgetColor: Color(0xff5e616a),
          //   ),
          // ),
          Expanded(
            child: Container(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Color(0xff2a2e3d),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        color:widget.iconBgColor,
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
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      widget.time,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
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
