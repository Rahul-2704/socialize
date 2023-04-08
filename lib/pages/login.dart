import 'package:flutter/material.dart';
import 'package:socialize/pages/forgotPassword.dart';
import 'package:socialize/pages/register.dart';
import 'package:socialize/pages/feedPage.dart';
import 'package:socialize/api/apis.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;
  late String _emailLogin;
  TextEditingController _passwordLogin = TextEditingController();
  final GlobalKey<FormState> _fkLogin = GlobalKey<FormState>();
  final _emailController=TextEditingController();
  final _passwordController=TextEditingController();
  bool _isLoading = false;

  void validateAndSaveLogin() {
    final FormState? form = _fkLogin.currentState;
    if (form!.validate()) {
      print('Form is valid');
    } else {
      print('Form is invalid');
    }
  }

  void loginUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().login(
        email: _emailController.text.trim(),
        password:_passwordController.text.trim(),
    );
    if(res == "success"){
     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const FeedPage()));
    }
    else{
    }
    setState(() {
      _isLoading=false;
    });
  }

  @override
    void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: Container(
        alignment: Alignment.center,
        height : MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Form(
            key: _fkLogin,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                Column(
                  children: [
                    SizedBox(
                      width: 350,
                      height:70,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top:1),
                              child: Icon(
                                Icons.email,
                              ),
                            ),
                          ),
                          validator: (value) =>  !RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value!)? 'Enter a valid email':null,
                          onSaved: (email){
                            _emailLogin = email!;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: 350,
                      height:70,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: passwordVisible,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),

                            prefixIcon: Padding(
                              padding: EdgeInsets.only(top:1),
                              child: Icon(
                                Icons.lock,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Enter Password',
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) =>  value!.isEmpty ? 'Enter Password' : null,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(width: 240,),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ForgotPassword(),
                            ));
                          },
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Colors.teal[500],
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 350,
                      height: 60,
                      child: ElevatedButton(
                        onPressed:() {
                          // dummyEnter();
                          validateAndSaveLogin();
                          loginUser();
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Does not have account?',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: (){
                           Navigator.pushReplacement(context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                  RegisterPage(),
                              )
                            );
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void dummyEnter() {
    _emailController.text = "kunal.pasad@spit.ac.in";
    _passwordController.text = "kunal6";
  }
}