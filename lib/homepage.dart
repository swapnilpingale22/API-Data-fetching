import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/users_model.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  //1
  //create a list of model class name
  List<UsersModel> userList = [];
  //2
  //create a method to fetch data from api
  Future<List<UsersModel>> getUserData() async {
    final responce =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    var data = jsonDecode(responce.body);

    if (responce.statusCode == 200) {
      for (Map i in data) {
        userList.add(UsersModel.fromJson(i as Map<String, dynamic>));
      }
      return userList;
    } else {
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("API Data"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => await getUserData(),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var user = snapshot.data;
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            leading: CircleAvatar(
                                child: Text(user![index].id.toString())),
                            title: Text('Name: ${user[index].name}'),
                            subtitle: Text('Email: ${(user[index].email)}'),
                            trailing: Column(
                              children: [
                                const Text('Geo Lat/Lng:'),
                                Text(user[index].address.geo.lat),
                                Text(user[index].address.geo.lng),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
