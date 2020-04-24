import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        title: Text('User List'),
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
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.account_box, size: 50,),
                        enabled: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15.0),
                        title: Column(
                          children: <Widget>[
                            BasicUserInfo().getUserWidget(snapshot.data[index]),
                            SizedBox(height: 1,)
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserDetailsScreen(user: snapshot.data[index],),
                            ),
                          );
                        },
                      );
                    },
                  );
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
}


class UserDetailsScreen extends StatelessWidget {
  final User user;
  UserDetailsScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('User with id: ' + user.id.toString()) ,
      ),
      body: Center(
          child:
          Container(
            margin: EdgeInsets.all(20),
              child: UserDetails().getDataWidget(user)
          )
      ),
    );
  }
}







/*

 -----------------------------------------------------------------
 DATA WIDGET CREATORS
 -----------------------------------------------------------------

*/

class BasicUserInfo{
  Widget getUserWidget(User user){
          return Container(
            width: 300,
            decoration: new BoxDecoration(
                color: Colors.blueGrey[100],
                borderRadius: new BorderRadius.all(Radius.circular(5))
            ),
            child: Column(
              children: <Widget>[
                Text(user.name, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),),
                Text(user.email , style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 15
                ),),
              ],
            ),
          );
    }
}

class UserDetails {
  Widget getDataWidget(User user) {
    return Container(
      color: Colors.blueGrey[100],
        padding: EdgeInsets.all(20),
        width: 400,
        height: 400,
        child: Center(
          child: Column(
            children: <Widget>[
              Text(user.name, style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(height: 5,),
              Text(user.username, style: TextStyle(
                fontSize: 20,
              ),),
              SizedBox(height: 5,),
              Text('Email: ' + user.email, style: TextStyle(
                fontSize: 15,
                fontStyle: FontStyle.italic
              ),),
              SizedBox(height: 5,),
              Text('Phone: ' + user.phone, style: TextStyle(
                fontSize: 15,
              ),),
              SizedBox(height: 5,),
              Text('Website: ' + user.website, style: TextStyle(
                fontSize: 15,
              ),),
              SizedBox(height: 20,),
              Container(
                padding: EdgeInsets.all(10),
                width: 300,
                color: Colors.blueGrey[50],
                child: Row(
                  children: <Widget>[
                    Text('Company: '),
                    SizedBox(width: 8,),
                    Column(
                      children: <Widget>[
                        Text(user.company.name, style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 2,),
                        Text(user.company.catchPhrase + '\n' + user.company.bs, style: TextStyle(
                          fontSize: 11,
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.all(10),
                width: 300,
                color: Colors.blueGrey[50],
                child: Row(
                  children: <Widget>[
                    Text('Address: '),
                    SizedBox(width: 8,),
                    Column(
                      children: <Widget>[
                        Text(user.address.suite + ', ' + user.address.street + ', \n' + user.address.city + ', ' + user.address.zipcode + '.', style: TextStyle(
                          fontSize: 13,
                        ),),
                        SizedBox(height: 2,),
                        Text('Longitude: ' + user.address.geo.lng + ', Latitude: ' + user.address.geo.lat, style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      id:  json['id'],
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