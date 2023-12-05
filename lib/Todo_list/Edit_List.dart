// ignore_for_file: camel_case_types, file_names, use_build_context_synchronously, sort_child_properties_last, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_llist/Todo_list/Add_list.dart';
import 'package:todo_llist/Todo_list/Todo.dart';
import 'package:todo_llist/Todo_list/Todo_list.dart';

class Edit_List extends StatefulWidget {
  final int id;
  final String name;
  final String date;
  final String dis;
  const Edit_List(
      {super.key,
      required this.name,
      required this.date,
      required this.dis,
      required this.id});

  @override
  State<Edit_List> createState() => _Edit_ListState();
}

class _Edit_ListState extends State<Edit_List> {
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

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    date.text = widget.date;
    dis.text = widget.dis;
  }

  Future<int> insertTask(Todo task) async {
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
                        padding: EdgeInsets.fromLTRB(0.w, 1.h, 75.w, 0.h),
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
                            color: Colors.purple,
                            size: 35,
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.fromLTRB(30.w, 2.h, 30.w, 0),
                        child: Center(
                            child: Text(
                          'Update List',
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
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  await updateTask();
                  // Add your action when the button is pressed
                },
                child: const Icon(
                  Icons.edit,
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

  Future<void> updateTask() async {
    Todo updatedTask = Todo(
      id: widget.id, // Pass the existing task ID
      name: name.text,
      date: date.text,
      description: dis.text,
    );
    await DatabaseHelper().updateTask(updatedTask);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const Todo_List(),
      ),
    );
  }
}
