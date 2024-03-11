import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'GlobalState.dart';
import 'DeviceConnectionPage.dart'; // Assume this is the page for connecting to devices

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalState>(
      builder: (context, globalState, child) => Scaffold(
        appBar: AppBar(
          title: Text('BLE Terminal'),
          actions: [
            Switch(
              value: globalState.isConnected,
              onChanged: (value) {
                if (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeviceConnectionPage()),
                  );
                } else {
                  globalState.setBluetoothConnection(false, '');
                }
              },
            ),
          ],
        ),
        body: Center(
          child: globalState.isConnected
              ? Text("Messages will be displayed here.")
              : Text("Please connect to the device."),
        ),
      ),
    );
  }
}
