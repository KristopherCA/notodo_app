import 'package:flutter/material.dart';
import 'package:notodo_app/database_client.dart';
import 'package:notodo_app/notodo_item.dart';

import 'date_formatted.dart';
import 'notodo_item.dart';
import 'notodo_list.dart';

class NoToDoScreen extends StatefulWidget {
  @override
  _NoToDoScreenState createState() => _NoToDoScreenState();
}

class _NoToDoScreenState extends State<NoToDoScreen> {
  final TextEditingController noToDoController = TextEditingController();
  var db = DatabaseHelper();

  deleteNoToDo(int id, int index) async {
    await db.deleteItem(id);
    setState(() {
      itemlist.removeAt(index);
    });
  }

  readNoToDoList(DatabaseHelper db) async {
    List items = await db.getAllItems();
    items.forEach((item) {
      setState(() {
        itemlist.add(NoToDoItem.map(item));
      });
    });
  }

  @override
  void initState() {
    readNoToDoList(db);

    super.initState();
  }

  void handleSubmit(String text) async {
    noToDoController.clear();
    NoToDoItem noToDoItem = NoToDoItem(text, dateFormatted());
    int savedItem = await db.saveItem(noToDoItem);
    NoToDoItem addedItem = await db.getItem(savedItem);
    setState(() {
      itemlist.insert(0, addedItem);
    });
  }

  showFormDialog(BuildContext context, Row row) {
    var alert = AlertDialog(
      content: row,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            if (noToDoController.text == null ||
                noToDoController.text.isEmpty) {
              noToDoController.text = 'Nothing';
            }
            handleSubmit(noToDoController.text);
            noToDoController.clear();
            Navigator.pop(context);
          },
          child: Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.deepPurple,
        ),
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.deepPurple,
        )
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Flexible(
              child: ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  reverse: false,
                  itemCount: itemlist.length,
                  itemBuilder: (_, int index) {
                    return Card(
                      color: Colors.deepPurpleAccent,
                      child: ListTile(
                        title: itemlist[index],
                        onLongPress: () => updateItem(itemlist[index], index),
                        trailing: IconButton(
                          padding: EdgeInsets.all(0.0),
                          key: Key(itemlist[index].itemName),
                          icon: Icon(
                            Icons.remove_circle,
                            color: Colors.black,
                          ),
                          onPressed: () =>
                              deleteNoToDo(itemlist[index].id, index),
                        ),
                      ),
                    );
                  })),
          Divider(
            height: 1.0,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 8.0,
        backgroundColor: Colors.deepPurple,
        onPressed: () => showFormDialog(
              context,
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: noToDoController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'Note',
                        labelStyle: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                        hintText: 'Not to do!',
                        hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                        icon: Icon(
                          Icons.note_add,
                          color: Colors.deepPurple,
                        )),
                  ))
                ],
              ),
            ),
        tooltip: "Add a note",
        child: ListTile(
          title: Icon(Icons.add),
        ),
      ),
    );
  }

  updateItem(NoToDoItem item, int index) {
    var alert = AlertDialog(
      title: Text('Update'),
      content: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            controller: noToDoController,
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Note',
                hintText: 'Don\'t do it!',
                icon: Icon(Icons.update)),
          ))
        ],
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () async {
              NoToDoItem newItemUpdated = NoToDoItem.fromMap({
                'itemName': noToDoController.text,
                'dateCreated': dateFormatted(),
                'id': item.id
              });
              handleSubmitUpdate(index, item);
              await db.updateItem(newItemUpdated);
              setState(() {
                readNoToDoList(db);
              });
            },
            child: Text('Submit')),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel'))
      ],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  void handleSubmitUpdate(int index, NoToDoItem item) {
    setState(() {
      itemlist.removeWhere((element) {
        itemlist[index].itemName == item.itemName;
      });
    });
  }
}
