

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Profile.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile profile = Profile(name: "", dob: "", height: 0, weight: 0);

  // State
  bool loading = false;

  // Firebase collection
  final CollectionReference profileCollection = FirebaseFirestore.instance.collection("babyProfiles");

  ProfileChangeNotifier(){
    fetch();
  }

  Future fetch() async {
    loading = true;
    notifyListeners();

    var doc = await profileCollection.doc("exampleProfile").get();
    final data = doc.data()! as Map<String, dynamic>;
    profile = Profile.fromJson(data);

    loading = false;
    notifyListeners();
  }

  Future updateProfile(Profile updatedProfile, Function callback) async {
    loading = true;
    notifyListeners();

    await profileCollection.doc("exampleProfile").set(updatedProfile.toJson());
    await fetch();

    callback();
  }
}