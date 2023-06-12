import 'package:flutter/material.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:project_manga/theme/colors.dart';

class AnimeDetailPage extends StatefulWidget {
  final Map anime;

  const AnimeDetailPage({Key? key, required this.anime}) : super(key: key);

  @override
  State<AnimeDetailPage> createState() => _AnimeDetailPageState();
}

class _AnimeDetailPageState extends State<AnimeDetailPage> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = FavoriteAnime().isFavorite(widget.anime);
  }

  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });

    // Menambahkan atau menghapus anime dari daftar favorite
    if (isFavorite) {
      FavoriteAnime().addToFavorites(widget.anime);
    } else {
      FavoriteAnime().removeFromFavorites(widget.anime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
        child: getAppBar(),
        preferredSize: Size.fromHeight(200), // Adjust the height value as needed
      ),
      body: getBody(),
    );
  }

  Widget getAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: white,
      flexibleSpace: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 180,
            child: OverflowBox(
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.anime['images']['webp']['image_url']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(color: black.withOpacity(0.2)),
          ),
          Container(
            height: 180,
            width: double.infinity,
            child: Stack(
              children: [
                BlurryContainer(
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: white,
                                size: 22,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon:
                                    isFavorite ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border, color: Colors.white),
                                  onPressed: toggleFavorite,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.anime['title'].toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: white,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getFirstSection() {
    return Container(
      decoration: BoxDecoration(
        color: white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                widget.anime['episodes'].toString(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "Episodes",
                style: TextStyle(fontSize: 14, color: black.withOpacity(0.5)),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                widget.anime['status'].toString(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "Status",
                style: TextStyle(fontSize: 14, color: black.withOpacity(0.5)),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                widget.anime['score'].toString(),
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "Score",
                style: TextStyle(fontSize: 14, color: black.withOpacity(0.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget getSecondSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Synopsis",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 15),
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: widget.anime['synopsis'].toString(),
            style: TextStyle(fontSize: 14, color: black.withOpacity(0.8)),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget getBody() {
    return ListView(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getFirstSection(),
              SizedBox(height: 20),
              getSecondSection(),
              SizedBox(height: 20),
              // Add more sections and widgets here for manga details
            ],
          ),
        ),
      ],
    );
  }
}

class FavoriteAnime {
  static final FavoriteAnime _instance = FavoriteAnime._internal();

  factory FavoriteAnime() {
    return _instance;
  }

  FavoriteAnime._internal();

  static List<dynamic> FavoriteAnimes = [];

  void addToFavorites(dynamic favoriteAnime) {
    FavoriteAnimes.add(favoriteAnime);
  }

  void removeFromFavorites(dynamic favoriteAnime) {
    FavoriteAnimes.remove(favoriteAnime);
  }

  bool isFavorite(dynamic favoriteAnime) {
    return FavoriteAnimes.contains(favoriteAnime);
  }
}
