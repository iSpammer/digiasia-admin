import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:TWatch_Manager/models/analytic_info_model.dart';
import 'package:TWatch_Manager/widgets/analytic_info_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants/constants.dart';
import '../../constants/responsive.dart';
import '../../utils/TWatchData.dart';
import '../../widgets/analytic_cards.dart';


class HeartChart extends StatefulWidget {
  final String device;
  HeartChart({super.key, required this.device});

  List<Color> get availableColors => const <Color>[
        Color(0xFF6E1BFF),
        Color(0xFFFFC300),
        Color(0xFF2196F3),
        Color(0xFFFF683B),
        Color(0xFFFF3AF2),
        Color(0xFFE80054),
      ];

  final Color barBackgroundColor = Colors.black.withOpacity(0.3);
  final Color barColor = Colors.black;
  final Color touchedBarColor = Color(0xFF3BFF49);

  @override
  State<StatefulWidget> createState() => HeartChartState();
}

class HeartChartState extends State<HeartChart> {
  final Duration animDuration = const Duration(milliseconds: 250);
  List<double>? histogramData = [];
  List<TWatchData>? myList = [];
  int touchedIndex = -1;
  QuerySnapshot? querySnapshot;
  bool isPlaying = false;
  TWatchData? lastData;

  @override
  void initState() {
    initCollection();
    super.initState();
  }

  Future<void> initCollection() async {
    getData();
  }

  //get the data from the firebase firestore server, saves into an arraylist
  // Get docs from collection reference
  Future<void> getData() async {
     querySnapshot = await FirebaseFirestore.instance
        .collection(widget.device)
        .orderBy("timeStamp", descending: true)
        .limit(100)
        .get();

    setState(() {
      myList = querySnapshot!.docs
          .map(
            (doc) => TWatchData.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
      histogramData = List<double>.from(myList!.map((e) => e.heartrate));
    });
    // print(querySnapshot.docs.first.data());
    lastData = myList?.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0x44000000),
          elevation: 0,
          title: const Text("Health Data"),
        ),
        body: SizedBox(
            child: myList!.length == 0
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              physics: const ScrollPhysics(),

              child: Column(children: [
                      AnalyticInfoCard(
                          info: AnalyticInfo(
                              title: widget.device.split("@")[0],
                              color: Colors.amber,
                              iconSrc: Icons.devices_other_sharp)),
                      AnalyticCards(
                        list: [
                          AnalyticInfo(
                            title: "Health Status",
                            iconSrc: Icons.query_stats,
                            color: primaryColor,
                            val: lastData!.heartrate.toString()
                          ),
                          AnalyticInfo(
                            title: "X ACC",
                            iconSrc: Icons.electric_bolt_outlined,
                            color: purple,
                            val: lastData!.xacc.toString()
                          ),
                          AnalyticInfo(
                            title: "Y ACC",
                            iconSrc: Icons.monitor_heart_outlined,
                            color: orange,
                            val: lastData!.yacc.toString()
                          ),
                          AnalyticInfo(
                            title: "Z ACC",
                            iconSrc: Icons.air,
                            color: green,
                            val: lastData!.zacc.toString()
                          ),
                        ],
                      ),

                      Container(
                        constraints: const BoxConstraints(maxHeight: 600),
                        child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(),
                            series: <ChartSeries>[

                              BarSeries<TWatchData, String>(
                                  dataSource: myList!,
                                  // display the data
                                  xValueMapper: (TWatchData data, _) =>
                            data.timestamp!.toString(),
                            //           "${data.timestamp!.month}/${data.timestamp!.day} ${data.timestamp!.hour}:${data.timestamp!.hour}:${data.timestamp!.second}",
                                  yValueMapper: (TWatchData data, _) =>
                                      data.heartrate)
                            ]),
                      )
                    ]),
                )));
  }
}
