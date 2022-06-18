import 'package:cloud_firestore/cloud_firestore.dart';
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
                title: Text(friendlist[index].name ?? "No name"),
                subtitle: Text(friendlist[index].age ?? ''),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoom(
                    friendModel: friendlist[index],
                    userModel: userModel,
                  )));
                },
              );
            }
          );

        },
      ),
    );
  }
}
