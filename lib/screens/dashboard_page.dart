import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_tinker/res/palette.dart';
import 'package:plant_tinker/widgets/dashboard/humidity_chart.dart';
import 'package:plant_tinker/widgets/dashboard/light_chart.dart';
import 'package:plant_tinker/widgets/dashboard/moisture_chart.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  final User user;

  const DashboardPage({required this.user});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _plantDataStream =
      FirebaseFirestore.instance
          .collection('plant')
          .where('timestamp',
              isGreaterThan:
                  (DateTime.now().millisecondsSinceEpoch - 43200000) ~/ 1000)
          .orderBy('timestamp')
          // .limitToLast(200)
          .snapshots();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Palette.blue_gray,
      statusBarIconBrightness: Brightness.light,
    ));
    // print((DateTime.now().millisecondsSinceEpoch - 43200000) ~/ 1000);
    return Scaffold(
      backgroundColor: Palette.blue_gray,
      // appBar: AppBar(
      //   elevation: 0,
      //   backgroundColor: Palette.blue_gray,
      //   centerTitle: true,
      //   title: Text(
      //     'PlantTinker',
      //     style: TextStyle(
      //       fontSize: 26.0,
      //       color: Palette.neon_green,
      //       letterSpacing: 2,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _plantDataStream,
          builder:
              (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }

            if (snapshot.data != null) {
              final retrievedDocs = snapshot.data!.docs;
              print(retrievedDocs.length);

              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Palette.green_accent.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Health',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 1,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                      Text(
                                        'Good',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1,
                                          fontSize: 24.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.0),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.info,
                                        size: 26.0,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 4.0),
                                      Expanded(
                                        child: Text(
                                          'The moisture content of the plant is alright',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Temperature',
                            style: TextStyle(
                              color: Palette.blue_accent,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 30.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            retrievedDocs.last
                                    .data()['temperature']
                                    .toString() +
                                '°C',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 50.0,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Humidity',
                            style: TextStyle(
                              color: Palette.blue_accent,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 30.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            retrievedDocs.last.data()['humidity'].toString() +
                                '%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 50.0,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Moisture',
                            style: TextStyle(
                              color: Palette.blue_accent,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 30.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            (retrievedDocs.last.data()['moisture'] as double)
                                    .toStringAsFixed(2) +
                                '%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 50.0,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Light',
                            style: TextStyle(
                              color: Palette.blue_accent,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 30.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            (retrievedDocs.last.data()['light'])
                                    .toStringAsFixed(0) +
                                '%',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                              fontSize: 50.0,
                            ),
                          ),
                          SizedBox(height: 24.0),
                          MoistureChart(
                            docs: retrievedDocs,
                          ),
                          SizedBox(height: 24.0),
                          HumidityChart(
                            docs: retrievedDocs,
                          ),
                          SizedBox(height: 24.0),
                          LightChart(
                            docs: retrievedDocs,
                          ),
                          SizedBox(height: 24.0),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 85.0),
                          child: Image.asset(
                            'assets/plant_shadow.png',
                            height: 500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              // return Container();
            }

            return Container();
          },
        ),
      ),
    );
  }
}
