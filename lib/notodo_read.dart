import 'package:notodo_app/database_client.dart';

import 'notodo_item.dart';

readNoToDoList(DatabaseHelper db) async {
  List items = await db.getAllItems();
  items.forEach((item) {
    NoToDoItem noToDoItem = NoToDoItem.map(items);
    print('DB items: ${noToDoItem.notodoitemName}');
  });
}
