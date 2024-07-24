import 'package:flutter/material.dart';
import 'package:notes_book/Screen/home_screen.dart';
import 'package:sqflite/sqflite.dart';

import 'SqFlite/database_helper.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titelController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Add Notes",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            letterSpacing: 3,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: titelController,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontSize: 25,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  labelText: "Title",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: TextFormField(
                  controller: descController,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 25,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    labelText: "Description",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 50),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    insertData(
                      title: titelController.text.toString(),
                      description: descController.text.toString(),
                    ).then(
                      (value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                    );
                  },
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> insertData({
    required String title,
    required String description,
  }) async {
    Database db = await DatabaseHelper.dbHelper();

    await db.rawInsert(
        "INSERT INTO NoteBook(title,description) VALUES('$title','$description')");

    print("Data successfully inserted...");
  }
}
