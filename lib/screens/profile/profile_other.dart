import 'package:flutter/material.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:jodoh_my/screens/chat/chatroom.dart';

class ProfilerOther extends StatefulWidget {
  final bool isFromChat;
  final bool isFollowed;
  final UserModel friendModel;
  final UserModel userModel;
  const ProfilerOther({Key? key, required this.friendModel, required this.isFollowed, required this.userModel, required this.isFromChat}) : super(key: key);

  @override
  State<ProfilerOther> createState() => _ProfilerOtherState();
}

class _ProfilerOtherState extends State<ProfilerOther> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            splashRadius: 25,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text('User Profile'),
        centerTitle: true,
      ),
      body: ListView(
        children: [


          SizedBox(
            height: 170,
            child: Stack(
              children: [
          
                Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
                    boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.2), spreadRadius: 3, offset: Offset(0,3))],
                  ),
                  child: Container(),
                ),
          
                Positioned(
                  bottom: 0,
                  top: 0,
                  right: 0,
                  left: 0,
          
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.2), spreadRadius: 3, offset: Offset(0,3))],
                        ),
                        child: CircleAvatar(
                          radius: 80.0,
                          backgroundImage: NetworkImage(widget.friendModel.pic ?? ''),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          
          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.friendModel.name!, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Icon(Icons.verified, color: Colors.blue)
            ],
          ),

          SizedBox(height: 10),

          followBox(widget.isFollowed),

          SizedBox(height: 20),

          statusBox(widget.friendModel.status ?? ''),

          SizedBox(height: 10),

          Center(child: Text('${widget.friendModel.age!} years old', style: TextStyle(fontSize: 15))),

          SizedBox(height: 5),

          Center(child: Text(widget.friendModel.state ?? '', style: TextStyle(fontSize: 15))),

          SizedBox(height: 10),

          if (widget.friendModel.bio != null)...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 2,
                    offset: Offset(0,3)
                  )
                ]
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text('Biodata', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(widget.friendModel.bio!)
                ],
              ),
            )
          ],

          SizedBox(height: 20),

          if (widget.friendModel.interest1 != null)...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 2,
                    offset: Offset(0,3)
                  )
                ]
              ),
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text('Interests', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  interestBox(widget.friendModel.interest1!),
                  if (widget.friendModel.interest2 != null) interestBox(widget.friendModel.interest2!),
                  if (widget.friendModel.interest3 != null) interestBox(widget.friendModel.interest3!),
                ],
              ),
            )
          ],

          SizedBox(height: 30),

        ],
      ),
    );
  }

  Widget interestBox(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.fromLTRB(15,10,15,10),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            spreadRadius: 1,
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, 3)
          )
        ]
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))
    );
  }

  Widget statusBox(String text) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.fromLTRB(30,10,30,10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              spreadRadius: 1,
              color: Colors.green.withOpacity(0.1),
              offset: Offset(0, 3)
            )
          ]
        ),
        child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15))
      ),
    );
  }

  Widget followBox(bool isFollowed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        SizedBox(
          height: 45,
          child: ElevatedButton(
            onPressed: () {
        
            },
            child: Row(
              children: [
                if (isFollowed)...[
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 5),
                ],
                Text(isFollowed ? ' Following ' : ' Follow ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            )
          ),
        ),

        if (isFollowed && widget.isFromChat)...[
          SizedBox(width: 10),
          SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                if (widget.isFromChat) Navigator.pop(context);
                else Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChatRoom(userModel: widget.friendModel, friendModel: widget.friendModel)));
              },
              child: Row(
                children: [
                  Icon(Icons.message),
                  SizedBox(width: 5),
                  Text('Message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              )
            ),
          ),
        ]
      ],
    );
  }
}