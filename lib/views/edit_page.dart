import 'package:flutter/material.dart';
import 'package:notetaker/model/model.dart';
import 'package:notetaker/service/api_service.dart';

class EditPage extends StatefulWidget {
  String id;
  String title;
  String description;
  final VoidCallback onSave;
   EditPage({super.key,required this.id,required this.title,required this.description,required this.onSave});

  @override
  State<EditPage> createState() => _EditPageState();
}


class _EditPageState extends State<EditPage> {

  TextEditingController titleController =TextEditingController();
  TextEditingController descriptionController =TextEditingController();
  @override
  void initState() {
    titleController=TextEditingController(text: widget.title);
    descriptionController=TextEditingController(text: widget.description);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
  onPressed: () {
    setState(() {
      updateNotes();
      });
      widget.onSave(); 
      Navigator.of(context).pop();
  },
  child: Text('Save', style: TextStyle(fontSize: 20)),
),
      )),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                )
              ),
      
            ),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                )
              ),
      
            )
          ],
        ),
      ),
    );
  }
  updateNotes(){
    var titleEdit = titleController.text;
    var descriptionEdit = descriptionController.text;
    ApiSercice().editNotes(id: widget.id,value: NoteModel(title: titleEdit,description: descriptionEdit));
  }
}