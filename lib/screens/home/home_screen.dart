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


  // Display users
  Future<List<BoxContainer>> getData() async {
    final List<BoxContainer> list = [];
    
    try {
      final data = await FirebaseFirestore.instance.collection('users').get();

      final UserModel userModel = await getUserModel();

      String? userGender = userModel.gender;
      List listPendingMe = userModel.pending ?? []; // take user's list pending
      List listUpcomingMe = userModel.upcoming ?? []; // take user's list upcoming
      List listFollowerMe = userModel.follower ?? [];

      for (var e in data.docs) {
        String? uid = e['uid'];
        String? name = e['name'];
        String? age = e['age'];
        String? state = e['state'];
        String? gender = e['gender'];
        String? pic = e['pic'];
        
        List listUpcomingThem = [];
        try {
          listUpcomingThem = e['upcoming']; // take user's upcoming
        } catch (_) {}
        List listPendingThem = [];
        try {
          listPendingThem = e['pending']; // take user's pending
        } catch (_) {}
        List listFollowerThem = [];
        try {
          listFollowerThem = e['follower']; // take user's follower
        } catch (_) {}
        
        String status = 'none';
        if (listUpcomingThem.contains(user!.uid))
          status = 'pending';
        else if (listPendingThem.contains(user!.uid))
          status = 'upcoming';
        else if (listFollowerThem.contains(user!.uid) && listFollowerMe.contains(uid))
          status = 'follower';

        BoxContainer boxContainer = BoxContainer(
          status: status,
          onTapProfile: () {},
          listFollowerMe: listFollowerMe,
          listFollowerThem: listFollowerThem,
          listPendingMe: listPendingMe,
          listPendingThem: listPendingThem,
          listUpcomingThem: listUpcomingThem,
          listUpcomingMe: listUpcomingMe,
          uid: uid!,
          userId: user!.uid,
          onTapLike: () {

            // // ========== Follower ============
            // if (status == 'upcoming') {
            //   listFollowerThem.add(user!.uid);
            //   listFollowerMe.add(uid);

            //   listPendingThem.removeWhere((e) => e == user!.uid);
            //   listUpcomingMe.removeWhere((e) => e == uid);
            //   // Them
            //   FirebaseFirestore.instance
            //     .collection("users")
            //     .doc(uid)
            //     .update({
            //       'follower': listFollowerThem,
            //       'pending': listPendingThem
            //   });
            //   // Me
            //   FirebaseFirestore.instance
            //     .collection("users")
            //     .doc(user!.uid)
            //     .update({
            //       'follower': listFollowerMe,
            //       'upcoming': listUpcomingMe
            //   });
            // }

            // else if (status == 'follower') {
            //   listFollowerThem.removeWhere((e) => e == user!.uid);
            //   listFollowerMe.removeWhere((e) => e == uid);
            //   // Them
            //   FirebaseFirestore.instance
            //     .collection("users")
            //     .doc(uid)
            //     .update({
            //       'follower': listFollowerThem
            //   });
            //   // Me
            //   FirebaseFirestore.instance
            //     .collection("users")
            //     .doc(user!.uid)
            //     .update({
            //       'follower': listFollowerMe
            //   });
            // }
            
            // // =================================
            
            // else {
            //   // Me
            //   if (listPendingMe.contains(uid)) {
            //     listPendingMe.removeWhere((e) => e == uid);
            //   } else {
            //     listPendingMe.add(uid!);
            //   }
            //   FirebaseFirestore.instance
            //     .collection("users")
            //     .doc(user!.uid)
            //     .update({
            //       'pending': listPendingMe
            //   });

            //   // Them
            //   if (listUpcomingThem.contains(user!.uid)) {
            //     listUpcomingThem.removeWhere((e) => e == user!.uid);
            //   } else {
            //     listUpcomingThem.add(user!.uid);
            //   }
            //   FirebaseFirestore.instance
            //     .collection("users")
            //     .doc(uid)
            //     .update({
            //       'upcoming': listUpcomingThem
            //   });
            // }

            

          },
          name: name ?? 'No name',
          imageUrl: pic ?? 'No pic',
          state: '$age | $state',
        );

        if (userGender == 'Female' && gender == 'Male') 
          list.add(boxContainer);
        else if (userGender == 'Male' && gender == 'Female')
          list.add(boxContainer);
      }
    } catch (e) {
      debugPrint("ROSAK APA SIOT $e");
    }

    return list;
  }


  //logout
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()));
    }
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
                colors: [Colors.purple, Colors.purple.shade100]),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                logout(context);
              },
              icon: Icon(Icons.logout, color: Colors.black)),
        ],
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(
            height: 90,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Colors.purple, Colors.purple.shade100]),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.purple.withOpacity(0.1),
                            spreadRadius: 10,
                            blurRadius: 5,
                            offset: Offset(0, 0))
                      ]),
                  child: Text(
                    'Welcome to JodohMY',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.purple.withOpacity(0.1),
                                  spreadRadius: 7,
                                  blurRadius: 8,
                                  offset: Offset(0, 5))
                            ]),
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            SizedBox(width: 30),
                            Icon(Icons.search, color: Colors.grey.shade700),
                            SizedBox(width: 20),
                            Text('Search awek',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade700))
                          ],
                        ),
                      ),
                    )))
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
              margin: EdgeInsets.only(left: 20),
              child: Text('Find Partner',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          SizedBox(height: 5),
          SizedBox(
            height: 400,
            child: FutureBuilder<List<BoxContainer>>(
              future: getData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();
                if (!snapshot.hasData || snapshot.data == null)
                  return Text('No data');
                  
                final List<BoxContainer>? listContainer = snapshot.data;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listContainer!.length,
                  itemBuilder: (context, index) {
                    return listContainer[index];
                  }
                );

              }
            ),
          )
        ],
      ),
    );
  }
}

class BoxContainer extends StatefulWidget {
  final VoidCallback onTapProfile;
  final VoidCallback onTapLike;
  final String? imageUrl;
  final String name;
  final String? state;
  final String status; // Status with you (none, pending, upcoming, follower)
  final List listFollowerThem;
  final List listFollowerMe;
  final List listPendingThem;
  final List listPendingMe;
  final List listUpcomingThem;
  final List listUpcomingMe;
  final String uid;
  final String userId;
  const BoxContainer(
      {Key? key,
      required this.onTapProfile,
      required this.onTapLike,
      this.imageUrl,
      required this.name,
      required this.status,
      this.state,
      required this.listFollowerThem,
      required this.listFollowerMe,
      required this.listPendingThem,
      required this.listPendingMe,
      required this.listUpcomingThem,
      required this.listUpcomingMe,
      required this.uid,
      required this.userId
      })
      : super(key: key);

  @override
  State<BoxContainer> createState() => _BoxContainerState();
}

class _BoxContainerState extends State<BoxContainer> {

  Icon icon = Icon(Icons.favorite);
  String status = 'none';

  List listFollowerThem = [];
  List listFollowerMe = [];
  List listPendingThem = [];
  List listPendingMe = [];
  List listUpcomingThem = [];
  List listUpcomingMe = [];
  String uid = '';
  String userId = '';

  @override
  void initState() {
    super.initState();

    listFollowerThem = widget.listFollowerThem;
    listFollowerMe = widget.listFollowerMe;
    listPendingThem = widget.listPendingThem;
    listPendingMe = widget.listPendingMe;
    listUpcomingThem = widget.listUpcomingThem;
    listUpcomingMe = widget.listUpcomingMe;
    uid = widget.uid;
    userId = widget.userId;

    if (widget.status == 'pending') {
      status = 'pending';
      icon = Icon(Icons.favorite, color: Colors.red);
    }
    else if (widget.status == 'upcoming') {
      status = 'upcoming';
      icon = Icon(Icons.pending, color: Colors.yellow);
    }
    else if (widget.status == 'follower') {
      status = 'follower';
      icon = Icon(Icons.done_outline);
    }
  }

  void insertData() {
    // ========== Follower ============
    if (status == 'upcoming') {
      listFollowerThem.add(userId);
      listFollowerMe.add(uid);

      listPendingThem.removeWhere((e) => e == userId);
      listUpcomingMe.removeWhere((e) => e == uid);
      // Them
      FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
          'follower': listFollowerThem,
          'pending': listPendingThem
      });
      // Me
      FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({
          'follower': listFollowerMe,
          'upcoming': listUpcomingMe
      });
    }

    else if (status == 'follower') {
      listFollowerThem.removeWhere((e) => e == userId);
      listFollowerMe.removeWhere((e) => e == uid);
      // Them
      FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
          'follower': listFollowerThem
      });
      // Me
      FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({
          'follower': listFollowerMe
      });
    }
    
    // =================================
    
    else {
      // Me
      if (listPendingMe.contains(uid)) {
        listPendingMe.removeWhere((e) => e == uid);
      } else {
        listPendingMe.add(uid);
      }
      FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({
          'pending': listPendingMe
      });

      // Them
      if (listUpcomingThem.contains(userId)) {
        listUpcomingThem.removeWhere((e) => e == userId);
      } else {
        listUpcomingThem.add(userId);
      }
      FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
          'upcoming': listUpcomingThem
      });
    }
  }

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
                offset: Offset(0, 5))
          ]),
      width: width,
      margin: EdgeInsets.fromLTRB(20, 10, 0, 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: widget.onTapProfile,
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
                        child: widget.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child:
                                    Image.network(widget.imageUrl!, fit: BoxFit.cover))
                            : Icon(Icons.person, size: 100),
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
                                  offset: Offset(0, 0))
                            ]
                          ),
                          child: IconButton(
                            onPressed: () {
                              insertData();
                              if (status == 'none') {
                                status = 'pending';
                                icon = Icon(Icons.favorite, color: Colors.red);
                              }
                              else if (status == 'pending') {
                                status = 'none';
                                icon = Icon(Icons.favorite);
                              }
                              else if (status == 'upcoming') {
                                status = 'follower';
                                icon = Icon(Icons.done_outline);
                              }
                              else if (status == 'follower') {
                                status = 'none';
                                icon = Icon(Icons.favorite);
                              }
                              else
                                icon = Icon(Icons.person);

                              setState(() {});
                            },
                            icon: icon
                          ),
                        )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10), // TOTAL 120
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(widget.name,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                SizedBox(height: 10), // TOTAL 120
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(widget.state ?? '',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 12))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

