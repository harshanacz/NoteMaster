import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/database/DB_provider.dart';
import 'package:notemaster/models/note_model.dart';
import 'package:notemaster/screens/note_screens/edit_note.dart';
import 'package:notemaster/widgets/common/showSnackBar.dart';
import 'package:notemaster/widgets/common/text_widget.dart';

class NoteDetailPage extends StatefulWidget {
  final int noteId;

  const NoteDetailPage({
    Key? key,
    required this.noteId,
  }) : super(key: key);

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  var appBarHeight = AppBar().preferredSize.height;
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NotesDatabase.instance.readNote(widget.noteId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          title: const CustomText(size: 20, text: "View note"),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 25,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          elevation: 0,
          backgroundColor: appBarColor,
          actions: [
            InkWell(
              onTap: () async {
                if (isLoading) return;

                await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditNotePage(note: note),
                ));

                refreshNote();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: appBarHeight,
                decoration: BoxDecoration(
                  color: iconBgcolor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 8),
                      blurRadius: 8,
                    ),
                  ],
                ),
                // ignore: sort_child_properties_last
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 23,
                ),
                alignment: Alignment.center,
              ),
            ),
            InkWell(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: drawerBackgroundcolor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      title: const CustomText(
                        size: 20,
                        text: "Delete",
                        textColor: whiteColor,
                      ),
                      content: const CustomText(
                        size: 16.5,
                        text: "Are you sure you want to delete this note?",
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
                            await NotesDatabase.instance.delete(widget.noteId);
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (Route<dynamic> route) => false);
                            showSnackBar(context, "Deleted successfully");
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
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: appBarHeight,
                decoration: BoxDecoration(
                  color: iconBgcolor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 8),
                      blurRadius: 8,
                    ),
                  ],
                ),
                // ignore: sort_child_properties_last
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 25,
                ),
                alignment: Alignment.center,
              ),
            ),
            // editButton(),
            //  deleteButton()
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    CustomText(
                      size: 20,
                      text: note.title,
                      fontWeight: FontWeight.w600,
                    ),
                    // Text(
                    //   note.title,
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        note.isImportant
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 15),
                                  SizedBox(width: 8.0),
                                  CustomText(
                                    size: 13,
                                    fontWeight: FontWeight.w300,
                                    text: "Important",
                                    textColor: whiteColor2,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        CustomText(
                          size: 13,
                          fontWeight: FontWeight.w300,
                          text: DateFormat('hh:mm a, MMM dd')
                              .format(note.createdTime),
                          textColor: whiteColor2,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    CustomText(
                      size: 17,
                      text: note.description,
                      textColor: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
      );

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          // await NotesDatabase.instance.delete(widget.noteId);

          // Navigator.of(context).pop();
        },
      );
}
