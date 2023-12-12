import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "API photo fetch",
        debugShowCheckedModeBanner: false,
        home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  List<dynamic> data = [];
  String imageUrl = "";
  @override
  initState() {
    getData();
    super.initState();
  }

  getData() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/photos");
    var response = await http.get(url);

    setState(() {
      data = json.decode(response.body);
    });

    if (data.isEmpty) {
      const Text("Error: non images fetched!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Text("Gallery"), backgroundColor: Colors.green),
        body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, //3 items per row
                crossAxisSpacing:
                    10.0, //Spacing between each itme in the cross axis
                mainAxisSpacing: 10.0
                // Spacing between each row in the main axis
                ),
            itemCount: data.length > 30 ? 30 : data.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    imageUrl = data[index]["url"];
                  });

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SecondPage(imageUrl: imageUrl)));
                },
                child: Image.network(
                  data[index]["url"],
                  width: 100,
                  height: 100,
                ),
              );
            }));
  }
}

class SecondPage extends StatelessWidget {
  final String imageUrl;
  const SecondPage({required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gallery"),
          backgroundColor: Colors.green,
        ),
        body: Center(
            child: imageUrl.isNotEmpty
                ? Image.network(imageUrl)
                : const Text("No image selected")));
  }
}
