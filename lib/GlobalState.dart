import 'package:flutter/material.dart';

class GlobalState with ChangeNotifier {
  bool _isConnected = false;
  String _bluetoothID = '';

  bool get isConnected => _isConnected;
  String get bluetoothID => _bluetoothID;

  void setBluetoothConnection(bool connected, String id) {
    _isConnected = connected;
    _bluetoothID = id;
    notifyListeners();
  }
}
