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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: Text(
          "NOTE Book",
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
                      child: ListTile(
                        title: Text(dataList[index]["title"]),
                        subtitle: Text(dataList[index]["description"]),
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
                builder: (context) => AddNote(),
              ),
              (route) => false,
            );
          },
          label: Text("Add"),
          icon: Icon(Icons.add)),
    );
  }
}
