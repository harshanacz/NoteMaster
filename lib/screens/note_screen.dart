import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notemaster/database/DB_provider.dart';
import 'package:notemaster/models/note_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notemaster/screens/note_read_screen.dart';
import 'package:notemaster/widgets/notebox/noteBox.dart';
import '../widgets/common/text_widget.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late List<Note> notes;
  bool isLoading = false;

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      height: MediaQuery.of(context).size.height,
      child:
          // notes.isNotEmpty
          //     ? const Align(
          //         alignment: Alignment.topLeft,
          //         child: CustomText(
          //             size: 17,
          //             text: "Your recent notes:",
          //             align: TextAlign.start),
          //       )
          //     : const SizedBox(),
          isLoading ? CircularProgressIndicator() : buildNotes(),

      // Center(
      //   child: isLoading
      //       ? CircularProgressIndicator()
      //       : notes.isEmpty
      //           ? Column(
      //               children: [
      //                 SizedBox(
      //                   height: MediaQuery.of(context).size.height * 0.2,
      //                 ),
      //                 const CustomText(
      //                     size: 20, text: 'Create your first note!'),
      //                 const CustomText(
      //                     size: 17, text: "Organize your thoughts and ideas.")
      //               ],
      //             )
      //           // const Text(
      //           //     'No Notes',
      //           //     style: TextStyle(color: Colors.white, fontSize: 24),
      //           //   )
      //           : buildNotes(),
      // )
    );
  }

  Widget buildNotes() => ListView.builder(
        itemCount: notes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: CustomText(
                      size: 17,
                      text: "Your recent notes:",
                      align: TextAlign.start)),
            );
          } else {
            final note = notes[index - 1];
            return GestureDetector(
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id!),
                ));
              },
              child: NoteCardWidget(
                note: note,
                index: index - 1,
              ),
            );
          }
        },
      );
  // StaggeredGridView.countBuilder(
  //       padding: EdgeInsets.all(8),
  //       itemCount: notes.length,
  //       staggeredTileBuilder: (index) => StaggeredTile.fit(2),
  //       crossAxisCount: 4,
  //       mainAxisSpacing: 4,
  //       crossAxisSpacing: 4,
  //       itemBuilder: (context, index) {
  //         final note = notes[index];

  //         return GestureDetector(
  //           onTap: () async {
  //             await Navigator.of(context).push(MaterialPageRoute(
  //               builder: (context) => NoteDetailPage(noteId: note.id!),
  //             ));

  //             refreshNotes();
  //           },
  //           child: NoteCardWidget(note: note, index: index),
  //         );
  //       },
  //     );

}
