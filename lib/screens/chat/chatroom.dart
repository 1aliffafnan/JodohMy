import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:jodoh_my/screens/chat/constant.dart';

class ChatRoom extends StatefulWidget {
  final UserModel userModel;
  final UserModel friendModel;
  const ChatRoom({Key? key, required this.userModel, required this.friendModel}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _controller = TextEditingController();

  String message = "";

  Future<void> addMessage() async {
    await database.child('messages').child(chatRoomId).push().set({
      'uid' : widget.userModel.uid,
      'text' : message,
      'datetime' : DateTime.now().toUtc().toIso8601String()
    });
  }

  List<ChatModel> chatList = [];
  String chatRoomId = '';

  @override
  void initState() {
    getChatRoom();
    super.initState();
  }

  final database = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://jodohmy-default-rtdb.asia-southeast1.firebasedatabase.app')
    .ref();

  Future<void> getChatRoom() async {
    chatList = [];
    try {
      String chatRoomId1 = '${widget.userModel.uid}${widget.friendModel.uid}';
      String chatRoomId2 = '${widget.friendModel.uid}${widget.userModel.uid}';
      DatabaseEvent check = await database.child('messages').child(chatRoomId1).orderByKey().once();
      if (!check.snapshot.exists) {
        check = await database.child('messages').child(chatRoomId2).once();
        if (!check.snapshot.exists) {
          Map initialChat = {
            'uid' : widget.userModel.uid,
            'text' : 'Hello',
            'datetime' : DateTime.now().toUtc().toIso8601String()
          };
          await database.child('messages').child(chatRoomId1).push().set(initialChat);
          DatabaseEvent newCheck = await database.child('messages').child(chatRoomId1).once();
          (newCheck.snapshot.value as Map).forEach((key, value) {
            chatList.add(ChatModel(uid: value['uid'], key: key, text: value['text'], datetime: value['datetime']));
          });
        }
        else {
          chatRoomId = chatRoomId2;
          (check.snapshot.value as Map).forEach((key, value) {
            chatList.add(ChatModel(uid: value['uid'], key: key, text: value['text'], datetime: value['datetime']));
          });
        }
      }
      else {
        chatRoomId = chatRoomId1;
        (check.snapshot.value as Map).forEach((key, value) {
          chatList.add(ChatModel(uid: value['uid'], key: key, text: value['text'], datetime: value['datetime']));
        });
      }
    } catch (e) {
      debugPrint("TOLOL : $e");
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });

    chatList.sort((a, b) => a.key.compareTo(b.key));
    setState(() {});
    
  }

  final _scrollController = ScrollController();

    

  

  @override
  Widget build(BuildContext context) {
    //getChatRoom();
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(widget.friendModel.pic ?? ''),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(width: 20),
            Text(widget.friendModel.name ?? 'No Name'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: StreamBuilder<Object>(
              stream: database.child('messages').child(chatRoomId).onValue,
              builder: (context, snapshot) {
                //if (snapshot.connectionState != ConnectionState.active) return LinearProgressIndicator();
                return ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: chatList.length,
                  itemBuilder: (context, i) {
            
                    DateTime dateTime = DateTime.parse(chatList[i].datetime).add(Duration(hours: 8));
                    String dt = DateFormat('HH:mm').format(dateTime);
            
                    if (chatList[i].uid == widget.userModel.uid) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(dt),
                          SizedBox(width: 5),
                          Container(
                            width: chatList[i].text.length > 30 ? MediaQuery.of(context).size.width - 5 - 20 - 20 - 50 : null,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            child: Text(chatList[i].text, style: TextStyle(color: Colors.white))
                          ),
                        ],
                      );
                    }
                    else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: chatList[i].text.length > 30 ? MediaQuery.of(context).size.width - 5 - 20 - 20 - 50 : null,
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(15)
                            ),
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            child: Text(chatList[i].text, style: TextStyle(color: Colors.white))
                          ),
                          SizedBox(width: 5),
                          Text(dt)
                        ],
                      );
                    }
                  },
                );
              }
            ),
          ),
          Container(
            height: 60,
            decoration: kMessageContainerDecoration,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      message = value;
                    },
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    _controller.clear();
                    await addMessage();
                    await getChatRoom();
                  },
                  child: Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
