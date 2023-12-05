// ignore_for_file: camel_case_types, unnecessary_string_interpolations, file_names

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_llist/Todo_list/Todo_list.dart';

class View_All_Todo extends StatefulWidget {
  final String name;
  final String date;
  final String dis;
  const View_All_Todo(
      {super.key, required this.date, required this.name, required this.dis});

  @override
  State<View_All_Todo> createState() => _View_All_TodoState();
}

class _View_All_TodoState extends State<View_All_Todo> {
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
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: Scaffold(
            backgroundColor: Colors.white,
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
                      0,
                      3,
                    ), // changes the position of the shadow
                  ),
                ],
              ),
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(35.w, 2.h, 35.w, 0),
                    child: Center(
                      child: Text(
                        'View List',
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(3.w, 2.h, 5.w, 0),
                    child: SizedBox(
                      height: 70.h,
                      child: Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListView(
                          children: [
                            Padding(
                                padding: EdgeInsets.fromLTRB(0.w, 2.h, 0.w, 0),
                                child: Center(
                                  child: Text(
                                    '${widget.name}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.sp,
                                      color: Colors.purple,
                                    ),
                                  ),
                                )),
                            Column(
                              children: widget.dis.split('\n').map((textLine) {
                                bool? isChecked =
                                    false; // Maintain the state of the checkbox

                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
                                  return Center(
                                    child: CheckboxListTile(
                                      title: Text(textLine),
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value;
                                        });
                                      },
                                      secondary: const Icon(Icons.star_half),
                                    ),
                                  );
                                });
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 5.h, 20.w, 0),
                    child: Material(
                      elevation: 20.0,
                      shadowColor: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(20.0),
                      child: SizedBox(
                        height: 5.0.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const Todo_List(),
                              ),
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blueGrey),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                          ),
                          child: Text(
                            'Back',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
