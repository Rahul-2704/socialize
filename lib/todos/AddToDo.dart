import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../pages/globals.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({Key? key}) : super(key: key);

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController _titleController=TextEditingController();
  TextEditingController _descriptionController=TextEditingController();
  String type="";
  String category="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: mode ? Colors.grey[900] : Colors.white,
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              IconButton(onPressed: (){
                Navigator.pop(context);
              },
                icon: Icon(
                    CupertinoIcons.arrow_left,
                    color: !mode ? Colors.black : Colors.white,
                    size: 28
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create',
                      style: TextStyle(
                        fontSize:33,
                        color: !mode ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'New Todo',
                      style: TextStyle(
                        fontSize:33,
                        color: !mode ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Task title"),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Task Type"),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect("Important",0xff2662fa),
                        SizedBox(width: 20,),
                        taskSelect("Planned",0xff2662fa),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Description"),
                    SizedBox(
                      height: 12,
                    ),
                    description(),
                    SizedBox(
                      height: 25,
                    ),
                    label("Category"),
                    SizedBox(
                      height: 12,
                    ),
                    Wrap(
                      runSpacing: 10,
                      children: [
                        categorySelect("Food",0xff2662fa),
                        SizedBox(width: 20,),
                        categorySelect("WorkOut",0xff2662fa),
                        SizedBox(width: 20,),
                        categorySelect("Work",0xff2662fa),
                        SizedBox(width: 20,),
                        categorySelect("Code",0xff2662fa),
                        SizedBox(width: 20,),
                        categorySelect("Run",0xff2662fa),
                        SizedBox(width: 20,),
                        categorySelect("Entertainment",0xff2662fa),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Button(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Button(){
    return InkWell(
      onTap: (){
        String todoId = const Uuid().v1();
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Todo')
            .doc(todoId).set({
          "title" : _titleController.text,
          "todoId" : todoId,
          "id" : FirebaseAuth.instance.currentUser!.uid,
          "task" : type,
          "Category" : category,
          "description" : _descriptionController.text,
          "time" : DateFormat.j().format(DateTime.now()).toString(),
          "check" : false,
        });
        Navigator.pop(context);
      },
      child: Container(
          height: 56,
          width: MediaQuery.of(context).size.width,
          decoration:BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                  colors: [
                    Color(0xff8a32f1),
                    Color(0xffad32f9),
                  ]
              )
          ),
          child:Center(
            child: Text(
              'Add To Do',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
      ),
    );
  }

  Widget description(){
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: !mode ? Colors.grey[300] : Colors.black87,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(
          color: mode ? Colors.white : Colors.black87,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter Description",
            hintStyle: TextStyle(
              color: mode ? Colors.white : Colors.grey[700],
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )
        ),
      ),
    );
  }

  Widget taskSelect(String label,int color){
    return InkWell(
      onTap: (){
        setState(() {
          type = label;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        backgroundColor: type == label ? mode ? Colors.white : Color(0xff2bc8d9) : !mode ? Color(color) : Colors.grey[600],
        label:Text(
          label,
          style: TextStyle(
            color:type==label?Colors.black:Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal:17 ,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget categorySelect(String label,int color){
    return InkWell(
      onTap: (){
        setState(() {
          category=label;
        });
      },
      child: Chip(
        backgroundColor:category==label?mode ? Colors.white : Color(0xff2bc8d9) : !mode ? Color(color) : Colors.grey[600],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        label:Text(
          label,
          style: TextStyle(
            color:category==label?Colors.black:Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal:17 ,
          vertical: 3.8,
        ),
      ),
    );
  }

  Widget title(){
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: !mode ? Colors.grey[300] : Colors.black87,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        style: TextStyle(
          color: mode ? Colors.white : Colors.black,
          fontSize: 17,
        ),
        controller: _titleController,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color: mode ? Colors.white : Colors.grey[700],
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )
        ),
      ),
    );
  }

  Widget label(String label){
    return Text(
      label,
      style: TextStyle(
        color: !mode ? Colors.black : Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }
}