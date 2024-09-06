import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/src/workmanager.dart';
import 'package:workmanager/workmanager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'AppRetainWidget.dart';
const myTask = "syncWithTheBackEnd";
void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String latitude = 'waiting...';
  String longitude = 'waiting...';
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppRetainWidget(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Background Location Service'),
          ),
          body: Center(
            child: ListView(
              children: <Widget>[
                locationData('Latitude: ' + latitude),
                locationData('Longitude: ' + longitude),
                locationData('Altitude: ' + altitude),
                locationData('Accuracy: ' + accuracy),
                locationData('Bearing: ' + bearing),
                locationData('Speed: ' + speed),
                locationData('Time: ' + time),
                ElevatedButton(
                    onPressed: () async {
                      await BackgroundLocation.setAndroidNotification(
                        title: 'Background service is running',
                        message: 'Background location in progress',
                        icon: '@mipmap/ic_launcher',
                      );
                      await BackgroundLocation.startLocationService(
                          distanceFilter: 1);
                      BackgroundLocation.getLocationUpdates((location) {


                        setState(() {
                          Timer? countdownTimer;
                          var isTimerRuning = false;
                          isTimerRuning = true;
                          countdownTimer = Timer.periodic(Duration(seconds: 60), (t) {

                            // controllerANNOUNCE;
                            http.get(Uri.parse("http://devalpha.vitwo.ai/api/v2/claimz.php?device=987656hh&lat=${location.latitude}&lng=${location.longitude}"),);


                          });
                          final channel = WebSocketChannel.connect(
                            Uri.parse('wss://echo.websocket.events'),
                          );
                          channel.sink.add('${location.latitude.toString()+" | "+location.longitude.toString()}');

                          Fluttertoast.showToast(
                              msg: "MyLocation ${location.latitude.toString()+" | "+location.longitude.toString()}",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                          /*Timer? countdownTimers;
                          var isTimerRunings = false;
                          isTimerRunings = true;
                          countdownTimers = Timer.periodic(Duration(seconds: 5), (t) {
                            Fluttertoast.cancel();
                          });*/



                          latitude = location.latitude.toString();
                          longitude = location.longitude.toString();
                          accuracy = location.accuracy.toString();
                          altitude = location.altitude.toString();
                          bearing = location.bearing.toString();
                          speed = location.speed.toString();
                          time = DateTime.fromMillisecondsSinceEpoch(
                              location.time!.toInt())
                              .toString();
                        });
                        print('''\n
                          Latitude:  $latitude
                          Longitude: $longitude
                          Altitude: $altitude
                          Accuracy: $accuracy
                          Bearing:  $bearing
                          Speed: $speed
                          Time: $time
                        ''');
                      });
                    },
                    child: Text('Start Location Service')),
                ElevatedButton(
                    onPressed: () {
                      BackgroundLocation.stopLocationService();
                    },
                    child: Text('Stop Location Service')),
                ElevatedButton(
                    onPressed: () {
                      getCurrentLocation();
                    },
                    child: Text('Get Current Location')),
                SizedBox(height: 100,),
                StreamBuilder(
                  stream: channel.stream,
                  builder: (context, snapshot) {
                    print("Show Socket LatLong ${snapshot.data}");
                    return Text(snapshot.hasData ? '${snapshot.data}' : '');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget locationData(String data) {
    return Text(
      data,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  void getCurrentLocation() {
    BackgroundLocation().getCurrentLocation().then((location) {
      print('This is current Location ' + location.toMap().toString());
    });
  }

  @override
  void dispose() {
    // BackgroundLocation.stopLocationService();
    super.dispose();
  }

}
void callbackDispatcher() {
  Workmanager().executeTask((task) {
    switch (task) {
      case myTask:
        print("this method was called from native!");
        break;
      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }

    //Return true when the task executed successfully or not
    return Future.value(true);
  } as BackgroundTaskHandler);
}
