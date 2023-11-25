import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notetaker/model/model.dart';
import 'package:notetaker/service/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NoteModel> noteList = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
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
      )),
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Title:',
                                style: GoogleFonts.kanit(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                              subtitle: Text(
                                data.title ?? 'data is here',
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Description:',
                                style: GoogleFonts.kanit(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                              subtitle: Text(
                                data.description ?? 'data is here',
                              ),
                            ),
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AlertDialog(
                  title: Text('Add Notes'),
                  actions: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Title',
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Description',
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(onPressed: () {}, child: Text('Add')),
                        TextButton(onPressed: () {}, child: Text('Cancel')),
                      ],
                    )
                  ],
                ),
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
}
