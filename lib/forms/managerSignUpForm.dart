import 'package:flutter/material.dart';
import '../authentication/signUpPage.dart';
import 'Data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//import 'intl/intl.dart';
int initialP = 0;
var width, height;
String gender;
List<int> s = [0, 1, 1];
PageController pageController = PageController(
  initialPage: initialP,
  keepPage: true,
);
final List<GlobalKey<FormState>> _formKey = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

final List<TextEditingController> tempTEC = [
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController(),
  TextEditingController()
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FormPageView(),
    );
  }
}

class FormPageView extends StatefulWidget {
  @override
  _FormPageViewState createState() => _FormPageViewState();
}

class _FormPageViewState extends State<FormPageView> {
  String userType = 'Candidate';
  bool selected0 = false, selected1 = true;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.cyan[100],
        appBar: AppBar(title: Text("Sign UP")),
        body: ListView(children: <Widget>[
          Card(
              child: Column(children: [
            Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                alignment: Alignment.center,
                child: Text(
                  'Welcome in HR Management App !',
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 30),
                )),
            Icon(Icons.people, size: 100),
            Text('Select UserType'),
            Padding(padding: EdgeInsets.all(10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected1 = !selected1;
                        selected0 = !selected0;
                        userType = selected0 ? 'Manager' : 'Candidate';
                      });
                    },
                    child: AnimatedContainer(
                      padding: EdgeInsets.fromLTRB(14, 20, 14, 20),
                      decoration: selected0
                          ? BoxDecoration(
                              color: Colors.cyan[50],
                              border: Border.all(width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(12)))
                          : BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.grey[100])),
                      duration: Duration(microseconds: 400000),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.group),
                          Text('HR Manager')
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selected0 = !selected0;
                        selected1 = !selected1;
                        userType = selected1 ? 'Candidate' : 'HR Manager';
                      });
                    },
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(20),
                      decoration: selected1
                          ? BoxDecoration(
                              border: Border.all(width: 2, color: Colors.blue),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12)))
                          : BoxDecoration(
                              border: Border.all(
                                  width: 2, color: Colors.grey[100])),
                      duration: Duration(microseconds: 400000),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.group_add),
                          Text('Candidate')
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 50),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Already User ? "),
                    Container(
                      width: 1.2 * MediaQuery.of(context).size.width / 3,
                      child: OutlineButton(
                        borderSide: BorderSide(color: Colors.deepPurple),
                        shape: StadiumBorder(),
                        onPressed: () {},
                        child: Text("Sign In"),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text("Continue As"),
                    Container(
                      width: 1.2 * MediaQuery.of(context).size.width / 3,
                      child: RaisedButton(
                        shape: StadiumBorder(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FormPageView()));
                        },
                        color: Colors.lightBlueAccent,
                        child: Text(userType),
                      ),
                    )
                  ],
                )
              ],
            ),
          ]))
        ]));
  }
}

class ManagerForm extends StatefulWidget {
  @override
  _ManagerFormState createState() => _ManagerFormState();
}

List<Color> color = <Color>[Colors.blue[900], Colors.cyan[50]];

class _ManagerFormState extends State<ManagerForm>
    with AutomaticKeepAliveClientMixin<ManagerForm> {
  @override
  void dispose() {
    s = [0, 1, 1];
    initialP = 0;
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.blue[50],
//      drawerScrimColor: Colors.cyanAccent,
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
              children: <Widget>[AccountInfo(), CompanyInfo(), OtherInfo()],
            ),
            Container(
              color: Colors.blue[50],
              width: width,
              padding: EdgeInsets.only(top: width/100),
              child: Wrap(
                runAlignment: WrapAlignment.center,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom:
                        BorderSide(color: color[s[0]], width: 2))),
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                      onTap: () {
                        pageController.animateToPage(0,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease);
                        setState(() {
                          initialP = 0;
                          s = [1, 1, 1];
                          s[0] = 0;
                        });
                      },
                      child: Text('Account Info', style:
                      TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(bottom:
                      BorderSide(color: color[s[1]], width: 2))
                    ),
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                        onTap: () {
                          pageController.animateToPage(1,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.ease);
                          setState(() {
                            initialP = 1;
                            s = [1, 1, 1];
                            s[1] = 0;
                          });
                        },
                        child: Text('Company Info',style:
                        TextStyle(fontWeight: FontWeight.w500))),
                  ),
                  Icon(Icons.arrow_forward_ios),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom:
                        BorderSide(color: color[s[2]], width: 2))),
                    padding: EdgeInsets.all(10),
                    child: InkWell(
                        child: Text('Requirement Info', style:
                          TextStyle(fontWeight: FontWeight.w500)),
                        onTap: () {
                          pageController.animateToPage(2,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.ease);
                          setState(() {
                            initialP = 2;
                            s = [1, 1, 1];
                            s[2] = 0;
                          });
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
//        color: Colors.pinkAccent,
        width: height / 8,
        height: width / 4,
        child: Column(
          children: <Widget>[
            Expanded(
                child: IconButton(
                    onPressed: () {
                      if (initialP != 0) {
                        setState(() {
                          s = [1, 1, 1];
                          s[--initialP] = 0;
                        });
                        pageController.animateToPage(initialP,
                            duration: Duration(milliseconds: 1000),
                            curve: Curves.ease);
                      }
                    },
                    icon: Icon(Icons.expand_less,
                        color: Colors.blue[800], size: 35))),
            Expanded(
                child: IconButton(
              icon: Icon(Icons.expand_more, color: Colors.blue[900], size: 35),
              onPressed: () {
//                print(initialP);
                if (initialP != 2 &&
                    _formKey[initialP].currentState.validate()) {
//                  print('11');
                    setState(() {
                      s = [1, 1, 1];
                      s[++initialP] = 0;
                    });
//                    print(initialP);
                    pageController.animateToPage(initialP,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.ease);
                } else
                  _formKey[initialP].currentState.validate();
//                print('22');

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
            )),
            Icon(null)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//      resizeToAvoidBottomInset: true,
    );
  }
}

TextStyle formStyle = TextStyle(
    color: Colors.blue[900],
    fontSize: 17,
    fontWeight: FontWeight.bold,
    fontFamily: 'Times New Roman');
TextStyle categoryStyle =
    TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500);
Color formColor = Colors.blue[900], radioBG = Color.fromRGBO(0, 131, 143, .2);

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo>
    with AutomaticKeepAliveClientMixin<AccountInfo> {
  bool selectedF = false, selectedM = false, dobFlag = false;
  DateTime previousSelected;
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
//      height: height,
      padding: EdgeInsets.all(width / 20),
      color: Colors.blue[50],
      child: Center(
        child: SingleChildScrollView(
//          physics: ClampingScrollPhysics(),
//          primary: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Form(
                key: _formKey[0],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Personal Information", style: categoryStyle),
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
                            border: InputBorder.none),
                        validator: (value) {
                          if (value.length < 2) return 'Enter Proper Name';
                          return null;
                        },
//                        onChanged: (value) {
//                          if(value.length > 2)
//                          _formKey[0].currentState.validate();
//                        },
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        enabled: false,
                        style: formStyle,
                        controller: tempTEC[1],
                        cursorColor: formColor,
                        decoration: InputDecoration(
                          enabled: false,
                            labelStyle: formStyle,
                            labelText: 'DD / MM / YYYY',
//                            suffixText: '01/01/2001',
//                        focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.calendar_today, color: formColor)),
                      ),
                      onTap: () => cupertinoDatePicker()
                    ),
                    dobError(),
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
                            prefixText: "+91 ",
                            prefixIcon: Icon(Icons.call, color: formColor,)
                        ),
                        validator: (value) {
                          validateDob();
                          final List<int> v = value.codeUnits;
                          if(value.length < 10){
                            tempTEC[2].clear();
//                            print('1');
                            return 'Please enter complete conatact no';
                          }
                          else if(v[0] == 48 || v[0] == 49 || v[0] == 50 || v[0] == 51 || v[0] == 52 || v[0] == 53){
                            tempTEC[2].clear();
//                            print('2');
                            return 'Enter Correct Contact No';
                          }
                          else
                            return null;
                        },
                        onEditingComplete:() {
                          if(tempTEC[2].text.length > 9)
                            _formKey[0].currentState.validate();
                        },
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                      title: Text('I\'m a....',
                          style: formStyle, textAlign: TextAlign.start),
                      subtitle: Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: FlatButton(
                              textColor: selectedF ? Colors.blue[50] : null,
                              color: selectedF ? formColor : null,
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: formColor),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8))),
                              onPressed: () {
                                setState(() {
                                  selectedF = true;
                                  selectedM = false;
                                  gender = 'Female';
                                });
                              },
                              child: Text('Female',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                          Expanded(
                            child: FlatButton(
                              textColor: selectedM ? Colors.blue[50] : null,
                              color: selectedM ? formColor : null,
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: formColor),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      bottomRight: Radius.circular(8))),
                              onPressed: () {
                                setState(() {
                                  selectedM = true;
                                  selectedF = false;
                                  gender = 'Male';
                                });
                              },
                              child: Text('Male',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                            ),
                          )
                        ],
                      ),
                    ),
//                    Padding(padding: EdgeInsets.all(10)),
                    Container(
                        padding: EdgeInsets.only(top: 30, bottom: 15),
                        child:
                            Text('Account Information', style: categoryStyle)),
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
                          if (value.isEmpty)
                            return 'Email must not be Empty';
                          else if (!(value.contains('@', 1)))
                            return 'Email must contains "@"';
                          return null;
                          /// value.contains(RegExp(r'[A-Z]'))
                        },
                        onFieldSubmitted: (value) {
                          if(_formKey[0].currentState.validate()) {
                            Focus.of(context).unfocus();
                          }
                        }
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
                          if (value.length < 7) {
                            return 'Password Must be 8 characters long';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          if (_formKey[0].currentState.validate())
                            _formKey[0].currentState.save();
                          Focus.of(context).unfocus();
                        },
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

  void cupertinoDatePicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CupertinoDatePicker(
          maximumDate: DateTime.now(),
          backgroundColor: Colors.blue[50],
          minimumDate: DateTime(1900, 1, 1),
          mode: CupertinoDatePickerMode.date,
          initialDateTime: previousSelected == null ? DateTime(2002, 1, 1) : previousSelected,
          onDateTimeChanged: (DateTime dateTime) =>
              setState(() {
                previousSelected = dateTime;
                tempTEC[1].text = "${dateTime.day} / ${dateTime.month} / ${dateTime.year}";
                dobFlag = false;
              }),
        );
      },
    );
  }

  validateDob() {
    if(tempTEC[1].text.isEmpty)
      setState(() => dobFlag = true );
    else
      setState(() => dobFlag = false );
  }

  Widget dobError() {
    if(dobFlag)
      return Text('Select Date of birth',
          style: TextStyle(color: Colors.red[700],fontSize: 12)
      );
    return Container();
  }

}

class CompanyInfo extends StatefulWidget {
  final List<String> companyType = ['Automobile', 'Bio-Medical', 'Chemical', 'E-Commerce', 'Education And Training',
    'Electrical', 'Infrastructure', 'IT', 'Manufacturing', 'Machinary', 'Oil and Gas', 'PowerPlant', 'Software', 'TextTile'
  ];
  @override
  _CompanyInfoState createState() => _CompanyInfoState();
}

String typeSelection = '< Select >';


class _CompanyInfoState extends State<CompanyInfo> with AutomaticKeepAliveClientMixin<CompanyInfo>{
  bool companyflag = false;
  @override
  bool get wantKeepAlive => true;

//  void getTypes(String types){
//    jobTypes.clear();
//    jobTypes = List.from(jobTypes)..addAll(selectionTypes.map((map) => StateModel.fromJson(map))
//        .where((item) => item.type == types)
//        .map((item)=> item.jobs)
//        .expand((i) => i)
//        .toList());
////    print(widget.jobTypes);
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.all(width / 20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              Form(
                key: _formKey[1],
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: TextFormField(
                        maxLines: 1,
                        controller: tempTEC[5],
                        decoration: InputDecoration(
                          labelStyle: formStyle,
                          border: InputBorder.none,
                          labelText: 'Comapany Name',
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.business, color: formColor),
                        ),
                        validator: (value) {
                          validateCom();
                          if(value.isEmpty)
                            return 'Company name must not be empty';
                          return null;
                        },
                      ),
                    ),
                    ListTile(
                      title: TextFormField(
                        maxLines: 1,
                        controller: tempTEC[6],
                        decoration: InputDecoration(
                          labelStyle: formStyle,
                          border: InputBorder.none,
                          labelText: 'Comapany Address',
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.business, color: formColor),
                        ),
                        validator: (value) {
                          validateCom();
                          if(value.isEmpty)
                            return 'Please provide address';
                          return null;
                        },
                      ),
                    )
                  ],
                )
              ),
            ]
          ),
        )
      )
    );
  }

  Widget companySelError() {
    if(companyflag)
      return Text('Select Company Type',
        style: TextStyle(color: Colors.red[700],fontSize: 12),
      );
    else
      return Container();
  }
  validateCom() {
    if(typeSelection == '< Select >')
      setState(() => companyflag = true);
    else
      setState(() => companyflag = false );
  }
}

class OtherInfo extends StatefulWidget {
  final List<String> experience = <String>[
    'No Experience',
    '6 Month',
    '1 Year',
    '2 Year',
    'More than 2 Years',
    'Any'
  ];

  List<bool> skillBox = [];
  List skillTypes = [];
  final List <String>skillsNeeded = [];

  @override
  _OtherInfoState createState() => _OtherInfoState();
}

String jobSelection = '< Select >';
class _OtherInfoState extends State<OtherInfo>
    with AutomaticKeepAliveClientMixin<OtherInfo> {
  List<String> jobTypes = [
    'Android Developer','Flutter Developer','IOS Developer','BackEnd Developer','FrontEnd Developer','Full-Stack Developer','Web Developer','UI / UX Designer','Computer engineer',
  ];
  bool jobSelFlag = false, skillNeedFlag = false, exSelFlag = false;
  double expansion = 6;
  String exSelection = '< Select >';
/*  List<bool> choiceBox = [
    false,
    false,
  ];
  List<bool> experienceBox = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];*/

  @override
  bool get wantKeepAlive => true;

  void getSkillsTypes(String match) {
    widget.skillTypes.clear();
    widget.skillTypes = List.from(widget.skillTypes)..addAll(skillsByRole.map((map) => SkillModel.fromJson(map))
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
//    print(widget.skillTypes.length);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
//    print(height/(13.5-widget.skillTypes.length));
    return Container(
//        height: height-(height/10),
//        color: Colors.cyan[100],
      padding: EdgeInsets.all(width / 20),
      child: Center(
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ListTile(
                title: ExpansionTile(
                  title: Text('Looking for :', style: formStyle),
                  subtitle: Text('$jobSelection',
                    style: TextStyle(
//                      fontSize: 20,
                      color: Colors.blue[900],
                    ),
                  ),
                  children: <Widget>[
                    ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: jobTypes.length,
                      itemBuilder: (BuildContext context, index){
                        return RadioListTile(
                            activeColor: formColor,
                            groupValue: jobSelection,
                            value: jobTypes[index],
                            title: Text('${jobTypes[index]}',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.blue[900],
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Times New Roman')
                            ),
                            onChanged: (isSelected) =>
                                setState(() {
                                  jobSelection = isSelected;
//                                  print(widget.skillTypes.length);
                                  getSkillsTypes(isSelected);
//                                  widget.skillBox.clear();
                                  widget.skillBox = List(widget.skillTypes.length);
//                                  widget.skillBox.fillRange(0, widget.skillTypes.length, false);
                                  widget.skillBox = widget.skillBox.expand((i)=> [false]).toList();
                                })
                        );
                      },
                    ),
                  ],
                ),
              ),
              jobSelError(),
              ListTile(
                title: ExpansionTile(
                  title: Text('Techincal Skills for $jobSelection', style: formStyle),
                  children: <Widget>[
                    SizedBox(
                        height: height/expansion,
                        width: width,
                        child: GridView.builder(
                          controller: ScrollController(),
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
                                print(widget.skillsNeeded);
                                setState(() {
                                  widget.skillBox[index] = isSelected;
                                });
                              },
                            );
                          },
                        )
                    ),
                  ],
                ),
                subtitle: Form(
                  key: _formKey[2],
                  child: ListTile(
                    trailing: Icon(Icons.keyboard),
                    contentPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    title: TextFormField(
                      maxLines: 1,
                      maxLength: 100,
                      style: TextStyle(
                          color: formColor,
                          fontSize: 15
                      ),
                      cursorColor: formColor,
                      controller: tempTEC[7],
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          labelStyle: formStyle,
                          hintText: 'Write about skills',
                          labelText:  'Skills Description',
                          hintStyle: TextStyle(fontSize: 12),
                          focusedBorder: InputBorder.none,
//                              prefixIcon: Icon(Icons.person, color: formColor),
                          border: InputBorder.none
                      ),
                      validator: (value) {
                        if(value.isEmpty) {
                          validateOth();
                          return 'Please write some description';
                        }
                        return null;
                      },
                    ),
//                        trailing: Icon(Icons.keyboard),
                  ),
                ),
              ),
              skillNeedError(),
              ListTile(
                title: ExpansionTile(
                  title: Text(
                    "Experience Needed : $exSelection",
                    style: formStyle, /* textAlign: TextAlign.center*/
                  ),
                  children: <Widget>[
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.experience.length,
                      itemBuilder: (BuildContext context, i) {
                        return RadioListTile(
//                          subtitle: Text('companyName'),
                          groupValue: exSelection,
                          value: widget.experience[i],
                          selected: false,
                          title: Text('${widget.experience[i]}',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Times New Roman')),
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
              exSelError(),
              Padding(padding: EdgeInsets.all(width / 10)),
              RaisedButton(
                textColor: Colors.cyan[100],
                color: formColor,
                child: Text('CREATE  ACCOUNT'),
                onPressed: () async{
                  print(widget.skillsNeeded);
                  bool validate = true;
                  for(int i=0; i<3; i++) {
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
//                    print(tempTEC.length);
                    for (int i = 0; i < tempTEC.length; i++) userData.add(tempTEC[i].text);
                    bool isSuccess = await signUpState().signUpWithEmailAndPassword(
                        true, userData, context, jobSelection, exSelection, widget.skillsNeeded, null, null,gender
                    );
                    if(isSuccess) {
                      _formKey[0].currentState.reset();
                      _formKey[1].currentState.reset();
                      _formKey[2].currentState.reset();
                      for(int i =0 ;i < tempTEC.length; i++){
//                        print(tempTEC[i].text);
                        tempTEC[i].clear();
                        //  print(userData[i]);
                      }
                      print('..');
                      exSelection = '';
                      typeSelection = '';
                      jobSelection = '';
                      widget.skillsNeeded.clear();
                    }
                  } // if Validate....
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget jobSelError() {
    if(jobSelFlag)
      return Text('Select Looking For : section',
        style: TextStyle(color: Colors.red[700],fontSize: 12),
      );
    else return Container();
  }

  Widget skillNeedError() {
    if(skillNeedFlag)
      return Text('Select atLeast 1 skill',
        style: TextStyle(color: Colors.red[700],fontSize: 12),
      );
    else return Container();
  }

  Widget exSelError() {
    if(exSelFlag)
      return Text('Select Looking For : section',
        style: TextStyle(color: Colors.red[700],fontSize: 12),
      );
    else return Container();
  }

  validateOth() {
    if(jobSelection == '< Select >') setState(() => jobSelFlag = true);
    else setState(() => jobSelFlag = false);
    if(widget.skillsNeeded.isEmpty) setState(() => skillNeedFlag = true);
    else setState(() => skillNeedFlag = false);
    if(exSelection == '< Select >') setState(() => exSelFlag = true);
    else setState(() => exSelFlag = false);
  }
}