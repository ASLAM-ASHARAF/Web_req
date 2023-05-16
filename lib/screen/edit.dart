import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_req/data/url.dart';
import 'package:http/http.dart' as http;
import 'package:web_req/models/post.dart';

class edit extends StatefulWidget {
  Post? post;

  edit({this.post, Key? key}) : super(key: key);

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  List<Post>? posts;
  bool isLoaded = true;
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  void initState() {
    print("bbbbbbbbbbbb${widget.post?.title}");
    print("bbbbbbbbbb${widget.post?.body}");
    titlecontroller.text = widget.post?.title ?? "";
    descriptioncontroller.text = widget.post?.body ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Note',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: TextFormField(
              controller: titlecontroller,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            child: TextField(
              controller: descriptioncontroller,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'Description',
                filled: true,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                bool issuccess = await editData();

                if (issuccess) {
                  Navigator.of(context).pop(issuccess);
                }
              },
              child: Text('change'))
        ],
      ),
    );
  }

  Future<bool> editData() async {
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    final body = {
      'title': title,
      'body': description,
    };
    final url = Url();
    var uri = Uri.parse(url.baseUrl + url.updateNote);
    final response = await http.put(uri, body: jsonEncode(body));
    if (response.statusCode == 201) {
      titlecontroller.text = '';
      descriptioncontroller.text = '';
      print(response.body);
      showsnackbar('edited successdully');
      isLoaded = true;
      return true;
    } else {
      print('failed to edit');
      showerrorsnackbar('failed to edit');
      return false;
    }
  }

  void showsnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showerrorsnackbar(String error) {
    final snackBar = SnackBar(
      content: Text(error),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
