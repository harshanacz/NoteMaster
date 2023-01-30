import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/models/todo_model.dart';

class UserInput extends StatelessWidget {
  final textController = TextEditingController();
  final Function insertFunction; // this will receive the addItem function
  UserInput({required this.insertFunction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      // color: const Color(0xFFDAB5FF),
      child: Row(
        children: [
          // this will be the input box
          Expanded(
            child: TextField(
              controller: textController,
              maxLines: 1,
              // autofocus: true,
              style: const TextStyle(
                fontFamily: "Montserrat",
                color: whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Add...",
                  hintStyle: const TextStyle(
                    fontFamily: "Montserrat",
                    color: whiteColor2,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: iconBgcolor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black45),
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: TextField(
            //     controller: textController,
            //     decoration: const InputDecoration(
            //       hintText: 'add new todo',
            //       border: InputBorder.none,
            //     ),
            //   ),
            // ),
          ),
          const SizedBox(width: 10),
          // this will be the button
          GestureDetector(
            onTap: () {
              // create a todo
              var myTodo = Todo(
                  title: textController.text,
                  creationDate: DateTime.now(),
                  isChecked: false);
              // pass this to the insertfunction as parameter
              insertFunction(myTodo);
            },
            child: Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                  child: Icon(
                Icons.add,
                //Icons.send_rounded,
                color: Colors.white,
              )),
            ),
          )
          // GestureDetector(
          //   onTap: () {
          //     // create a todo
          //     var myTodo = Todo(
          //         title: textController.text,
          //         creationDate: DateTime.now(),
          //         isChecked: false);
          //     // pass this to the insertfunction as parameter
          //     insertFunction(myTodo);
          //   },
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Theme.of(context).primaryColor,
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
          //     child: const Text(
          //       'Add',
          //       style: TextStyle(
          //         color: Colors.white,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
