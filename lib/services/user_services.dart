import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mkulima/models/user.dart';
import 'package:mkulima/services/local_services.dart';

class UserServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getUserData({required userId}) async {
    final query = await FirebaseFirestore.instance
        .collection('clients')
        .where('user_id', isEqualTo: userId)
        .get();

    if (query.size > 0) {
      // Iterate over the documents
      final userMap = query.docs[0].data();
      final user = User.fromMap(userMap);
      await local.setInstance(
          key: "userData", type: String, value: json.encode(userMap));
      return user;
    }
    return null;
  }

  Future<User?> getClientData({required userId}) async {
    final query = await FirebaseFirestore.instance
        .collection('clients')
        .where('user_id', isEqualTo: userId)
        .get();

    if (query.size > 0) {
      // Iterate over the documents
      final userMap = query.docs[0].data();
      final user = User.fromMap(userMap);
      return user;
    }
    return null;
  }

  Future<User?> getDriverData({required driverId}) async {
    final query = await FirebaseFirestore.instance
        .collection('drivers')
        .where('user_id', isEqualTo: driverId)
        .get();

    if (query.size > 0) {
      // Iterate over the documents
      final userMap = query.docs[0].data();
      final user = User.fromMap(userMap);
      return user;
    }
    return null;
  }

  Future<User?> createUserData({required Map<String, dynamic> userData}) async {
    User? user;
    DocumentReference clientDoc = _firestore.collection('clients').doc();
    try {
      await clientDoc.set(userData);
      user = User.fromMap(userData);
      await local.setInstance(
          key: "userData", type: String, value: json.encode(userData));
      return user;
    } catch (error) {
      print('======================>Failed to write data: $error');
      return user;
    }
  }
}

UserServices userServices = UserServices();
