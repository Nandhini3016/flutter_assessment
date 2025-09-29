import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/video_call_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Assessment Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (c) => LoginScreen(),
        '/users': (c) => UserListScreen(),
        '/video': (c) => VideoCallScreen(),
      },
    );
  }
}
