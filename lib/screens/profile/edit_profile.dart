import 'package:flutter/material.dart';
import 'package:jodoh_my/model/user_model.dart';

class EditProfile extends StatefulWidget {
  final UserModel userModel;
  const EditProfile({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Boss'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              
            ],
          ),
        ),);
  }
}
