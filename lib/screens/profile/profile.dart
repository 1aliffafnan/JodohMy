import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jodoh_my/screens/authenticate/login_screen.dart';
import 'package:jodoh_my/screens/home/home_screen.dart';
import 'package:jodoh_my/screens/profile/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String name = 'Anjing';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => EditProfile(name: name))
              );
            },
            child: Text('Edit Profile'),
          ),
        ],
      ),
      body: Container()
    );
  }
}