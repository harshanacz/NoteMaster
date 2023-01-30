import 'package:flutter/material.dart';
import 'package:notemaster/database/DB_provider(2).dart';
import 'package:notemaster/widgets/common/text_widget.dart';
import 'package:notemaster/widgets/todo_widgets/todo_card.dart';

class Todolist extends StatelessWidget {
  // create an object of database connect
  // to pass down to todocard, first our todolist have to receive the functions
  final Function insertFunction;
  final Function deleteFunction;
  final db = DatabaseConnect();
  Todolist(
      {required this.insertFunction, required this.deleteFunction, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: db.getTodo(),
        initialData: const [],
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          var data =
              snapshot.data; // this is the data we have to show. (list of todo)
          var datalength = data!.length;

          return datalength == 0
              ? Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    const CustomText(size: 20, text: "Create to-do list!"),
                    const CustomText(
                        size: 17,
                        text: "Efficiently manage your tasks and goals")
                  ],
                )
              : ListView.builder(
                  itemCount: datalength,
                  itemBuilder: (context, i) => Todocard(
                    id: data[i].id,
                    title: data[i].title,
                    creationDate: data[i].creationDate,
                    isChecked: data[i].isChecked,
                    insertFunction: insertFunction,
                    deleteFunction: deleteFunction,
                  ),
                );
        },
      ),
    );
  }
}
