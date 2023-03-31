import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../api/apis.dart';
import '../api/dialogs.dart';


class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String ? _image;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Center(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 15,
                    ),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: (){
                                _showBottomSheet();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                              ),
                              child: _image != null ? ClipRRect(
                                  child: Image.file(File(_image!),
                                      width: MediaQuery.of(context).size.height * .42,
                                      height: MediaQuery.of(context).size.height * .42,
                                      fit: BoxFit.cover)
                              )
                              : Image(
                                  image: AssetImage('images/profilePicture.png'),
                                ),
                            ),
                        SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                    width: 2,
                                  ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                              ),
                              labelText: 'Enter Caption',
                              hintText: 'Caption',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                              ),
                              labelStyle: TextStyle(
                                  color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                    SizedBox(height: 20,),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.92,
                      height: MediaQuery.of(context).size.height*0.07,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.cyan),
                        ),
                          onPressed: (){
                            if (_formKey.currentState!.validate()){
                              _formKey.currentState!.save();
                              APIs.updatePost(File(_image!)).then((value) {
                                Dialogs.showSnackBar(context,"Post Done Successfully!");
                              });
                            }
                          },

                          child: Text(
                            'Post',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * .03, bottom: MediaQuery.of(context).size.height * .05),
            children: [
              const Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });

                          APIs.updatePost(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/add_image.png')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(MediaQuery.of(context).size.width * .3, MediaQuery.of(context).size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updatePost(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')),
                ],
              )
            ],
          );
        });
  }
}
