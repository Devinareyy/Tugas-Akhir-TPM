import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:project_manga/dbmodel/user.dart';
import 'package:project_manga/main.dart';
import 'package:project_manga/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SharedPreferences prefs;
  late Box<UserModel> _myBox;

  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    Initial();
    _myBox = Hive.box(boxName);
  }

  void Initial() async {
    prefs = await SharedPreferences.getInstance();
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
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
          (route) => false,);
  }

  Future<void> _register() async{
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      final hashedPassword = sha256.convert(utf8.encode(password)).toString();
      _myBox.add(UserModel(
        username: username,
        password: hashedPassword,
      ));
      _showSnackbar('Registration successful');
      await prefs.remove("username");
      _goToLogin();
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
            Container(
              width: 300,
              height: 300,
              child: Image.network(
                'https://cdn.discordapp.com/attachments/734105016276746341/1113605128470147192/pengu.png',
              ),
            ),
            const SizedBox(height: 10),
            const Text('Register',
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
                            onPressed: _register,
                            child:
                            const Text('Register', style: TextStyle(fontSize: 15)),
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
            ),
            BackButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}