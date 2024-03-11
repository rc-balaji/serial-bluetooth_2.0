import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'DeviceConnectionPage.dart';
import 'GlobalState.dart';
import 'ChatPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(
      builder: (context, globalState, child) => Scaffold(
        appBar: AppBar(
          title: Text('BLE Terminal'),
          actions: [
            IconButton(
              icon: Icon(globalState.isConnected ? Icons.bluetooth_connected : Icons.bluetooth_disabled),
              onPressed: () {
                if (!globalState.isConnected) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DeviceConnectionPage()));
                } else {
                  globalState.setBluetoothConnection(false, '', '', '',null);
                }
              },
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: globalState.isConnected
                  ? Column(
                children: [
                  Text("Connected to: ${globalState.deviceName}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text("MAC Address: ${globalState.deviceAddress}", style: TextStyle(fontSize: 16)),
                ],
              )
                  : Text("Please connect to the device.", style: TextStyle(fontSize: 20)),
            ),
            Expanded(
              child: globalState.isConnected
                  ? ChatPage()
                  : Center(child: Text("No device connected.")),
            ),
          ],
        ),
      ),
    );
  }
}
