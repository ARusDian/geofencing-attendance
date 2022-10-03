import 'package:flutter/material.dart';
import 'package:loginakunabsen/model/users.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {

  UserData user;

  Profile({ Key? key,required UserData this.user }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Anda'),
      ),
      body:Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 127, 195, 255)
          ),
        child: Container(
          margin: const EdgeInsets.all(10),
          child: ListView(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: const Color.fromARGB(255, 76, 146, 251),
                  ),
                  child: const Icon(Icons.account_circle, size: 75,),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child :Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child:Text("Nama Lengkap"),
                        ),
                        Expanded(
                          flex: 3,
                          child:TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: user.user_name,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child:Text("Email"),
                        ),
                        Expanded(
                          flex: 3,
                          child:TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: user.user_email,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child:Text("Gender"),
                        ),
                        Expanded(
                          flex: 3,
                          child:TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: user.gender,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}