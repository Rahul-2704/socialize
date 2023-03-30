import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialize/models/user.dart' as model;
class Authmethods{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User? currentUser=_auth.currentUser;
    DocumentSnapshot snap=await _firestore.collection("users")
        .doc(currentUser!.uid).get();
    return model.User.fromSnap(snap);
  }
  Future<String> signupUser({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required List followers,
    required List following,
    required String photoUrl,
    required String bio,
    required String username,
})async{
    String res='Some error occurred';
    try{
      if(email.isNotEmpty||password.isNotEmpty||firstName.isNotEmpty||lastName.isNotEmpty){
        //register the user
       UserCredential cred= await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //add user to our database
       model.User user=model.User(
         firstname: firstName,
         lastname: lastName,
         uid: cred.user!.uid,
         password: password,
         email: email,
         following: following,
         followers: followers,
         photoUrl: photoUrl,
       );
        await _firestore.collection("users").doc(cred.user!.uid).set(user.toJson(),);
        res="success";
      }
    }catch(err){
      res=err.toString();
    }
    return res;
  }

  Future<String> login({
     required String email,
     required String password
})async{
    String res="Some error occurred";

    try{
      if(email.isNotEmpty||password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(
            email: email,
            password: password
        );
        res="success";
      }else{
        res="Please enter all the fields";
      }
    }catch(err){
      res=err.toString();
    }
    return res;
  }
}