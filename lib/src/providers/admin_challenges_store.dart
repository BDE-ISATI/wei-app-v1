import 'dart:convert';
import 'dart:typed_data';

import 'package:appli_wei_custom/models/administration/admin_challenge.dart';
import 'package:appli_wei_custom/services/challenge_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AdminChallengesStore with ChangeNotifier {
  AdminChallengesStore({@required this.authorizationHeader});

  final List<AdminChallenge> _challenges = [];

  final String authorizationHeader;

  Future<List<AdminChallenge>> getChallenges({bool forceUpdate = false}) async {
    if (_challenges.isEmpty || forceUpdate) {
      _challenges.clear();
      try {
        _challenges.addAll(await ChallengeService.instance.challengesForAdministration(authorizationHeader));
      }
      catch (e) {
        throw Exception("Impossible d'obtenir les challenges : ${e.toString()}");
      }
    }

    return _challenges;
  }

  Future<String> createChallenge(AdminChallenge toCreate) async {
    if (toCreate.image.isEmpty) {
      final ByteData bytes = await rootBundle.load('assets/logo.jpg');
      
      final buffer = bytes.buffer;
      toCreate.image = base64.encode(Uint8List.view(buffer));
    }

    try {
      toCreate.id = await ChallengeService.instance.createChallenge(authorizationHeader, toCreate);
      
      _challenges.add(toCreate);
      notifyListeners();
      
      return "";
    }
    catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }

  Future<String> updateChallenge(AdminChallenge toUpdate) async {
    try {
      await ChallengeService.instance.updateChallenge(authorizationHeader, toUpdate);
      
      // We need to notify listeners to update images
      notifyListeners();

      return "";
    }
    catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }

  Future<String> deleteChallenge(AdminChallenge toDelete) async {
    try {
      ChallengeService.instance.deleteChallenge(authorizationHeader, toDelete);
      
      _challenges.remove(toDelete);
      notifyListeners();
      
      return "";
    }
    catch (e) {
      return "Erreur : ${e.toString()}";
    }
  }

  void refreshData() {
    _challenges.clear();
    notifyListeners();
  }

}