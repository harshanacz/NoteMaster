import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/models/todo_model.dart';
import 'package:notemaster/widgets/common/text_widget.dart';

// ignore: must_be_immutable
class Todocard extends StatefulWidget {
  // create varibles that a todocard will receive data for
  final int id;
  final String title;
  final DateTime creationDate;
  bool isChecked;
  final Function insertFunction;
  final Function deleteFunction;
  Todocard(
      {required this.id,
      required this.title,
      required this.creationDate,
      required this.isChecked,
      required this.insertFunction, // it will handle the changes in checkbox
      required this.deleteFunction, // it will handle the delete button function
      Key? key})
      : super(key: key);

  @override
  _TodocardState createState() => _TodocardState();
}

class _TodocardState extends State<Todocard> {
  @override
  Widget build(BuildContext context) {
    // create a local todo
    var anotherTodo = Todo(
        id: widget.id,
        title: widget.title,
        creationDate: widget.creationDate,
        isChecked: widget.isChecked);
    //
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: drawerBackgroundcolor,
        // border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Row(
        children: [
          // this wil be the checkbox
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white,
                ),
                child: Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    checkColor: whiteColor,
                    activeColor: activeColor,
                    value: widget.isChecked,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        widget.isChecked = value!;
                      });
                    },
                  ),
                ),
              )
              // Checkbox(
              //   value: widget.isChecked,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       widget.isChecked = value!;
              //     });
              //     // change the value of anothertodo's isCheck
              //     anotherTodo.isChecked = value!;
              //     // insert it to database
              //     widget.insertFunction(anotherTodo);
              //   },
              // ),
              ),
          // this will be the title and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CustomText(
                //   size: 17,
                //   text: widget.title,
                //   textColor: whiteColor,
                // ),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: whiteColor,
                    fontSize: 17,
                    decorationThickness: 2.0,
                    decoration: widget.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 5),
                CustomText(
                  size: 13,
                  text: DateFormat('dd MMM yyyy - hh:mm aaa')
                      .format(widget.creationDate),
                  textColor: whiteColor2,
                ),
              ],
            ),
          ),
          // this will be the delete button
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                // add delete method
                widget.deleteFunction(anotherTodo);
              },
              icon: const Icon(
                Icons.close,
                size: 28,
                color: whiteColor2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
