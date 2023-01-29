import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = '',
    this.description = '',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 8),
              Container(child: buildDescription()),
              const SizedBox(height: 16),
            ],
          ),
        ),
        // Positioned(
        //     right: 5,
        //     bottom: 10,
        //     child: IconButton(
        //       icon: const Icon(
        //         Icons.save_outlined,
        //         color: Colors.white,
        //         size: 25,
        //       ),
        //       onPressed: () {},
        //     )
        //     // Switch(
        //     //   value: isImportant ?? false,
        //     //   onChanged: onChangedImportant,
        //     // ),
        //     )
      );

  Widget buildTitle() => TextFormField(
        autofocus: true,
        maxLines: 1,
        initialValue: title,
        style: const TextStyle(
          fontFamily: "Montserrat",
          color: Colors.white70,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(
            fontFamily: "Montserrat",
            color: whiteColor,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        initialValue: description,
        maxLines: 60,
        style: TextStyle(color: Colors.white60, fontSize: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something...',
          hintStyle: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white70,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );
}
