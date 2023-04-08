import 'package:flutter/material.dart';
import 'package:socialize/pages/bioData.dart';
import 'package:socialize/api/apis.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = true;
  bool passwordVisible1 = true;
  late String _firstname, _lastname, _email, _dob;
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _password = TextEditingController();
  final _confirmpassword = TextEditingController();
   final GlobalKey<FormState> _fk = GlobalKey<FormState>();
  @override
  void dispose(){
    _emailController.dispose();
    _password.dispose();
    super.dispose();
  }
  void validateAndSave() {
    final FormState? form = _fk.currentState;
    if (form!.validate()) {
      print('Form is valid');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => BioData(),));
    } else {
      print('Form is invalid');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
      ),
      body: Container(
        height : MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/indexBackground.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _fk,
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
                SizedBox(height: 15,),
                SizedBox(
                  width: 350,
                  height:80,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      controller:_firstnameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'First Name',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.person,
                          ),
                        )
                      ),
                      validator: (value) => value!.isEmpty ? 'First Name cannot be blank':null,
                      onSaved: (firstname){
                        _firstname = firstname!;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                SizedBox(
                  width: 350,
                  height:80,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      controller: _lastnameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Last Name',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.person,
                            ),
                          )
                      ),
                      validator: (value) => value!.isEmpty ? 'Last Name cannot be blank':null,
                      onSaved: (lastname){
                        _lastname = lastname!;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                SizedBox(
                  width: 350,
                  height:80,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      controller: _dobController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'DD/MM/YYYY',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.calendar_month,
                            ),
                          )
                      ),
                      validator: (value) => value!.isEmpty ? 'Please enter date of birth':null,
                      onSaved: (dob){
                        _dob = dob!;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 3,),
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
                          )
                      ),
                      validator: (value) =>  !RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+[a-z]").hasMatch(value!)? 'Enter a valid email':null,
                      onSaved: (email){
                        _email=email!;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                SizedBox(
                  width: 350,
                  height:70,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: TextFormField(
                      controller: _password,
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
                        hintText: 'Create Password',
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
                SizedBox(height: 3,),
                SizedBox(
                  width: 350,
                  height:70,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: TextFormField(
                      controller: _confirmpassword,
                      keyboardType: TextInputType.text,
                      obscureText: passwordVisible1,
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
                        hintText: 'Confirm Password',
                        // labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible1 ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              passwordVisible1 = !passwordVisible1;
                            });
                          },
                        ),
                      ),
                      validator: (value) =>  _confirmpassword.text != _password.text ? 'Re-enter Password' : null,
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async{
                      validateAndSave();
                      String res=await AuthMethods().signupUser(
                            firstName:_firstnameController.text.trim(),
                            lastName:_lastnameController.text.trim(),
                            email:_emailController.text.trim(),
                            password:_password.text.trim(),
                            followers: [],
                            following: [],
                            photoUrl:'images/profilePicture.png',
                            bio:'',
                            username:'',
                            login: true,
                          );
                      print(res);
                    },
                    child: Text(
                      'Sign Up',
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                    ),
                  ),
                ),
                SizedBox(height: 3,),
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
      ),
    );
  }
}
