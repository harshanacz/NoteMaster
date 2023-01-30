import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/database/DB_provider(2).dart';
import 'package:notemaster/models/todo_model.dart';
import 'package:notemaster/widgets/todo_widgets/todo_list.dart';
import 'package:notemaster/widgets/todo_widgets/user_input.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  // we have to create our functions here, where the two widgets can communicate

  // create a database object so we can access database functions
  var db = DatabaseConnect();

  // function to add todo
  void addItem(Todo todo) async {
    await db.insertTodo(todo);
    setState(() {});
  }

  // function to delete todo
  void deleteItem(Todo todo) async {
    await db.deleteTodo(todo);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Todolist(insertFunction: addItem, deleteFunction: deleteItem),
          // we will add our widgets here.
          UserInput(insertFunction: addItem),
        ],
      ),
    );
  }
}
