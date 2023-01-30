import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/database/DB_provider.dart';
import 'package:notemaster/models/note_model.dart';
import 'package:notemaster/screens/note_screens/edit_note.dart';

import 'package:notemaster/screens/note_screens/note_read_screen.dart';
import 'package:notemaster/widgets/common/showSnackBar.dart';
import 'package:notemaster/widgets/common/text_widget.dart';
import 'package:notemaster/widgets/notebox/noteBox.dart';

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
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isNotEmpty
                  ? buildNotes()
                  : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                        ),
                        const CustomText(
                            size: 20, text: 'Create your first note!'),
                        const CustomText(
                            size: 17, text: "Organize your thoughts and ideas.")
                      ],
                    ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: iconBgcolor,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddEditNotePage(),
                ));
              },
              child: const Icon(
                Icons.add,
                size: 28,
              ),
            ),
          ),
        ),
      ],
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
              onLongPress: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: drawerBackgroundcolor,
                      content: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.edit_outlined,
                                  color: whiteColor),
                              title: const CustomText(
                                size: 17,
                                text: "Edit",
                                textColor: whiteColor,
                              ),
                              onTap: () async {
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) =>
                                      NoteDetailPage(noteId: note.id!),
                                ));
                              },
                            ),
                            const Divider(color: Colors.white),
                            ListTile(
                              leading: const Icon(
                                Icons.delete_outline,
                                color: whiteColor,
                              ),
                              title: const CustomText(
                                size: 17,
                                text: "Delete",
                                textColor: whiteColor,
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      backgroundColor: drawerBackgroundcolor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      title: const CustomText(
                                        size: 20,
                                        text: "Delete",
                                        textColor: whiteColor,
                                      ),
                                      content: const CustomText(
                                        size: 16.5,
                                        text:
                                            "Are you sure you want to delete this note?",
                                        textColor: whiteColor,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const CustomText(
                                            size: 16.5,
                                            text: "Delete",
                                            textColor: whiteColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          onPressed: () async {
                                            await NotesDatabase.instance
                                                .delete(note.id!);
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/home',
                                                    (Route<dynamic> route) =>
                                                        false);
                                            showSnackBar(context,
                                                "Deleted successfully");
                                          },
                                        ),
                                        TextButton(
                                          child: const CustomText(
                                            size: 16.5,
                                            text: "Close",
                                            textColor: whiteColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
}
