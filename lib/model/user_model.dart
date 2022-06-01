import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class UserModel {
  String? uid;
  String? email;
  String? name;
  String? age;
  String? gender;
  String? state;
  String? status;
  GeoPoint? geoPoint;

  UserModel({this.uid, this.email, this.name, this.age, this.gender, this.state, this.status, this.geoPoint});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      age: map['age'],
      gender: map['gender'],
      state: map['state'],
      status: map['status'],
      geoPoint: map['geoPoint']
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
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
