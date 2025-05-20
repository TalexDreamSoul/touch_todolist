import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:touch_todolist/data/database.dart';
import 'package:touch_todolist/utils/dialog_box.dart';
import 'package:touch_todolist/utils/todo_tile.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever opening the app, then create default data
    if (_myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }

    super.initState();
  }

  TextEditingController controller = TextEditingController();

  // String greetingMessage = 'Hello World';

  // void greetUser() {
  //   setState(() {
  //     greetingMessage = "Hello, ${controller.text}";
  //   });
  // }

  final _controller = TextEditingController();

  // List todoList = [
  //   ["Make tutorial", false],
  //   ["Do exercise", false],
  // ];

  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      backgroundColor: Colors.blue[200],
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemBuilder: (ctx, index) {
          return TodoTile(
            taskName: db.todoList[index][0],
            taskCompleted: db.todoList[index][1],
            onChanged: (value) {
              setState(() {
                db.todoList[index][1] = value;
              });
              db.updateDataBase();
            },
            deleteFunction: (context) {
              setState(() {
                db.todoList.removeAt(index);
              });
              db.updateDataBase();
            },
          );
        },
        itemCount: db.todoList.length,
      ),
      // body: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Text(greetingMessage),
      //         TextField(
      //           controller: controller,
      //           decoration: InputDecoration(
      //             border: OutlineInputBorder(),
      //             hintText: 'Type your name',
      //             labelText: 'Enter your name',
      //           ),
      //         ),
      //         ElevatedButton(onPressed: greetUser, child: Text('Tap')),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
