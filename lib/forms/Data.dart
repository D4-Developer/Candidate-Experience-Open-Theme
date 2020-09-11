class StateModel {
  String type;
  List<String> jobs;
  StateModel({this.type, this.jobs});
  StateModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    jobs = json['jobs'].cast<String>();
  }
}

List selectionTypes = [
  {
    'type' : 'Automobile',
    'jobs': [
      'Automobile engineer',
      'Electrical engineer',
      'Mechanical engineer',
    ]
  },
  {
    'type' : 'Bio-Medical',
    'jobs': [
      'Bio-Medical engineer',
    ]
  },
  {
    'type' : 'Chemical',
    'jobs': [
      'Chemical engineer',
      'Plastic engineer',
      'Rubber engineer',
    ]
  },
  {
    'type' : 'E-Commerce',
    'jobs': [
      'Android Developer',
      'IOS Developer',
      'Web Developer',
      'UI / UX Designer'
    ]
  },
  {
    'type' : 'Education And Training',
    'jobs': [
      'App Developer',
      'Contenet Maker',
      'Web Developer',
      'Marketing',
      'UI / UX Designer'
    ]
  },
  {
    'type' : 'Electrical',
    'jobs': [
      'Electical engineer',
    ]
  },
  {
    'type' : 'Infrastructure',
    'jobs': [
      'Architect',
      'Civil engineer',
    ]
  },
  {
    'type' : 'IT',
    'jobs': [
      'Android Developer',
      'BackEnd Developer',
      'FrontEnd Developer',
      'FullStack Developer',
      'UI / UX Designer',
    ]
  },
  {
    'type' : 'Manufacturing',
    'jobs': [
      'Designer',
      'Chemical engineer',
      'Electrical engineer',
      'Mechanical engineer',
    ]
  },
  {
    'type' : 'Machinary',
    'jobs': [
      'Designer',
      'Electrical engineer',
      'Mechanical engineer',
    ]
  },
  {
    'type' : 'Oil and Gas',
    'jobs': [
      'Chemical engineer',
      'Petroleum engineer',
    ]
  },
  {
    'type' : 'PowerPlant',
    'jobs': [
      'Electrical engineer',
    ]
  },
  {
    'type' : 'Software',
    'jobs': [
      'Back-End Developer',
      'Maintainance officer',
      'Security officer',
    ]
  },
  {
    'type' : 'TextTile',
    'jobs': [
      'Chemical engineer',
      'TextTile engineer',
    ]
  },
];

class SkillModel {
  String job;
  List skills;
  SkillModel({this.job, this.skills});

  SkillModel.fromJson(Map<String, dynamic> json){
    job = json['job'];
    skills = json['skills'].cast<String>();
  }
}

List skillsByRole = [
  {
    'job': 'Android Developer',
    'skills': [
      'Android Studio',
      'Java & XML',
      'FireBase',
      'Kotlin',
      'Material Design'
    ]
  },
  {
    'job': 'Flutter Developer',
    'skills': [
//      'Dart Core / Advanced',
      'Flutter & Dart Core / Advanced',
      'FireBase',
      'Material Design'
    ]
  },
  {
    'job': 'IOS Developer',
    'skills': [
      'Cocoa Touch',
      'Swift',
      'Xcode'
    ]
  },
  {
    'job': 'BackEnd Developer',
    'skills': [
      'Java',
      'FireBase',
      'Kotlin',
      'MySql',
      'Node.js',
      'Php',
      'Python',
      'Ruby'
    ]
  },
  {
    'job': 'FrontEnd Developer',
    'skills' : [
      'Css',
      'CSS preprocessor',
      'JavaScript/jQuery',
      'JavaScript Frameworks',
      'UI/UX Design'
    ]
  },
  {
    'job': 'Full-Stack Developer',
    'skills' : [
      'Css',
      'Java',
      'JavaScript',
      'FireBase',
      'Kotlin',
      'MySql',
      'Node.js',
      'Php',
      'Python',
      'UI/UX Design'
    ]
  },
  {
    'job': 'Web Developer',
    'skills' : [
      'BackEnd Developer',
      'FrontEnd Developer',
      'FullStack Developer',
    ]
  },
  {
    'job': 'UI / UX Designer',
    'skills' : [
      'Adobe Xd',
      'AfterEffexts',
      'Photoshop',
      'WireFraming'
    ]
  },
  {
    'job': 'Electrical engineer',
    'skills' : [
      'Arduino',
      'Circuit Designing',
      'Designing',
      'IOT',
      'MATLAB',
      'Programming',
      'Raspberry pi'
    ]
  },
  {
    'job': 'Mechanical engineer',
    'skills' : [
      'Ansys',
      'AutoCAD',
      'Designing',
      'IOT',
      'NX CAM',
      'SolidWorks',
    ]
  },
  {
    'job': 'Civil engineer',
    'skills' : [
      'AutoCAD / SketchUP',
      'Revit / Tekla',
      'Staad Pro / E Tabs',
      '3DS Max / V Ray'
    ]
  },
  {
    'job': 'Chemical engineer',
    'skills' : [
      'Aspen(Plus-HYSYS) / SimSci PRO',
      'MATLAB',
    ]
  },
  {
    'job': 'Petroleum engineer',
    'skills' : [
      'Aspen HTSYS',
      'ECLIPSE',
      'GAP',
    ]
  },
  {
    'job': 'Automobile engineer',
    'skills' : [
      'Ansys',
      'AutoCAD',
      'Desining',
      'SolidWorks'
    ]
  },
  {
    'job': 'Bio-Medical engineer',
    'skills' : [
      'Designing / Developing / Testing',
      'Strong Mathematics'
    ]
  },
  {
    'job': 'Rubber engineer',
    'skills' : [

    ]
  },
  {
    'job': 'Plastic engineer',
    'skills' : []
  },
  {
    'job': 'Computer engineer',
    'skills' : [
      'AI',
      'C++',
      'Designing',
      'Css/JavaScript',
      'Java',
      'Kotlin',
      'ML',
      'Node.js/MySql/Php',
    ]
  },
];

List <String> ff = [
  ''
];