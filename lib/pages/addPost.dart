import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socialize/pages/accountPage.dart';
import 'package:socialize/pages/requestPage.dart';
import 'package:socialize/news/newsPage.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/pages/globals.dart';
import 'package:socialize/providers/userProvider.dart';
import 'package:socialize/resources/firestore_methods.dart';
import 'package:socialize/utils/colors.dart';
import 'package:socialize/utils/utils.dart';
import 'dart:typed_data';
import 'package:socialize/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool request = true;
  Uint8List?  _file;
  final TextEditingController _descriptionController=TextEditingController();
  void dispose(){
    super.dispose();
    _descriptionController.dispose();
  }
  _selectImage(BuildContext context) async{
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text('Create a Post'),
        children: [
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Take a Photo'),
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List? file=await pickImage(ImageSource.camera,);
              setState(() {
                _file=file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Choose from Gallery'),
            onPressed: () async{
              Navigator.of(context).pop();
              Uint8List? file=await pickImage(ImageSource.gallery,);
              setState(() {
                _file=file;
              });
            },
          ),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: const Text('Cancel'),
            onPressed: () async{
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }
  void postImage(String uid,
      String username,
      String profImage,)
  async{
    try{
      String res=await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if(res=='success'){
        showSnackBar('Posted', context);
      }
      else{
        showSnackBar(res, context);
      }
    }catch(err){
      showSnackBar(err.toString(), context);
    }

  }
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    //final model.User user=Provider.of<UserProvider>(context).getUser;
    return _file==null
        ?Center(
        child: Material(
        child: IconButton(
          icon: Icon(Icons.upload),
          onPressed: ()=>_selectImage(context),
        ),
      ),
    ):
    Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: mode ? Colors.black :mobileBackgroundColor,
            leading:IconButton(
              icon:const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: (){},
            ),
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'New Post',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: mode ? Colors.white : Colors.black,
                ),
              ),
            ),
            centerTitle: false,
            actions: [
              TextButton(
                onPressed: ()=>postImage(
                 userProvider.getUser.uid,
                  userProvider.getUser.firstname,
                  userProvider.getUser.photoUrl,
        ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.teal,
      // ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:EdgeInsets.all(14.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    userProvider.getUser.photoUrl,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.4,
                child:TextField(
                  controller: _descriptionController,
                  decoration:const InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child:SizedBox(
                  height: 45,
                  width: 45,
                  child: AspectRatio(
                    aspectRatio: 487/451,
                    child:Container(
                      decoration:BoxDecoration(
                          image: DecorationImage(
                            image:MemoryImage(_file!),
                            fit:BoxFit.fill,
                            alignment: FractionalOffset.topCenter,
                          ),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: mode ? Colors.grey[800] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10,),
          child: Row(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => FeedPage(),));
                },
                icon: Icon(
                  Icons.home_outlined,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => NewsScreen(),));
                },
                icon: Icon(
                  Icons.search,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => AddPostScreen(),));
                },
                icon: Icon(
                  Icons.add,
                  color: mode ? Colors.white : Colors.black,
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => RequestPage(),));
                },
                icon: Icon(
                  Icons.favorite_border,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) => MyAccount(),));
                },
                icon: Icon(
                  Icons.person_outline_outlined,
                  color: mode ? Colors.white54 : Colors.grey[700],
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






