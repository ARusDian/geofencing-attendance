import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginakunabsen/model/users.dart';
import 'package:loginakunabsen/model/homebase.dart';
import 'package:poly_geofence_service/poly_geofence_service.dart';
import 'package:geolocator/geolocator.dart' as coordinates;
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class AttendanceInfoPage extends StatefulWidget{

  UserData user;

  AttendanceInfoPage({required this.user});

  @override
  _AttendanceInfoPageState createState() => _AttendanceInfoPageState(user: user);
}

class _AttendanceInfoPageState extends State<AttendanceInfoPage>{


  UserData user;

  _AttendanceInfoPageState({required this.user});

  String bujur = "";
  String lintang = "";
  final _streamController = StreamController<PolyGeofence>.broadcast();

  final _polyGeofenceService = PolyGeofenceService.instance.setup(
      interval: 1000,
      accuracy: 100,
      loiteringDelayMs: 6000,
      statusChangeDelayMs: 1000,
      allowMockLocations: false,
      printDevLog: false);

  final List<PolyGeofence> _polyGeofenceList =<PolyGeofence>[
      for(HomeBase homebase in ListHomeBases)
        PolyGeofence(
          id: homebase.base_name,
          data: {
            'address' : homebase.address,
            'about' : homebase.address
          },
          polygon: <LatLng>[for(List cordinate in homebase.base_polygon) LatLng(cordinate[0], cordinate[1])]
        ),
    ];

  Future<void> _onPolyGeofenceStatusChanged(
      PolyGeofence polyGeofence,
      PolyGeofenceStatus polyGeofenceStatus,
      Location location) async {
    print('polyGeofence: ${polyGeofence.toJson()}');
    print('polyGeofenceStatus: ${polyGeofenceStatus.toString()}');
    _streamController.sink.add(polyGeofence);
  }

  void _onLocationChanged(Location location) {
    print('location: ${location.toJson()}');
  }

  void _onLocationServicesStatusChanged(bool status) {
    print('isLocationServicesEnabled: $status');
  }

  void _onError(error) {
    final errorCode = getErrorCodesFromError(error);
    if (errorCode == null) {
      print('Undefined error: $error');
      return;
    }

    print('ErrorCode: $errorCode');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _polyGeofenceService.addPolyGeofenceStatusChangeListener(_onPolyGeofenceStatusChanged);
      _polyGeofenceService.addLocationChangeListener(_onLocationChanged);
      _polyGeofenceService.addLocationServicesStatusChangeListener(_onLocationServicesStatusChanged);
      _polyGeofenceService.addStreamErrorListener(_onError);
      _polyGeofenceService.start(_polyGeofenceList).catchError(_onError);
    });
    // requestPermission();
  }

  void requestPermission() async{
    bool serviceEnabled;
    coordinates.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await coordinates.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await coordinates.Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await coordinates.Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
    coordinates.Position position = await coordinates.Geolocator.getCurrentPosition(desiredAccuracy: coordinates.LocationAccuracy.high);
    lintang = position.latitude.toString();
    bujur = position.longitude.toString();
  }

  void _showToast(BuildContext context,String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder<PolyGeofence>(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        requestPermission();
        final updatedDateTime = DateTime.now();
        var content = snapshot.data?.toJson();
        final _statusController = TextEditingController(text: ((content?['status'].toString().substring(19)=="EXIT")?null:content?['status'].toString().substring(19)) ?? "Diluar Kantor");
        final _waktuController = TextEditingController(text: DateFormat('kk:mm:ss \n EEE d MMM').format(updatedDateTime));
        final _lintangController = TextEditingController(text: lintang);
        final _bujurController = TextEditingController(text:  bujur);
        final _lokasiController = TextEditingController(text:content?['id'].toString()?? "Tidak Ditemukan");
        return Scaffold(
          body: Container(
            margin: const EdgeInsets.only(top:80, left:30, right:30),
            child:Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _waktuController,
                        decoration: InputDecoration(
                          helperText: "Waktu",
                          contentPadding: EdgeInsets.all(20)
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        // controller: _statusController,
                        decoration: InputDecoration(
                          helperText: "Status",
                          labelText: "Hadir"
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _lintangController,
                        decoration: const InputDecoration(
                          helperText: "Kordinat Lintang",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _bujurController,
                        decoration: InputDecoration(
                          helperText: "Kordinat Bujur",
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _statusController,
                        decoration: InputDecoration(
                          helperText: "Status Lokasi",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        controller: _lokasiController,
                        decoration: InputDecoration(
                          helperText: "Lokasi Kantor",
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: (() {
                          Navigator.pop(context);
                        }),
                        child: Text("Batal"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: (() {
                          setState(()async {
                            final response = await http.post(
                              Uri.http('geolocattend.000webhostapp.com','/attendance.php'),
                              headers: <String, String>{
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode(<String, dynamic>{
                                'id_user': user.id_user,
                                'location_name': _lokasiController.text,
                                'longitude': _bujurController.text,
                                'latitude':_lintangController.text,
                                'status': _statusController.text,
                                'attendance_status': "Hadir",
                                'timestamp': DateTime.now().toString(),
                              }),
                            );
                            _showToast(context,response.body.toString());
                            Navigator.pop(context);
                          });
                        }),
                        child: Text("Absen"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Container(
                  child: TextButton(
                    onPressed: (() {
                      setState(() {
                        _polyGeofenceService.stop();
                        _polyGeofenceService.start(_polyGeofenceList).catchError(_onError);
                        requestPermission();
                      });
                    }),
                    child: Text("Refresh"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}