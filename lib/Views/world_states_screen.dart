import 'package:flutter/material.dart';
import 'package:flutter_covid19_tracker_app/Services/Model/WorldStatesModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

import '../Services/states_services.dart';
import 'countries_list.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorsList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa268),
    const Color(0xffde5246),
  ];
  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            FutureBuilder(
                future: statesServices.fetchWorldStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _controller,
                      ),
                    );
                  } else {
                    return Column(children: [
                      PieChart(
                        chartValuesOptions: ChartValuesOptions(
                          showChartValuesInPercentage: true,
                        ),
                        dataMap: {
                          'total':
                              double.parse(snapshot.data!.cases!.toString()),
                          'Recovered':
                              double.parse(snapshot.data!.recovered.toString()),
                          'Deaths':
                              double.parse(snapshot.data!.deaths.toString()),
                        },
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        legendOptions: const LegendOptions(
                          legendPosition: LegendPosition.left,
                        ),
                        animationDuration: const Duration(milliseconds: 1200),
                        chartType: ChartType.ring,
                        colorList: colorsList,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.05),
                        child: Card(
                          child: Column(
                            children: [
                              ReusableRow(
                                title: 'Total',
                                value: snapshot.data!.cases.toString(),
                              ),
                              ReusableRow(
                                title: 'Deaths',
                                value: snapshot.data!.deaths.toString(),
                              ),
                              ReusableRow(
                                title: 'Recovered',
                                value: snapshot.data!.recovered.toString(),
                              ),
                              ReusableRow(
                                title: 'Active',
                                value: snapshot.data!.active.toString(),
                              ),
                              ReusableRow(
                                title: 'Critical',
                                value: snapshot.data!.critical.toString(),
                              ),
                              ReusableRow(
                                title: 'Today Deaths',
                                value: snapshot.data!.todayDeaths.toString(),
                              ),
                              ReusableRow(
                                title: 'Today Recovered',
                                value: snapshot.data!.todayRecovered.toString(),
                              ),
                              ReusableRow(
                                title: 'Affected Countries',
                                value:
                                    snapshot.data!.affectedCountries.toString(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CountriesListScreen()));
                  },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xff1aa268),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text('Track Countries'),
                          ),
                        ),
                      ),
                    ]);
                  }
                })
          ],
        ),
      ),
    ));
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, bottom: 5, left: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
