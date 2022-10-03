import 'package:intl/intl.dart';

class UserData{
  int id_user;
  String user_name;
  String user_email;
  String user_password;
  String gender;
  String rank;
  DateTime created_at;
  DateTime updated_at;
  DateTime? deleted_at= null;


  UserData({
    required this.id_user,
    required this.user_name,
    required this.user_email,
    required this.user_password,
    required this.gender,
    required this.rank,
    required this.created_at,
    required this.updated_at,
    required this.deleted_at
  });

  Map<String, dynamic> toMap() {
    return {
      "id_user" : this.id_user,
      "user_name" : this.user_name,
      "user_email" : this.user_email,
      "user_password" : this.user_password,
      "gender" : this.gender,
      "rank" : this.rank,
      "created_at" : this.created_at,
      "updated_at" : this.updated_at,
      "deleted_at" : this.deleted_at,
    };
  }

  factory UserData.fromJSON(Map<String, dynamic> json) {
    print(json.toString());
    return UserData(
        id_user: int.parse(json['id']),
        user_name: json['user_name'],
        user_email: json['user_email'],
        user_password: json['user_password'],
        gender: json['gender'],
        rank: json['rank'],
        created_at: DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['created_at']),
        updated_at: DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['updated_at']),
        deleted_at: DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['deleted_at']),
      );
  }
}

// var ListUsers = <UserData>[
//   UserData(
//     id_user: 1,
//     user_name: "ruxne",
//     user_email: "ruxne.galleon@gmail.com",
//     user_password: "ruxne1234",
//     gender: "Pria",
//     rank: "SuperAdmin",
//     created_at: DateTime.now(),
//     updated_at: DateTime.now(),
//   ),
//   UserData(
//     id_user: 2,
//     user_name: "dyne",
//     user_email: "dyne@gmail.com",
//     user_password: "dyne1234",
//     gender: "Pria",
//     rank: "SuperAdmin",
//     created_at: DateTime.now(),
//     updated_at: DateTime.now(),
//   ),
// ];
