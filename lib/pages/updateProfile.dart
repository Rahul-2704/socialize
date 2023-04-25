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
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  bool isLoading = true;
  late String username = '';
  late String pfp = '';
  late String bio = '';
  late String postId='';

  @override
  void initState(){
    super.initState();
    FirebaseFirestore.instance.collection("users").
    doc(FirebaseAuth.instance.currentUser!.uid)
        .get().then((value) {
      username = value.data()!["username"];
      pfp = value.data()!["photoUrl"];
      bio = value.data()!["bio"];
      setState(() {
        isLoading = false;
        _usernameController = TextEditingController(text: username);
        _bioController = TextEditingController(text: bio);
      });
    });
  }
  void getId() async{
    QuerySnapshot<Map<String,dynamic>> snapshot=await FirebaseFirestore.instance.collection("posts")
        .where("id",isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    postId=snapshot.docs.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading ? GestureDetector(
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
                color: mode ? Colors.white : Colors.black87,
              ),
              backgroundColor: mode ? Colors.black87 : Colors.white,
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
          color: !mode ? Colors.white : Colors.grey[900],
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
                      backgroundColor: MaterialStateProperty.all(
                          !mode ? Colors.blue : Colors.black38
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
    : Center(child: CircularProgressIndicator(),);
  }

  Widget nameTextField(){
    return Form(
      child: TextFormField(
        style: TextStyle(
            color: mode ? Colors.white : Colors.black,
        ),
        controller: _usernameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: mode ? Colors.white : Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: mode ? Colors.grey : Colors.black,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.person,
            color: mode ? Colors.greenAccent : Colors.green,
          ),
          hintText: username,
          helperText: 'Username',
          helperStyle: TextStyle(
            color: mode ? Colors.white70 : Colors.black,
          ),
          hintStyle: TextStyle(
            color: mode ? Colors.white70 : Colors.black,
          )
        ),
        onSaved: (username){
          _username = username!;
        },
      ),
    );
  }

  Widget aboutTextField(){
    return TextFormField(
      style: TextStyle(
        color: mode ? Colors.white : Colors.black,
      ),
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
            color: mode ? Colors.grey : Colors.black,
            width: 2,
          ),
        ),
        hintText: bio,
        helperText: 'About',
        helperStyle: TextStyle(
          color: mode ? Colors.white70 : Colors.black,
        ),
        hintStyle: TextStyle(
          color: mode ? Colors.white70 : Colors.black,
        )
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
      color: mode ? Colors.black87 : Colors.black,
      height: 120,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Select Profile Photo',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w400,
              color: !mode ? Colors.black : Colors.white,
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
                label: Text(
                  'Camera',
                  style: TextStyle(
                    fontSize: 20,
                    color: !mode ? Colors.blue : Colors.grey,
                  ),
                ),
                icon: Icon(
                  Icons.camera,
                  size: 27,
                  color: !mode ? Colors.blue : Colors.grey,
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
                    color: !mode ? Colors.blue : Colors.grey,
                  ),
                ),
                icon: Icon(
                  Icons.image,
                  size: 27,
                  color: !mode ? Colors.blue : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}