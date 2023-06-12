import 'package:flutter/material.dart';
import 'package:project_manga/pages/anime_detail_page.dart';

class FavoriteAnimePage extends StatefulWidget {
  @override
  _FavoriteAnimePageState createState() => _FavoriteAnimePageState();
}

class _FavoriteAnimePageState extends State<FavoriteAnimePage> {
  List<dynamic> favoriteMangaList = FavoriteAnime.FavoriteAnimes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            color: Colors.grey.withOpacity(0.1),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Favorite',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: favoriteMangaList.isEmpty
          ? Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Image.network(
          'https://cdn.discordapp.com/attachments/734105016276746341/1113553470067318905/slime.png',
          height: 100,
          ),
          SizedBox(height: 16),
          Text('YOU DON`T HAVE ANY FAVORITE?!'),
          ],
          ),
          )
                : ListView.builder(
              itemCount: favoriteMangaList.length,
              itemBuilder: (context, index) {
                final manga = favoriteMangaList[index];
                return GestureDetector(
                  onTap: () {
                    // Handle tap on the ListTile
                    // Add your desired functionality here
                    // For example, navigate to a detail page:
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimeDetailPage(anime: manga),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.network(manga['images']['webp']['image_url']),
                    title: Text(manga['title'].toString()),
                    subtitle: Text(manga['status'].toString()),
                    // Add more details or customize the layout as needed
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
