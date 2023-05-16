import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_req/models/post.dart';
import 'package:web_req/screen/home_page.dart';
import 'package:http/http.dart' as http;

import '../data/url.dart';

class create extends StatefulWidget {
  const create({Key? key}) : super(key: key);

  @override
  State<create> createState() => _createState();
}

class _createState extends State<create> {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  List<Post>? posts;
  bool isLoaded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
      ),
      body:
      Column(
        children: [
          Container(child: TextField(
controller: titlecontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: 'title',
              filled: true,


            ),
          ),),
          SizedBox(height: 20,),
          SizedBox(child: TextField(
controller: descriptioncontroller,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              hintText: 'Description',
              filled: true,


            ),
          ),),
          SizedBox(height: 20,),

        ElevatedButton(onPressed:
    saveData,
        //     ()
        // // async
        // {
        //
        //
        //  //  bool issuccess =  await saveData();
        //  //
        //  // if(issuccess){
        //  //   Navigator.of(context).pop(true);
        //  // }
        //
        //   },
  child: Text('save'))

        ],
      ),


    );
  }
  Future<bool> saveData() async{
    final title= titlecontroller.text;
    final description= descriptioncontroller.text;
    final body =
       {
    'title':title,
    'body': description,
  };
    final url = Url();
    var uri = Uri.parse(url.baseUrl + url.createNote);
    final response = await http.post(uri, body: jsonEncode(body));
    if (response.statusCode == 201){
      titlecontroller.text = '';
      descriptioncontroller.text = '';
      print(response.body);
     showsnackbar('created successdully');
     isLoaded = true;
     return true;
    }
    else{
      print('failed to post');
      showerrorsnackbar('failed');
      return false;
    }

}
void showsnackbar (String message){
    final  snackBar = SnackBar(content: Text(message),backgroundColor: Colors.green,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  void showerrorsnackbar (String error){
    final  snackBar = SnackBar(content: Text(error),backgroundColor: Colors.red,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
