import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes_app/core/model/notes_model.dart';
import 'package:notes_app/core/services/db_service.dart';
import 'package:notes_app/core/utils/widget.dart';
import 'package:notes_app/modules/screens/note_detail_screen.dart';
import 'package:notes_app/modules/screens/search_note_screen.dart';
import 'package:sqflite/sqflite.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  DatabaseService databaseService = DatabaseService();
  List<NotesModel> noteList = [];
  int count = 0;
  int axisCount = 2;

  void navigateToDetail(NotesModel note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NoteDetailScreen(appBarTitle: title, note: note);
        },
      ),
    );

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseService.initializeDatabase();
    dbFuture.then((database) {
      Future<List<NotesModel>> noteListFuture = databaseService.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          count = noteList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(),
      body: noteList.isEmpty
          ? Container(
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Click on the add button to add new a note!",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: getNotesList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(NotesModel('', '', 3, 0, ''), 'Add Note');
        },
        tooltip: 'Add Note',
        shape: const CircleBorder(side: BorderSide(color: Colors.black, width: 2)),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  AppBar myAppBar() {
    return AppBar(
      title: Text(
        "Notes",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: noteList.isEmpty
          ? Container()
          : IconButton(
              onPressed: () async {
                final NotesModel result = await showSearch(
                  context: context,
                  delegate: NotesSearchScreen(notes: noteList),
                );
                if (result != null) {
                  navigateToDetail(result, "Edit Note");
                }
              },
              splashRadius: 22,
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
      actions: [
        noteList.isEmpty
            ? Container()
            : IconButton(
                onPressed: () {
                  setState(() {
                    axisCount = axisCount == 2 ? 4 : 2;
                  });
                },
                splashRadius: 22,
                icon: Icon(axisCount == 2 ? Icons.list : Icons.grid_on),
                color: Colors.black,
              ),
      ],
    );
  }

  Widget getNotesList() {
    return StaggeredGridView.countBuilder(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 4,
      itemCount: count,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            navigateToDetail(noteList[index], 'Edit Note');
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors[noteList[index].color],
                border: Border.all(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            noteList[index].title,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      Text(
                        getPriorityText(noteList[index].priority),
                        style: TextStyle(
                          color: getPriorityColor(noteList[index].priority),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            noteList[index].description ?? "",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        noteList[index].date,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) {
        return StaggeredTile.fit(axisCount);
      },
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
    );
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.green;

      default:
        return Colors.yellow;
    }
  }

  String getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return "!!!";

      case 2:
        return "!!";

      case 3:
        return "!";

      default:
        return "!";
    }
  }
}
