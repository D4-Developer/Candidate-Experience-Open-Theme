import '../authentication/signUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import '../forms/Data.dart';

var width,height,scaleFactor;
String gender;
int initialP = 0;
final List<GlobalKey<FormState>> _formKey = [GlobalKey<FormState>(),GlobalKey<FormState>()];
final List<TextEditingController> tempTEC = [
  TextEditingController(), TextEditingController(),
  TextEditingController(), TextEditingController(),
  TextEditingController(), TextEditingController(),
  TextEditingController(),
];
List<int> s = [0,1,1];
PageController pageController = PageController(
  initialPage: initialP,
  keepPage: true,
);

class CandidateForm extends StatefulWidget {
  @override
  _CandidateFormState createState() => _CandidateFormState();
}

List<Color> color = <Color>[Colors.blue[900],Colors.blue[50]];
class _CandidateFormState extends State<CandidateForm> {

  @override
  Widget build(BuildContext context) {
    scaleFactor = MediaQuery.of(context).textScaleFactor;
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) {
//              setState(() {
//            });
              },
              children: <Widget>[
                AccountInfo(), EducationInfo(), OtherInfo()
              ],
            ),
            Container(
              color: Colors.blue[50],
              width: width,
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  FlatButton(
                    shape: Border(bottom: BorderSide(color: color[s[0]])),
                    onPressed: () {
                      pageController.animateToPage(0, duration: Duration(milliseconds: 1000), curve: Curves.ease);
                      setState(() {
                        initialP = 0;
                        s = [1,1,1];
                        s[0] = 0;
                      });
                    },
                    child: Text('Account\nInfo', textScaleFactor: 1),
                  ),
                  Icon(Icons.arrow_forward_ios),
                  FlatButton(
                      shape: Border(bottom: BorderSide(color: color[s[1]])),
                      onPressed: () {
                        pageController.animateToPage(1, duration: Duration(milliseconds: 1000), curve: Curves.ease);
                        setState(() {
                          initialP = 1;
                          s = [1,1,1];
                          s[1] = 0;
                        });
                      },
                      child: Text('Education\nInfo', textScaleFactor: 1)
                  ),
                  Icon(Icons.arrow_forward_ios,),
                  FlatButton(
                      shape: Border(bottom: BorderSide(color: color[s[2]])),
                      child: Text('Other\nInfo', textScaleFactor: 1),
                      onPressed: () {
                        pageController.animateToPage(2, duration: Duration(milliseconds: 1000), curve: Curves.ease);
                        setState(() {
                          initialP = 2;
                          s = [1,1,1];
                          s[2] = 0;
                        });
                      }
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
//        color: Colors.pinkAccent,
        width: height/8,
        height: width/4,
        child: Column(
          children: <Widget>[
            Expanded(
              child: IconButton(
                onPressed: () {
                  if(initialP != 0) {
                    setState(() {
                      s = [1, 1, 1];
                      s[--initialP] = 0;
                    });
                    pageController.animateToPage(
                        initialP, duration: Duration(milliseconds: 1000),
                        curve: Curves.ease
                    );
                  }
                },
                icon: Icon(
                  Icons.expand_less,
                  color: Colors.blue[800],
                  size: 35
                )
              )
            ),
            Expanded(
              child: IconButton(
                icon: Icon(
                    Icons.expand_more,
                    color: Colors.blue[900],
                    size: 35
                  ),
                onPressed: () {
                  if(initialP ==0  && _formKey[initialP].currentState.validate()) {
                      setState(() {
                        s = [1, 1, 1];
                        s[++initialP] = 0;
                      });
                      pageController.animateToPage(
                          initialP, duration: Duration(milliseconds: 1000),
                          curve: Curves.ease
                      );
                    }
                    else if(initialP == 1) {
                    setState(() {
                      s = [1, 1, 1];
                      s[++initialP] = 0;
                    });
                    pageController.animateToPage(
                        initialP, duration: Duration(milliseconds: 1000),
                        curve: Curves.ease
                    );
                  }




                  /*if(initialP == 1 && _formKey[initialP].currentState.validate()) {
                    setState(() {
                        s = [1, 1, 1];
                        s[++initialP] = 0;
                      });
                      pageController.animateToPage(
                          initialP, duration: Duration(milliseconds: 1000),
                          curve: Curves.ease
                      );
                  }
                  else if(initialP == 0 && _formKey[initialP].currentState.validate()) {
                    setState(() {
                      s = [1, 1, 1];
                      s[++initialP] = 0;
                    });
                    pageController.animateToPage(
                        initialP, duration: Duration(milliseconds: 1000),
                        curve: Curves.ease
                    );
                  }*/

                },
              )
            ),
            Icon(null)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//      resizeToAvoidBottomInset: true,
    );
  }
}

TextStyle formStyle = TextStyle(color: Colors.blue[900], fontSize: 17/scaleFactor,fontWeight: FontWeight.bold,fontFamily: 'Times New Roman');
TextStyle categoryStyle = TextStyle(color: Colors.black, fontSize: 17/scaleFactor, fontWeight: FontWeight.w500);
Color formColor = Colors.blue[900], radioBG = Color.fromRGBO(0, 131, 143, .2);

class AccountInfo extends StatefulWidget {
  final List<String> hobbyTitle = ['Reading', 'Music', 'Sports', 'Swimming', 'Singing / Dancing'];
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

List <String> hobbies = [];
class _AccountInfoState extends State<AccountInfo> with AutomaticKeepAliveClientMixin<AccountInfo>{
  final List<bool> hobbyBox = [false, false, false, false, false];
  bool selectedF = false, selectedM = false;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(width/20),
      child: Center(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(), /// only scroll when needed by child widget
//          primary: false,
          child: Form(
            key: _formKey[0],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: width/10),
                    child: Text("Personal Information", style: categoryStyle,textScaleFactor: 1)
                ),
                ListTile(
                  title: TextFormField(
                    maxLines: 1,
                    style: formStyle,
                    controller: tempTEC[0],
                    cursorColor: formColor,
                    decoration: InputDecoration(
                      labelStyle: formStyle,
                      labelText: 'Name',
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(Icons.person, color: formColor),
                      border: InputBorder.none
                    ),
                    validator: (value) {
                      if(value.length < 2)
                        return 'Enter Proper Name';
                      return null;
                    },
                  ),
                ),
                ListTile(
                  title: TextFormField(
                    enabled: false,
                    style: formStyle,
                    controller: tempTEC[1],
                    cursorColor: formColor,
                    decoration: InputDecoration(
                      labelStyle: formStyle,
                      labelText: 'DD / MM / YYYY',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.calendar_today, color: formColor)
                    ),
                  ),
                  onTap: () => cupertinoDatePicker(),
                ),
                ListTile(
                  title: TextFormField(
                    maxLength: 10,
                    style: formStyle,
                    controller: tempTEC[2],
                    keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                    inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelStyle: formStyle,
                      labelText: 'Contact Number',
                        border: InputBorder.none,
                        prefixText: "+91",
                      prefixIcon: Icon(Icons.call, color: formColor,)
                    ),
                    validator: (value) {
                      final List<int> v = value.codeUnits;
                      if(value.length < 10){
                        tempTEC[2].clear();
                        print('1');
                        return 'Please enter complete conatact no';
                      }
                      else if(v[0] == 48 || v[0] == 49 || v[0] == 50 || v[0] == 51 || v[0] == 52 || v[0] == 53){
                        tempTEC[2].clear();
                        print('2');
                        return 'Enter Correct Contact No';
                      }
                      else
                        return null;
                    },
                  ),
                ),
                ListTile(
                  title: ExpansionTile(
                    backgroundColor: radioBG,
                    title: Text("Hobbies", style: formStyle,textScaleFactor: 1),
                    children: <Widget>[
                      ListView.builder(
                        itemCount: 5,
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemBuilder: (BuildContext context, i){
                          return CheckboxListTile(
                              value: hobbyBox[i],
                              selected: hobbyBox[i],
                              title: Text('${widget.hobbyTitle[i]}', style: TextStyle(
                                  color: Colors.blue[800],
                                  fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'Times New Roman'
                                ),
                                textScaleFactor: 1
                              ),
                              activeColor: formColor,
                              onChanged: (isSelected) {
                                if(isSelected && !(hobbies.contains(widget.hobbyTitle[i])))
                                  hobbies.add(widget.hobbyTitle[i]);
                                else hobbies.remove(widget.hobbyTitle[i]);
//                                print(hobbies);
                                setState(() {
                                  hobbyBox[i] = isSelected;
                                });
                              }
//                              setState(() => hobbyBox[i] = isSelected),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                  title: Text('I\'m a....', style: formStyle, textAlign: TextAlign.start,textScaleFactor: 1),
                  subtitle: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          color: selectedF ? formColor : null,
                          textColor: selectedF ? Colors.blue[100] : Colors.blue[900],
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(color: formColor),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)
                              )
                          ),
                          onPressed: () {
                            setState(() {
                              selectedF = true;
                              selectedM = false;
                              gender = 'Female';
                            });
                          },
                          child: Text('Female', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),textScaleFactor: 1),
                        ),
                      ),
                      Expanded(
                        child: FlatButton(
                          color: selectedM ? formColor : null,
                          textColor: selectedM ? Colors.blue[100] : Colors.blue[900],
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(color: formColor),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomRight: Radius.circular(8)
                              )
                          ),
                          onPressed: () {
                            setState(() {
                              selectedM = true;
                              selectedF = false;
                              gender = 'Male';
                            });
                          },
                          child: Text('Male',  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),textScaleFactor: 1),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 30, bottom: 15),
                  child: Text('Account Information', style: categoryStyle, textScaleFactor: 1)
                ),
                ListTile(
                  title: TextFormField(
                    maxLines: 1,
                    style: formStyle,
                    controller: tempTEC[3],
//                        autovalidate: true,
                    cursorColor: formColor,
                    scrollPadding: EdgeInsets.all(0),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelStyle: formStyle,
                      labelText: 'Email',
//                        alignLabelWithHint: false,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.mail, color: formColor),
                      focusedBorder: InputBorder.none,
//                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if(value.isEmpty)
                        return 'Email must not be Empty';
                      else if(!(value.contains('@', 1)))
                        return 'Email must contains "@"';
                      return null;
                      /// value.contains(RegExp(r'[A-Z]'))
                    },
                    onFieldSubmitted: (value) =>
                      Focus.of(context).unfocus(),
                  ),
                ),
                ListTile(
//                    contentPadding: EdgeInsets.all(15),
                  title: TextFormField(
                    maxLines: 1,
                    style: formStyle,
                    controller: tempTEC[4],
                    cursorColor: formColor,
                    decoration: InputDecoration(
                      labelStyle: formStyle,
                      labelText: 'Password',
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(Icons.lock, color: formColor),
                      border: InputBorder.none
//                        alignLabelWithHint: true,
//                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if(value.length < 8)
                        return 'Password Must be 8 characters long';
                      return null;
                    },
                    onFieldSubmitted: (value) {
//                          if(_formKey[0].currentState.validate())
//                            _formKey[0].currentState.save();
//                          Focus.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void cupertinoDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          backgroundColor: Colors.blue[50],
          onDateTimeChanged: (DateTime dateTime) {
            setState(() {
              tempTEC[1].text = "${dateTime.day} / ${dateTime.month} / ${dateTime.year}";
            });
          },
          initialDateTime: DateTime.now(),
          minimumDate: DateTime(1900, 1,1),
          maximumDate: DateTime.now(),
          mode: CupertinoDatePickerMode.date,
        );
      },
    );
  }
}

class EducationInfo extends StatefulWidget {
  final List<String> education = ['Diploma Graduate', 'Bachelor Degree', 'Master Degree', /*'Other'*/]; /// consider OTHER
  List skillTypes = [];
  List<bool> skillBox = [];
  final List<String> skills = ['C++', 'Java', 'Python', 'Designing', 'UI/UX', 'Flutter', 'AI', 'ML', 'DataScience','JavaScript','PHP'];
  @override
  _EducationInfoState createState() => _EducationInfoState();
}
String eduSelection = '', jobSelection = '';
//List<String> skills = [];
List skillsNeeded = [];

class _EducationInfoState extends State<EducationInfo> with AutomaticKeepAliveClientMixin<EducationInfo>{
  double expansion = 6;
  String added = 'null';
  bool e1 = false,h1 = false;

  @override
  bool get wantKeepAlive => true;

  void getSkillsTypes(String match) {
    widget.skillTypes.clear();
    widget.skillTypes = List.from(widget.skillTypes)
      ..addAll(skillsByRole.map((map) => SkillModel.fromJson(map))
          .where((object) => object.job == match)
          .map((object) => object.skills)
          .expand((i) => i)
          .toList());
    var l = widget.skillTypes.length;
    if(l > 8)
      expansion = 2.5;
    else if(l > 6)
      expansion = 4;
    else if(l > 4)
      expansion = 5;
    else
      expansion = 7;
  }
  @override
  void initState() => super.initState();

  bool validate() {
      if(eduSelection.isEmpty)
        setState(() => e1 = true);
      else
        setState(() => e1 = false);
     /* if(!(hobbyBox.contains(true)))
        setState(() => h1 = true);
      else
        setState(() => h1 = false);*/
    if(eduSelection.isEmpty)
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(width/20),
      child: Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          physics: ClampingScrollPhysics(),
          primary: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: ExpansionTile(
                  backgroundColor: radioBG,
                  title: Text("Education : $eduSelection", style: formStyle,textScaleFactor: 1),
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: widget.education.length,
                      itemBuilder: (BuildContext context, i){
                        return RadioListTile(
                          groupValue: eduSelection.isEmpty ? '< Select >':eduSelection,
                          value: widget.education[i],
                          title: Text('${widget.education[i]}', style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'Times New Roman'
                            ),
                            textScaleFactor: 1
                          ),
                          activeColor: formColor,
                          onChanged: (value) =>
                              setState(() => eduSelection = value),
                        );
                      },
                    ),
                  ],
                ),
              ),
              _expandEducation(),
              ExpansionTile(
                title: Text('Technical Skills : $added',textScaleFactor: 1),
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
                              if(isSelected && !(skillsNeeded.contains(widget.skillTypes[index])))
                                skillsNeeded.add(widget.skillTypes[index]);
                              else skillsNeeded.remove(widget.skillTypes[index]);
//                                print(widget.skillsNeeded);
                              setState(() {
                                if(skillsNeeded.length > 0)
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

/// remove comment
//              if(e1)
//                Text('Please select Education field'),
              /// skills checkbox may be on ProfilePage of User....
/// remove comment
//              if(h1)
//                Text('Select atleast 1 Hobby field')
            ],
          ),
        ),
      ),
    );
  }

  final List<String> jobType = ['Android Developer', 'IOS Developer', 'Flutter Developer',
  'FrontEnd Developer', 'BackEnd Developer', 'Full-Stack Developer',
  'Software Engineer',
  ];

  Widget _expandEducation() {
    if(eduSelection != 'B.C.A / M.C.A' && eduSelection != '< Select >')
      return ListTile(
        title: ExpansionTile(
          title: Text("I'm a  : $jobSelection", style: formStyle,textScaleFactor: 1/* textAlign: TextAlign.center*/),
          children: <Widget>[
            ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: jobType.length,
              itemBuilder: (BuildContext context, i){
                return RadioListTile(
//                          subtitle: Text('companyName'),
                  groupValue: jobSelection.isEmpty ? '< Select >': jobSelection,
                  value: jobType[i],
                  title: Text('${jobType[i]}', style: TextStyle(
                      color: Colors.blue[800],
                      fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'Times New Roman'
                    ),
                    textScaleFactor: 1
                  ),
                  activeColor: formColor,
                  onChanged: (value) {
                    setState(() => jobSelection = value);
                    getSkillsTypes(value);
                    widget.skillBox = List(widget.skillTypes.length);
                    widget.skillBox = widget.skillBox.expand((i)=> [false]).toList();
                  }
                );
              },
            ),
          ],
          backgroundColor: radioBG,
        ),
      );
    return Container();
  }
}

class OtherInfo extends StatefulWidget {
  /*final List<String> choices = ['Job', 'Internship'];*/  /// option for job / internship....
  final List<String> experience = ['No Experience', '6 Month', '1 Year', '2 Year', 'More than 2 Years'];
  @override
  _OtherInfoState createState() => _OtherInfoState();
}

class _OtherInfoState extends State<OtherInfo>with AutomaticKeepAliveClientMixin<OtherInfo> {
  List<bool> choiceBox = [false, false,];
  String exSelection = '', choiceSelection = '';
  List<bool> experienceBox = [false, false, false, false, false, false,];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(width/20),
      child: Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey[1],
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.book, color: formColor),
                      title: TextFormField(
                        maxLines: 1,
                        style: formStyle,
                        cursorColor: formColor,
                        controller: tempTEC[5],
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText:  'Project Title1',
                            labelStyle: formStyle,
                            focusedBorder: InputBorder.none,
//                              prefixIcon: Icon(Icons.person, color: formColor),
                            border: InputBorder.none
                        ),
                        validator: (value) {
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.book, color: formColor),
                      title: TextFormField(
                        maxLines: 1,
                        style: formStyle,
                        cursorColor: formColor,
                        controller: tempTEC[6],
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText:  'Project Title2',
                            labelStyle: formStyle,
                            focusedBorder: InputBorder.none,
//                              prefixIcon: Icon(Icons.person, color: formColor),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: ExpansionTile(
//                        initiallyExpanded: isSelected,
//                    onExpansionChanged: (flag) =>
//                      setState(() => isSelected = !flag),
                  title: Text("Experience : $exSelection", style: formStyle,textScaleFactor: 1/* textAlign: TextAlign.center*/),
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: widget.experience.length,
                      itemBuilder: (BuildContext context, i){
                        return RadioListTile(
//                          subtitle: Text('companyName'),
                          groupValue: exSelection,
                          value: widget.experience[i],
                          selected: experienceBox[i],
                          title: Text('${widget.experience[i]}', style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 15,fontWeight: FontWeight.w600,fontFamily: 'Times New Roman'
                            ),
                            textScaleFactor: 1
                          ),
                          activeColor: formColor,
                          onChanged: (value) =>
                              setState(() => exSelection = value),
                        );
                      },
                    ),
                  ],
                  backgroundColor: radioBG,
                ),
              ),
              Padding( padding: EdgeInsets.all(width/10)),
              RaisedButton(
                color: formColor,
                child: Text('CREATE  ACCOUNT', style: TextStyle(color: Colors.blue[100]),textScaleFactor: 1),
                onPressed: () async{
                  print(skillsNeeded);
                 /* String a = 'No Experience',b='2 month', c = '2 Year';
                  a = a.split('').reversed.join();
                  b = b.split('').reversed.join();
                  c = c.split('').reversed.join();
                  print(a);
                  print(b);
                  print(c);
//                  b = c;
                    print('compare = ${a.compareTo(b)}');
                    print('compare = ${a.compareTo(c)}');
                    print('compare = ${c.compareTo(b)}');*/
                  bool validate = true;
                  for(int i=0; i<2; i++) {
//                    print(tempTEC[i].text);
                    if(!(_formKey[i].currentState.validate())){
                      validate = false;
                      initialP = i;
                      pageController.animateToPage(i, duration: Duration(milliseconds: 1000), curve: Curves.ease);
                      break;
                    }
                  }
                  if(validate) {
                    List<String> userData = [];
                    print(tempTEC.length);
                    for(int i =0 ;i < tempTEC.length; i++){
                      userData.add(tempTEC[i].text);
                      print(userData[i]);
                    }
                    List s  = userData.getRange(5,7).toList();
                    print(s);
//                    print(eduSelection);
//                    print(exSelection);
//                    print(hobbies);
//                    print(gender);
//                    print(engineeringSelection);

//                    List<String> getAccountInfo();
                    /// skills of List
                    bool isSuccess = await signUpState().signUpWithEmailAndPassword(
                      false, userData, context, eduSelection, exSelection, skillsNeeded, hobbies, jobSelection, gender
                    );
                    print('--');
                    print(isSuccess);
                    if(isSuccess) {
                      _formKey[0].currentState.reset();
                      _formKey[1].currentState.reset();
                      for(int i =0 ;i < tempTEC.length; i++){
                        print(tempTEC[i].text);
                        tempTEC[i].clear();
                        //  print(userData[i]);
                      }
                      print('..');
                      exSelection = '';
                      hobbies.clear();
                      jobSelection = '';
                      eduSelection = '';
                      skillsNeeded.clear();
                    }
                    print('validated');
                  }
                  print('done signUp');
                },
              )
            ],
          ),
        ),
      ),
    );
  }

}