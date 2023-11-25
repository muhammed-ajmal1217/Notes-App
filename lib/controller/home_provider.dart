import 'package:flutter/material.dart';
import 'package:notetaker/model/model.dart';
import 'package:notetaker/service/api_service.dart';

class HomeProvider extends ChangeNotifier {
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();
  List<NoteModel> noteList = [];
  void loadNotes() async {
    try {
      List<NoteModel> notes = await ApiSercice().getNotes();
      noteList = notes;
    } catch (error) {
      print('Error loading notes: $error');
    }
    notifyListeners();
  }

  addNotes(BuildContext context) async {
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;
    await ApiSercice()
        .createNotes(NoteModel(description: description, title: title));
    loadNotes();
    Navigator.pop(context);

    notifyListeners();
  }
    deleteNote({required id}) async {
    await ApiSercice().deleteNotes(id: id);
    loadNotes();
    notifyListeners();
  }
    updateNotes({required id}){
    var titleEdit = titlecontroller.text;
    var descriptionEdit = descriptioncontroller.text;
    loadNotes();
    ApiSercice().editNotes(id: id,value: NoteModel(title: titleEdit,description: descriptionEdit));
    notifyListeners();
  }
}
