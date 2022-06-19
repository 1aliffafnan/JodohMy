import 'package:flutter/material.dart';


const kSendButtonTextStyle = TextStyle(
  color: Colors.deepPurple,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);


const kMessageTextFieldDecoration =  InputDecoration.collapsed(
  hintText: 'Type Something...',
  hintStyle: TextStyle(color: Colors.black),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.deepPurple, width: 2.0),
  ),
);

