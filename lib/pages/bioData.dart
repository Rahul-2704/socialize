import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BioData extends StatefulWidget {
  const BioData({Key? key}) : super(key: key);

  @override
  State<BioData> createState() => _BioDataState();
}

class _BioDataState extends State<BioData> {
  late PickedFile _imageFile;
  final ImagePicker picker = ImagePicker();
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
                  onPressed: () {},
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
          CircleAvatar(
            radius: 80,
            backgroundImage: // _imageFile == null ?
            AssetImage('images/profilePicture.png')
            // : FileImage(File(_imageFile.path)),
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
                size: 28,
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
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text('Camera'),
                icon: Icon(
                  Icons.camera,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text('Gallery'),
                icon: Icon(
                  Icons.image,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async{
    final pickedFile = await picker.getImage(
      source: source,
    );
    setState(() {
      _imageFile = pickedFile!;
    });
  }
}
