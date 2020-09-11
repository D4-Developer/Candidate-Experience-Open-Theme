
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(Homep());
}

var userData;
String title = 'Flutter Code Sample';

/// This Widget is the main application widget.
class Homep extends StatelessWidget {

  //Homep(var u, FirebaseAuth _auth){
  // userData = u;
  // print(userData);
  //}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyState(),
    );
  }
}

/// This Widget is the main application widget.

// stores ExpansionPanel state information
class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

class MyState extends StatefulWidget {

  MyState({Key key}) : super(key: key);

  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyState> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: ',
      style: optionStyle,
    ),
    Container(
      child: profile(),
    )

  ];

  MyStatefulWidgetState();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if(index == 2)
        title="Profile";
      else
        title="Flutter Code Sample";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('.',style: TextStyle(fontSize: 30)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text('.',style: TextStyle(fontSize: 30),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            title: Text('.',style: TextStyle(fontSize: 30)),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.cyan[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class profile extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => profileS();
}
class profileS extends State<profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("profile"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blueGrey[800]),
                      borderRadius: BorderRadius.circular(50)
                  ),
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.only(left: 20),
                  child: Icon(Icons.person,size: 100,color: Colors.blueGrey[500],)
              ),
              Container(
                padding: EdgeInsets.only(right: 100),
                child: Column(
                  children: <Widget>[
                    Text(userData['DisplayName']),
                    Text("Company Name"),
                  ],
                ),
              )
            ],
          ),
          Padding( padding: EdgeInsets.all(10) ),
          tabBar()
        ],
      ),
    );
  }

}

class tabBar extends StatefulWidget {
  @override
  _tabs createState() => _tabs();
}

class _tabs extends State<tabBar> {
  int index = 0;
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (index == 0) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: TabBar(
                unselectedLabelColor: Colors.black45,
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(text: "Personal Details", icon: Icon(Icons.contact_mail)),
                  Tab(text: "Hiring for", icon: Icon(Icons.group_add))
                ],
                onTap: (val) {
                  print("Tapped $val");
                  if ( val != index ) {
                    setState((){
                      index = val;
                    });
                  }
                },
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Card(
                    color: Colors.lightBlue[50],
                    child: ListTile(title: Text('Login - Email :'),subtitle:Text('${userData['Email']}') )
                ),
                Card(
                    color: Colors.lightBlue[50],
                    child: Column(
                        children: [
                          Text('Contact Details :',style: TextStyle(wordSpacing: 5)),
                          ListTile(title: Text('Email :'), subtitle:Text('${userData['Email']}')),
                          ListTile(title: Text('Contact  Number :'), subtitle:Text('${userData['Email']}'), onTap: addNumber,),
                        ]
                    )
                ),

              ],
            ),
          ],
        ),
      );
    }
    else{
      return Container(
        child: Column(
          children: <Widget>[
            DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: TabBar(
                unselectedLabelColor: Colors.black45,
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(text: "Personal Details", icon: Icon(Icons.contact_mail)),
                  Tab(text: "Hiring for",icon: Icon(Icons.group_add))
                ],
                onTap: (val) {
                  print("Tapped $val");
                  if ( val != index )
                    setState((){ index = val; });
                },
              ),
            ),
            Card(
              color: Colors.lightBlue,
              child: Container(
                  child: Text("Hiring for Full Statck Developers")),
            ),
            DropdownButton(
              value: 'Web Developer',
              items: <String>['Web Developer', 'FrontEnd Developer', 'BackEnd Developer', 'Full-Stack Developer']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
            )
          ],
        ),
      );
    }
  }

  addNumber() {
    TextEditingController number = new TextEditingController();
    print(userData['ContactNo']);
    if(userData['ContactNo'])
      return showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                title: Text("Neteork Error. "),
                content: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        autofocus: true,
                        controller: number,
                        keyboardType: TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            prefixText: "+91"
                        ),
                        maxLength: 10,
                        style: TextStyle(fontSize: 20),
                        validator: (String value) {
                          print("vchk");
                          return null;
                        },
                      ),
                      RaisedButton(
                          color: Colors.lightBlue,
                          child: Text("Submit"),
                          onPressed: () { Navigator.of(context).pop(); }
                      )
                    ],
                  ),
                )
            ),
      );
  }
}
