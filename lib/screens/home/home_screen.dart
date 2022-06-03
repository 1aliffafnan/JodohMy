import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../authenticate/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;

  Future<UserModel> getUserModel() async {
    UserModel usermodel;
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    usermodel = UserModel.fromMap(data.data());

    return usermodel;
  }

  Future<List<UserModel>> getData() async {
    final List<UserModel> list = [];

    final data = await FirebaseFirestore.instance.collection('users').get();

    final UserModel userModel = await getUserModel();

    String? userGender = userModel.gender;

    for (var e in data.docs) {
      String gender = e['gender'];
      String name = e['name'];
      String age = e['age'];
      String state = e['state'];

      UserModel userModel = UserModel(name: name, age: age, state: state);

      if (userGender == 'Female' && gender == 'Male')
        list.add(userModel);
      else if (userGender == 'Male' && gender == 'Female') list.add(userModel);
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Welcome to Awek Lejen"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  logout(context);
                },
                child: const Icon(Icons.logout)),
          ],
        ),
        body: Center(
            child: FutureBuilder<List<UserModel>>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return CircularProgressIndicator();

                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = snapshot.data;

                    return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Center(
                            child: Container(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    child: ListTile(
                                        onTap: () {},
                                        leading: Icon(Icons.person),
                                        title: Text(data[index].name!),
                                        subtitle: Text("${data[index].age!} years old"),
                                        trailing: IconButton(
                                            splashColor: (Colors.blueAccent),
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.favorite,
                                            ))),
                                  ),
                                ],
                              ),
                            )),
                          );
                        });
                  } else
                    return Container();
                })));
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
