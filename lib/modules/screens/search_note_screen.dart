import 'package:flutter/material.dart';
import 'package:notes_app/core/model/notes_model.dart';

class NotesSearchScreen extends SearchDelegate {
  final List<NotesModel>? notes;
  List<NotesModel> filteredNotes = [];
  NotesSearchScreen({this.notes});

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context).copyWith(
      hintColor: Colors.black,
      primaryColor: Colors.white,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
    assert(theme != null);
    return theme;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        splashRadius: 22,
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      splashRadius: 22,
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.search,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                "Enter a note to search",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      );
    } else {
      filteredNotes = [];
      getFilteredList(notes!);
      if (filteredNotes.isEmpty) {
        return Container(
          color: Colors.white,
          child: const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.sentiment_dissatisfied,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "No results found",
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  close(context, filteredNotes[index]);
                },
                leading: const Icon(
                  Icons.note,
                  color: Colors.black,
                ),
                title: Text(
                  filteredNotes[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  filteredNotes[index].description ?? "",
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              );
            },
          ),
        );
      }
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == '') {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Icon(
                  Icons.search,
                  size: 50,
                  color: Colors.black,
                ),
              ),
              Text(
                "Enter a note to search",
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      );
    } else {
      filteredNotes = [];
      getFilteredList(notes!);
      if (filteredNotes.isEmpty) {
        return Container(
          color: Colors.white,
          child: const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.sentiment_dissatisfied,
                    size: 50,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "No result found",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        );
      } else {
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  close(context, filteredNotes[index]);
                },
                leading: const Icon(
                  Icons.note,
                  color: Colors.black,
                ),
                title: Text(
                  filteredNotes[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  filteredNotes[index].description ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        );
      }
    }
  }

  List<NotesModel> getFilteredList(List<NotesModel> note) {
    for (int i = 0; i < note.length; i++) {
      if (note[i].title.toLowerCase().contains(query) || note[i].description!.toLowerCase().contains(query)) {
        filteredNotes.add(note[i]);
      }
    }
    return filteredNotes;
  }
}
