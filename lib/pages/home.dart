import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wally/pages/singleImage.dart';

// import '../api_key.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var photos = [];
  TextEditingController query = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPhotos("");
  }

  getPhotos(final String searchQuery) async {
    var head = {
      "Authorization":
          "YOUR_API_KEY_HERE"
    }; //TODO: replace apiKey with your own API key
    var url = Uri.parse(searchQuery == ""
        ? 'https://api.pexels.com/v1/curated?per_page=30'
        : "https://api.pexels.com/v1/search?query=$searchQuery&per_page=40");
    var response = await http.get(url, headers: head);
    var data = jsonDecode(response.body);
    setState(() {
      photos = data['photos'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          //body images
          SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 1,
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: (200 / 400),
                    children: List.generate(photos.length, (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SingleImageView(data: photos[index])));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            photos[index]['src']['medium'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              )
            ]),
          ),

          Padding(
            padding:
                const EdgeInsets.only(right: 15, left: 15, bottom: 5, top: 45),
            child: TextField(
              onSubmitted: (query) => getPhotos(query),
              controller: query,
              onChanged: ((e) => {debugPrint(e)}),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                hintText: 'Search Wallpapers here',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}
