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
  Map<String, dynamic> _lastRemoved;

  int _lastRemovedPos;

  @override
  void initState() {
    super.initState();
    readData().then((value) {
      setState(() {
        _toDoList = jsonDecode(value);
      });
    });
  }

  final _toDoController =
      TextEditingController(); // controlador de entrada de texto

  void addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);

      saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  controller: _toDoController,
                  decoration: InputDecoration(
                    labelText: "Nova Tarefa",
                    labelStyle: TextStyle(color: Colors.blueAccent),
                  ),
                )),
                // ignore: deprecated_member_use
                RaisedButton(
                  onPressed: addToDo,
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _toDoList.length,
              itemBuilder: buildItem,
            ),
          ),
        ],
      ),
    );
  }

// funcão quer retorna do tipo widget
  Widget buildItem(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child:
              Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error_outline),
        ),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          _toDoList.removeAt(index);
          saveData();

          final snack =SnackBar(
            content: Text("Tarefa ${_lastRemoved["title"]} removida com sucesso!"),
            action: SnackBarAction(
              label: "Desfa",
            ),
          );
        });
      },
    );
    // return
  }

  Future<File> _getfile() async {
    final directy = await getApplicationDocumentsDirectory();
    print(File("${directy.path}/data.json"));
    return File("${directy.path}/data.json");
  }

  Future<File> saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getfile();

    return file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      final file = await _getfile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
