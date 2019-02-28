import 'package:flutter/material.dart';
import 'dart:async';
import "package:http/http.dart" as http;
import 'dart:convert' ;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Simple Json and FutureBuilder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> getUsers() async{
 var data = await http.get("http://www.json-generator.com/api/json/get/cfwZmvEBbC?indent=2");

 var jsonData = json.decode(data.body);

 List<User> users = [];
 for(var u in jsonData) {
   User user = User(
       u["about"], u["name"], u["email"], u["picture"]);
   users.add(user);
 }
 print(users.length);
 return users;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
          child: FutureBuilder(future: getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if(snapshot.data == null){
              return Container(
                child: Center(
                  child: Text("Loading.......")
                ),
              );
            } else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                   snapshot.data[index].picture
                  ),
                ),
                title: Text(snapshot.data[index].name),
              );
            },);
          }},),

      ),

    );
  }
}

class User {
  final String about;
  final String name;
  final String email;
  final String picture;

  User(this.about, this.email, this.name, this.picture);


}



abstract class Repository {

  Future<User> getUsers(int index);

}

abstract class Cache<T> {

  Future<T> get(int index);

  put(int index, T object);

}