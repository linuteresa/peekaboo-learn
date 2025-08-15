import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:learning/models/games.dart';

import '../data/letter.dart';

class GameProvider with ChangeNotifier {
  final List<Games> _gameList = [];
  final Set<String> _completed = {};
  final Set<String> _unlocked = {"A", "1", "Apple", "Car"};
  final List<Games> _letterList = [];
  final List<Games> _numberList = [];
  final List<Games> _speakList = [];
  final List<Games> _spellingList = [];
  List<Games> get gameList => _gameList;
  final dbInstance = FirebaseDatabase.instance;
  Future<void> getGame() async {
    try {
      _gameList.clear();
      _letterList.clear();
      _numberList.clear();
      _speakList.clear();
      _spellingList.clear();

      getLetter();

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> gameInit() async {
    await checkAlreadyCompletd();
    getGame();
  }

  getLetter() {
    for (var element in letterData) {
      final Games gm = Games.fromJson(element);
      if (_completed.contains(gm.letter)) {
        gm.isCompleted = true;
        _unlocked.add(gm.nextUnlock);
      }
      if (_unlocked.contains(gm.letter)) {
        gm.isUnlocked = true;
      }
      sortAndAdd(gm);
      _gameList.add(gm);
    }
  }

  addCompleted(String letter) async {
    // get game ny letter and update isCompleted to true and add to completed
    _completed.add(letter);

    getGame();
  }

  sortAndAdd(Games games) {
    // make it in else if
    if (games.type == 'letter') {
      _letterList.add(games);
    } else if (games.type == 'number') {
      _numberList.add(games);
    } else if (games.type == 'speak') {
      _speakList.add(games);
    } else if (games.type == 'fill') {
      _spellingList.add(games);
    }
  }

  // filter by type and return list
  List<Games> getByType(String type) {
    if (type == 'letter') {
      return _letterList;
    } else if (type == 'number') {
      return _numberList;
    } else if (type == 'speak') {
      return _speakList;
    } else {
      return _spellingList;
    }
  }

  Future checkAlreadyCompletd() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await dbInstance.ref('users/${user!.uid}/completed').get();
    if (userData.value != null) {
      final Map<String, dynamic> data = jsonDecode(jsonEncode(userData.value));
      data.forEach((key, value) {
        _completed.add(key);
      });
    }
    getGame();
  }
}
