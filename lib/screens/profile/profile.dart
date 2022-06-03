import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:jodoh_my/screens/profile/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;

  // Stream<UserModel> getUserModel() async* {
  //   UserModel usermodel;
  //   final data = await FirebaseFirestore.instance.collection("users").doc(user!.uid).snapshots();
  //   usermodel = UserModel.fromMap(data.data());
  //   yield usermodel;
  // }

  Future<UserModel> getUserModel2() async {
    UserModel usermodel;
    final data = await FirebaseFirestore.instance.collection("users").doc(user!.uid).get();
    usermodel = UserModel.fromMap(data.data());
    return usermodel;
  }

  // String? name = '';
  // String? location = '';
  // String biodata =
  //     'Saya Suka Ayam, Hari hari saya makan ayam, ayam goreng sangat sedap laa saya rasa, awak suka ayam tak, suka laa saya';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return CircularProgressIndicator();
        else if (snapshot.connectionState == ConnectionState.active) {
          final Map data = (snapshot.data as DocumentSnapshot).data() as Map<String,dynamic>;
          String? name = data['name'];
          String? state = data['state'];
          String? age = data['age'];
          String? biodata = data['biodata'];
          return Scaffold( 
            body: Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/jodoh.png"),
                          fit: BoxFit.cover,
                          colorFilter:
                              ColorFilter.mode(Colors.deepPurple, BlendMode.hue)),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(height: 80),
                          CircleAvatar(
                            backgroundImage: AssetImage('assets/dog.jpg'),
                            radius: 50,
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditProfile(name: 'name')));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(child: Text('Edit Profile Ayamas')),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                Text(name ?? 'You dont have name',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                Text("$age years old"),
                 
                 Text(state ?? 'Your gay'),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(40, 10, 40, 20),
                      child: Text(biodata ?? "Mana biodata kau")),
                  Text('Interest', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        else return Container();
      }
    );
  }
}
