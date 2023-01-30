import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/database/DB_provider.dart';
import 'package:notemaster/models/note_model.dart';
import 'package:notemaster/screens/note_screens/edit_note.dart';
import 'package:notemaster/screens/note_screens/note_read_screen.dart';
import 'package:notemaster/widgets/common/showSnackBar.dart';
import 'package:notemaster/widgets/notebox/noteBox.dart';
import 'package:sqflite/sqflite.dart';
import '../../widgets/common/text_widget.dart';

class NoteScreen extends StatefulWidget {
  final bool isSearchBarShow;
  const NoteScreen({super.key, required this.isSearchBarShow});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _controller = TextEditingController();
  List<Note>? _searchResults;
  late Database _database;
  late List<Note> notes;
  bool isLoading = false;
  bool isLoadingSearch = false;
  bool isNotSearched = true;

  _openDatabase() async {
    setState(() {
      isLoadingSearch = true;
    });
    _database = await openDatabase('notes.db', version: 1);

    setState(() {
      isLoadingSearch = false;
    });
  }

  // _search(String query) async {
  //   setState(() {
  //     isLoadingSearch = true;
  //   });
  //   final result = await _database.query(
  //     'notes',
  //     where: 'title LIKE ?',
  //     whereArgs: ['%$query%'],
  //   );
  //   var res = result.map((json) => Note.fromJson(json)).toList();
  //   setState(() {
  //     _searchResults = res;

  //     isLoadingSearch = false;
  //     // _searchResults = result == null ? [] : result;
  //   });
  // }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();
    // _searchResults = notes;

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    // _openDatabase();
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: isLoading
              ? const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        color: whiteColor,
                      )),
                )
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
            return Column(
              children: [
                widget.isSearchBarShow
                    ? Column(
                        children: [
                          const SizedBox(height: 5),
                          TextField(
                            controller: _controller,
                            onChanged: (text) {
                              if (text.isNotEmpty) {
                                isNotSearched = false;
                              }
                              if (text.isEmpty) {
                                isNotSearched = true;
                              }
                              // _search(text);
                            },
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: CustomText(
                                    size: 17,
                                    text: isNotSearched
                                        ? "Search results: (All notes)"
                                        : "Search results:",
                                    align: TextAlign.start)),
                          ),
                          isLoadingSearch
                              ? const CircularProgressIndicator(
                                  color: whiteColor,
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _searchResults?.length,
                                  itemBuilder: (context, index) {
                                    // final note = _searchResults[index];
                                    final note = _searchResults![index];
                                    return GestureDetector(
                                      onLongPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              backgroundColor:
                                                  drawerBackgroundcolor,
                                              content: SizedBox(
                                                width: double.maxFinite,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    ListTile(
                                                      leading: const Icon(
                                                          Icons.edit_outlined,
                                                          color: whiteColor),
                                                      title: const CustomText(
                                                        size: 17,
                                                        text: "Edit",
                                                        textColor: whiteColor,
                                                      ),
                                                      onTap: () async {
                                                        await Navigator.of(
                                                                context)
                                                            .push(
                                                                MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddEditNotePage(
                                                                  note: note),
                                                        ));
                                                      },
                                                    ),
                                                    const Divider(
                                                        color: whiteColor2),
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
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              backgroundColor:
                                                                  drawerBackgroundcolor,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0)),
                                                              title: CustomText(
                                                                size: 20,
                                                                text: note.isImportant ==
                                                                        true
                                                                    ? "Delete | important note"
                                                                    : "Delete",
                                                                textColor: note
                                                                            .isImportant ==
                                                                        true
                                                                    ? Colors.red
                                                                        .shade700
                                                                    : whiteColor,
                                                              ),
                                                              content:
                                                                  CustomText(
                                                                size: 16.5,
                                                                text: note.isImportant ==
                                                                        true
                                                                    ? "You have marked this note as important! Are you sure you want to delete this note?"
                                                                    : "Are you sure you want to delete this note?",
                                                                textColor:
                                                                    whiteColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const CustomText(
                                                                    size: 16.5,
                                                                    text:
                                                                        "Delete",
                                                                    textColor:
                                                                        whiteColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    await NotesDatabase
                                                                        .instance
                                                                        .delete(
                                                                            note.id!);
                                                                    Navigator.of(context).pushNamedAndRemoveUntil(
                                                                        '/home',
                                                                        (Route<dynamic>
                                                                                route) =>
                                                                            false);
                                                                    showSnackBar(
                                                                        context,
                                                                        "Deleted successfully");
                                                                  },
                                                                ),
                                                                TextButton(
                                                                  child:
                                                                      const CustomText(
                                                                    size: 16.5,
                                                                    text:
                                                                        "Close",
                                                                    textColor:
                                                                        whiteColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
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
                                        await Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              NoteDetailPage(noteId: note.id!),
                                        ));
                                      },
                                      child: NoteCardWidget(
                                        note: note,
                                        index: index - 1,
                                      ),
                                    );
                                    // const ListTile(
                                    //     title: CustomText(
                                    //   text: "sd",
                                    //   size: 20,
                                    // )
                                    //     // Text(note['title']),
                                    //     );
                                  },
                                )
                        ],
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
