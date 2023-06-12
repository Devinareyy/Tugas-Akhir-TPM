import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:project_manga/pages/anime_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List? AnimeList;

  Future<void> fetchMangaData() async {
    final response = await http.get(Uri.parse("https://api.jikan.moe/v4/top/anime"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        AnimeList = data['data'];
      });
    }
  }

  @override
  void initState() {
    fetchMangaData();
    super.initState();
    _currentTime = DateTime.now();
    _startTimer();
  }

//======================FOR CLOCK==================//
  late DateTime _currentTime;
  String _timeZone = 'WIB';
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _currentTime = DateTime.now().add(Duration(hours: _getTimeZoneOffset()));
      });
    });
  }

  int _getTimeZoneOffset() {
    switch (_timeZone) {
      case 'WIB':
        return 0;
      case 'WITA':
        return 1;
      case 'WIT':
        return 2;
      case 'London':
        return -6;
      default:
        return 0;
    }
  }

  void _changeTimeZone(String newTimeZone) {
    setState(() {
      _timeZone = newTimeZone;
    });
  }
//==================================================//

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('HH:mm:ss').format(_currentTime),
                      style: TextStyle(fontSize: 24),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Center(child: Text('Change Time Zone', style: TextStyle(fontWeight: FontWeight.bold),)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _changeTimeZone('WIB');
                                    },
                                    child: Text('WIB', style: TextStyle(fontSize: 20)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _changeTimeZone('WITA');
                                    },
                                    child: Text('WITA', style: TextStyle(fontSize: 20)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _changeTimeZone('WIT');
                                    },
                                    child: Text('WIT', style: TextStyle(fontSize: 20)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _changeTimeZone('London');
                                    },
                                    child: Text('London', style: TextStyle(fontSize: 20)),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
            getSectionQuote(),
            SizedBox(height: 30),
            readerToday(),
            SizedBox(height: 30),
            AnimeList != null
                ? buildAnimeList()
                : CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }


  Widget getSectionQuote() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You can access the new update early!",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Get access to the newest update 1 week early than everyone else. Go check 'Other' > 'Go Premium'",
              style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: (){}, child: Text("Or Click Here")),
            ),
          ],
        ),
      ),
    );
  }

  Widget readerToday() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hot release this season",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 15),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(
                "https://pbs.twimg.com/media/Fthcr64XsAAVBnt.jpg:large",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 15),
        Text(
          "[Oshi No Ko] Idol sempurna dengan background misterius",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget buildAnimeList() {
    var size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Recommendation",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AnimeList?.take(10).map<Widget>((anime) {
              return GestureDetector(
                onTap: () {
                  // Handle navigation to anime detail page here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnimeDetailPage(anime: anime),
                    ),
                  );
                },
                child: Container(
                  width: size.width / 2.5,
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(anime['images']['webp']['image_url']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        anime['title'].toString(),
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        anime['status'].toString(),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList() ?? [],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}
