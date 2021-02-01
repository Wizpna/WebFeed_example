import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

void main() async {
  runApp(MaterialApp(
    home: MyHashnode(),
  ));
}

class MyHashnode extends StatefulWidget {
  @override
  _MyHashnodeState createState() => _MyHashnodeState();
}

class _MyHashnodeState extends State<MyHashnode> {
  
  //initializing http package
  var client = http.Client();

  Future myDevBlog() async {
    //Making a http get request from my hashnode blog
    var response = await client.get('https://promise.hashnode.dev/rss.xml');
    var channel = RssFeed.parse(response.body);
    final item = channel.items;
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Promise Amadi\'s Blog'),
      ),
      body: StreamBuilder(
        stream: myDevBlog().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: ListTile(
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].description),
                    leading: Text((1 + index).toString()),
                  )),
                );
              },
            );
          } else if (snapshot.hasError ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
