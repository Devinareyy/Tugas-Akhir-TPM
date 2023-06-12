import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_manga/pages/currency_page.dart';
import 'package:project_manga/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: OtherPage(),
    );
  }
}

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.remove('username');
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false,
                      );
                    },
                        icon: Icon(Icons.logout)),
                  ],
                )
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height:100),
                CircleAvatar(
                  backgroundImage: NetworkImage('https://cdn.discordapp.com/attachments/734105016276746341/1113588530363514900/informal.jpg'),
                  radius: 80,
                ),
                SizedBox(height:5),
                Text('Devina Reynitta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Teknologi Pemrograman Mobile merupakan salah satu matkul yang saya suka di semester 6, '
                        'walaupun tugasnya project terus, setidaknya melihat hasil tugasnya membuat saya senang.'
                        'Kemudian juga pak Bagus mengajarnya santai dan tidak tegang',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 80),
                OutlinedButton.icon(
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(child: Text('Early Access Cost ¥2000 / mo', style: TextStyle(fontWeight: FontWeight.bold))),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('or', style: TextStyle(fontSize: 20)),
                                SizedBox(height: 20),
                                Text('14.29 USD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('200,000 Rupiah', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('13.33 Euro', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.workspace_premium_outlined),
                    label: Padding(padding: EdgeInsets.all(10),child: Text('Go Premium', style: TextStyle(fontSize: 20))),
                ),
                TextButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CurrencyConverterPage()),
                      );
                    },
                    child: Text('Try to convert by yourself?')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
