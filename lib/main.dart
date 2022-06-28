import 'package:flutter/material.dart';
import 'package:login_auth/data/join_or_login.dart';
import 'package:login_auth/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Material 라이브러리를 가지고 왔기 때문에 MaterialApp 위젯을 사용함
    //컨트롤 클릭 하면 constructor들을 확인할 수 잇따
    return MaterialApp(
      //제공하는 데이터를 명시해야함 JoinOrLogin
      home: ChangeNotifierProvider<JoinOrLogin>.value(
        //value<-오브젝트를 '생성'해서 전달하는 것
          value: JoinOrLogin(), child: AuthPage()),
    );
  }
}
