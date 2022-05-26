import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  late ServerStatus _serverStatus = ServerStatus.connecting;

  ServerStatus get serverStatus => _serverStatus;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    IO.Socket socket = IO.io('http://172.16.0.60:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    socket.on('event', (data) => log(data));
    socket.on('fromServer', (_) => log(_));

    socket.onDisconnect((data) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    socket.on('new-message', (data) {
      log('New message: ${data['message']}');
    });
  }
}
