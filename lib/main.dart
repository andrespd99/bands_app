import 'package:bands_app/pages/home.dart';
import 'package:bands_app/pages/status.dart';
import 'package:bands_app/services/socket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        title: 'Band App',
        home: StatusPage(),
      ),
    );
  }
}
