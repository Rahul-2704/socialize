
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialize/pages/interest.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../utils/utils.dart';

class BioData extends StatefulWidget {
  const BioData({Key? key}) : super(key: key);
  @override
  State<BioData> createState() => _BioDataState();
}

class _BioDataState extends State<BioData> {
  late PickedFile _imageFile;
  final ImagePicker picker = ImagePicker();
  Uint8List? _image;
  final TextEditingController _usernameController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image(
                  height: 40,
                  image: AssetImage('images/logo.png'),
                ),
              ),
            ),
            Text(
              'Socialize',
              style: TextStyle(
                fontFamily: 'Lobster',
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/indexBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView(
            children: <Widget>[
              imageProfile(),
              SizedBox(height: 20,),
              nameTextField(),
              SizedBox(height: 20,),
              aboutTextField(),
              SizedBox(height: 20,),
              SizedBox(
                height: 45,
                width: 350,
                child: ElevatedButton(
                  onPressed: () async{
                    FirebaseFirestore _firestore=FirebaseFirestore.instance;
                    FirebaseAuth _auth=FirebaseAuth.instance;
                    CollectionReference users=FirebaseFirestore.instance.collection("users");
                    await users.add(_bioController.text.trim());
                    // _firestore.collection("users").add(_usernameController.text()).
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => ChooseInterest(),));
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nameTextField(){
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: 'Username',
        hintText: 'Username',
        helperText: 'Enter a valid Username',
      ),
    );
  }

  Widget aboutTextField(){
    return TextFormField(
      controller: _bioController,
      maxLines: 5,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.teal,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        labelText: 'About',
        hintText: 'Bio',
        helperText: 'Write about yourself',
      ),
    );
  }

  Widget imageProfile(){
    return Center(
      child: Stack(
        children: <Widget>[
          _image!=null? CircleAvatar(
            radius: 80,
            backgroundImage: MemoryImage(_image!),
          )
          :const CircleAvatar(
            radius: 80,
            // backgroundImage: _imageFile == null ?
            // Image.asset('images/profilePicture.png').image
            //  : null,
            backgroundImage: NetworkImage(
              'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.shutterstock.com%2Fsearch%2Fprofile&psig=AOvVaw3GC9aaNm4gY-2DyeeKnuWK&ust=1679510263674000&source=images&cd=vfe&ved=0CBAQjRxqFwoTCJj-jbfV7f0CFQAAAAAdAAAAABAE'
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet(){
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Choose Profile Photo',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () async{
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                },
                label: Text('Camera', style: TextStyle(fontSize: 20,),),
                icon: Icon(
                  Icons.camera,
                  size: 27,
                ),
              ),
              TextButton.icon(
                onPressed: () {

                },
                label: Text('Gallery', style: TextStyle(fontSize: 20,),),
                icon: Icon(
                  Icons.image,
                  size: 27,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
