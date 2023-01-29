import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/database/DB_provider.dart';
import 'package:notemaster/models/note_model.dart';
import 'package:notemaster/screens/edit_note.dart';
import 'package:notemaster/screens/note_read_screen.dart';
import 'package:notemaster/widgets/common/showSnackBar.dart';
import 'package:notemaster/widgets/notebox/noteBox.dart';
import '../widgets/common/text_widget.dart';

class NoteScreen extends StatefulWidget {
  final bool isSearchBarShow;
  const NoteScreen({super.key, required this.isSearchBarShow});

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
                    const CustomText(size: 20, text: 'Create your first note!'),
                    const CustomText(
                        size: 17, text: "Organize your thoughts and ideas.")
                  ],
                ),
    );
  }

  Widget buildNotes() => ListView.builder(
        itemCount: notes.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                widget.isSearchBarShow
                    ? TextField(
                        maxLines: 1,
                        // autofocus: true,
                        style: const TextStyle(
                          fontFamily: "Montserrat",
                          color: whiteColor2,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 30),
                            border: InputBorder.none,
                            hintText: "Search...",
                            hintStyle: const TextStyle(
                              fontFamily: "Montserrat",
                              color: whiteColor2,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: iconBgcolor,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                      )
                    : const SizedBox(),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: CustomText(
                          size: 17,
                          text: "Your recent notes:",
                          align: TextAlign.start)),
                ),
              ],
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
                                      AddEditNotePage(note: note),
                                ));
                              },
                            ),
                            const Divider(color: whiteColor2),
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
                                      title: CustomText(
                                        size: 20,
                                        text: note.isImportant == true
                                            ? "Delete | important note"
                                            : "Delete",
                                        textColor: note.isImportant == true
                                            ? Colors.red.shade700
                                            : whiteColor,
                                      ),
                                      content: CustomText(
                                        size: 16.5,
                                        text: note.isImportant == true
                                            ? "You have marked this note as important! Are you sure you want to delete this note?"
                                            : "Are you sure you want to delete this note?",
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
