import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserModelStream {
  final String uid;

  UserModelStream({required this.uid});
}

class UserModel extends ChangeNotifier {
  String? uid;
  String? pic;
  String? bio;
  String? interest1;
  String? interest2;
  String? interest3;
  String? email;
  String? name;
  String? age;
  String? gender;
  String? state;
  String? status;
  GeoPoint? geoPoint;

  UserModel(
      {this.uid,
      this.pic,
      this.interest1,
      this.interest2,
      this.interest3,
      this.bio,
      this.email,
      this.name,
      this.age,
      this.gender,
      this.state,
      this.status,
      this.geoPoint});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        pic: map['pic'],
        bio: map['bio'],
        interest1: map['interest1'],
        interest2: map['interest2'],
        interest3: map['interest3'],
        email: map['email'],
        name: map['name'],
        age: map['age'],
        gender: map['gender'],
        state: map['state'],
        status: map['status'],
        geoPoint: map['geoPoint']);
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'pic': pic,
      'bio': bio,
      'email': email,
      'name': name,
      'age': age,
      'gender': gender,
      'state': state,
      'status': status,
      'geoPoint': geoPoint
    };
  }
}
