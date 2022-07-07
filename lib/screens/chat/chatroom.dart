import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:jodoh_my/screens/chat/constant.dart';
import 'package:jodoh_my/screens/profile/profile_other.dart';
import 'package:http/http.dart' as http;

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

  Future<void> deleteMessage(String key) async {
    await database.child('messages').child(chatRoomId).child(key).set({});
  }

  List<ChatModel> chatList = [];
  String chatRoomId = '';

  @override
  void initState() {
    
    super.initState();
  }

  final database = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://jodohmy-default-rtdb.asia-southeast1.firebasedatabase.app')
    .ref();

  Future<bool> getChatRoom() async {
    try {
      String chatRoomId1 = '${widget.userModel.uid}${widget.friendModel.uid}';
      String chatRoomId2 = '${widget.friendModel.uid}${widget.userModel.uid}';
      DatabaseEvent check = await database.child('messages').child(chatRoomId1).orderByKey().once();
      if (!check.snapshot.exists) {
        check = await database.child('messages').child(chatRoomId2).once();
        if (!check.snapshot.exists) {
          Map initialChat = {
            'uid' : widget.userModel.uid,
            'text' : '',
            'datetime' : DateTime.now().toUtc().toIso8601String()
          };
          chatRoomId = chatRoomId1;
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

    return true;
  }

  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool isOnce = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 15),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            splashRadius: 25,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilerOther(
              isFollowed: widget.userModel.follower!.contains(widget.friendModel.uid),
              isFromChat: true,
              userModel: widget.userModel,
              friendModel: widget.friendModel
            )));
          },
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(widget.friendModel.pic ?? ''),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 20),
              Text(widget.friendModel.name ?? 'No Name'),
              SizedBox(width: 10),
              Icon(Icons.verified, color: Colors.blue)
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(double.infinity, 100, 0, 0),
                items: [
                  PopupMenuItem<String>(
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CircularProgressIndicator()));
                            
                      final friendDoc = await FirebaseFirestore.instance.collection("users").doc(widget.friendModel.uid).get();
                      List listFollowerThem = friendDoc.get('follower');
                      listFollowerThem.removeWhere((e) => e == widget.userModel.uid);

                      List listFollowerMe = widget.userModel.follower!;
                      listFollowerMe.removeWhere((e) => e == widget.friendModel.uid);

                      await Future.wait([
                        // Them
                        FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.friendModel.uid)
                          .update({
                            'follower': listFollowerThem
                          }),
                        // Me
                        FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.userModel.uid)
                          .update({
                            'follower': listFollowerMe
                          })
                      ]);

                      if (mounted) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Unfollow')
                  ),
                ],
                elevation: 8.0,
              );
              // PopupMenuButton(itemBuilder: (context) => [
              //   PopupMenuItem(child: Text('ANjing'))
              // ]);
              // showModalBottomSheet(
              //   context: context,
              //   builder: (context) => Container(
              //     margin: EdgeInsets.all(20),
              //     height: 60,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         SizedBox(
              //           height: 50,
              //           child: ElevatedButton(
              //             onPressed: () async {
              //               Navigator.push(context, MaterialPageRoute(builder: (context) => CircularProgressIndicator()));
                            
              //               final friendDoc = await FirebaseFirestore.instance.collection("users").doc(widget.friendModel.uid).get();
              //               List listFollowerThem = friendDoc.get('follower');
              //               listFollowerThem.removeWhere((e) => e == widget.userModel.uid);

              //               List listFollowerMe = widget.userModel.follower!;
              //               listFollowerMe.removeWhere((e) => e == widget.friendModel.uid);
  
              //               await Future.wait([
              //                 // Them
              //                 FirebaseFirestore.instance
              //                   .collection("users")
              //                   .doc(widget.friendModel.uid)
              //                   .update({
              //                     'follower': listFollowerThem
              //                   }),
              //                 // Me
              //                 FirebaseFirestore.instance
              //                   .collection("users")
              //                   .doc(widget.userModel.uid)
              //                   .update({
              //                     'follower': listFollowerMe
              //                   })
              //               ]);

              //               if (mounted) {
              //                 Navigator.pop(context);
              //                 Navigator.pop(context);
              //                 Navigator.pop(context);
              //               }
              //             },
              //             child: Text("Unfollow ${widget.friendModel.name}")
              //           ),
              //         )
              //       ],
              //     ),
              //   )
              // );
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FutureBuilder<bool>(
              future: getChatRoom(),
              builder: (context, snapshot1) {
                if (snapshot1.connectionState != ConnectionState.done) return Container();
                return StreamBuilder(
                  stream: database.child('messages').child(chatRoomId).onValue,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.active) return Container();

                    chatList = [];
                    final Map data = (snapshot.data as DatabaseEvent).snapshot.value as Map;

                    data.forEach((key, value) {
                      chatList.add(ChatModel(uid: value['uid'], key: key, text: value['text'], datetime: value['datetime']));
                    });

                    chatList.sort((a, b) => a.key.compareTo(b.key));
                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      shrinkWrap: true,
                      itemCount: chatList.length,
                      itemBuilder: (context, i) {

                        DateTime dateTime = DateTime.parse(chatList[i].datetime).add(Duration(hours: 8));
                        DateTime? dateTimeBefore = i != 0 ? DateTime.parse(chatList[i-1].datetime).add(Duration(hours: 8)) : null;
                        String time = DateFormat('HH:mm').format(dateTime);
                        String date = DateFormat('EEEE, dd MMMM').format(dateTime);
                        if (chatList.length == 1) return Column(
                          children: [
                            SizedBox(height: 150),
                            Icon(Icons.auto_awesome, size: 100, color: Colors.black.withOpacity(0.3)),
                            SizedBox(height: 20),
                            Text('Start a conversation!', style: TextStyle(fontSize: 17, color: Colors.black.withOpacity(0.3), fontWeight: FontWeight.bold))
                          ],
                        );
                        if (chatList[i].text == '') return Container();
                        if (chatList[i].uid == widget.userModel.uid) {
                          return Column(
                            children: [

                              if (i == 1 || dateTime.day != dateTimeBefore!.day)
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(date, style: TextStyle(color: Colors.white))
                                ),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(time),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(context: context, builder: (context) => AlertDialog(
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextButton(onPressed: () {
                                              Clipboard.setData(ClipboardData(text: chatList[i].text));
                                              Fluttertoast.showToast(msg: 'Message copied!');
                                              Navigator.pop(context);
                                            }, child: Text('Copy')),
                                            SizedBox(width: 10),
                                            Container(
                                              color: Colors.purple,
                                              height: 20,
                                              width: 2,
                                              child: Container(),
                                            ),
                                            SizedBox(width: 10),
                                            TextButton(onPressed: () {
                                            deleteMessage(chatList[i].key);
                                            Fluttertoast.showToast(msg: 'Message deleted!');
                                            Navigator.pop(context);
                                            }, child: Text('Delete Message')),
                                          ],
                                        ),
                                      ));
                                    },
                                    child: Container(
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
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                        else {
                          return Column(
                            children: [

                              if (i == 1 || (dateTimeBefore != null && dateTime.day != dateTimeBefore.day))
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(date, style: TextStyle(color: Colors.white))
                                ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(context: context, builder: (context) => AlertDialog(
                                        content: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            TextButton(onPressed: () {
                                              Clipboard.setData(ClipboardData(text: chatList[i].text));
                                              Fluttertoast.showToast(msg: 'Message copied!');
                                              Navigator.pop(context);
                                            }, child: Text('Copy')),
                                          ],
                                        ),
                                      ));
                                    },
                                    child: Container(
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
                                  ),
                                  SizedBox(width: 5),
                                  Text(time)
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    );
                  }
                );
              }
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey.shade300
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 25),
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type a message..',
                        hintStyle: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(300)
                  ),
                  margin: EdgeInsets.only(right: 8),
                  child: IconButton(
                    splashColor: Colors.purple,
                    focusColor: Colors.purple,
                    color: Colors.white,
                    onPressed: () async {
                      if (message != '') {
                        _controller.clear();
                        chatList = [];
                        if (widget.friendModel.fcm != null) sendPushMessage(message, widget.userModel.name!, widget.friendModel.fcm!);
                        await addMessage();
                        await getChatRoom();
                        message = '';
                      }
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void sendPushMessage(String body, String title, String token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAA-wlLelc:APA91bHS9wpwK9GtWqAoJi-NklHpb67YGUMxL3BfU48exMpGhGFlGqDNwUE7N7PquRWs8qBarAsHvj4jBz3eNzJwKtIWjCTXn_vaTWkHPp2HFHDsr5qTf-KWG-EZzsI9F8ADtYVoVYBv',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'image': widget.userModel.pic
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }
}
