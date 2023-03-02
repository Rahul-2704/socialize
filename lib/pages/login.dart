import 'package:flutter/material.dart';
import 'package:socialize/pages/register.dart';
import 'package:socialize/pages/feedPage.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool passwordVisible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/indexBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Image(
                        height: 50,
                        image: AssetImage('images/logo.png'),
                      ),
                    ),
                  ),
                  Text(
                    'Socialize',
                    style: TextStyle(
                      fontFamily: 'Lobster',
                      fontSize: 70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Username or email',
                    labelText: 'Username or email',
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                child: TextField(
                  obscureText: passwordVisible,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          passwordVisible = !passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 230),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.teal[500],
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: 350,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => FeedPage(),));
                  },
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    'Does not have account?',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.pushNamed(context, '/register');
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) => RegisterPage(),));
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.teal[500],
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}