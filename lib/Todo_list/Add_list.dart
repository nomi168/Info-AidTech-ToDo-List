// ignore_for_file: camel_case_types, file_names, use_build_context_synchronously, sort_child_properties_last

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_llist/Todo_list/Todo.dart';
import 'package:todo_llist/Todo_list/Todo_list.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static const String tableName = 'tasks';

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'tasks.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            date TEXT,
            description TEXT,
            isComplete INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTaskCompletion(int taskId, bool isComplete) async {
    final db = await database;
    await db.update(
      tableName,
      {'isComplete': isComplete ? 1 : 0},
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<int> updateTask(Todo task) async {
    final db = await database;
    return await db.update(
      tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<List<Todo>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        name: maps[i]['name'],
        date: maps[i]['date'],
        description: maps[i]['description'],
        isComplete: maps[i]['isComplete'] == 1,
      );
    });
  }
}

class Add_List extends StatefulWidget {
  const Add_List({super.key});

  @override
  State<Add_List> createState() => _Add_ListState();
}

class _Add_ListState extends State<Add_List> {
  TextEditingController name = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController dis = TextEditingController();
  DateTime selectedDate = DateTime.now();
  LinearGradient _buildRainbowGradient() {
    return const LinearGradient(
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.blue,
        Colors.indigo,
        Colors.purple,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Future<Object> insertTask(Todo task) async {
    final db = await DatabaseHelper().database;
    return await db.insert('tasks', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm
            .replace); // Use ConflictAlgorithm.replace to replace existing entries
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        date.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: _buildRainbowGradient(),
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(
                          0, 3), // changes the position of the shadow
                    ),
                  ],
                ),
                child: ListView(
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(35.w, 10.h, 35.w, 0),
                        child: Center(
                            child: Text(
                          'Add List',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            shadows: const [
                              Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.greenAccent,
                              ),
                            ],
                          ),
                        ))),
                    Padding(
                        padding: EdgeInsets.fromLTRB(13.w, 5.h, 10.w, 0),
                        child: Material(
                          elevation: 10.0,
                          shadowColor: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(20.0),
                          child: TextField(
                            controller: name,
                            decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: false,
                                prefixIcon: Icon(
                                  Icons.text_fields,
                                  color: Colors.blueGrey,
                                ),
                                hintText: 'Name',
                                border: InputBorder.none),
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.fromLTRB(13.w, 5.h, 10.w, 0),
                      child: Material(
                        elevation: 10.0,
                        shadowColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(20.0),
                        child: InkWell(
                          onTap: () => _selectDate(context),
                          child: IgnorePointer(
                            child: TextField(
                              controller: date,
                              decoration: const InputDecoration(
                                fillColor: Colors.white,
                                filled: false,
                                prefixIcon: Icon(
                                  Icons.date_range,
                                  color: Colors.blueGrey,
                                ),
                                hintText: 'Date',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(13.w, 5.h, 10.w, 0),
                      child: Material(
                        elevation: 10.0,
                        shadowColor: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(20.0),
                        child: TextField(
                          controller: dis,
                          maxLines: null,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 60.0), // Adjust the vertical padding
                            fillColor: Colors.white,
                            filled: false,
                            prefixIcon: Icon(
                              Icons.disc_full_sharp,
                              color: Colors.blueGrey,
                            ),
                            hintText: 'Description',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(0.w, 27.h, 70.w, 0),
                        child: SizedBox(
                            height: 5.0.h,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const Todo_List(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 35,
                              ),
                            ))),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  Todo newTask = Todo(
                    name: name.text,
                    date: date.text,
                    description: dis.text,
                  );
                  if (name.text.isNotEmpty && date.text.isNotEmpty) {
                    await insertTask(newTask);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Todo_List(),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            // Background blur effect
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                            // AlertDialog
                            AlertDialog(
                              title: const Text("Please Fill Required Fields"),
                              content:
                                  const Text("Name and Date are required."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  }

                  // Add your action when the button is pressed
                },
                child: const Icon(
                  Icons.add,
                  size: 30,
                ),
                backgroundColor: Colors.white,
                shape:
                    const CircleBorder(), // Make the FloatingActionButton circular
              )),
        );
      },
    );
  }
}
