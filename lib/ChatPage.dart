import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'GlobalState.dart'; // Make sure this import path matches your file structure

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _Message {
  int whom;
  String text;
  _Message(this.whom, this.text);
}

class _ChatPageState extends State<ChatPage> {
  static final clientID = 0;
  BluetoothConnection? connection;
  List<_Message> messages = List<_Message>.empty(growable: true);
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  bool isConnecting = true;
  bool get isConnected => connection?.isConnected ?? false;
  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initConnection());
  }

  void _initConnection() async {
    await _requestPermissions();
    connection = Provider.of<GlobalState>(context, listen: false).connection;
    if (connection != null) {
      setState(() {
        isConnecting = false;
      });
      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected by remote request');
        }
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Future<void> _requestPermissions() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverName = Provider.of<GlobalState>(context).deviceName;
    return Scaffold(
      appBar: AppBar(
        title: isConnecting
            ? Text('Connecting to $serverName...')
            : isConnected
                ? Text('Connected to $serverName')
                : Text('Chat Log with $serverName'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(12.0),
                controller: listScrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  var message = messages[index];
                  return ListTile(
                    title: Text(
                      ">${message.text}",
                      style: TextStyle(
                          color: message.whom == clientID
                              ? Colors.blue
                              : Colors.red),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(left: 16.0),
                    child: TextField(
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: isConnected
                            ? 'Type your message...'
                            : 'Chat got disconnected',
                      ),
                      enabled: isConnected,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: isConnected
                      ? () => _sendMessage(textEditingController.text)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _buffer = ''; // Buffer to store incomplete messages

      void _onDataReceived(Uint8List data) {
        // Append new data to buffer
        _buffer += utf8.decode(data);

        // Process complete words by splitting at spaces or newline
        List<String> words = _buffer.split(RegExp(r'[ \n]'));

        // Keep the last element in the buffer if it's incomplete
        _buffer = words.removeLast();

        // Add each complete word to the messages list
        for (var word in words) {
          if (word.isNotEmpty) {
            setState(() {
              this.messages.add(_Message(1, word.trim()));
            });

            // Scroll to the latest message
            Future.delayed(Duration(milliseconds: 333)).then((_) {
              listScrollController.animateTo(
                listScrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 333),
                curve: Curves.easeOut,
              );
            });
          }
        }
      }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();
    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;
        setState(() {
          messages.add(_Message(clientID, text));
        });
        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Handle error
      }
    }
  }
}
