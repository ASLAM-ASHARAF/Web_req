import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:web_req/models/post.dart';
import 'package:web_req/screen/create.dart';
import 'package:web_req/screen/edit.dart';

import '../data/url.dart';


class home_page extends StatefulWidget {

  const home_page({Key? key}) : super(key: key);

  @override
  State<home_page> createState() => _home_pageState();
}

class _home_pageState extends State<home_page> {

  List<Post>? posts;
  bool isLoaded = true;

  @override
  void initState() {
    print("aaaa");
    // TODO: implement initState
    super.initState();
    getall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Web Req", style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.black26,


      ),
      body:RefreshIndicator(
        onRefresh: getall,
        child: Visibility(
          visible: isLoaded,
          child: SafeArea(child: ListView.builder(
            itemCount: posts?.length, itemBuilder: (context, index) {
              final post = posts? [index];
            return GestureDetector(
              onTap: () {

              },
              child: Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [


                            Expanded(child: Text(posts?[index].title ?? "",
                              style: TextStyle(color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,), maxLines: 1,)),
                            IconButton(onPressed: Delete,
                                icon: Icon(Icons.delete, color: Colors.red,)),
                            IconButton(onPressed: (){
                              navtoeditpage(posts?[index]);
                            },
                                icon: Icon(Icons.edit, color: Colors.blue,)),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Expanded(child: Text(posts?[index].body ?? "",
                          style: TextStyle(color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            overflow: TextOverflow.ellipsis,), maxLines: 4,)),
                      ],
                    ),
                  ),

                ],
              ),
            );
          },)),
          replacement: const Center(child: CircularProgressIndicator(),),
        ),
      ),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: navtocreatepage,
          label: Text('Create')
      ),
    );
  }

  void navtocreatepage() {
    final route = MaterialPageRoute(builder: (context) =>
        create()

    );
    Navigator.push(context, route);
      //   .then((value) {
      // if (value == true) {
      //   getall();
      // }
    // }
    // );
  }
  void navtoeditpage(Post? posts) {
    print("aaaaaaaaaaaaaaa${posts?.title}");
    print("aaaaaaaaaaaaaa${posts?.body}");
    final route = MaterialPageRoute(builder: (context) =>
        edit(post: posts,)

    );
    Navigator.push(context, route)
      .then((value) {
    if (value == true) {
      getall();
    }
    }
    );
  }
  Future<void> getall() async {
    final url = Url();
    final uri = Uri.parse(url.baseUrl + url.getAllNote);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      print("bbbb");
      // final json = jsonDecode(response.body);
      List<Post> result = postFromJson(response.body);
      // List<Post> result = json;
      setState(() {
        posts = result;



      });
    }
    else {
      print('failed');
    }
  }
  Future<void> Delete() async {
    final url = Url();
    final uri = Uri.parse(url.baseUrl + url.deleteNote);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      print("cccc");
      final json = jsonDecode(response.body);

      // List<Post> result = json;

    }
    else {
      print('failed');
    }
  }
}
