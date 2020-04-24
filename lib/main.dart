import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Users Fetch',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyApiHome(),
    );
  }
}

class MyApiHome extends StatefulWidget {
  @override
  _MyApiHomeState createState() => _MyApiHomeState();
}

class _MyApiHomeState extends State<MyApiHome> {
  Future<List<User>> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Users\' List'),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Container(
            margin: EdgeInsets.only(top: 35, left: 10, right: 10, bottom: 20),
            width: 400,
            child: FutureBuilder<List<User>>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return BasicUserWidget().getUserWidgetList(snapshot.data);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
  //BasicUserWidget().getUserWidgetList(snapshot.data)
}

class ClickedUserData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}






/*

 -----------------------------------------------------------------
 DATA WIDGET CREATORS
 -----------------------------------------------------------------

*/

class BasicUserWidget {
  Widget getUserWidgetList(List<User> users){
    var widgetList = List<Widget>();

    for(var user in users){
      widgetList.add(
          Container(
            width: 400,
            color: Colors.blueGrey[100],
            child: Column(
              children: <Widget>[
                Text(user.name, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),),
                Text(user.email, style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15
                ),)
              ],
            ),
          )
      );
      widgetList.add(
          SizedBox(height: 5,)
      );
    }
    return Column(
      children: widgetList,
    );
  }
}

class UserData {

  Widget getWidget(User user) {
    return Container(

    );
  }
}





/*

 -----------------------------------------------------------------
 DATA FETCHERS
 -----------------------------------------------------------------

*/

Future<List<User>> fetchUsers() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  var users = List<User>();

  if (response.statusCode == 200) {
    var usersJSON = json.decode(response.body);
    for (var userJSON in usersJSON) {
      users.add(User.fromJson(userJSON));
    }
    return users;
  }else {
    throw Exception('Failed to load album');
  }
}

Future<User> fetchUser() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users/1');

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}





/*

 -----------------------------------------------------------------
 DATA MODELS
 -----------------------------------------------------------------

*/

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final Address address;
  final String phone;
  final String website;
  final Company company;

  User({this.id, this.name, this.username, this.email, this.address, this.phone, this.website, this.company});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:  json['street'],
      name:  json['name'],
      username:  json['username'],
      email:  json['email'],
      address:  Address.fromJson(json['address']),
      phone:  json['phone'],
      website:  json['website'],
      company:  Company.fromJson(json['company']),

    );
  }
}

class Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final Geo geo;

  Address({this.street, this.suite, this.city, this.zipcode, this.geo});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      suite: json['suite'],
      city: json['city'],
      zipcode: json['zipcode'],
      geo: Geo.fromJson(json['geo']),
    );
  }
}

class Geo {
  final String lat;
  final String lng;

  Geo({this.lat, this.lng});

  factory Geo.fromJson(Map<String, dynamic> json) {
    return Geo(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}

class Company {
  final String name;
  final String catchPhrase;
  final String bs;

  Company({this.name, this.catchPhrase, this.bs});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      name: json['name'],
      catchPhrase: json['catchPhrase'],
      bs: json['bs'],
    );
  }
}