import 'package:flutter/material.dart';
import 'package:loginakunabsen/model/users.dart';
import 'package:loginakunabsen/user/profile.dart';
import 'package:loginakunabsen/user/form_absen.dart';

class MainPage extends StatelessWidget {

  final UserData user;

  MainPage({required UserData this.user});

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(user : user);
  }
}

class BottomNavBar extends StatefulWidget {

  final UserData user;
  BottomNavBar({required UserData this.user});

  @override
  _BottomNavBarState createState() => _BottomNavBarState(user : user);
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndexPage = 0;

  final UserData user;

  _BottomNavBarState({required UserData this.user});
  
  Widget getPage(int index){
    switch(index){
      case 0:
        return Profile(user : user);
      case 1:
        return FormAbsen(user : user);
      default:
        return Profile(user : user);
    }
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndexPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 164, 255),
      body: getPage(_selectedIndexPage),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person_outline_sharp),
            label : "Profil"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            activeIcon: Icon(Icons.calendar_month_rounded),
            label : "Absen"
          ),
        ],
        currentIndex: _selectedIndexPage,
        onTap: _onItemTap,
        ),
    );
  }
}