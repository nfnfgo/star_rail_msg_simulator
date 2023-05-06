// Fundamentals
import 'package:flutter/material.dart';

class SRIMSettingsInfo with ChangeNotifier {
  SRIMSettingsInfo() {
    chatWindowsFullScreen = false;
  }

  /// If the chat windows UI is full screen
  bool chatWindowsFullScreen = false;

  /// Same as this.notifyListeners(), throw error if failed to notify litseners
  void notify() {
    try {
      notifyListeners();
    } catch (e) {
      throw Exception(
          '[CanNotNotifyListenersError] Failed to notify listeners, please make sure '
          'that this instance is created by a ChangeNotifierProvider widget');
    }
  }
}
