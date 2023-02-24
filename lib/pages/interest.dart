import 'package:flutter/material.dart';
import 'package:socialize/pages/scroll.dart';

class ChooseInterest extends StatefulWidget {
  const ChooseInterest({Key? key}) : super(key: key);

  @override
  State<ChooseInterest> createState() => _ChooseInterestState();
}

class _ChooseInterestState extends State<ChooseInterest> {
  List<Scroll> interests=[
    Scroll("Acting", false),
    Scroll("Agriculture", false),
    Scroll("Animals", false),
    Scroll("Astronomy",false),
    Scroll("Books",false),
    Scroll("Business",false),
    Scroll("Cinematography",false),
    Scroll("Cooking",false),
    Scroll("Dancing",false),
    Scroll("Directory",false),
    Scroll("Drawing",false),
    Scroll("Food",false),
    Scroll("Gaming",false),
    Scroll("Movies",false),
    Scroll("Philosophy",false),
    Scroll("Photography",false),
    Scroll("Science",false),
    Scroll("Songs",false),
    Scroll("Sports",false),
    Scroll("Technology",false),
    Scroll("Vlogs",false),
  ];

  List<Scroll> selectedInterests =  [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Image(
                  height: 40,
                  image: AssetImage('images/logo.png'),
                ),
              ),
            ),
            Text(
              'Socialize',
              style: TextStyle(
                fontFamily: 'Lobster',
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
                SizedBox(
                  width: 350,
                  child: Text(
                    'Choose your interests',
                    style: TextStyle(
                      color: Colors.grey[800],
                      letterSpacing: 1.5,
                      fontFamily: 'Dosis',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                  ),
                ),
                SizedBox(
                  height: 600,
                  child: Container(
                    child: ListView.builder(
                      itemCount: interests.length,
                      itemBuilder: (BuildContext context,int index) {
                        return ContactItem(interests[index].name, interests[index].isSelected,index,);
                      }
                    ),
                  ),
                ),
                SizedBox(
                  width: 350,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.teal[400]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

  Widget ContactItem(String name, bool isSelected, int index){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {  },
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          trailing: isSelected ?
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.check_circle,
              color: Colors.blue,
            ),
          ) :
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.grey,
            ),
          ),
          onTap: (){
            setState(() {
              interests[index].isSelected = !interests[index].isSelected;
              if(interests[index].isSelected == true){
                selectedInterests.add(Scroll(name, true));
              }
              else{
                selectedInterests.removeWhere((element) => element.name == interests[index].name);
              }
            });
          },
        ),
      ),
    );
  }
}