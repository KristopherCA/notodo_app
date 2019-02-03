import 'package:flutter/material.dart';

class NoToDoItem extends StatelessWidget {
  String itemName;
  String dateCreated;
  int id;

  NoToDoItem(this.itemName, this.dateCreated);

  NoToDoItem.map(dynamic obj) {
    this.itemName = obj['itemName'];
    this.dateCreated = obj['dateCreated'];
    this.id = obj['id'];
  }

  String get notodoitemName => itemName;
  String get notododateCreated => dateCreated;
  int get notodoid => id;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['itemName'] = itemName;
    map['dateCreated'] = dateCreated;

    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  NoToDoItem.fromMap(Map<String, dynamic> map) {
    this.itemName = map['itemName'];
    this.dateCreated = map['dateCreated'];
    this.id = map['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              itemName,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.9),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              child: Text(
                'Created on: $dateCreated',
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
