import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/models/note_model.dart';
import 'package:notemaster/widgets/common/text_widget.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({
    Key? key,
    required this.note,
    required this.index,
  }) : super(key: key);

  final Note note;
  final int index;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('hh:mm a, MMM dd').format(note.createdTime);
    String title = note.title;
    String dis = note.description;

    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        color: drawerBackgroundcolor,
        // border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  size: 15.5,
                  fontWeight: FontWeight.w600,
                  text: title.length > 10
                      ? '${title.substring(0, 10)}...'
                      : title,
                ),
                CustomText(
                  size: 13,
                  fontWeight: FontWeight.w300,
                  text: time,
                  textColor: whiteColor2,
                ),
              ],
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.topLeft,
              child: CustomText(
                fontWeight: FontWeight.w400,
                textColor: whiteColor,
                align: TextAlign.start,
                size: 13,
                text: dis.length > 100 ? '${dis.substring(0, 100)}...' : dis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
