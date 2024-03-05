import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo/chat.dart';
import 'package:firebase_demo/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async{
  await initFirebase();
  runApp(const MyApp());
}

Future<void> initFirebase() async{
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseAuth auth = FirebaseAuth.instance;
  if(auth.currentUser == null){
    var user = await auth.createUserWithEmailAndPassword(email: "chatdemo${Random().nextInt(999999) + 999999}@chat.com", password: "12345678");
    await user.user?.updateDisplayName("User #${Random().nextInt(999999) + 999999}");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Chat(),
    );
  }
}