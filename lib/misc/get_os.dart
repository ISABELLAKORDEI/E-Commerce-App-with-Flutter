import 'dart:io';

class Misc {
  static String getOS() {
    final os = Platform.operatingSystem;
    if (os == 'ios') {
      return 'iOS';
    } else if (os == 'android') {
      return 'Android';
    } else {
      return 'Android';
    }
  }
}
