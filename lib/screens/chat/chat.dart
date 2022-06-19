import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:jodoh_my/screens/chat/chatroom.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  late UserModel userModel;

  final database = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://jodohmy-default-rtdb.asia-southeast1.firebasedatabase.app')
    .ref();

  Future<List<UserModel>> getFriendlist() async {
    List<UserModel> friendlist = [];

    userModel = await getUserModel(); // Me

    final data = await FirebaseFirestore.instance.collection("users").get(); // All users
    
    for (var e in data.docs) {
      try {
        UserModel friend = UserModel.fromMap(e.data());
        if (userModel.follower!.contains(friend.uid)) {
          friendlist.add(friend);
        }
      } catch (_) {}
    }

    return friendlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Chats')),
        actions: [
          ElevatedButton(onPressed: () {
            database.child('messages').set(null);
          }, child: Text('Delete all messages'))
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: getFriendlist(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done || snapshot.data == null) return LinearProgressIndicator();

          List<UserModel> friendlist = snapshot.data!;
          return ListView.builder(
            itemCount: friendlist.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(friendlist[index].pic ?? ''),
                  backgroundColor: Colors.transparent,
                ),
                title: Row(
                  children: [
                    Text(friendlist[index].name ?? "No name"),
                    SizedBox(width: 10),
                    Icon(Icons.verified, color: Colors.blue, size: 15,)
                  ]
                ),
                subtitle: friendlist[index].bio != null ? Text(friendlist[index].bio!) : null,
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(
                    friendModel: friendlist[index],
                    userModel: userModel,
                  ))).then((value) => setState(() {}));
                },
              );
            }
          );

        },
      ),
    );
  }
}
