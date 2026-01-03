import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';

import '../../../models/user.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  AuthService();

  BuildContext? get context => null;
  // LOGIN
  Future<User_App> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final doc = await _firestore.collection('users').doc(uid).get();
    print(doc.data());
    if (doc.data() != null) {
      log('User data: ${doc.data()}');
      log('Login successful for user: $uid');
    }
    if (!doc.exists) {
      throw Exception('User data not found');
    }

    return User_App.fromMap(uid, doc.data()!);
  }

  // LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  // CURRENT USER
  Future<User_App?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();

    if (!doc.exists) return null;

    return User_App.fromMap(user.uid, doc.data()!);
  }

  Future<User_App> registerChild(
    String email,
    String password,
    String role,
    String name,
    String phone,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    await _firestore.collection('users').doc(uid).set({
      'email': email,
      'role': 'child',
      'name': name,
      'phone': phone,
    });

    return User_App(
      uid: uid,
      email: email,
      role: "child",
      name: name,
      phone: phone,
      childId: '',
    );
  }

  Future<String> getChildId(String phoneChild) async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phoneChild)
          .where('role', isEqualTo: 'child')
          .limit(1)
          .get()
          .timeout(const Duration(seconds: 10));

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Child with phone $phoneChild not found');
      }

      return querySnapshot.docs.first.id;
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } on TimeoutException {
      throw Exception('Timeout while fetching child data');
    }
  }

  Future<User_App> registerParent({
    required String phone,
    required String password,
    required String name,
    required String phoneChild,
  }) async {
    final email = '$phone@oldcare.com';

    try {
      final childId = await getChildId(phoneChild);

      final credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10));

      final uid = credential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'role': 'parent',
        'name': name,
        'phone': phone,
        'child_id': childId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return User_App(
        uid: uid,
        email: email,
        role: 'parent',
        name: name,
        phone: phone,
        childId: childId,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception('Auth error: ${e.message}');
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } on TimeoutException {
      throw Exception('Network timeout, please try again');
    }
  }
}
