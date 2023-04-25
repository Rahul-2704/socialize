import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialize/widgets/suggestion_card.dart';
import 'accountPage.dart';
import 'globals.dart';

class SuggestionPage extends StatefulWidget {
  const SuggestionPage({Key? key}) : super(key: key);

  @override
  State<SuggestionPage> createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mode ? Colors.grey[900] : Colors.white,
        iconTheme: IconThemeData(
          color: !mode ? Colors.black : Colors.white,
        ),
        title: Text(
          'Suggestions',
          style: TextStyle(
            color: !mode ? Colors.black : Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            return Container(
              color: mode ? Colors.grey[900] : Colors.white,
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyAccount(id:(snapshot.data! as dynamic).docs[index]['id']),
                          )
                      );
                    },
                    child: SuggestedUsers(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  );
                },
              ),
            );
          }
      ),
    );
  }
}