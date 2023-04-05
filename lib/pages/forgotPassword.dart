import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:socialize/api/dialogs.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/forgotPassword.png'),
              opacity: 0.8,
            )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                ),
              ),
              SizedBox(height: 40,),
              ElevatedButton(
                child: Text('Forgot'),
                onPressed: () {
                  auth.sendPasswordResetEmail(
                    email: emailController.text.toString()
                    ).then((value){
                      Dialogs.snackBarForgotPassword(
                        context,
                        'We have sent you email to recover password, please check mail'
                      );
                    })
                    .onError((error, stackTrace){
                    Fluttertoast.showToast(
                      msg: error.toString()
                    );
                  }
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}