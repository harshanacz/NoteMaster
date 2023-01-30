import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/database/DB_provider.dart';
import 'package:notemaster/models/note_model.dart';
import 'package:notemaster/screens/note_screens/note_read_screen.dart';
import 'package:notemaster/widgets/common/showSnackBar.dart';
import 'package:notemaster/widgets/common/text_widget.dart';
import 'package:notemaster/widgets/notebox/noteBox.dart';
import 'package:sqflite/sqflite.dart';

class SearchNotes extends StatefulWidget {
  const SearchNotes({super.key});

  @override
  State<SearchNotes> createState() => _SearchNotesState();
}

class _SearchNotesState extends State<SearchNotes> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  late Database _database;

  @override
  void initState() {
    super.initState();
    _openDatabase();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _openDatabase() async {
    _database = await openDatabase('notes.db', version: 1);
  }

  _search(String query) async {
    final result = await _database.query(
      'notes',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    setState(() {
      if (result.isNotEmpty) {
        _searchResults = result;
      }
      // _searchResults = result == null ? [] : result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundcolor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundcolor,
        title: const CustomText(size: 20, text: "Search Notes"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _controller,
              onChanged: (text) {
                _search(text);
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  border: InputBorder.none,
                  hintText: "Search by title..",
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
          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final note = _searchResults[index];
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
                                                NoteDetailPage(
                                                    noteId: note.id!),
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
                                                backgroundColor:
                                                    drawerBackgroundcolor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0)),
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    onPressed: () async {
                                                      await NotesDatabase
                                                          .instance
                                                          .delete(note.id!);
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              '/home',
                                                              (Route<dynamic>
                                                                      route) =>
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
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
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
                          await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                NoteDetailPage(noteId: note.id!),
                          ));
                        },
                        child: NoteCardWidget(
                          note: note,
                          index: index - 1,
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CustomText(
                    text: "No Results Found.",
                    size: 17,
                  )),
          ),
        ],
      ),
    );
  }
}
