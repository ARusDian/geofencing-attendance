
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loginakunabsen/model/attendance.dart';
import 'package:loginakunabsen/model/users.dart';
import 'package:loginakunabsen/user/attendanceinfopage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FormAbsen extends StatelessWidget {

  final UserData user;

  FormAbsen({ Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Kehadiran'),
      ),
      body: ListAbsen(user : user),
    );
  }
}


class ListAbsen extends StatefulWidget {

  final UserData user;

  const ListAbsen({Key? key, required this.user}) : super(key: key);

  @override
  _ListAbsenState createState() => _ListAbsenState(user : user);
}


class _ListAbsenState extends State<ListAbsen>{

  List<AttendanceData> ListData = [];

  final UserData user;
  _ListAbsenState({
    required this.user
    });

  _getDataAttendance() async {
    // final response = await http.get(Uri.http('192.168.56.1:8080','/flutter/testhttp/user.php'));
    final response = await http.get(Uri.https('geolocattend.000webhostapp.com','/attendance.php',{'id_user' : this.user.id_user.toString()}),
                                    headers: {HttpHeaders.contentTypeHeader: 'application/json',});
    print(response.body.toString());
    ListData = <AttendanceData>[
    for (var data in convert.jsonDecode(response.body))
      AttendanceData.fromJSON(data)
    ];
  }
  @override
  void initState() {
    _getDataAttendance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 127, 195, 255)
        ),
      child:Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.only(top:20, left: 10, right: 10),
                padding: const EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 58, 183, 62),
                  borderRadius: BorderRadius.circular(10)
                  ),
                child: TextButton(
                  onPressed: (){setState(() {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => AttendanceInfoPage(user: user,))).then((value) { setState(() {
                    _getDataAttendance();
                    });});
                  });},
                  child: Text(
                    "Absen",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top:20, left: 10, right: 10),
                padding: const EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 211, 211, 44),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: TextButton(
                  onPressed: (){setState(() {
                    _getDataAttendance();
                  });},
                  child: Text(
                    "Refresh",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            ],
          ),
          Flexible(
            child:Container(
              margin: const EdgeInsets.all(10),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return  Container(
                    height: 150,
                    decoration: BoxDecoration(border:Border.all(color: Colors.black87)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text((index+1).toString()),
                            Text(ListData[index].attendance_status),
                            Text(ListData[index].location_name),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(DateFormat('kk:mm:ss \n EEE d MMM').format(ListData[index].timestamp)),
                            Text(ListData[index].status),
                            Text(user.user_name),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(ListData[index].latitude),
                            Text(ListData[index].longitude),
                          ],
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index){
                  return const SizedBox(height: 10);
                },
                itemCount: ListData.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}