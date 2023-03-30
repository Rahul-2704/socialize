import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialize/models/user.dart' as model;
import 'package:socialize/pages/interest.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
class BioData extends StatefulWidget {
  const BioData({Key? key}) : super(key: key);
  @override
  State<BioData> createState() => _BioDataState();
}

class _BioDataState extends State<BioData> {
  final ImagePicker picker = ImagePicker();
  String? _image;
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
                  //   print(_bioController.text.trim());
                  //   FirebaseAuth currentUser=(await FirebaseAuth.instance.currentUser) as FirebaseAuth;
                  // FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update(
                  //    { merge:true,
                  //   "bio":_bioController.text.trim(),}
                  //  );
                  //   var firebaseUser =  FirebaseAuth.instance.currentUser;
                   final firestoreInstance = FirebaseFirestore.instance;
                  //
                  //   firestoreInstance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set(
                  //   {
                  //   "bio" :_bioController.text.trim(),
                  //   },SetOptions(merge: true)).then((_){
                  //   print(_bioController.text.trim());
                  //   });
                    var firebaseUser = FirebaseAuth.instance.currentUser;
                    firestoreInstance
                        .collection("users")
                        .doc(firebaseUser!.uid)
                        .set({"bio": _bioController.text.trim(),"username":_usernameController.text.trim()},SetOptions(merge: true)).then((_) {
                        print("success!");
                    });
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
        children: [
          _image != null ?
          CircleAvatar(
            radius: 80,
            child: Image.file(
              File(_image!),
              width: MediaQuery.of(context).size.height * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.cover,
            ),
          )
          :
          CircleAvatar(
            radius: 80,
            child: Image.asset(
              'images/profilePicture.png'
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
                  FirebaseStorage storage=FirebaseStorage.instance;
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if(image != null){
                    setState(() {
                      _image = image.path;
                    });
                    Navigator.pop(context);
                    final Directory systemTempDir = Directory.systemTemp;                           // getting tempory directory

                    final byteData = await rootBundle.load(_image!);                                    // loading image using rootBundle
                    final file = File('${image.path}/$image.jpeg');

                    await file.writeAsBytes(byteData.buffer
                        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
                  }
                //  TaskSnapshot taskSnapshot =
                 // await storage.ref('$image.path/$_image').putFile(file);

                },
                label: Text('Camera', style: TextStyle(fontSize: 20,),),
                icon: Icon(
                  Icons.camera,
                  size: 27,
                ),
              ),
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
