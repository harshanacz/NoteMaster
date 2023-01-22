import 'package:flutter/cupertino.dart';

import '../widgets/common/text_widget.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: MediaQuery.of(context).size.height,
      child: Column(children: const [
        SizedBox(height: 10),
        Align(
          alignment: Alignment.topLeft,
          child: CustomText(
              size: 17, text: "Your recent notes:", align: TextAlign.start),
        ),
        // SizedBox(height: 40),
        // CustomText(
        //     size: 20, text: "Create your first note!", align: TextAlign.start),
        // CustomText(size: 17, text: "Organize your thoughts and ideas.")
      ]),
    );
  }
}
