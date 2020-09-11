import 'dart:async';
import 'ResumeRanking.dart';
import '../UIstuff/loadingAnimation.dart';
import '../test/pie_R.dart';
import '../UIstuff/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

Map<String, dynamic> userData;
Map<String, dynamic> temp = Map();
FirebaseAuth auth;
var requirements;
class Homep extends StatelessWidget {

  Homep(var u, FirebaseAuth _auth){
    userData = u;
    auth = _auth;
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    return MyState();
  }
}

class MyState extends StatefulWidget {

  MyState({Key key}) : super(key: key);
  @override
  MyStatefulWidgetState createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyState> {

  int _selectedIndex = 0;
  static  List<Widget> _widgetOptions = <Widget>[
    ResumeRank(userData),
    homePage(),
    ResumeRanking(),
    analysis(),
    ProfilePage(userData, true, true),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('ResumeRanking',style: TextStyle(fontSize: 15)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home',style: TextStyle(fontSize: 15)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Test Result',style: TextStyle(fontSize: 15)),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.poll),
            title: Text('Analysis',style: TextStyle(fontSize: 15),),
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
class ResumeRanking extends StatefulWidget {
  @override
  ResumeRankingState createState() => ResumeRankingState();
}

class ResumeRankingState extends State<ResumeRanking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test Result"),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[900],
        ),
        body:
        SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('candidates')
//            .where('Details.job', isEqualTo: '${userData['Details']['job']}')
//            .where('Details.choice', isEqualTo: '${userData['Details']['choice']}')
//            .where('Details.experience', isEqualTo: '${userData['Details']['experience']}')
//            .where('Details.qualification', isEqualTo: '${userData['Details']['qualification']}')
                  .orderBy('TestResult', descending: true)

//            .where('Details.choice', isEqualTo: '${temp['choice']}')
//            .where('Details.qualification', isEqualTo: '${temp['qualification']}')
//            .where('Details.experience', isEqualTo: '${temp['experience']}')
                  .snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                print(snapshot.hasData);

                if (snapshot.hasError) return Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    {
                      print(snapshot.data.documents.length);
                      List <DocumentSnapshot> documents = snapshot.data.documents;
                      if(snapshot.data.documents.length > 0) {
                        //averageTheTest(snapshot.data.documents);
                        return ListView(
                            controller: ScrollController(),
                            shrinkWrap: true,
                            children: <Widget>[
                              ListTile(
                                title: Text("All Candidates Test Result", textScaleFactor: 1, textAlign: TextAlign.center),
                              ),
                              Container(
//                          height: MediaQuery.of(context).size.height - ,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: documents.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return Card(
                                      color: Colors.blue[50],
                                      child: ListTile(
                                        leading: Icon(Icons.people),
                                        title: Text("${documents.elementAt(index)['DisplayName']}", textScaleFactor: 1),
                                        subtitle: Text("Result = ${documents.elementAt(index)['TestResult']}", textScaleFactor: 1,),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]
                        );
                      }
                      return Center(
                        child: Text("No Candidates"),
                      );
                    }
                }
              }),
        )
    );
  }

  void averageTheTest(List<DocumentSnapshot> documents) async{
    int temp = 0;
    for(int i=0; i<documents.length; i++){
      temp += documents.elementAt(i).data['TestResult'];
    }
    var data = {
      'Total' : temp,
      'TotalUser' : documents.length
    };
    await Firestore.instance.collection('appData').document('TestResult').setData(data);
  }
}
class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  bool isLoaded = false;
  List<charts.Series<BarChartData, String>> series;

  @override
  Widget build(BuildContext context) {

    var streamQuery;
    /*const timeout = const Duration(seconds: 5);
    const ms = const Duration(seconds: 5);
    void handleTimeout() {  // callback function
      print('timer ended');
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Timer Ended')));
    }
    startTimeout([int milliseconds]) {
      var duration = milliseconds == null ? timeout : ms * milliseconds;
      return new Timer(duration, handleTimeout);
    }*/

    if(userData['RChoice'] == 2) {
      print('2');
      streamQuery = Firestore.instance.collection('candidates')
          .where('Details.job', isEqualTo: '${userData['Details']['job']}')
          .where('TechnicalSkills.skills', isEqualTo: userData['TechnicalSkills']);
    }
    else {
      print('1');
          streamQuery = Firestore.instance.collection('candidates'
              '')
          /// watch the whereIn clause:
              .where('Details.job', isEqualTo: '${userData['Details']['job']}')
              .where('Details.experience', isEqualTo: '${userData['Details']['experience']}')
              .where('TechnicalSkills.skill', isEqualTo: userData['TechnicalSkills']);
          print("in first choice");
        }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        automaticallyImplyLeading: false,
        title: Text("Explore"),
      ),
      body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: streamQuery
            /// getting error in orderBy('', );
//            .orderBy('TestResult', descending: true)
              .snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              print('build');
              print(snapshot.hasData);

              if (snapshot.hasError) return Text('${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  {
                    print(snapshot.data.documents.length);
                    List <DocumentSnapshot> documents = snapshot.data.documents;
                    if(snapshot.data.documents.length > 0) {
                      return ListView(
                        children: <Widget>[
                          ListTile(
                            title: Text("Candidates Based On Your Requirements", textAlign: TextAlign.center, textScaleFactor: 1),
                          ),
                          ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, index) {
                              return Card(
                                color: Colors.blue[50],
                                child: ListTile(
                                  leading: Icon(Icons.people),
                                  title: Text("${documents.elementAt(index)['DisplayName']}"),
                                //  subtitle: Text("Looking for : ${documents.elementAt(index)['Details']['choice']}"),
                                  onTap: () async{

                                    if(documents.elementAt(index)['isGivenTest']) {
                                      loadingAnimation(context, "Getting UserProfile...");
                                      DocumentReference ds = userData['appData'];
                                      await ds.get().then((DocumentSnapshot DS) async {
                                        var average = DS['Total'] / DS['TotalUser'];
                                        print(" total average = $average");
                                        final List<BarChartData> dataA = [
                                          BarChartData("Average - score",
                                              charts.ColorUtil.fromDartColor(Colors.blueAccent),
                                              average),
                                          BarChartData("${documents.elementAt(index)['DisplayName']}'s score",
                                              charts.ColorUtil.fromDartColor(Colors.pinkAccent),
                                              documents.elementAt(index)['TestResult']),
                                        ];

                                        series = [
                                          charts.Series(
                                              data: dataA,
                                              id: 'Average - score',
                                              domainFn: (BarChartData series,_) => series.title,
                                              measureFn: (BarChartData series,_) => series.result,
                                              colorFn: (BarChartData series,_) => series.barColor,
                                              labelAccessorFn: (BarChartData series,_) =>
                                                '${series.result.toStringAsPrecision(4)}'
                                          )
                                        ];
                                      });
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder:
                                          (BuildContext context) => ProfilePage(documents.elementAt(index), false, false, series)
                                      ));
                                    }//
                                    else{
                                      Navigator.push(context, MaterialPageRoute(builder:
                                          (BuildContext context) => ProfilePage(documents.elementAt(index), false, false)
                                      ));
                                    }// await AppData Collection
                                  },
                                ),
                              );
                            },
                          ),
                        ]
                      );
                    }
                    return Center(
                      child: Text("No Candidates", textScaleFactor: 1,),
                    );
                  }
              }
            }),
        )
    );
  }

}

class analysis extends StatefulWidget {
  @override
  _analysisState createState() => _analysisState();
}

class _analysisState extends State<analysis> {
  bool isLoaded = false;
  List<charts.Series<BarChartData, String>> series;

  @override
  Widget build(BuildContext context) {

    if(!isLoaded)analysisNeed();
    return isLoaded ? BarChart(series) : Center(child: CircularProgressIndicator());
  }

  void analysisNeed() async{

    DocumentReference ds = userData['appData'];
    await ds.get().then((DocumentSnapshot DS) async{

      var average = DS['Total']/DS['TotalUser'];
      print(" total average = $average");

      Firestore.instance.collection('candidates')
          .where('Details.job', isEqualTo: '${userData['Details']['job']}')
          .where('isGivenTest', isEqualTo: true)
          .snapshots().listen((requirementSnapshot) {

        print('= length ${requirementSnapshot.documents.length}');
        int requirementTotal = 0, requirementUser = requirementSnapshot.documents.length;
        for(int i=0; i<requirementSnapshot.documents.length; i++){
          requirementTotal += requirementSnapshot.documents.elementAt(i).data['TestResult'];
          //print(requirementSnapshot.documents.elementAt(i).data['TestResult']);
        }
        if(requirementSnapshot.documents.length == 0) {
          requirementUser = 1;
//          print(requirementTotal/requirementUser);
        }
        final List<BarChartData> dataA = [
          BarChartData("Average - score", charts.ColorUtil.fromDartColor(Colors.blueAccent) ,average),
          BarChartData("${userData['Details']['job']}'s Average score", charts.ColorUtil.fromDartColor(Colors.pinkAccent) ,requirementTotal/requirementUser),
        ];

        series = [
          charts.Series(
              data: dataA,
              id: 'Average - score',
              domainFn: (BarChartData series, _) => series.title,
              measureFn: (BarChartData series, _) => series.result,
              colorFn: (BarChartData series, _) => series.barColor,
              labelAccessorFn: (BarChartData series, _) => '${series.result.toStringAsPrecision(4)}'
          )
        ];
        setState(() => isLoaded = true );
//        Navigator.of(context).push(MaterialPageRoute(builder: (_) => subcharts(series)));
        print(requirementTotal/requirementUser);

       });

    });
  }
}

/* class MyProfile extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MyProfileS();
}
class MyProfileS extends State<MyProfile> {

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        appBar: AppBar(
          title: Text("profile"),
          backgroundColor: Colors.blue[900],
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
                          child: Icon(Icons.person,size: 100,color: Colors.blueGrey[500])
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 100),
                        child: Column(
                          children: <Widget>[
                            Text(userData['DisplayName']),
                            Text(userData['CompanyName']),
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding( padding: EdgeInsets.all(10) ),
                  tabBar()
                ],
              ),
            ]));
  }

}

class tabBar extends StatefulWidget {

  @override
  _tabs createState() => _tabs();
}

class _tabs extends State<tabBar> {
  int index = 0;
  final _formKey = GlobalKey<FormState>();
  final List<String> choices = ['Internship', 'Job'];
  final List<String> jobs = ['FrontEnd Developer', 'BackEnd Developer', 'Full-Stack Developer', 'Software Engineer'];
  final List<String> qualifications = <String> ['Not Needed', 'Diploma Graduate', 'Bachelor Degree', 'Master Degree'];
  final List<String> experience = <String> ['No Experience Needed', '6 Month', '1 Year', '2 Year', 'More than 2 Years', 'Any'];

  @override
  void initState(){
    super.initState();
    if(userData['Details']!=null){
//      print("in Not eqauls to null");
      temp['choice'] = userData['Details']['choice'];
      temp['job'] = userData['Details']['job'];
      temp['qualification'] = userData['Details']['qualification'];
      temp['experience'] = userData['Details']['experience'];
//      print("printing = ${temp['qualification']}");
    }

    temp['choice'] = temp['choice'] == null ? null : temp['choice'];
    temp['qualification'] = temp['qualification'] == null ? null: temp['qualification'];
    temp['experience'] = temp['experience'] == null ? null : temp['experience'];
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
                  Tab(text: "Hiring for", icon: Icon(Icons.group_add))
                ],
                onTap: (val) {
//                  print("Tapped $val");
                  if ( val != index )
                    setState(() => index = val );
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
                    Navigator.pop(context);
                  }
                )
              ],
            ),
          ],
        ),
      );
    }
    else{
      return
        Container(
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
                  Tab(text: "Hiring for",icon: Icon(Icons.group_add))
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
                    title: Text("Hiring for ${temp['choice']}")
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
                showDialog(
                  context: context,
                  builder: (context) => Center(child: CircularProgressIndicator())
                );
                print("Submit Pressed");
                userData['Details']['job'] = temp['job'];
                userData['Details']['choice'] = temp['choice'];
                userData['Details']['experience'] = temp['experience'];
                userData['Details']['qualification'] = temp['qualification'];
                requirementOption();
                var data = {
                  'DetailsAdded': true,
                  'Details': {
                    'job': temp['job'],
                    'choice': temp['choice'],
                    'experience': temp['experience'],
                    'qualification': temp['qualification'],
                  },
                  'RChoice': userData['RChoice'],
                };
                print("await = ${userData['RChoice']}");
                await Firestore.instance.collection('firmUser')
                  .document(userData['UID']).updateData(data);
//                DocumentSnapshot doc = await Firestore.instance.collection('firmUser').document(userData['UID']).get();
//                userData = doc.data;
//                print(userData);
//                homePage().createElement().build();
                print('Details Updated');
                Navigator.pop(context);
                Scaffold.of(context).showSnackBar(SnackBar(content: Text(' Details Saved ')));
              },
            )
          ],
        ),
      );
    }
    return PageView(); /// To Make Swipeable Like Instagram Profile Page....
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
                              keyboardType: TextInputType.numberWithOptions(),
                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              autofocus: true,
                              controller: number,
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
                                  setState((){});
                                  await Firestore.instance.collection('firmUser').document(userData['UID']).updateData(data);
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
  void requirementOption() {
    var ch = userData['Details'].values;

    print(ch);
//    print(ch.contains("Not Needed") && ch.contains("No Experience Needed"));
    if(ch.contains("No Experience Needed"))
      userData['RChoice'] = 2;
    else
      userData['RChoice'] = 1;
    print(userData['RChoice']);
  }
}
*/
//}

