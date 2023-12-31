import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:project_manga/dbmodel/user.dart';
import 'package:project_manga/main.dart';
import 'package:project_manga/pages/register_page.dart';
import 'package:project_manga/pages/root_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late Box<UserModel> _myBox;
  late SharedPreferences prefs;

  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    checkIsLogin();
    _myBox = Hive.box(boxName);
  }

  void checkIsLogin() async {
    prefs = await SharedPreferences.getInstance();

    bool? isLogin = (prefs.getString('username') != null) ? true : false;

    if(isLogin && mounted){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) => RootApp(),
      ),
              (route) => false);
    }
  }

  void _goToRegister() {
    Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }


  void _login() async {

      bool found = false;
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      found = checkLogin(username, hashedPassword);

      if (!found) {
        _showSnackbar('Username or Password is Wrong');
        _isObscure = false;
      } else {
        await prefs.setString('username', username);
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => RootApp(),
            ),
                (route) => false,
          );
        }
        _showSnackbar('Login Success');
        _isObscure = true;
      }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Anime Journey',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
            Container(
              width: 300,
              height: 300,
              child: Image.network(
                'https://cdn.discordapp.com/attachments/734105016276746341/1113605113718775839/Bazo.png',
              ),
            ),
            const SizedBox(height: 10),
            const Text('Login',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black)),
            const SizedBox(height: 10,),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: _usernameController,
                          cursorColor: const Color(0xffc1071e),
                          style: const TextStyle(fontSize: 15, color: Colors.black),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.people),
                            filled: true,
                            fillColor: Colors.white24,
                            labelText: 'Username',
                            labelStyle: const TextStyle(color: Colors.black),
                            hintText: 'Input your Username',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color(0xFFA8C1D2),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF3CA9FC),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: _passwordController,
                          style: const TextStyle(fontSize: 15, color: Colors.black),
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: Colors.white24,
                            labelText: 'Password',
                            labelStyle: const TextStyle(color: Colors.black),
                            hintText: 'Input your Password',
                            hintStyle: const TextStyle(color: Colors.grey),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: const BorderSide(
                                color: Color(0xFFA8C1D2),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: const BorderSide(
                                color: Color(0xFF3CA9FC),
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: _goToRegister, // Navigate to RegisterScreen
                      child: const Text(
                        "Register here",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: SizedBox(
                        width: 300,
                        height: 50,
                        child: Builder(builder: (context) {
                          return ElevatedButton(
                            onPressed: _login,
                            child:
                            const Text('Login', style: TextStyle(fontSize: 15)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  int getLength() {
    return _myBox.length;
  }

  bool checkLogin(String username, String password) {
    bool found = false;
    for (int i = 0; i < getLength(); i++) {
      if (username == _myBox.getAt(i)!.username &&
          password == _myBox.getAt(i)!.password) {
        ("Login Success");
        found = true;
        break;
      } else {
        found = false;
      }
    }

    return found;
  }

  bool checkUsers(String username) {
    bool found = false;
    for (int i = 0; i < getLength(); i++) {
      if (username == _myBox.getAt(i)!.username) {
        found = true;
        break;
      } else {
        found = false;
      }
    }
    return found;
  }
}
