import 'package:flutter/material.dart';
import 'package:notes_book/Screen/SqFlite/database_helper.dart';
import 'package:notes_book/Screen/add_note.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Map<String, dynamic>> dataList = [];
  Future<Database> getData() async {
    Database db = await DatabaseHelper.dbHelper();
    dataList = await db.rawQuery("SELECT * FROM NoteBook");
    return db;
  }

  Future<void> deleteNote(int id) async {
    Database db = await DatabaseHelper.dbHelper();
    await db.delete("NoteBook", where: "id = ?", whereArgs: [id]);

    dataList = await db.rawQuery("SELECT * FROM NoteBook");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          "NOTE BOOK",
          style: TextStyle(
            letterSpacing: 3,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error ${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(dataList[index]["id"].toString()),
                        ),
                        title: Text(
                          dataList[index]["title"],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              letterSpacing: 1),
                        ),
                        subtitle: Text(
                          dataList[index]["description"],
                          style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 17,
                              letterSpacing: 1),
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Delete Note ?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cencel")),
                                      TextButton(
                                          onPressed: () {
                                            deleteNote(dataList[index]["id"])
                                                .then(
                                              (value) {
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          child: const Text("Ok"))
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete)),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Container(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNotes(),
              ),
              (route) => false,
            );
          },
          label: const Text("Add"),
          icon: const Icon(Icons.add)),
    );
  }
}
