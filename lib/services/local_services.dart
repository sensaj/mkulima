import 'dart:convert';

import 'package:mkulima/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalServices {
  Future<bool> checkLoginState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final results = preferences.getBool("hasLogin");

    return results != null && results;
  }

  Future setInstance(
      {required String key, required type, required value}) async {
    final instance = await SharedPreferences.getInstance();

    switch (type) {
      case String:
        instance.setString(key, value);
        break;
      case List:
        instance.setStringList(key, value);
        break;
      case int:
        instance.setInt(key, value);
        break;
      case bool:
        instance.setBool(key, value);
        break;
    }
  }

  Future getInstance({required String key, required type}) async {
    final instance = await SharedPreferences.getInstance();
    var value;
    switch (type) {
      case String:
        value = instance.getString(key);
        break;
      case List:
        value = instance.getStringList(key);
        break;
      case int:
        value = instance.getInt(key);
        break;
      case bool:
        value = instance.getBool(key);
        break;
    }
    return value;
  }

  Future removeInstance({required String key}) async {
    final instance = await SharedPreferences.getInstance();
    instance.remove(key);
  }

  Future<User?> getLocalUserData() async {
    final userData = await getInstance(key: "userData", type: String);
    print(userData);
    if (userData != null) {
      final userResults = json.decode(userData);
      User user = User.fromMap(userResults);
      return user;
    }
    return null;
  }
}

LocalServices local = LocalServices();
