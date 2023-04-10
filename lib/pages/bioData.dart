import 'dart:io' as i;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socialize/api/dialogs.dart';

class BioData extends StatefulWidget {
  const BioData({Key? key}) : super(key: key);
  @override
  State<BioData> createState() => _BioDataState();
}

class _BioDataState extends State<BioData> {
  final ImagePicker picker = ImagePicker();
  late String _username;
  final GlobalKey<FormState> _bioK = GlobalKey<FormState>();
  String? _image;
  final TextEditingController _usernameController=TextEditingController();
  final TextEditingController _bioController=TextEditingController();
  void validateAndSave() {
    final FormState? form = _bioK.currentState;
    if (form!.validate()) {
      print('Form is valid');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => FeedPage(),));
    } else {
      print('Form is invalid');
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
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
                      validateAndSave();
                      final firestoreInstance = FirebaseFirestore.instance;
                      FirebaseAuth _auth=FirebaseAuth.instance;
                      firestoreInstance.collection("users").doc(_auth.currentUser!.uid).set(
                          {
                            "username" : _usernameController.text.trim(),
                            "bio":_bioController.text.trim(),
                          },SetOptions(merge: true)).then((_){
                        print("success!");
                      });
                      String? downloadLink;
                      String imageName = "${FirebaseAuth.instance.currentUser!.uid}";
                      UploadTask uploadTask=FirebaseStorage.instance
                          .ref()
                          .child("photos")
                          .child(imageName)
                          .putFile(i.File(_image!));
                      TaskSnapshot downloadURL = (await uploadTask);
                      String url = await downloadURL.ref.getDownloadURL();
                      firestoreInstance.collection("users").doc(_auth.currentUser!.uid).set(
                          {
                            "photoUrl":url,
                          },SetOptions(merge: true)).then((_){
                        Dialogs.showSnackBar(context,"Bio Updated Successfully!");
                      });
                      Navigator.pushReplacement(context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                            FeedPage(),
                        )
                      );
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
      ),
    );
  }

  Widget nameTextField(){
    return Form(
      key:_bioK,
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
          labelText: 'Username',
          hintText: 'Username',
          helperText: 'Enter a valid Username',
        ),
        validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
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
        labelText: 'About',
        hintText: 'Bio',
        helperText: 'Write about yourself',
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
          ClipRRect(
            borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.1),
            child: Image.asset(
              'images/profilePicture.png',
              width: MediaQuery.of(context).size.height * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.cover,
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
                  FirebaseStorage storage = FirebaseStorage.instance;
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
