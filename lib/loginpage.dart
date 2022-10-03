import 'package:loginakunabsen/model/users.dart';
import 'package:loginakunabsen/registration.dart';
import 'package:loginakunabsen/user/main_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<UserData> listUsers = [];
  ErrorStatusMSG status = ErrorStatusMSG.Normal;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  

  Widget allertMessage(){
    if(status == ErrorStatusMSG.WrongEmailPassword){
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
      child: const Text(
        "Email atau Password Salah",
        textAlign: TextAlign.center,
      ),
    );
    }
    else{
      return Container();
    }
  }

  _getDataUser() async {
    // final response = await http.get(Uri.http('192.168.56.1:8080','/flutter/testhttp/user.php'));
    final response = await http.get(Uri.https('geolocattend.000webhostapp.com','/user.php'));
    listUsers = <UserData>[
    for (var data in convert.jsonDecode(response.body))
      UserData.fromJSON(data)
    ];
  }

  void _checklogin(){
    _getDataUser();
    if (listUsers.any((account) => account.user_email == _emailController.text) &&
        listUsers.any((account) => account.user_password == _passwordController.text)){
      UserData user = listUsers.firstWhere((account) => account.user_email == _emailController.text && account.user_password == _passwordController.text);
      status = ErrorStatusMSG.Normal;
      setState(() {
        Navigator.push(context,MaterialPageRoute(builder: (context) => MainPage(user:user) )).then((value) { setState(() {
          _getDataUser();
        });});
      });
    }
    else{
      setState(() {
        status = ErrorStatusMSG.WrongEmailPassword;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getDataUser();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title :const Text("GeoLocPeople"),
        centerTitle:true,
      ),
      body:Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 154, 242, 255)
        ),
          child: Container(
            margin: const EdgeInsets.only(top: 150, left: 25, right: 25),
            child: Column(
              children:<Widget>[
              Flexible(
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    helperText: "Masukkan Email Anda"
                  ),
                ),
              ),
              Flexible(
                child: TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    helperText: "Masukkan Password Anda"
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child:Container(
                      margin: const EdgeInsets.only(top:20, left: 10, right: 10),
                      decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 58, 183, 62),
                      borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextButton(
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white
                            ),
                          ),
                        onPressed: (){
                          setState(() {
                            Navigator.push(context,MaterialPageRoute(builder: (context) => Registration() )).then((value) { setState(() {
                            _getDataUser();
                          });});
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child:Container(
                      margin: const EdgeInsets.only(top:20, left: 10, right: 10),
                      decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 58, 183, 62),
                      borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextButton(
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white
                            ),
                          ),
                        onPressed:(){
                          setState(() {
                            _checklogin();
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              allertMessage(),
            ],
          ),
        ),
      ),
    );
  }
}
