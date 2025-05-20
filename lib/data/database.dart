import 'package:hive/hive.dart';

class ToDoDataBase {
  List todoList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    todoList = [
      ["Make tutorial", false],
      ["Do exercise", false],
      ["Have branch", false],
      ["Do something", false],
      ["Do something else", false],
      ["Do something else else", false],
    ];
  }

  void loadData() {
    todoList = _myBox.get("TODOLIST");
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", todoList);
  }
}
