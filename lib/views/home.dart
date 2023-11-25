import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notetaker/model/model.dart';
import 'package:notetaker/service/api_service.dart';
import 'package:notetaker/views/edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NoteModel> noteList = [];
  TextEditingController titlecontroller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  void loadNotes() async {
    try {
      List<NoteModel> notes = await ApiSercice().getNotes();
      setState(() {
        noteList = notes;
      });
    } catch (error) {
      print('Error loading notes: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes App',
          style: GoogleFonts.kanit(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: ApiSercice().getNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  final data = noteList[index];
                  return Card(
                    elevation: 4,
                    color: const Color.fromARGB(255, 24, 24, 24),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 0.1,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Title:',
                                        style: GoogleFonts.kanit(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      subtitle: Text(
                                        data.title ?? 'data is here',
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'Description:',
                                        style: GoogleFonts.kanit(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      subtitle: Text(
                                        data.description ?? 'data is here',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (ctx) => EditPage(
                                          id: data.id!,
                                          title: data.title!,
                                          description: data.description!,
                                          onSave: () {
                                            setState(() {
                                              loadNotes();
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Icon(Icons.edit),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                    onTap: () => deleteNote(id: data.id),
                                    child: Icon(Icons.delete)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: noteList.length,
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('Data is not available'));
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Notes'),
                content: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: titlecontroller,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        maxLines: 4,
                        controller: descriptioncontroller,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          addNotes();
                        },
                        child: Text('Add'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  )
                ],
              );
            },
          );
        },
        backgroundColor: Colors.black,
        shape: CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add),
      ),
    );
  }

  addNotes() async {
    final title = titlecontroller.text;
    final description = descriptioncontroller.text;

    await ApiSercice()
        .createNotes(NoteModel(description: description, title: title));
    loadNotes();

    Navigator.pop(context);
    titlecontroller.clear();
    descriptioncontroller.clear();
  }

  deleteNote({required id}) async {
    await ApiSercice().deleteNotes(id: id);
    loadNotes();
    setState(() {});
  }
}
