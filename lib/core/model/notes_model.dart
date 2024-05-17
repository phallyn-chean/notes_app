class NotesModel {
  int? _id;
  String? _title;
  String? _description;
  String? _date;
  int? _priority;
  int? _color;

  NotesModel(this._title, this._date, this._priority, this._color, this._description);

  NotesModel.withId(this._id, this._title, this._date, this._priority, this._color, this._description);

  int? get id => _id;

  String get title => _title ?? "";

  String? get description => _description;

  int get priority => _priority ?? 0;

  int get color => _color!;

  String get date => _date!;

  set title(String newTitle) {
    if (newTitle.isNotEmpty && newTitle.length <= 255) {
      _title = newTitle;
    }
  }

  set description(String? newDesription) {
    if (newDesription == null || newDesription.isNotEmpty) {
      _description = newDesription;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 3) {
      _priority = newPriority;
    }
  }

  set color(int newColor) {
    if (newColor >= 0 && newColor <= 9) {
      _color = newColor;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['color'] = _color;
    map['date'] = _date;

    return map;
  }

  NotesModel.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _priority = map['priority'];
    _color = map['color'];
    _date = map['date'];
  }
}
