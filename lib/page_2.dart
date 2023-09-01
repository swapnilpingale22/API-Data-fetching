import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/example2.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Future<Example2> getData() async {
    final responce =
        await http.get(Uri.parse("https://reqres.in/api/users?page=1"));

    if (responce.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(responce.body);
      final Example2 example2 = Example2.fromJson(jsonData);
      return example2;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Example2>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error.toString()}',
              ),
            );
          } else if (snapshot.hasData) {
            final Example2 user = snapshot.data!;
            return ListView.builder(
              itemCount: user.data.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.grey.shade800,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                        child: Text(user.data[index].id.toString())),
                    trailing: CircleAvatar(
                        backgroundImage: NetworkImage(user.data[index].avatar)),
                    title: Text(
                        'Name: ${user.data[index].firstName}  ${user.data[index].lastName} '),
                    subtitle: Text('Email: ${user.data[index].email}'),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No data available',
              ),
            );
          }
        },
      ),
    );
  }
}
