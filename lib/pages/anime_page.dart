import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_manga/pages/anime_detail_page.dart';

class AnimeListPage extends StatefulWidget {
  @override
  _AnimeListPageState createState() => _AnimeListPageState();
}

class _AnimeListPageState extends State<AnimeListPage> {
  List<dynamic> animeList = [];
  List<dynamic> filteredAnimeList = [];
  TextEditingController searchController = TextEditingController();
  int currentPage = 1;
  bool isLoading = false;

  Future<void> fetchAnimeData({int page = 1}) async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse("https://api.jikan.moe/v4/anime?page=$page"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> fetchedAnimeList = data['data'];
        setState(() {
          animeList.addAll(fetchedAnimeList);
          filteredAnimeList = animeList;
        });
      }
    } catch (error) {
      // Handle error here
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchAnimeData();
    super.initState();
  }

  void searchAnime(String query) {
    setState(() {
      filteredAnimeList = animeList.where((anime) {
        final title = anime['title'].toString().toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  Widget buildAnimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: filteredAnimeList.length,
      itemBuilder: (context, index) {
        final anime = filteredAnimeList[index];
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
            width: MediaQuery.of(context).size.width / 2.5,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(
                          anime['images']['webp']['image_url'],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  anime['title'].toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  anime['status'].toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAnimeList() {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.0),
              color: Colors.grey.withOpacity(0.1),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Find new anime to watch',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              height: 40,
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 8),
                child: TextField(
                  controller: searchController,
                  cursorColor: Colors.blue,
                  onChanged: searchAnime,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search...",
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Anime List",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
        buildAnimeGrid(),
        if (isLoading) CircularProgressIndicator(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: animeList.isEmpty && isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchAnimeData(page: currentPage + 1);
            return true;
          }
          return false;
        },
        child: buildAnimeList(),
      ),
    );
  }
}
