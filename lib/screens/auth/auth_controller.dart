import 'dart:convert';
import 'package:e_commerce_app/screens/auth/auth_urls.dart';
import 'package:e_commerce_app/screens/auth/auth_widgets.dart';
import 'package:e_commerce_app/screens/auth/login.dart';
import 'package:e_commerce_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends GetxController {
  late DateTime _expiryDate = DateTime.now().add(const Duration(days: 100));
  late String _userId;
  late String _token = "";
  late Map<String, dynamic> _profile = {};
  late bool _isFirstTime = true;

  Auth() {
    debugPrint("#################");
    debugPrint("##### AUTH ######");
    debugPrint("#################");

    getStorageToken();
  }

  get authHeaders {
    return {"Content-Type": "application/json"};
  }

  get headers {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token"
    };
  }

  signUp(List userdata) async {
    var body = jsonEncode({
      'first_name': userdata[0],
      'last_name': userdata[1],
      'email': userdata[2],
      'phone': userdata[3],
      'password': userdata[4]
    });
    debugPrint(body);

    try {
      var res =
          await http.post(Uri.parse(signUpUrl), body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);
      if (res.statusCode == 201) {
        var token = json.decode(res.body)["token"]["access_token"];
        _token = token;
        await setTokenInfo(json.decode(res.body)["token"]);

        var profile = json.decode(res.body)["profile"];
        setProfile(profile);
        debugPrint('Data posted');
        showSnackbar(
            path: Icons.check_rounded,
            title: "Successful Sign Up!",
            subtitle: "Welcome! Happy Shopping :)");
        await Future.delayed(const Duration(seconds: 2));
        Get.off(() => const Homescreen());

        return;
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Failed Sign Up!",
            subtitle: "Looks like the user email already exists!");
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed Sign Up!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  updateUser(String gender, String dob) async {
    var body = jsonEncode({'gender': gender, 'dob': dob});
    debugPrint(body);
    var prefs = await SharedPreferences.getInstance();
    var token = json.decode(prefs.getString("token")!);
    _token = token['access_token'];

    try {
      var res = await http.patch(Uri.parse(updateUserUrl),
          body: body, headers: headers);
      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);
      if (res.statusCode == 200) {
        var profile = json.decode(res.body);
        setProfile(profile);
        debugPrint('Data posted');
        showSnackbar(
            path: Icons.check_rounded,
            title: "Details successfully added!",
            subtitle: "Just one more step");
        await Future.delayed(const Duration(seconds: 2));
        Get.offAll(() => const Homescreen());
        return;
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Update Failed",
            subtitle: "Please try again later!");
      }
      return;
    } catch (error) {
      debugPrint("$error");
      showSnackbar(
          path: Icons.close_rounded,
          title: "Details not updated!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

  signIn(String email, String password) async {
    var body = json.encode({"username": email, "password": password});
    debugPrint(body);
    try {
      var res = await http.post(Uri.parse(signInUrl),
          body: body, headers: authHeaders);

      debugPrint("Got response ${res.statusCode}");
      debugPrint(res.body);
      var respBody = json.decode(res.body);
      if (res.statusCode == 200) {
        debugPrint('$respBody');
        _token = respBody['access_token'];
        _expiryDate =
            DateTime.now().add(Duration(seconds: respBody['expires_in']));
        await setTokenInfo(respBody);
        var profileResp = await getProfile();
        if (profileResp.statusCode == 200) {
          var profile = json.decode(profileResp.body);
          debugPrint("Setting body");
          _userId = profile['id'].toString();
          setProfile(profile);
          debugPrint("Done setting body :)");
        }
      } else {
        showSnackbar(
            path: Icons.close_rounded,
            title: "Failed Sign In!",
            subtitle:
                "Please confirm account credentials are correct or exist");
      }
      return res;
    } catch (error) {
      debugPrint('$error');
      showSnackbar(
          path: Icons.close_rounded,
          title: "Failed Sign In!",
          subtitle: "Please check your internet connection or try again later");
    }
  }

/* --- tokens --- */
  Future<void> setTokenInfo(info) async {
    debugPrint('$info');
    if (info == null) {
      return;
    }
    _token = info["access_token"];
    _expiryDate = DateTime.now().add(Duration(seconds: info['expires_in']));
    return await storeTokenInfo(info);
  }

  Future<void> storeTokenInfo(info) async {
    var _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("token", json.encode(info));
  }

  String getToken() {
    if (_expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return _token;
  }

  Future<bool> getStorageToken() async {
    var _prefs = await SharedPreferences.getInstance();
    bool foundToken = false;
    if (_prefs.containsKey("token")) {
      var token = json.decode(_prefs.getString("token")!);
      _token = token['access_token'];
      setTokenInfo(token);
      if (_prefs.containsKey("profile")) {
        _profile = json.decode(_prefs.getString("profile")!);
      } else {
        debugPrint("No profile found.");
      }
      foundToken = true;
    } else {
      debugPrint("No token found.");
    }
    return foundToken;
  }

/* --- get profile --- */

  void setProfile(profile) async {
    _profile = profile;
    var _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("profile", json.encode(profile));
    debugPrint('$profile');
  }

  Future<http.Response> getProfile() {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token"
    };
    return http.get(Uri.parse(profileUrl), headers: headers);
  }

  void updateProfile() async {
    debugPrint("getting the profile");
    var profileResp = await getProfile();

    if (profileResp.statusCode == 200) {
      var profile = json.decode(profileResp.body);
      debugPrint('$profile');
      setProfile(profile);
    }
  }

  void doGetProfile() async {
    var profileResp = await getProfile();
    if (profileResp.statusCode == 200) {
      var profile = json.decode(profileResp.body);
      setProfile(profile);
      debugPrint("Setting profile Complete :)");
    }
  }

/* --- sign out --- */
  Future<bool> logout() async {
    debugPrint("Logging out");
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    _profile = {};
    await clearStorage();
    await Future.delayed(const Duration(seconds: 2));
    Get.offAll(const Login());
    return true;
  }

  Future<bool> clearStorage() async {
    var _prefs = await SharedPreferences.getInstance();
    return _prefs.clear();
  }
}
