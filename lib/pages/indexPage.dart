import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Padding(
                padding: const EdgeInsets.only(left: 120),
                child: Text(
                  '- Stay connected and updated',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        icon: Icon(
                            Icons.login
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        label: Text(
                            'Login'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        icon: Icon(
                            Icons.add_box_rounded
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        label: Text(
                            'Register'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
