import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/api/dialogs.dart';
import 'package:socialize/pages/accountPage.dart';

import 'globals.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String ? _image;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _captionController=TextEditingController();
  bool isLoading1 = true;
  late String username = '';
  late String pfp='';

  @override
  void initState() {
    FirebaseFirestore.instance.collection("users").
    doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value) {
      username = value.data()!["username"];
      pfp = value.data()!["photoUrl"];
      setState(() {
        isLoading1 = false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          height: double.maxFinite,
          color: !mode ? Colors.white : Colors.black87,
          child: SingleChildScrollView(
            child: Center(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.025,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*0.025),
                      child: Row(
                        children: [
                          isLoading1 ? CircularProgressIndicator():
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              width: MediaQuery.of(context).size.width*0.22,
                              height: MediaQuery.of(context).size.width*0.22,
                              fit: BoxFit.cover,
                              imageUrl: pfp,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                              const CircleAvatar(
                                  child: Icon(Icons.person)
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Text(
                            username,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height*0.04,
                              fontWeight: FontWeight.w500,
                              color: !mode ? Colors.black87 : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.02,
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
                              :
                              Image(
                                image: AssetImage('images/uploadImage.jpg'),
                              ),
                            ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width*0.04
                          ),
                          child: TextFormField(
                            style: TextStyle(
                              color: !mode ? Colors.black : Colors.white,
                            ),
                            controller: _captionController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: !mode ? Colors.black : Colors.white,
                                    width: 2,
                                  ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: !mode ? Colors.black : Colors.white,
                                    width: 1,
                                  ),
                              ),
                              labelText: 'Enter Caption',
                              hintText: 'Caption',
                              hintStyle: TextStyle(
                                color: !mode ? Colors.black : Colors.white,
                              ),
                              labelStyle: TextStyle(
                                color: !mode ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.92,
                      height: MediaQuery.of(context).size.height*0.07,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            !mode ? Colors.blue : Colors.black38,
                          ),
                        ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()){
                              _formKey.currentState!.save();
                              await APIs.addPost(File(_image!), _captionController.text.trim()).then((value) {
                                Dialogs.showSnackBar(context,"Post Done Successfully!");
                              });
                              Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                    MyAccount(id: FirebaseAuth.instance.currentUser!.uid),
                                )
                              );
                            }
                          },

                          child: Text(
                            'Post',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.height*0.025,
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
          return Container(
            color: mode ? Colors.black87 : Colors.white,
            child: ListView(
              shrinkWrap: true,
              padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * .03, bottom: MediaQuery.of(context).size.height * .05),
              children: [
                Text(
                    'Pick Profile Picture',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height*0.02,
                      fontWeight: FontWeight.w500,
                      color: !mode ? Colors.black : Colors.white,
                    )
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
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('images/camera.png')
                    ),
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
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('images/add_image.png')
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
