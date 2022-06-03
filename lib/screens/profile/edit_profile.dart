import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final String name;
  const EditProfile({Key? key, required this.name}) : super(key: key);

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
      body: Text(widget.name),
    );
  }
}
