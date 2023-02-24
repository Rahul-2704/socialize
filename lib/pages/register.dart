import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = true;
  bool passwordVisible1 = true;
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
              SizedBox(
                width: 250,
                child: Text(
                  'Sign Up to see photos and videos from your friends.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 350,
                height:60,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'First Name',
                    labelText: 'First Name',
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: 350,
                height:60,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Last Name',
                    labelText: 'Last Name',
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: 350,
                height:60,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'DD/MM/YYYY',
                    labelText: 'Date of Birth',
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: 350,
                height:60,
                child: TextField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Email',
                    labelText: 'Email',
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: 350,
                height:60,
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
                    hintText: 'Create Password',
                    labelText: 'Create Password',
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
              SizedBox(height: 10),
              SizedBox(
                width: 350,
                height:60,
                child: TextField(
                  obscureText: passwordVisible1,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible1 ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          passwordVisible1 = !passwordVisible1;
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'Sign Up',
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                  ),
                ),
              ),
              SizedBox(height: 5,),
              SizedBox(
                width: 300,
                child: Text(
                  'By signing up, you agree to our Terms, Data Policy and Cookies Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
