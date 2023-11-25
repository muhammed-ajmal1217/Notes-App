import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notetaker/controller/home_provider.dart';
import 'package:notetaker/service/api_service.dart';
import 'package:notetaker/views/edit_page.dart';
import 'package:notetaker/widgets/add_dialogue.dart';
import 'package:notetaker/widgets/shimmer_loader.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  


  @override
  void initState() {
    final homeProvider=Provider.of<HomeProvider>(context,listen: false);
    super.initState();
    homeProvider.loadNotes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes App',
          style: GoogleFonts.kanit(fontSize: 25),
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, child) => 
         Padding(
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
                    final data = homeProvider.noteList[index];
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
                                          style: GoogleFonts.quicksand(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        subtitle: Text(
                                          data.title ?? 'data is here',style: GoogleFonts.quicksand(),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          'Description:',
                                          style: GoogleFonts.quicksand(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        subtitle: Text(
                                          data.description ?? 'data is here',style: GoogleFonts.quicksand(),
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
                                                homeProvider.loadNotes(); 
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Icon(Icons.edit,color: Colors.grey,),
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                      onTap: () => homeProvider.deleteNote(id: data.id),
                                      child: Icon(Icons.delete,color: Colors.grey,)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: homeProvider.noteList.length,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerLoader();
              } else {
                return Center(child: Text('Data is not available'));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return DialoguePage();
            },
          );
        },
        backgroundColor: Color.fromARGB(255, 255, 186, 59),
        shape: CircleBorder(),
        elevation: 4,
        child: Icon(Icons.add,color: Colors.black,),
      ),
    );
  }
}
