import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

enum Genders {Pria, Wanita}


enum ErrorStatusMSG{
  Normal,
  WrongEmailPassword,
  FillFormsRequired,
  NotEqualPasswords,
  ServerError,
}

class _RegistrationState extends State<Registration> {

  Genders? _gender = Genders.Pria;

  ErrorStatusMSG status = ErrorStatusMSG.Normal;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifPasswordController = TextEditingController();

  void _showToast(BuildContext context,String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  void _registerFunc() async{
    if(_nameController.text != "" || _emailController.text != "" || _passwordController.text != "" || _verifPasswordController.text != ""){
      if(_passwordController.text == _verifPasswordController.text){
        final response = await http.post(
          Uri.http('geolocattend.000webhostapp.com','/user.php'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, dynamic>{
            'user_name': _nameController.text,
            'user_email': _emailController.text,
            'user_password': _passwordController.text,
            'gender': _gender.toString().substring(8),
            'rank': "Pengguna",
            'created_at': DateTime.now().toString(),
            'updated_at': DateTime.now().toString(),
            'deleted_at': "0000-00-00 00:00:00"
          }),
        );
        _showToast(context, response.body.toString());
        Navigator.pop(context);
      }
      else{
        setState(() {
          status = ErrorStatusMSG.NotEqualPasswords;
        });
      }
    }
    else{
      setState(() {
          status = ErrorStatusMSG.FillFormsRequired;
        });
    }
  }

  Widget allertMessage(){
    String allertMessageText = " ";
    if(status == ErrorStatusMSG.Normal ){
      return Container();
    }
    else{
      if (status == ErrorStatusMSG.NotEqualPasswords){
        allertMessageText = "Password yang anda Masukkan tidak sesuai dengan password verifikasi";
      }
      else if (status == ErrorStatusMSG.FillFormsRequired){
        allertMessageText = "Pastikan data sudah terisi semua";
      }
      else if (status == ErrorStatusMSG.ServerError){
        allertMessageText = "Terjadi Masalah pada server";
      }
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 2
            ),
          color: const Color.fromARGB(255, 255, 143, 143)
        ),
        child: Text(
          allertMessageText,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Registrasi'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 154, 242, 255)
        ),
        child: Container(
          margin: EdgeInsets.all(50),
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    helperText: "Masukkan Nama Anda"
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    helperText: "Masukkan Email Anda"
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    helperText: "Masukkan Password Anda"
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _verifPasswordController,
                  decoration: const InputDecoration(
                    helperText: "Masukkan Password Yang Sama"
                  ),
                ),
              ),
              Container(
                height: 150,
                child: Column(
                  children: [
                    RadioListTile<Genders>(
                      value: Genders.Pria,
                      title: Text("Pria"),
                      groupValue: _gender,
                      onChanged: (Genders? value){
                        setState(() {
                          _gender = value;
                        });
                      }
                    ),
                    RadioListTile<Genders>(
                      value: Genders.Wanita,
                      title: Text("Wanita"),
                      groupValue: _gender,
                      onChanged: (Genders? value){
                        setState(() {
                          _gender = value;
                        });
                      }
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5, left: 20, right: 20, bottom:5),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextButton(
                  onPressed: _registerFunc,
                    child: Text("Register")
                ),
              ),
              allertMessage()
            ],
          ),
        )
      ),
    );
  }
}