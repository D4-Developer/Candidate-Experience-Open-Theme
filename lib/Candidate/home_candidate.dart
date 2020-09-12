import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../test/aptitudeTest.dart';
import '../test/pie_R.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../UIstuff/profilePage.dart';
import '../test/personality.dart';
Map<String, dynamic> userData;
Map<String, dynamic> temp = Map();
bool averageFlag = true;

FirebaseAuth auth;

class homeCandidate extends StatefulWidget {

  homeCandidate(var u, FirebaseAuth _auth) {
    userData = u;
    auth = _auth;
  }

  @override
  _homeC createState() => _homeC();
}

class _homeC extends State<homeCandidate> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static  List<Widget> _widgetOptions = <Widget>[
    Personality(),
    testPage(),
    ProfilePage(userData, false, true)

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context0) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async{
          showDialog(context: context,
              child: AlertDialog(
                title: Text("Are you sure to Log out from the app?"),
                actions: <Widget>[
                  RaisedButton(
                    shape: StadiumBorder(),
                    child: Text(" No "),
                    color: Colors.red[800],
                    onPressed: () => Navigator.pop(context),
                  ),
                  RaisedButton(
                    shape: StadiumBorder(),
                    child: Text(" Yes "),
                    color: Colors.blue[800],
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          );
          return false;
        },
        child: SafeArea(
          child: _widgetOptions.elementAt(_selectedIndex)
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Personality Test',style: TextStyle(fontSize: 15)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Aptitude Test',style: TextStyle(fontSize: 15)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile',style: TextStyle(fontSize: 15)),
          ),
        ],
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.blue[100],
      ),
    );
  }
}

class Personality extends StatefulWidget {
  @override
  _PersonalityState createState() => _PersonalityState();
}

class _PersonalityState extends State<Personality> {

  @override
  Widget build (BuildContext context) {
    print(userData['isGivenPersonality']);
    return FutureBuilder(
      future: Firestore.instance.collection('candidates').document(userData['UID']).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> ds){
        if(ds.connectionState == ConnectionState.waiting)
          return PersonalityTest(userData);
        else if(ds.connectionState == ConnectionState.done){
//          var u = ds.data.data;
//          print(u);
          userData = ds.data.data;
          return PersonalityTest(userData);
        }
        return PersonalityTest(userData);
      },
    );
  }
}

class testPage extends StatefulWidget {
  @override
  _testPageState createState() => _testPageState();
}
class _testPageState extends State<testPage> {
  int total,users;

  Future<void> progressIndicator() async {
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (context) =>
          Container(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                ],
              )
          ),
    );

    Future.delayed(const Duration(seconds: 1), () async {
      print(averageFlag);
      final List<BarChartData> dataA = [
        BarChartData("Your - score", charts.ColorUtil.fromDartColor(Colors.blueAccent) ,userData['TestResult'])
      ];

      List<charts.Series<BarChartData, String>> series =
      [
        charts.Series(
            data: dataA,
            id: 'Average - score',
            domainFn: (BarChartData series, _) => series.title,
            measureFn: (BarChartData series, _) => series.result,
            colorFn: (BarChartData series, _) => series.barColor,
            labelAccessorFn: (BarChartData series, _) => '${series.result.toStringAsPrecision(4)}'
        ),
      ];
      if(averageFlag || total==null || users==null) {
        DocumentReference ds = userData['appData'];
        await ds.get().then((DocumentSnapshot ds) {
          print(ds['Total']);
          total = ds['Total'];
          users = ds['TotalUser'];
          dataA.add(BarChartData("Average - score", charts.ColorUtil.fromDartColor(Colors.pinkAccent), (total/users)));

          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return pieCharts(series, userData['TestResult'].toDouble());}));
        });
        averageFlag = !averageFlag;
      }
      else {
        dataA.add(BarChartData("Average - score", charts.ColorUtil.fromDartColor(Colors.pinkAccent), (total/users)));
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return pieCharts(series, userData['TestResult'].toDouble());
        }));
      }
    });

  }// pro
  ValueNotifier vs = ValueNotifier(userData);// gressIndicator

  @override
  Widget build(BuildContext context) {
//    StreamBuilder(
//      stream: Firestore.instance.collection('candidates').document(userData['UID']).snapshots(),
//      builder: (context, AsyncSnapshot<DocumentSnapshot> ds){
//        if(ds.connectionState == ConnectionState.waiting)
//          return Container();
//        else if(ds.connectionState == ConnectionState.done){
////          var u = ds.data.data;
////          print(u);
//          userData = ds.data.data;
//          print(ds.data.data);
//          vs.value = ds.data.data;
//          return Container();
//        }
//        return Container();
//      },
//    );

    Stream<DocumentSnapshot> sds = Firestore.instance.collection('candidates').document(userData['UID']).snapshots();
    sds.listen((event) {
      userData = event.data;
      if(userData != event.data)
        setState(() {
          vs.value = event.data;
        });
      vs.value = event.data;
    });
    return checkStatus();
//    if(userData['isGivenTest'] || userData['isStarted'])
//      return Scaffold(
//        appBar: AppBar(
//          title: Text("Aptitude Test"),
//          automaticallyImplyLeading: false,
//          backgroundColor: Colors.blue[900],
//        ),
//        body: Card(
//          color: Colors.cyan[100],
//          child: ListView(
//            children: <Widget>[
//              ListTile(
//                title: Text("You Already Given The Test")
//              ),
//              ListTile(
//                title: Text("Result = ${userData['TestResult']}")
//              ),
//              RaisedButton(
//                color: Colors.cyan[300],
//                child: Text("Tap To See The Analysis Of Your Test"),
//                onPressed: progressIndicator
//              )
//            ],
//          ),
//        ),
//      );
//    else if(userData['isStarted'] == false)
//      return Scaffold(
//        appBar: AppBar(
//          automaticallyImplyLeading: false,
//          title: Text('Aptitude Test Page'),
//          backgroundColor: Colors.blue[900],
//        ),
//        body: Card(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(20),
//                child: Text('You have not given the Aptitude test.\nTo start the test first read the rules and then press below button.')
//              ),
//              ListTile(
//                title: Text('Rules :'),
//                subtitle :Text('The Test will contain 25 question.\nEach have 1 mark.'
//                   '\nYou can give the test only 1 time.\nYou have 30 minutes to complete it.'
//                ),
//              ),
//              Padding(padding: EdgeInsets.all(20)),
//              RaisedButton(
//                color: Colors.blue[900],
//                textColor: Colors.blue[100],
//                shape: StadiumBorder(),
//                child: Text('START APTITUDE TEST'),
//                onPressed: () async{
//                  DocumentReference dr = Firestore.instance.collection('appData').document('TestResult');
//                  var data = {
//                    'appData' : dr,
//                    'TestResult': 0,
//                    'isStarted': true,
//                  };
//                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AptitudeTest(auth, userData)));
//                  userData['isStarted'] = true;
//                  userData['TestResult'] = 0;
//                  userData['appData'] = dr;
//                  await Firestore.instance.collection('candidates').document(userData['UID']).updateData(data);
//                },
//              )
//            ],
//          ),
//        ),
//      );
  }

  checkStatus(){
    return ValueListenableBuilder(
      valueListenable: vs,
      builder: (BuildContext, newData, child){
        if(newData['isGivenTest'] || newData['isStarted'])
          return Scaffold(
            appBar: AppBar(
              title: Text("Aptitude Test"),
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue[900],
            ),
            body: Card(
              color: Colors.cyan[100],
              child: ListView(
                children: <Widget>[
                  ListTile(
                      title: Text("You Already Given The Test")
                  ),
                  ListTile(
                      title: Text("Result = ${userData['TestResult']}")
                  ),
                  RaisedButton(
                      color: Colors.cyan[300],
                      child: Text("Tap To See The Analysis Of Your Test"),
                      onPressed: progressIndicator
                  )
                ],
              ),
            ),
          );
        else if(newData['isStarted'] == false)
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text('Aptitude Test Page'),
              backgroundColor: Colors.blue[900],
            ),
            body: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(20),
                      child: Text('You have not given the Aptitude test.\nTo start the test first read the rules and then press below button.')
                  ),
                  ListTile(
                    title: Text('Rules :'),
                    subtitle :Text('The Test will contain 25 question.\nEach have 1 mark.'
                        '\nYou can give the test only 1 time.\nYou have 30 minutes to complete it.'
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  RaisedButton(
                    color: Colors.blue[900],
                    textColor: Colors.blue[100],
                    shape: StadiumBorder(),
                    child: Text('START APTITUDE TEST'),
                    onPressed: () async{
                      var data = {
                        'TestResult': 0,
                        'isStarted': true,
                      };
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> AptitudeTest(auth, userData)));
                      userData['isStarted'] = true;
                      userData['TestResult'] = 0;
                      await Firestore.instance.collection('candidates').document(userData['UID']).updateData(data);
                    },
                  )
                ],
              ),
            ),
          // ignore: missing_return, missing_return
          );
        print("Something went wrong");
          return Container();
      }
    );
  }
}

/*
class MyProfile extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MyProfileS();
}

class MyProfileS extends State<MyProfile> {

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        appBar: AppBar(
          title: Text("profile"),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Column(
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
                  tabBar_P()
                ],
              ),
            ]));
  }
}

class tabBar_P extends StatefulWidget {

  @override
  _tabs_P createState() => _tabs_P();
}

class _tabs_P extends State<tabBar_P> {
  int index = 0;
  final _formKey = GlobalKey<FormState>();

  final List<String> choices = ['Internship', 'Job'];
  final List<String> jobs = ['FrontEnd Developer', 'BackEnd Developer', 'Full-Stack Developer', 'Software Engineer'];
  final List<String> qualifications = ['Diploma Graduate', 'Bachelor Degree ', 'Master Degree'];
  final List<String> stream = ['Computer Engineering', 'Computer Science', 'Information Technology'];
  final List<String> experience = ['No Experience', '6 Month', '1 Year', '2 Year', 'More than 2 Years'];

  void initState(){
    super.initState();
    if(userData['Details']!=null){
      temp['choice'] = userData['Details']['choice'];
      temp['job'] = userData['Details']['job'];
      temp['qualification'] = userData['Details']['qualification'];
      temp['stream'] = userData['Details']['stream'];
      temp['experience'] = userData['qualification'];
    }

    temp['choice'] = temp['choice'] == null ? null : temp['choice'];
    temp['job'] = temp['job'] == null ? null : temp['job'];
    temp['qualification'] = temp['qualification'] == null ? null: temp['qualification'];
    temp['stream'] = temp['stream'] == null ? null: temp['stream'];
    temp['experience'] = temp['experience'] == null ? null : temp['experience'];

*/
/*
    temp['choice'] = userData['Details'][0] == null ? null: userData['Details'][0];
    temp['qualification'] = userData['Details'][1] == null ? null: userData['Details'][1];
    temp['stream'] = userData['Details'][2] == null ? null: userData['Details'][2];
    temp['experience'] = userData['Details'][3] == null ? null: userData['Details'][3];
    print("temp = ");
    print(temp );

    temp['choice'] = temp['choice'] == null ? null : temp['choice'];
    temp['qualification'] = temp['qualification'] == null ? null: temp['qualification'];
    temp['stream'] = temp['stream'] == null ? null: temp['stream'];
    temp['experience'] = temp['experience'] == null ? null : temp['experience'];
*//*


//    print(userData['Details']['qualification']);
////    print(userData['Details']['stream']);
////    print(userData['Details']['choice']);
////    print(userData['Details']['job']);
  }

  @override
  Widget build(BuildContext context2) {
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
                  Tab(text: "Looking for", icon: Icon(Icons.group_add))
                ],
                onTap: (val) {
//                  print("Tapped $val");
                  if ( val != index ) {
                    setState((){
                      index = val;
                    });
                  }
                },
              ),
            ),
            ListView(
              physics: ClampingScrollPhysics(),
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
                          ListTile(title: Text('Contact  Number :'), subtitle:Text('${userData['ContactNo']}'), onTap: addNumber ),
                        ]
                    )
                ),
                RaisedButton(
                    child: Text(" LogOut "),
                    onPressed: ()async {
                      await auth.signOut();
                      print("Successfully Logout....");
//                      this.dispose();
                      Navigator.pop(context);
                      averageFlag = true;// for another session we have to fetch average of all user TestResult
                    }
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: TabBar(
                unselectedLabelColor: Colors.black45,
                labelColor: Colors.black,
                tabs: <Widget>[
                  Tab(text: "Personal Details", icon: Icon(Icons.contact_mail)),
                  Tab(text: "Looking for",icon: Icon(Icons.group_add))
                ],
                onTap: (val) {
//                  print("Tapped $val");
                  if ( val != index )
                    setState((){ index = val; });
                },
              ),
            ),
            Card(
              color: Colors.lightBlue[50],
              child: Center(
                child: ListTile(
                    title: Text("I'm Looking for ${temp['choice']}")
                ),
              ),
            ),
            DropdownButton <String> (
              value: temp['choice'],
              items: choices.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('$item'), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return choices.map<Widget>((String item) {
                  return Text(item); }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['choice'] = selection; });
              },
              isExpanded: true,
            ),
            DropdownButton <String> (
              value: temp['job'],
              items: jobs.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('$item'), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return jobs.map<Widget>((String item) {
                  return Text(item); }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['job'] = selection; });
              },
              isExpanded: true,
            ),
            DropdownButton <String> (
              value: temp['qualification'],
              items: qualifications.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('$item'), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return qualifications.map<Widget>((String item) {
                  return Text(item); }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['qualification'] = selection; });
              },
              isExpanded: true,
            ),
            DropdownButton <String> (
              value: temp['stream'],
              items: stream.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('$item'), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return stream.map<Widget>((String item) {
                  return Text(item); }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['stream'] = selection; });
              },
              isExpanded: true,
            ),
            DropdownButton <String> (
              value: temp['experience'],
              items: experience.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('$item'), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return experience.map<Widget>((String item) {
                  return Text(item); }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['experience'] = selection; });
              },
              isExpanded: true,
            ),
            RaisedButton(
              color: Colors.blueAccent,
              child: Text(" Save "),
              disabledColor: Colors.blueGrey,
              onPressed: () async{
//                print(" Submit Pressed ");

                var data = {
                  'DetailsAdded': true,
                  'Details': {
                    'choice': temp['choice'],
                    'job': temp['job'],
                    'qualification': temp['qualification'],
                    'stream': temp['stream'],
                    'experience': temp['experience'],
                  }
                };
                await Firestore.instance.collection('candidates')
                    .document(userData['UID']).updateData(data);
                print('Details Updated');
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(' Details Saved ')));
              },
            )
          ],
        ),
      );
    }
  }

  addNumber() {
    TextEditingController number = new TextEditingController();
//    if(userData['ContactNo'] == null) {
      return showDialog(
          context: context,
          builder: (context) =>
              Container(
                  child: AlertDialog(
                    title: Text("Type to add contact no."),
                    content: Container(
                        width: 200,
                        height: 130,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                autofocus: true,
                                controller: number,
                                keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                                inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixText: "+91"
                                ),
                                maxLength: 10,
                                style: TextStyle(fontSize: 20),
                                validator: (value) {
                                  final List<int> v = value.codeUnits;
                                  if(value.length < 10){
                                    number.clear();
                                    print('1');
                                    return 'Please enter complete conatact no';
                                  }
                                  else if(v[0] == 48 || v[0] == 49 || v[0] == 50 || v[0] == 51 || v[0] == 52 || v[0] == 53){
                                    number.clear();
                                    print('2');
                                    return 'Enter Correct Contact No';
                                  }
                                  else
                                    return null;
                                },
                              ),
                              RaisedButton(
                                color: Colors.lightBlue,
                                child: Text("Save"),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    userData['ContactNo'] = "+91 " + number.text.substring(0,5) + " " + number.text.substring(5,10);
                                    Navigator.of(context).pop();
                                    var data = {'ContactNo' : userData['ContactNo']};
                                    await Firestore.instance.collection('candidates').document(userData['UID']).updateData(data);
                                    setState((){});
                                  }
                                }
                              )
                            ],
                          ),
                        )
                    ),
                  )
              ));
//    }
  }
}*/
