import 'package:flutter/material.dart';
import 'package:socialize/pages/bioData.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool passwordVisible = true;
  bool passwordVisible1 = true;
  late String _firstname,_lastname,_email,_dob;
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();
  final GlobalKey<FormState> _fk = GlobalKey<FormState>();
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
      // resizeToAvoidBottomInset : false,
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
        child: SingleChildScrollView(
          child: Form(
            key: _fk,
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
                  height:80,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      // decoration: buildInputDecoration(Icons.person,'First name'),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'First Name',
                        // labelText: 'First Name',
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Icon(
                            Icons.person,
                          ),
                        )
                      ),
                      validator: (value) => value!.isEmpty ? 'First Name cannot be blank':null,
                      onSaved: (firstname){
                        _firstname=firstname!;
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
                      // decoration: buildInputDecoration(Icons.person,'First name'),
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Last Name',
                          // labelText: 'Last Name',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.person,
                            ),
                          )
                      ),
                      validator: (value) => value!.isEmpty ? 'Last Name cannot be blank':null,
                      onSaved: (lastname){
                        _lastname=lastname!;
                      },
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                // SizedBox(
                //   width: 350,
                //   height:60,
                //   child: TextField(
                //     decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       filled: true,
                //       fillColor: Colors.white,
                //       hintText: 'Last Name',
                //       labelText: 'Last Name',
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10,),

                SizedBox(
                  width: 350,
                  height:80,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'DD/MM/YYYY',
                        // labelText: 'Date of Birth',
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(top: 1),
                            child: Icon(
                              Icons.calendar_month,
                            ),
                          )
                      ),
                      validator: (value) => value!.isEmpty ? 'Please enter date of birth':null,
                      onSaved: (dob){
                        _dob=dob!;
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
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        //labelText: 'Email',
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
                        // labelText: 'Create Password',
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible ? Icons.visibility_off : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) =>  value!.isEmpty ? 'Enter Password':null,

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
                      validator: (value) =>  _confirmpassword.text!=_password.text ? 'Re-enter Password':null,
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: validateAndSave,
                    // onPressed:(){
                    //   validateAndSave();
                    //   Navigator.pushReplacement(context,
                    //       MaterialPageRoute(builder: (BuildContext context) => BioData(),));
                    // },
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
