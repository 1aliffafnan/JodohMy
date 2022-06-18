import 'package:flutter/material.dart';


const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);


const kMessageTextFieldDecoration =  InputDecoration.collapsed(
  hintText: 'Type Something...',
  hintStyle: TextStyle(color: Colors.blueGrey),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

