import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const COLLECTION = 'Users';

class DBService {
  static DBService get instance => DBService();

  Future<void> createUser(String uid, String name,String email, String imageUrl) async {
    try{
      await FirebaseFirestore.instance.collection(COLLECTION).doc(uid).set(
        {
          'name':name,
          'email':email,
          'image':imageUrl,
          'lastSeen':DateTime.now().toUtc(),
        },
      );
    }catch(error){
        print('error occured in creating user to database');
    }

  }
}
