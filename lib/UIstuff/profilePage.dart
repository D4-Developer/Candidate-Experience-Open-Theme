import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../test/pie_R.dart';
import '../forms/Data.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../HR_Manager/home_HR-Manager.dart';
import 'package:flutter/services.dart';

//final _formKey = GlobalKey<FormState>();
TextEditingController textE = TextEditingController();
Map<String, dynamic> temp = Map();
PageController pageController = PageController(
  initialPage: 0,
  keepPage: true,
);
var width, height;

class ProfilePage extends StatefulWidget {
  final List<charts.Series<BarChartData, String>> series;
  final profileData, isEditable, isManager;
  ProfilePage(this.profileData, this.isManager, [this.isEditable = false, this.series]);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextStyle pageStyle = TextStyle(
    color: Colors.blue[100],
    fontFamily: 'Times New Roman',
    fontSize: 20,
  );
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    print(widget.profileData['CompanyAddress']);
    // print(widget.isEditable);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.blue[50],
            child: CustomScrollView(
              controller: ScrollController(),
              physics: ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
            automaticallyImplyLeading: !widget.isEditable,
                  backgroundColor: Colors.transparent,
//            pinned: true,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset('assets/ss.jpg'),
                  ),
                  expandedHeight: height/3,
//            floating: true,
                  title: Text('${widget.profileData['DisplayName']}'),
                ),
                SliverList(

                  delegate: SliverChildListDelegate([
                    ListTile(
                      leading: Icon(Icons.email),
                      contentPadding: EdgeInsets.fromLTRB(width/15, 0,width/15,0),
                      title: Text('Email : ${widget.profileData['Email']}', style: TextStyle(color: Colors.blue[900]),),
                    ),
                    ListTile(
                      leading: Icon(Icons.call),
                      contentPadding: EdgeInsets.fromLTRB(width/15, 0,width/15,0),
                      title: Text('Contact NO : ${widget.profileData['Contact Number']}', style: TextStyle(color: Colors.blue[900]),),
                      trailing: widget.isEditable ? Icon(Icons.edit) : null,
                    ),
                    if(widget.isManager)ListTile(
                      leading: Icon(Icons.business),
                      contentPadding: EdgeInsets.fromLTRB(width/15, 0,width/15,0),
                      title: Text('Company Name : ${widget.profileData['CompanyName']}', style: TextStyle(color: Colors.blue[900]),),
                      trailing: widget.isEditable ? Icon(Icons.edit) : null,
                    ),
                    if(widget.isManager)ListTile(
                      leading: Icon(Icons.business),
                      contentPadding: EdgeInsets.fromLTRB(width/15, 0,width/15,0),
                      title: Text('Company Address :', style: TextStyle(color: Colors.blue[900]),),
                      subtitle: Text("${widget.profileData['CompanyAddress']}"),
                      trailing: widget.isEditable ? Icon(Icons.edit) : null,
                    ),
                    if(!widget.isManager && widget.isEditable)
                      CandidateThings(widget.profileData),
                    if(widget.series != null)
                      graphicalR(widget.series), /// graphical of userResult && averageResult....
                    if(widget.isManager)
                      ManagerThings(widget.profileData),
                    if(!widget.isManager)
                      Container(
                      padding: EdgeInsets.fromLTRB( 0, 20, 0, 30),
                      child: SizedBox(
                        width: width,
                        height: height/3.5,
                        child: PageView(
                          pageSnapping: false,
                          controller: pageController,
                          children: <Widget>[
                            skillPage(),
                            educationPage(),
                            projectsPage()
                          ],
                        ),
                      ),
                    ),
                    widget.isEditable ? Center(
                      child: RaisedButton(
                        color: Colors.redAccent,
                        shape: StadiumBorder(),
                        onPressed: () async{
                          showDialog(context: context,
                              child: AlertDialog(
                                title: Text("Are you sure to Log out from the app?"),
                                actions: <Widget>[
                                  RaisedButton(
                                    shape: StadiumBorder(),
                                    child: Text(" No "),
                                    color: Colors.red[700],
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  RaisedButton(
                                    shape: StadiumBorder(),
                                    child: Text(" Yes "),
                                    color: Colors.blue[800],
                                    onPressed: () {
                                      _auth.signOut();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              )
                          );
                        },
                        child: Container(
                          width: width/3,
                          height: 35,
                          child: Center(
                            child: Text("Log  out", textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                    ) : Container(),
                  ]),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget skillPage() {
    return Card(
      color: Colors.blue[900],
      shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[900]),
          borderRadius: BorderRadius.circular(25)
      ),
      margin: EdgeInsets.fromLTRB(width/14, 0, width/14, 0),
      child: ListView(
        controller: ScrollController(),
        children: <Widget>[
          ListTile(
            title: Text('Skills', style: pageStyle, textAlign: TextAlign.center, textScaleFactor: 1),
            trailing: widget.isEditable ? Icon(Icons.edit) : null,
          ),
          ListTile(
            title: Text('${widget.profileData['TechnicalSkills']} ', style: pageStyle),
          )
        ],
      ),
    );
  }

  Widget educationPage() {
    print(widget.profileData['Details']);
    return Card(
      color: Colors.blue[600],
      shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[600]),
          borderRadius: BorderRadius.circular(25)
      ),
      margin: EdgeInsets.fromLTRB(width/14, 0, width/14, 0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Education', style: pageStyle, textAlign: TextAlign.center, textScaleFactor: 1),
            trailing: widget.isEditable ? Icon(Icons.edit) : null,
          ),
          ListTile(
//            subtitle: Text('${widget.profileData['Details']['experience']}'),
            title: widget.profileData['Details']['education'] == null ? null :
            Text('${widget.profileData['Details']['education']}'),
          )
        ],
      ),
    );
  }

  Widget projectsPage() {
    return Card(
      color: Colors.blue[300],
      shape: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue[300]),
          borderRadius: BorderRadius.circular(25)
      ),
      margin: EdgeInsets.fromLTRB(width/14, 0, width/14, 0),
      child: Column(
          children: <Widget> [
            ListTile(
              title: Text('Projects', textScaleFactor: 1, style: pageStyle, textAlign: TextAlign.center,),
              trailing: widget.isEditable ? Icon(Icons.edit) : null,
            ),
            ListTile(
              title: Container(
                width: width - width/10,
                height: height/5.5,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: widget.profileData['Projects'].length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Text(' -  ${widget.profileData['Projects'][index]}', style: pageStyle,),
                      );
                    }
                ),
              ),
            )
          ]
      ),
    );
  }

  Widget graphicalR(List<charts.Series<BarChartData, String>> series) {
    print(series);
    if(series != null) {
      return Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.assessment),
            contentPadding: EdgeInsets.fromLTRB(width/15, 0,width/15,0),
            title: Text("Analysis of ${widget.profileData['DisplayName']}'s Aptitude test",
              style: TextStyle(
                color: Colors.blue[900],
//                  fontSize: 18
              ),
              textScaleFactor: 1,
//                textAlign: TextAlign.center,
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(width/16, 0, width/16, 0),
            title: BarChart(series),
          ),
        ],
      );
    }
    return Container();
  }

}

Color formColor = Colors.cyan[800], radioBG = Color.fromRGBO(0, 131, 143, .2);
TextStyle formStyle = TextStyle(
    color: Colors.cyan[800],
    fontSize: 17,
    fontWeight: FontWeight.bold,
    fontFamily: 'Times New Roman');
class ManagerThings extends StatefulWidget {
  final userData;
  List skillTypes = [];
  List<bool> skillBox = [];
  List skillsNeeded = [];

  ManagerThings(this.userData);
  @override
  _ManagerThingsState createState() => _ManagerThingsState();
}

class _ManagerThingsState extends State<ManagerThings> {
  double expansion = 6;
  String added = 'null';
  final List<String> jobs = ['Android Developer', 'IOS Developer', 'Flutter Developer',
    'FrontEnd Developer', 'BackEnd Developer', 'Full-Stack Developer',
    'Software Engineer',
  ];
  final List<String> qualifications = <String> ['Not Needed', 'Diploma Graduate', 'Bachelor Degree', 'Master Degree'];
  final List<String> experience = <String> ['No Experience Needed', '6 Month', '1 Year', '2 Year', 'More than 2 Years', 'Any'];

  @override
  void initState(){
    super.initState();
    if(widget.userData['Details']!=null){
//      print("in Not Equals to null");
      temp['job'] = widget.userData['Details']['job'];
      temp['qualification'] = widget.userData['Details']['qualification'];
      temp['experience'] = widget.userData['Details']['experience'];
//      print("printing = ${temp['qualification']}");
    }
    temp['choice'] = temp['choice'] == null ? null : temp['choice'];
    temp['qualification'] = temp['qualification'] == null ? null: temp['qualification'];
    temp['experience'] = temp['experience'] == null ? null : temp['experience'];
    temp['SkillsNeeded'] = temp['SkillsNeeded'] == null ? null : temp['SkillsNeeded'];
    getSkillsTypes(temp['job']);
//    widget.skillTypes= [];
    widget.skillsNeeded = temp['SkillsNeeded'];
    widget.skillBox = List(widget.skillTypes.length);
    widget.skillBox = widget.skillBox.expand((i)=> [false]).toList();
//    setState((){ temp['job'] = selection; });

  }

  void getSkillsTypes(String match) {
    widget.skillTypes.clear();
    widget.skillTypes = List.from(widget.skillTypes)..addAll(skillsByRole.map((map) => SkillModel.fromJson(map))
        .where((object) => object.job == match)
        .map((object) => object.skills)
        .expand((i) => i)
        .toList());

    var l = widget.skillTypes.length;
    print("$l --");
    if(l > 8)
      expansion = 2.5;
    else if(l > 6)
      expansion = 4;
    else if(l > 4)
      expansion = 5;
    else
      expansion = 7;
//    print(widget.skillTypes.length);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
      child: Container(
        width: width,
        child: Wrap(
          alignment: WrapAlignment.center,
//          controller: ScrollController(),
//          physics: ClampingScrollPhysics(),
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text('Looking for : ${temp['job']}', textScaleFactor: .95, textAlign: TextAlign.center),
            ),
            DropdownButton <String> (
              value: temp['job'],
              items: jobs.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('  $item', textScaleFactor: 1,), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return jobs.map<Widget>((String item) {
                  return Container(
                    padding: EdgeInsets.only(left: width/25),
                    child: Text('$item', textScaleFactor: 1,)
                  );
                }).toList();
              },
              onChanged: (String selection){
                print(selection);
                getSkillsTypes(selection);
                widget.skillBox = List(widget.skillTypes.length);
                widget.skillsNeeded = [];
                widget.skillBox = widget.skillBox.expand((i)=> [false]).toList();
                setState((){ temp['job'] = selection; });
              },
              isExpanded: true,
            ),
/*
            DropdownButton <String> (
              value: temp['qualification'],
              items: qualifications.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('   $item'), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return qualifications.map<Widget>((String item) {
                  return Container(
                    child: Text('$item'),
                    padding: EdgeInsets.only(left: width/12),
                  );
                }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['qualification'] = selection; });
              },
              isExpanded: true,
            ),
*/ /// dropdown of education
            DropdownButton <String> (
              value: temp['experience'],
              items: experience.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('$item', textScaleFactor: 1,), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return experience.map<Widget>((String item) {
                  return Container(
//                    color: Colors.blue,
                      padding: EdgeInsets.only(left: width/25),
                      child: Text('$item', textScaleFactor: 1,)
                  );
                }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['experience'] = selection; });
              },
              isExpanded: true,
            ),
            ExpansionTile(
              title: Text('Technical Skills Needed : $added',textScaleFactor: 1),
              children: <Widget>[
                SizedBox(
                    height: height/expansion,
                    width: width,
                    child: GridView.builder(
                      controller: ScrollController(),
                      physics: ClampingScrollPhysics(),
                      itemCount: widget.skillTypes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: 4),
                      itemBuilder: (BuildContext context, index){
                        return CheckboxListTile(
                          dense: true,
                          activeColor: formColor,
                          value: widget.skillBox[index],
                          title: Text(widget.skillTypes[index]),
                          onChanged: (isSelected) {
                            if(isSelected && !(widget.skillsNeeded.contains(widget.skillTypes[index])))
                              widget.skillsNeeded.add(widget.skillTypes[index]);
                            else widget.skillsNeeded.remove(widget.skillTypes[index]);
//                                print(widget.skillsNeeded);
                            setState(() {
                              if(widget.skillsNeeded.length > 0)
                                added = 'added';
                              else
                                added = 'null';
                              widget.skillBox[index] = isSelected;
                            });
//                            print(widget.skillsNeeded);
                          },
                        );
                      },
                    )
                ),
              ],
            ),
            Container(
//              width: width / 3,
              child: RaisedButton(
                shape: StadiumBorder(),
                color: Colors.blue[900],
                child: Text("UPDATE  DETAILS"),
                textColor: Colors.blue[100],
                onPressed: () async{
//                  QuerySnapshot ds = await Firestore.instance.collection('candidates')
//                      .where('Details.job', isEqualTo: '${userData['Details']['job']}').getDocuments().whenComplete((ds) {
//                        print(ds);
//                    getRanking(ds);
//                  });
//                   qr = Firestore.instance.collection('candidates').where(field)

                  showDialog(
                      context: context,
                      builder: (context) => Center(child: CircularProgressIndicator())
                  );
//                  print('skills = ');
//                  print(widget.skillsNeeded);

                  widget.userData['Details']['job'] = temp['job'];
                  widget.userData['Details']['experience'] = temp['experience'];
                  widget.userData['SkillsNeeded'] = widget.skillsNeeded;
                  requirementOption();
                  userData['SkillsNeeded'] = widget.skillsNeeded;
//                   print(userData);
//                  if()
                  var data = {
                    'DetailsAdded': true,
                    'Details': {
                      'job': temp['job'],
                      'experience': temp['experience'],
                    },
                    'SkillsNeeded': widget.skillsNeeded,
                    'RChoice': widget.userData['RChoice'],
                  };
//                  print("await = ${widget.userData['RChoice']}");
                  await Firestore.instance.collection('firmUser')
                      .document(widget.userData['UID']).updateData(data);
//                DocumentSnapshot doc = await Firestore.instance.collection('firmUser').document(widget.userData['UID']).get();
//                widget.userData = doc.data;
//                print(widget.userData);
//                homePage().createElement().build();
                  print('Details Updated');
                  Navigator.pop(context);
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(' Details Saved ')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getRanking(List <DocumentSnapshot> documents) async{
    List<List<double>> RankedIndividuals = [];
    print('in ');
    for(int i =0 ; i< documents.length; i++){
      getSkillsTypes(documents.elementAt(0).data['Details']['job']);
      var userS = documents.elementAt(i).data['SkillsNeeded'].length;
      var totalS = widget.skillTypes.length;
      var skillsR = userS/totalS * 10;
      RankedIndividuals.add([userS/totalS * 10]);

      var userA = documents.elementAt(i).data['TestResult'] / 2.5;
      var userP = documents.elementAt(i).data['PersonalityResult'] / 15;
      var userPro = documents.elementAt(i).data['Projects'].length;
      if(userPro == 1)
        userPro = 7;
      else
        userPro = 10;
      var userEdu;
      if(documents.elementAt(i).data['Details']['education'] == 'Diploma Graduate')
        userEdu = 7;
      else if(documents.elementAt(i).data['Details']['education'] == 'Diploma Graduate')
        userEdu = 8;
      else
        userEdu = 10;

      var result = (skillsR * 10 + userEdu * 8 + userPro * 7 + userA * 6 + userP * 5) / 3.6;
      print('result = $result');
      var UID = documents.elementAt(i).data['UID'];
      var data = {
        'ResumeRanking': result,

      };
      await Firestore.instance.collection('candidates').document(UID).updateData(data);
//      switch(documents.elementAt(index))

      //      RankedIndividuals.add([])
//      print(documents.elementAt(i).data['TechnicalSkills'].length);
    }
    print(RankedIndividuals);

    //      print(' skills of candidate ${documents.elementAt(i).data['DisplayName']}');
//    print(' length = ${widget.skillTypes.length}');
  }

  void requirementOption() {
    var ch = widget.userData['Details'].values;

//    print(ch);
//    print(ch.contains("Not Needed") && ch.contains("No Experience Needed"));
    if(ch.contains("No Experience Needed"))
      widget.userData['RChoice'] = 2;
    else
      widget.userData['RChoice'] = 1;
    print(widget.userData['RChoice']);
  }
}

class CandidateThings extends StatefulWidget {
  final userData;
  List skillTypes = [];
  List<bool> skillBox = [];
  final List skillsNeeded = [];

  CandidateThings(this.userData);
  @override
  _CandidateThingsState createState() => _CandidateThingsState();
}

class _CandidateThingsState extends State<CandidateThings> {
  double expansion = 6;
  final List<String> jobs = ['Android Developer', 'IOS Developer', 'Flutter Developer',
    'FrontEnd Developer', 'BackEnd Developer', 'Full-Stack Developer',
    'Software Engineer',
  ];
  final List<String> experience = <String> ['No Experience Needed', '6 Month', '1 Year', '2 Year', 'More than 2 Years', 'Any'];
  String added = 'null';

  @override
  void initState(){
    super.initState();
    if(widget.userData['Details']!=null){
//      print("in Not Equals to null");
      temp['job'] = widget.userData['Details']['job'];
      temp['qualification'] = widget.userData['Details']['qualification'];
      temp['experience'] = widget.userData['Details']['experience'];
//      print("printing = ${temp['qualification']}");
    }
    temp['choice'] = temp['choice'] == null ? null : temp['choice'];
    temp['qualification'] = temp['qualification'] == null ? null: temp['qualification'];
    temp['experience'] = temp['experience'] == null ? null : temp['experience'];
    temp['TechnicalSkills'] = widget.userData['TechnicalSkills'] == null ? null : widget.userData['TechnicalSkills'];
    getSkillsTypes(temp['job']);
    print(widget.userData['TechnicalSkills']);
//    widget.skillTypes= [];
//    widget.skillsNeeded = temp['SkillsNeeded'];
    widget.skillBox = List(widget.skillTypes.length);
    widget.skillBox = widget.skillBox.expand((i)=> [false]).toList();
//    setState((){ temp['job'] = selection; });

  }

  void getSkillsTypes(String match) {
    widget.skillTypes.clear();
    widget.skillTypes = List.from(widget.skillTypes)
      ..addAll(skillsByRole.map((map) => SkillModel.fromJson(map))
          .where((object) => object.job == match)
          .map((object) => object.skills)
          .expand((i) => i)
          .toList());
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
      child: Container(
        width: width,
        child: Wrap(
          alignment: WrapAlignment.center,
//          controller: ScrollController(),
//          physics: ClampingScrollPhysics(),
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(10),
              title: Text('Looking for job as a: ${temp['job']}', textScaleFactor: .95, textAlign: TextAlign.center),
            ),
            DropdownButton <String> (
              value: temp['job'],
              items: jobs.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('  $item', textScaleFactor: 1,), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return jobs.map<Widget>((String item) {
                  return Container(
                      padding: EdgeInsets.only(left: width/25),
                      child: Text('$item', textScaleFactor: 1,)
                  );
                }).toList();
              },
              onChanged: (String selection){
                print(selection);
                getSkillsTypes(selection);
                widget.skillBox = List(widget.skillTypes.length);
                widget.skillBox = widget.skillBox.expand((i)=> [false]).toList();
                setState((){ temp['job'] = selection; });
              },
              isExpanded: true,
            ),
/*
            DropdownButton <String> (
              value: temp['qualification'],
              items: qualifications.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('   $item'), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return qualifications.map<Widget>((String item) {
                  return Container(
                    child: Text('$item'),
                    padding: EdgeInsets.only(left: width/12),
                  );
                }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['qualification'] = selection; });
              },
              isExpanded: true,
            ),
*/ /// dropdown of education
            DropdownButton <String> (
              value: temp['experience'],
              items: experience.map((String item) {
                return DropdownMenuItem<String>(
                    child: Text('$item', textScaleFactor: 1,), value: item);
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return experience.map<Widget>((String item) {
                  return Container(
//                    color: Colors.blue,
                      padding: EdgeInsets.only(left: width/25),
                      child: Text('$item', textScaleFactor: 1,)
                  );
                }).toList();
              },
              onChanged: (String selection){
                setState((){ temp['experience'] = selection; });
              },
              isExpanded: true,
            ),
            ExpansionTile(
              title: Text('Technical Skills I have : $added',textScaleFactor: 1),
              children: <Widget>[
                SizedBox(
                    height: height/expansion,
                    width: width,
                    child: GridView.builder(
                      controller: ScrollController(),
                      physics: ClampingScrollPhysics(),
                      itemCount: widget.skillTypes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, childAspectRatio: 4),
                      itemBuilder: (BuildContext context, index){
                        return CheckboxListTile(
                          dense: true,
                          activeColor: formColor,
                          value: widget.skillBox[index],
                          title: Text(widget.skillTypes[index]),
                          onChanged: (isSelected) {
                            if(isSelected && !(widget.skillsNeeded.contains(widget.skillTypes[index])))
                              widget.skillsNeeded.add(widget.skillTypes[index]);
                            else widget.skillsNeeded.remove(widget.skillTypes[index]);
//                                print(widget.skillsNeeded);
                            setState(() {
                              if(widget.skillsNeeded.length > 0)
                                added = 'added';
                              else
                                added = 'null';
                              widget.skillBox[index] = isSelected;
                            });
//                            print(widget.skillsNeeded);
                          },
                        );
                      },
                    )
                ),
              ],
            ),
            Container(
//              width: width / 3,
              child: RaisedButton(
                shape: StadiumBorder(),
                color: Colors.blue[900],
                child: Text("UPDATE  DETAILS"),
                textColor: Colors.blue[100],
                onPressed: () async{
                  print(userData);

                  showDialog(
                    barrierDismissible: false,
                      context: context,
                      builder: (context) => Center(child: CircularProgressIndicator())
                  );
//                  print('skills = ');
//                  print(widget.skillsNeeded);
                  widget.userData['Details']['job'] = temp['job'];
                  widget.userData['Details']['experience'] = temp['experience'];
                  widget.userData['TechnicalSkills'] = widget.skillsNeeded;
//                  requirementOption();
                  print(widget.skillsNeeded);
//                  userData['TechnicalSkills'] = widget.userData['TechnicalSkills'];
//                   print(userData);
                  var data = {
                    'DetailsAdded': true,
                    'Details': {
                      'job': temp['job'],
                      'experience': temp['experience'],
                    },
                    'TechnicalSkills': widget.skillsNeeded,
                    'RChoice': widget.userData['RChoice'],
                  };
//                  print("await = ${widget.userData['RChoice']}");
                  await Firestore.instance.collection('candidates')
                      .document(widget.userData['UID']).updateData(data);
//                DocumentSnapshot doc = await Firestore.instance.collection('firmUser').document(widget.userData['UID']).get();
//                widget.userData = doc.data;
//                print(widget.userData);
//                homePage().createElement().build();
                  print('Details Updated');
                  Navigator.pop(context);
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(' Details Saved ')));
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}
