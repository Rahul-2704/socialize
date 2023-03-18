import 'package:flutter/material.dart';
import 'globals.dart';

class FriendPage extends StatefulWidget {
  const FriendPage({Key? key}) : super(key: key);
  @override
  State<FriendPage> createState() => _FriendPage();
}

class _FriendPage extends State<FriendPage> {
  bool request = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor: mode ? Colors.black : Colors.white,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'User1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: mode ? Colors.white : Colors.black,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    mode = !mode;
                  });
                },
                icon: Icon(
                  mode ? Icons.light_mode : Icons.dark_mode,
                  color: mode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: mode ? Colors.grey[850] : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        'User1',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: mode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        '20',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: mode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        'Posts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: mode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: (){},
                    child: Column(
                      children: [
                        Text(
                          '500',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: mode ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          'Friends',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: mode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    request = !request;
                  });
                },
                child: request ? Text('Request') : Text('Requested'),
                style: ButtonStyle(
                  backgroundColor: request ? MaterialStatePropertyAll(Colors.blue) : MaterialStatePropertyAll(Colors.grey),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: mode ? Colors.grey : Colors.black,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Icon(
                     Icons.lock_outlined,
                     color: mode ? Colors.white : Colors.black,
                      size: 50,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 275,
                        child: Text(
                          'This account is private',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: mode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 4,),
                      SizedBox(
                        width: 275,
                        child: Text(
                          'Follow this account to see their photos and videos.',
                          style: TextStyle(
                            color: mode ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: mode ? Colors.grey : Colors.black,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: mode ? Colors.grey[800] : Colors.white,
        child: Padding(
          padding: EdgeInsets.only(bottom: 10,),
          child: Row(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.home,
                  color: mode ? Colors.white : Colors.black,
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: mode ? Colors.white : Colors.black,
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: mode ? Colors.white : Colors.black,
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: mode ? Colors.white : Colors.black,
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.person_outline_outlined,
                  color: mode ? Colors.white : Colors.black,
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