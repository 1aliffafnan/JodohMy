import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jodoh_my/screens/home/search-page.dart';
import 'package:jodoh_my/screens/profile/profile_other.dart';
import '../authenticate/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;
  List<UserModel> listUser = [];
  UserModel userModelAll = UserModel();

  // Display users
  Future<List<BoxContainer>> getData() async {
    final List<BoxContainer> list = [];
    
    try {
      final data = await FirebaseFirestore.instance.collection('users').get();

      final UserModel userModel = await getUserModel();
      userModelAll = userModel;

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

        UserModel friendModel = UserModel.fromMap(e.data());
        
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

        double distance = Geolocator.distanceBetween(
          userModel.geoPoint!.latitude,
          userModel.geoPoint!.longitude,
          friendModel.geoPoint!.latitude,
          friendModel.geoPoint!.longitude
        );
        distance = distance / 1000;

        BoxContainer boxContainer = BoxContainer(
          status: status,
          onTapProfile: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilerOther(
              isFollowed: userModel.follower != null ? userModel.follower!.contains(friendModel.uid) : false,
              friendModel: friendModel,
              userModel: userModel,
              isFromChat: false)
            ));
          },
          distance: distance.toStringAsFixed(1),
          listFollowerMe: listFollowerMe,
          listFollowerThem: listFollowerThem,
          listPendingMe: listPendingMe,
          listPendingThem: listPendingThem,
          listUpcomingThem: listUpcomingThem,
          listUpcomingMe: listUpcomingMe,
          uid: uid!,
          userId: user!.uid,
          onTapLike: () {
            
          },
          name: name ?? 'No name',
          imageUrl: pic ?? 'No pic',
          state: '$age | $state',
        );

        if (userGender == 'Female' && gender == 'Male') {
          list.add(boxContainer);
          listUser.add(friendModel);
        }
        else if (userGender == 'Male' && gender == 'Female') {
          list.add(boxContainer);
          listUser.add(friendModel);
        }
      }
    } catch (e) {
      debugPrint("ROSAK APA SIOT $e");
    }

    return list;
  }


  //logout
  Future<void> logout(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({'fcm': null});
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
                colors: [Colors.purple, Colors.purple.shade200]),
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
                          colors: [Colors.purple, Colors.purple.shade200]),
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
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (listUser.isNotEmpty) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(
                              listUser: listUser,
                              userModel: userModelAll,
                            )));
                          }
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
                          height: 60,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              SizedBox(width: 30),
                              Icon(Icons.search, color: Colors.grey.shade700),
                              SizedBox(width: 20),
                              Text('Search Partner..',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey.shade700))
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
              child: Text('Find Partner',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          SizedBox(height: 5),
          FutureBuilder<List<BoxContainer>>(
            future: getData(),
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting)
              //   return ListView.builder(
              //     shrinkWrap: true,
              //     scrollDirection: Axis.horizontal,
              //     itemCount: 5,
              //     itemBuilder: (context, index) {
              //       return BoxPlaceholder();
              //   }
              // );
              if (!snapshot.hasData || snapshot.data == null || snapshot.connectionState == ConnectionState.waiting)
                return Container();
                
              final List<BoxContainer> listContainer = snapshot.data!;
              final List<BoxContainer> newList = [];

              for (var e in listContainer) {
                if (e.state!.substring(5) == userModelAll.state) {
                  newList.add(e);
                }
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: listContainer.length,
                      itemBuilder: (context, index) {
                        if (index == listContainer.length - 1) return Container(margin: EdgeInsets.only(right: 20), child: listContainer[index]);
                        return listContainer[index];
                      }
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Text('Near ${userModelAll.state}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),

                  SizedBox(height: 5),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: newList.length,
                      itemBuilder: (context, index) {
                        if (index == newList.length - 1) return Container(margin: EdgeInsets.only(right: 20), child: newList[index]);
                        return newList[index];
                      }
                    ),
                  ),
                ],
              );

            }
          ),
          
        ]
      ),
    );
  }
}

class BoxContainer extends StatefulWidget {
  final VoidCallback onTapProfile;
  final VoidCallback onTapLike;
  final String distance;
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
      required this.distance,
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
      icon = Icon(Icons.hourglass_bottom, color: Colors.blue);
    }
    else if (widget.status == 'follower') {
      status = 'follower';
      icon = Icon(Icons.verified);
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
    double distance = double.parse(widget.distance);
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
                                icon = Icon(Icons.verified);
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        widget.state ?? '',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12
                        )
                      )
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10,5,10,5),
                      decoration: BoxDecoration(
                        color: distance > 100 ? Colors.red.shade700 : distance < 10 ? Colors.green : Colors.orange.shade700,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            spreadRadius: 1,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 3)
                          )
                        ]
                      ),
                      child: Text(
                        '${widget.distance} km',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        )
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BoxPlaceholder extends StatelessWidget {
  const BoxPlaceholder({Key? key}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    Icon icon = Icon(Icons.favorite);
    String status = 'none';
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
                        child: Icon(Icons.person, size: 100),
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
                            onPressed: () {},
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
                    child: LinearProgressIndicator()),
                SizedBox(height: 10), // TOTAL 120
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: LinearProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}