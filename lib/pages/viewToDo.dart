import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
class viewToDo extends StatefulWidget {
  final snap;
  const viewToDo({Key? key,required this.snap}) : super(key: key);

  @override
  State<viewToDo> createState() => _viewToDoState();
}

class _viewToDoState extends State<viewToDo> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String type="";
  String category="";
  bool edit=false;
  void initState(){
    super.initState();
    String title=widget.snap['title']==null?
        'Please give a title':widget.snap['title'];
    _titleController=TextEditingController(text: title);
    String description=widget.snap['description']==null?
    'Please give a title':widget.snap['description'];
    _descriptionController=TextEditingController(text:description);
    type=widget.snap['task'];
    category=widget.snap['Category'];

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient:LinearGradient(colors: [
              Color(0xff1d1e26),
              Color(0xff252041)
            ])
        ),
        child: SingleChildScrollView(
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon:Icon(CupertinoIcons.arrow_left
                      ,color: Colors.white,size: 28)
                  ),
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        setState(() {
                          edit=!edit;
                        });
                      }, icon: Icon(
                            Icons.edit,
                            color: edit?Colors.green:Colors.white,
                            size: 20,
                          )
                      ),
                      IconButton(
                        onPressed: (){
                          FirebaseFirestore.instance.collection("Todo").doc(widget.snap['todoId']).delete()
                              .then((value){
                                Navigator.pop(context);
                          });
                         
                        },
                        icon:Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 28,
                        ),),
                    ],
                  ),
                ],
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
                      edit?'Editing':'View',
                      style: TextStyle(
                        fontSize:33,
                        color:Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Your Todo',
                      style: TextStyle(
                        fontSize:33,
                        color:Colors.white,
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
                        taskSelect("Planned",0xff2bc8d9),
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
                        categorySelect("WorkOut",0xfff29732),
                        SizedBox(width: 20,),
                        categorySelect("Work",0xff6557ff),
                        SizedBox(width: 20,),
                        categorySelect("Code",0xff234ebd),
                        SizedBox(width: 20,),
                        categorySelect("Run",0xff2bc8d9),
                        SizedBox(width: 20,),
                        categorySelect("Entertainment",0xff880e4f),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    edit?button():Container(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget button(){
    return InkWell(
      onTap: (){
        String todoId=const Uuid().v1();
        FirebaseFirestore.instance.collection("Todo").doc(widget.snap['todoId']).update({
          "title":_titleController.text,
          "task":type,
          "Category":category,
          "description":_descriptionController.text,
          "time":DateFormat.j().format(DateTime.now()).toString(),
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
              'Edit To Do',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),),

          )
      ),
    );
  }
  Widget description(){
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        enabled: edit,
        controller: _descriptionController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Enter Description",
            hintStyle: TextStyle(
              color: Colors.white,
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
      onTap:edit?(){
        setState(() {
          type=label;
        });
      }:null,
      child: Chip(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
        backgroundColor:type==label?Colors.white:Color(color),
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
      onTap: edit?(){
        setState(() {
          category=label;
        });
      }:null,
      child: Chip(
        backgroundColor:category==label?Colors.white:Color(color),
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
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        enabled: edit,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Task Title",
            hintStyle: TextStyle(
              color:Colors.white,
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
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }
}
