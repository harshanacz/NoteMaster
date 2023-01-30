import 'package:flutter/material.dart';
import 'package:notemaster/colors.dart';
import 'package:notemaster/database/DB_provider.dart';
import 'package:notemaster/models/note_model.dart';
import 'package:notemaster/screens/home_screen.dart';
import 'package:notemaster/widgets/common/showSnackBar.dart';
import 'package:notemaster/widgets/common/text_widget.dart';
import 'package:notemaster/widgets/notebox/noteform_widget.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  var appBarHeight = AppBar().preferredSize.height;

  @override
  void initState() {
    super.initState();

    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: backgroundcolor,
        appBar: AppBar(
          elevation: 0,
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
          backgroundColor: appBarColor,
          title: CustomText(
              size: 20, text: title.isEmpty ? "Create note" : "Update note"),
          actions: [
            InkWell(
              onTap: () {
                setState(() {
                  isImportant = !isImportant;
                });
                if (isImportant == true) {
                  showSnackBar(context, "Added to Important, Save it.");
                }
                if (isImportant == false) {
                  showSnackBar(context, "Remove from Important, Save it.");
                }
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
                child: Icon(
                  isImportant ? Icons.star : Icons.star_border,
                  color: isImportant ? Colors.amber : Colors.white,
                  size: 25,
                ),
                alignment: Alignment.center,
              ),
            ),
            InkWell(
              onTap: addOrUpdateNote,
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
                  Icons.save_outlined,
                  color: Colors.white,
                  size: 25,
                ),
                alignment: Alignment.center,
              ),
            ),
            // buildButton()
          ],
        ),
        body: Form(
          key: _formKey,
          child: NoteFormWidget(
            isImportant: isImportant,
            number: number,
            title: title,
            description: description,
            onChangedImportant: (isImportant) =>
                setState(() => this.isImportant = isImportant),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
          ),
        ),
      );

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.note != null;

      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }

      Navigator.of(context)
          .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await NotesDatabase.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      isImportant: isImportant,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await NotesDatabase.instance.create(note);
  }
}
