import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];

  @override
  Widget build(BuildContext context) {
    return layout();
  }

  Future<File> _getfile() async {
    final directy = await getApplicationDocumentsDirectory();
    return File("${directy.path}/data.json");
  }

  Future<File> _saveFile() async {
    String data = json.encode(_toDoList);
    final file = await _getfile();

    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getfile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}

layout() {
  return Scaffold(
    appBar: AppBar(
      title: Text("Lista de tarefas"),
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
    ),
    body: Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                  decoration: InputDecoration(
                  labelText: "Nova Tarefa",
                  labelStyle: TextStyle(color: Colors.blueAccent),
                ),
              )),
              RaisedButton(
                onPressed: () {},
                color: Colors.blueAccent,
                child: Text("ADD"),
                textColor: Colors.white,
              )
            ],
          ),
        )
      ],
    ),
  );
}
