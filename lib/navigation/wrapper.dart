import 'package:flutter/material.dart';
import 'package:jodoh_my/model/user_model.dart';
import 'package:jodoh_my/navigation/bottom.dart';
import 'package:jodoh_my/screens/authenticate/login_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({ Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final UserModelStream? user = Provider.of<UserModelStream?>(context); // Receive from main.dart StreamProvider

    // return either Home or Authenticate widget
    if (user == null) {
      return LoginScreen();
    } else {
      return BotNav();
    }
  }

}