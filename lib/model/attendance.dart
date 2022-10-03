import 'package:intl/intl.dart';

class AttendanceData{
  int id_attendance;
  int id_user;
  String status;
  String location_name;
  String latitude;
  String longitude;
  String attendance_status;
  DateTime timestamp;

  AttendanceData({
    required this.id_attendance,
    required this.id_user,
    required this.status,
    required this.location_name,
    required this.latitude,
    required this.longitude,
    required this.attendance_status,
    required this.timestamp,
  });

  factory AttendanceData.fromJSON(Map<String, dynamic> json) {
    print(json.toString());
    return AttendanceData(
        id_attendance: int.parse(json['id']),
        id_user: int.parse(json['id_user']),
        status: json['status'],
        location_name: json['location_name'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        attendance_status: json['attendance_status'],
        timestamp: DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['timestamp']),
      );
  }
}

var ListAttendance = <AttendanceData>[];
