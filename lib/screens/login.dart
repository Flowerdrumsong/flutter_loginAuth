import 'package:flutter/material.dart';
import 'package:login_auth/data/join_or_login.dart';
import 'package:login_auth/helper/login_background.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main_page.dart';

class AuthPage extends StatelessWidget {
  //global key 생성 폼 키는 unique id
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String userEmail;
  late String userPassword;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              size: size,
              painter:
              LoginBackground(isJoin: Provider
                  .of<JoinOrLogin>(context)
                  .isJoin),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _logoImage,
                // Image.asset("assets/loading.gif"),
                Stack(
                  children: <Widget>[
                    _inputForm(size),
                    _autoButton(size),
                  ],
                ),
                Container(
                  height: size.height * 0.1,
                ),
                Consumer<JoinOrLogin>(
                  builder: (context, JoinOrLogin, child) =>
                      GestureDetector(
                          onTap: () {
                            JoinOrLogin.toggle();
                          },
                          child: Text(
                            JoinOrLogin.isJoin
                                ? "Already Have an Account? Sign in!"
                                : "Don't Have an Account? Create One!",
                            style: TextStyle(
                                color: JoinOrLogin.isJoin ? Colors.red : Colors
                                    .blue),
                          )),
                ),
                //높이의 비율을 따져서 5%의 여백을 줌
                Container(
                  height: size.height * 0.05,
                )
              ],
            )
          ],
        ));
  }

  void _register(BuildContext context, String userEmail, String userPassword) async {
    final _authentication = FirebaseAuth.instance;
    userEmail=this.userEmail;
    userPassword=this.userPassword;
    try {
      final newUser = _authentication.createUserWithEmailAndPassword(
          email: userEmail,
          password: userPassword
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
    }catch(e){
      print("e");
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:Text('Please try again later.'),
          ),
      );
    }
  }

  void _login(BuildContext context) async {
    // final UserCredential result=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    final User user = result.user!;

    if (user == null) {
      const snackBar = SnackBar(
        content: Text("Please try again later."),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    //메인페이지로 보내기
    // Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage(email: user.email)));
  }

  Widget get _logoImage =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Consumer<JoinOrLogin>(
              builder: (context, JoinOrLogin, child) =>
                  CircleAvatar(
                    backgroundImage: AssetImage(JoinOrLogin.isJoin
                        ? "assets/main_img.jpg"
                        : "assets/sean.gif"),
                    // backgroundImage: NetworkImage("https://c.tenor.com/1isjQ4IQwlQAAAAC/xiao-zhan-sean-xiao.gif"),
                  ),
            ),
          ),
        ),
      );

  Widget _autoButton(Size size) {
    return Positioned(
      left: size.width * .1,
      right: size.width * .1,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: Consumer<JoinOrLogin>(
          builder: (context, JoinOrLogin, child) =>
              ElevatedButton(
                  child: Text(
                    JoinOrLogin.isJoin ? "Join" : "Login",
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: JoinOrLogin.isJoin ? Colors.red : Colors.blue,
                  ),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(25)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print(userEmail);
                      print(userPassword);
                      _register(context, userEmail, userPassword);
                      _login(context);
                    }
                  }),
        ),
      ),
    );
  }

  Widget _inputForm(Size size) {

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Card(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular((16))),
        elevation: 6,
        child: Padding(
          padding:
          const EdgeInsets.only(left: 12.0, right: 12, top: 12, bottom: 32),
          child: Form(
            //사용자가 input 필드에 작성하면 > 상태가 변화 > 변한 상태를 폼키를 통해서 접근할 수 있음
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.account_circle),
                      labelText: "Email",
                    ),
                    onSaved: (value) {
                      print("text filed: $value");
                      userEmail = value!;
                    },
                    onChanged: (value) {
                      userEmail = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please input correct Email.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //입력하는 값 숨기기 .으로..
                    obscureText: true,
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.vpn_key),
                      labelText: "Password",
                    ),
                    onSaved: (value) {
                      print("text filed: $value");
                      userPassword = value!;
                    },
                    onChanged: (value) {
                      userPassword = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please input correct Password.";
                      }
                      return null;
                    },
                  ),
                  Container(
                    height: 8,
                  ),
                  Consumer<JoinOrLogin>(
                    builder: (context, JoinOrLogin, child) =>
                        Opacity(
                            opacity: JoinOrLogin.isJoin ? 0 : 1,
                            child: const Text("Forget Password?")),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
