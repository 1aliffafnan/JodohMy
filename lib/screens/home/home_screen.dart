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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.purple, Colors.purple.shade100]
            ),
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          
          SizedBox(
            height: 130,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.purple, Colors.purple.shade100]
                    ),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.1),
                        spreadRadius: 10,
                        blurRadius: 5,
                        offset: Offset(0, 0)
                      )
                    ]
                  ),
                  child: Text('Welcome to JodohMY', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.1),
                              spreadRadius: 7,
                              blurRadius: 8,
                              offset: Offset(0, 5)
                            )
                          ]
                        ),
                        height: 70,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            SizedBox(width: 30),
                            Icon(Icons.search, color: Colors.grey.shade700),
                            SizedBox(width: 20),
                            Text('Search..', style: TextStyle(fontSize: 16, color: Colors.grey.shade700))
                          ],
                        ),
                      ),
                    )
                  )
                )
              ],
            ),
          ),

          SizedBox(height: 30),

          Container(
            margin: EdgeInsets.only(left: 20),
            child: Text('Find Partner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
          ),

          SizedBox(height: 5),

          SizedBox(
            height: 400,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                BoxContainer(
                  onTap: () {
                    
                  },
                  title: 'Praveena',
                  imageUrl: 'https://64.media.tumblr.com/06aca69fb70f8bd5d339cb71ad494464/94b63cae4b93ec7e-ee/s500x750/a8ed40126e133042c3d661b4e6e33b91b3d63d8f.jpg',
                  biodata: 'Single mother',
                ),
                BoxContainer(
                  onTap: () {
                    
                  },
                  title: 'Fatimah Sudin',
                  imageUrl: 'https://i.pinimg.com/736x/39/38/64/39386416d72ea7646f7f7139766344df.jpg',
                  biodata: 'Saya melayu',
                ),
                BoxContainer(
                  onTap: () {
                    
                  },
                  title: 'Balqis Azmi',
                  imageUrl: 'https://pbs.twimg.com/media/CfR-XeqUMAA7Pb_.jpg',
                  biodata: 'Besar tak abang',
                ),
              ],
            ),
          )

        ],
      ),
    );


    //     body: Center(
    //         child: FutureBuilder<List<UserModel>>(
    //             future: getData(),
    //             builder: (context, snapshot) {
    //               if (snapshot.connectionState == ConnectionState.waiting)
    //                 return CircularProgressIndicator();
    //               if (!snapshot.hasData || snapshot.data == null)
    //                 return Text('No data');
                  
    //                 final data = snapshot.data;

    //                 return ListView.builder(
    //                     itemCount: data!.length,
    //                     itemBuilder: (context, index) {
    //                       return Center(
    //                         child: Padding(
    //                           padding: const EdgeInsets.all(8.0),
    //                           child: Column(
    //                         children: [
    //                           SizedBox(
    //                             child: ListTile(
    //                                 onTap: () {},
    //                                 leading: Icon(Icons.person),
    //                                 title: Text(data[index].name!),
    //                                 subtitle: Text("${data[index].age!} years old"),
    //                                 trailing: IconButton(
    //                                     splashColor: (Colors.blueAccent),
    //                                     onPressed: () {},
    //                                     icon: Icon(
    //                                       Icons.favorite,
    //                                     ))),
    //                           ),
    //                         ],
    //                           ),
    //                         ),
    //                       );
    //                     });
                  
    //             })));
  }

  // the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

class BoxContainer extends StatelessWidget {
  final VoidCallback onTap;
  final String? imageUrl;
  final String title;
  final String? biodata;
  const BoxContainer({Key? key, required this.onTap, this.imageUrl, required this.title, this.biodata}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = 220.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(0, 5)
          )
        ]
      ),
      width: width,
      margin: EdgeInsets.fromLTRB(20, 10, 0, 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300, // TOTAL 120
                  child: Stack(
                    children: [
                      SizedBox(
                        width: width,
                        height: 280,
                        child: imageUrl != null ?
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                          child: Image.network(imageUrl!, fit: BoxFit.cover)
                        ) : Icon(Icons.person, size: 100),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 130,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0, 0)
                              )
                            ]
                          ),
                          child: IconButton(
                            onPressed: () {

                            },
                            icon: Icon(Icons.favorite)
                          ),
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10), // TOTAL 120
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(title, style: TextStyle(fontWeight: FontWeight.bold))
                ),
                SizedBox(height: 10), // TOTAL 120
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(biodata ?? '', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 12))
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}