// ignore_for_file: camel_case_types, file_names, avoid_print, prefer_const_constructors, unused_element, use_build_context_synchronously, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_llist/Todo_list/Add_list.dart';
import 'package:todo_llist/Todo_list/Edit_List.dart';
import 'package:todo_llist/Todo_list/Todo.dart';
import 'package:todo_llist/Todo_list/View_Todo.dart';

class Todo_List extends StatefulWidget {
  const Todo_List({super.key});

  @override
  State<Todo_List> createState() => _Todo_ListState();
}

class _Todo_ListState extends State<Todo_List> {
  List<Todo> tasks = [];
  LinearGradient _buildRainbowGradient() {
    return LinearGradient(
      colors: const [
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

  Future<void> deleteTask(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  void initState() {
    super.initState();
    getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          // ignore: deprecated_member_use
          home: WillPopScope(
            onWillPop: () => _onWillPop(context),
            child: Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                    gradient: _buildRainbowGradient(),
                    borderRadius: BorderRadius.circular(0.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            Offset(0, 3), // changes the position of the shadow
                      ),
                    ],
                  ),
                  child: ListView(
                    children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(35.w, 4.h, 35.w, 3.h),
                          child: Center(
                              child: Text(
                            'To-Do List',
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
                      FutureBuilder<List<Todo>>(
                        future: getTasks(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child: Text(
                              'Add Your New Task',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.black87),
                            ));
                          } else {
                            List<Todo> tasks = snapshot.data!;

                            // Filter out completed tasks
                            List<Todo> incompleteTasks = tasks
                                .where((task) => !task.isComplete)
                                .toList();
                            return Padding(
                              padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 0),
                              child: Material(
                                color: Colors.white,
                                elevation: 15.0,
                                borderRadius: BorderRadius.circular(20.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: incompleteTasks.length,
                                  itemBuilder: (context, index) {
                                    final task = incompleteTasks[index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(task.name),
                                          subtitle: Text(task.date),
                                          leading: Text(
                                            '$index',
                                            style: TextStyle(fontSize: 17),
                                          ), // Print index number
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.green,
                                                ),
                                                onPressed: () {
                                                  String name = task.name;
                                                  String date = task.date;
                                                  String dis = task.description;
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Edit_List(
                                                        id: task.id!,
                                                        name: name,
                                                        date: date,
                                                        dis: dis,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  bool? deleteConfirmed =
                                                      await _showDeleteConfirmationDialog(
                                                          context);
                                                  if (deleteConfirmed!) {
                                                    await deleteTask(task.id!);
                                                    print('hahha');
                                                    setState(() {
                                                      tasks.removeAt(index);
                                                    });
                                                  }
                                                },
                                              ),
                                              Checkbox(
                                                value: task.isComplete,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    task.isComplete =
                                                        value ?? false;
                                                    displayMessage(context,
                                                        'Task is Completed');
                                                  });
                                                  await deleteTask(task.id!);
                                                },
                                              ),
                                            ],
                                          ),

                                          onLongPress: () async {
                                            bool? deleteConfirmed =
                                                await _showDeleteConfirmationDialog(
                                                    context);
                                            if (deleteConfirmed!) {
                                              await deleteTask(task.id!);
                                              setState(() {
                                                tasks.removeAt(index);
                                              });
                                            }
                                          },
                                          onTap: () {
                                            String name = task.name;
                                            String date = task.date;
                                            String dis = task.description;
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    View_All_Todo(
                                                  name: name,
                                                  date: date,
                                                  dis: dis,
                                                ),
                                              ),
                                            );
                                            // Add your action when the item is tapped
                                            print('${task.name} tapped!');
                                          },
                                          // Add more fields as needed
                                        ),
                                        if (index != incompleteTasks.length - 1)
                                          Divider(
                                            thickness: 0.7,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Add_List(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 30,
                  ),
                  backgroundColor: Colors.white,
                  shape:
                      CircleBorder(), // Make the FloatingActionButton circular
                )),
          ),
        );
      },
    );
  }

  Future<List<Todo>> getTasks() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Todo(
        id: maps[i]['id'],
        name: maps[i]['name'],
        date: maps[i]['date'],
        description: maps[i]['description'],
      );
    });
  }

  void displayMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Message'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Are you sure you want to exit the application?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
