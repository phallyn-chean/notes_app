import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app/core/model/notes_model.dart';
import 'package:notes_app/core/services/db_service.dart';
import 'package:notes_app/core/utils/widget.dart';

class NoteDetailScreen extends StatefulWidget {
  const NoteDetailScreen({super.key, required this.appBarTitle, required this.note});
  final String appBarTitle;
  final NotesModel note;

  @override
  State<StatefulWidget> createState() {
    return _NoteDetailScreenState(note, appBarTitle);
  }
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  DatabaseService service = DatabaseService();

  String? appBarTitle;
  NotesModel? notesModel;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int? color;
  bool isEdited = false;

  _NoteDetailScreenState(this.notesModel, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    titleController.text = notesModel?.title ?? "";
    descriptionController.text = notesModel?.description ?? "";
    color = notesModel!.color;
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(appBarTitle ?? "", style: Theme.of(context).textTheme.headlineSmall),
          backgroundColor: colors[color!],
          leading: IconButton(
            onPressed: () {
              isEdited ? showDiscardDialog(context) : moveToLastScreen();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                titleController.text.isEmpty ? showEmptyTitleDialog(context) : _save();
              },
              splashRadius: 22,
              icon: const Icon(
                Icons.save,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {
                showDeleteDialog(context);
              },
              splashRadius: 22,
              icon: const Icon(
                Icons.delete,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: Container(
          color: colors[color!],
          child: Column(
            children: [
              PriorityPicker(
                onTap: (index) {
                  isEdited = true;
                  notesModel!.priority = 3 - index;
                },
                selectedIndex: 3 - notesModel!.priority,
              ),
              ColorPicker(
                onTab: (index) {
                  setState(() {
                    color = index;
                  });
                  isEdited = true;
                  notesModel!.color = index;
                },
                selectedIndex: notesModel!.color,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: titleController,
                  maxLength: 255,
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: (value) {
                    updateTitle();
                  },
                  decoration: const InputDecoration.collapsed(hintText: "Title"),
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  maxLength: 255,
                  controller: descriptionController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  onChanged: (value) {
                    updateDescription();
                  },
                  decoration: const InputDecoration.collapsed(hintText: "Description"),
                ),
              ))
            ],
          ),
        ),
      ),
      onWillPop: () async {
        isEdited ? showDiscardDialog(context) : moveToLastScreen();
        return false;
      },
    );
  }

  void showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          title: Text(
            "Discard Changes?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text(
            "Are you sure you want to discard changes?",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "No",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.purple),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                moveToLastScreen();
              },
              child: Text(
                "Yes",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.purple),
              ),
            )
          ],
        );
      },
    );
  }

  void showEmptyTitleDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          title: Text(
            "Title is Empty!",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text(
            "The title of the note cannot be empty",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Okay",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.purple),
              ),
            )
          ],
        );
      },
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          title: Text(
            "Delete Note?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          content: Text(
            "Are you sure want to delete this note?",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "No",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.purple),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
              child: Text(
                "Okay",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.purple),
              ),
            )
          ],
        );
      },
    );
  }

  void moveToLastScreen() {
    Navigator.of(context).pop(true);
  }

  void updateTitle() {
    isEdited = true;
    notesModel!.title = titleController.text;
  }

  void updateDescription() {
    isEdited = true;
    notesModel!.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();

    notesModel!.date = DateFormat.yMMMMd().format(DateTime.now());

    if (notesModel!.id != null) {
      await service.updateNote(notesModel!);
    } else {
      await service.insertNote(notesModel!);
    }
  }

  void _delete() async {
    await service.deleteNote(notesModel!.id!);
    moveToLastScreen();
  }
}
