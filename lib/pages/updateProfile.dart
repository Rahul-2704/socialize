import 'dart:io' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialize/api/apis.dart';
import 'package:socialize/api/dialogs.dart';
import 'globals.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key?key}):super(key: key);
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final ImagePicker picker = ImagePicker();
  late String _username;
  final GlobalKey<FormState> _bioK = GlobalKey<FormState>();
  String? _image;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool isLoading = true;
  late String username = '';
  late String pfp = '';
  late String bio = '';
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection("users").
    doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value) {
      username = value.data()!["username"];
      pfp = value.data()!["photoUrl"];
      bio = value.data()!["bio"];
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            child: AppBar(
              leading: BackButton(
                color: mode ? Colors.white : Colors.black,
              ),
              backgroundColor: mode ? Colors.black : Colors.white,
              elevation: 1,
              title: Text(
                'Update Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: mode ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ListView(
              children: <Widget>[
                imageProfile(),
                SizedBox(height: 30,),
                nameTextField(),
                SizedBox(height: 20,),
                aboutTextField(),
                SizedBox(height: 20,),
                SizedBox(
                  height: 45,
                  width: 350,
                  child: ElevatedButton(
                    onPressed: () {
                      APIs.profileUpdate(i.File(_image!)).then((value) {
                        Dialogs.showSnackBar(context, 'Profile Updated Successfully!');
                      });
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .set({
                        "username" : (_usernameController.text.trim()).isEmpty ? username : _usernameController.text.trim(),
                        // "bio" : _bioController.text.trim(),
                        "bio" : (_bioController.text.trim()).isEmpty ? bio : _bioController.text.trim(),

                      },SetOptions(merge: true)).then((_){
                        print("success!");
                      });
                    },
                    child: Text(
                      'Update',
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
      ),
    );
  }

  Widget nameTextField(){
    return Form(
      child: TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 2,
              ),
            ),
            prefixIcon: Icon(
              Icons.person,
              color: Colors.green,
            ),
            hintText: username,
            helperText: 'Username'
        ),
        onSaved: (username){
          _username = username!;
        },
      ),
    );
  }

  Widget aboutTextField(){
    return TextFormField(
      controller: _bioController,
      maxLines: 3,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        hintText: bio,
        helperText: 'About',
      ),
    );
  }

  Widget imageProfile(){
    return Center(
      child: Stack(
        children: [
          _image != null ?
          ClipRRect(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.1),
            child: Image.file(
              i.File(_image!),
              width: MediaQuery.of(context).size.height * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.cover,
            ),
          )
              :
          isLoading ? Center(child: CircularProgressIndicator())
              :
          CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage(
              pfp,
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
                Icons.edit,
                color: Colors.white,
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
            'Select Profile Photo',
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
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if(image != null) {
                    setState(() {
                      _image = image.path;
                    });
                    Navigator.pop(context);
                  }
                },
                label: Text('Camera', style: TextStyle(fontSize: 20,),),
                icon: Icon(
                  Icons.camera,
                  size: 27,
                ),
              ),
              SizedBox(width: 15,),
              TextButton.icon(
                onPressed: () async {
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if(image != null){
                    setState(() {
                      _image = image.path;
                    });
                    Navigator.pop(context);
                  }
                },
                label: Text(
                  'Gallery',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
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