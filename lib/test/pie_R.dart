import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class pieCharts extends StatefulWidget {
  final double result;
  final isRedirect;
  List<charts.Series<BarChartData, String>> series;
  pieCharts(this.series, this.result, [this.isRedirect = false]);

  @override
  pie_R createState() => pie_R();
}

class pie_R extends State<pieCharts> {
  var width,height;
  Map<String, double> dataMap = Map();
  List<Color> colorList = [
    Colors.green,
    Colors.cyan[400],
  ];

  @override
  void initState() {
    super.initState();
    dataMap.putIfAbsent("Right Answer = ${widget.result}", () => widget.result);
    dataMap.putIfAbsent("Wrong Answer = ${35 - widget.result}", () => 35 - widget.result);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.isRedirect);
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
//    sleep(Duration(microseconds: 1000));
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("TEST ANALYSIS"),
        ),
        body: Card(
          color: Colors.blue[50],
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: PieChart(
                  dataMap: dataMap,
                  animationDuration: Duration(milliseconds: 1200),
                  chartLegendSpacing: 32.0,
                  chartRadius: MediaQuery.of(context).size.width / 2.7,
                  showChartValuesInPercentage: true,
                  showChartValues: true,
                  showChartValuesOutside: false,
                  chartValueBackgroundColor: Colors.lightBlueAccent[100],
                  colorList: colorList,
                  showLegends: true,
                  legendPosition: LegendPosition.right,
                  decimalPlaces: 2,
                  showChartValueLabel: true,
                  chartValueStyle: defaultChartValueStyle.copyWith(
                    color: Colors.blueGrey[700].withOpacity(0.9),
                  ),
                  chartType: ChartType.ring,
                )
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: BarChart(widget.series)
              )
            ],
          ),
        ),
        floatingActionButton: RaisedButton.icon(
          shape: StadiumBorder(),
          label: Text('BACK', textScaleFactor: 1,),
          color: Colors.blue[900],
          textColor: Colors.blue[100],
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            if(widget.isRedirect) {
              Navigator.pop(context);
              Navigator.pop(context);
            }
            else
              Navigator.pop(context);
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}

class BarChartData{
  final String title;
  var result;
  final charts.Color barColor;

  BarChartData(this.title, this.barColor, this.result);
}

class BarChart extends StatelessWidget {
  var width, height;
  final List<charts.Series<BarChartData, String>> series;
  BarChart([this.series]);

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.blue[50],
      child: Center(
        child: Container(
          width: height / 2,
          height: height / 1.9,
          child: charts.BarChart(series, animate: true,
            barGroupingType: charts.BarGroupingType.groupedStacked,
//            behaviors: [new charts.SeriesLegend(showMeasures: true)],
            barRendererDecorator: new charts.BarLabelDecorator<String>(),
          ),
        ),
      ),
    );
  }
}