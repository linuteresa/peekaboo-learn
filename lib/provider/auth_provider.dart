import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class AuthProv with ChangeNotifier {
  AppUser _appUser = AppUser();
  //  login function with firebase auth
  final dbInstance = FirebaseDatabase.instance;
  int perntage = 0;
  AppUser get appUser => _appUser;
  int get percentage => perntage;
  Future<void> login(String email, String password) async {
    // login function with firebase auth
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await getProfile();
    } catch (e) {
      // throw error with message only
      rethrow;
    }
  }

  // signup function with firebase auth
  Future<void> signup(SignupData data) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.email!, password: data.password!);
      // add display name and mobile number
      await FirebaseAuth.instance.currentUser!.updateDisplayName(data.name);
      // add user data to realtime database
      await dbInstance
          .ref('users/${FirebaseAuth.instance.currentUser!.uid}')
          .set({
        'level': 0,
        'score': 0,
      });
      await getProfile();
    } catch (e) {
      rethrow;
    }
  }

  // logout function with firebase auth
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userData = await dbInstance.ref('users/${user!.uid}').get();
      // set user data to user model

      if (userData.value != null) {
        final dataU = jsonDecode(jsonEncode(userData.value!));
        _appUser = AppUser(
          email: user.email,
          name: user.displayName,
          level: dataU['level'],
          score: dataU['score'],
          uid: user.uid,
        );
      }
      perntage = calculatePercent(_appUser.score ?? 0);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateScore(int score, String l) async {
    try {
      if (await checkAlreadyCompletd(l)) {
        throw 'Already completed';
      }
      final user = FirebaseAuth.instance.currentUser;

      _appUser.score = _appUser.score! + score;
      _appUser.level = calculateLevel(_appUser.score!);
      await dbInstance.ref('users/${user!.uid}').update({
        'score': _appUser.score,
        'level': _appUser.level,
      });
      await dbInstance
          .ref('users/${user.uid}/completed/$l')
          .set({'score': score});
      await getProfile();
      perntage = calculatePercent(_appUser.score!);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkAlreadyCompletd(String val) async {
    final user = FirebaseAuth.instance.currentUser;
    final userData =
        await dbInstance.ref('users/${user!.uid}/completed/$val').get();
    if (userData.value != null) {
      return true;
    }
    return false;
  }

  int calculateLevel(int score) {
    int level = 0;
    if (score >= 0 && score < 50) {
      level = 0;
    } else if (score >= 50 && score < 145) {
      level = 1;
    } else if (score >= 145 && score < 225) {
      level = 2;
    } else if (score >= 225 && score < 775) {
      level = 3;
    } else if (score >= 775 && score < 1265) {
      level = 4;
    } else if (score >= 1265) {
      level = 5;
    }

    return level;
  }

  // calculate % to next level
  int calculatePercent(int score) {
    int percent = 0;
    if (score >= 0 && score < 50) {
      percent = (score / 50 * 100).round();
    } else if (score >= 50 && score < 145) {
      percent = ((score - 50) / 95 * 100).round();
    } else if (score >= 145 && score < 225) {
      percent = ((score - 145) / 80 * 100).round();
    } else if (score >= 225 && score < 775) {
      percent = ((score - 225) / 550 * 100).round();
    } else if (score >= 775 && score < 1265) {
      percent = ((score - 775) / 490 * 100).round();
    } else if (score >= 1265) {
      percent = ((score - 1265) / 325 * 100).round();
    }

    return percent;
  }
}
