import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToDo {
  int? id;
  String title;
  String description;
  String date;

  ToDo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
    };
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late Database database;

  @override
  void initState() {
    super.initState();
    openDatabase1();
  }

  Future<void> openDatabase1() async {
    database = await openDatabase(
      path.join(await getDatabasesPath(), "todo.db"),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''CREATE TABLE AddTodoTask
          (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            date TEXT
          )''',
        );
      },
    );
    loadData();
  }

  Future<void> loadData() async {
    final List<Map<String, dynamic>> tasks =
        await database.query('AddTodoTask');
    setState(() {
      todoList = tasks
          .map((task) => ToDo(
                id: task['id'],
                title: task['title'],
                description: task['description'],
                date: task['date'],
              ))
          .toList();
    });
  }

  Future<void> insertTodo(ToDo todo) async {
    final id = await database.insert(
      'AddTodoTask',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    setState(() {
      todo.id = id;
      todoList.add(todo);
    });
  }

  Future<void> updateTodo(ToDo todo) async {
    await database.update(
      'AddTodoTask',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    setState(() {
      int index = todoList.indexWhere((element) => element.id == todo.id);
      if (index != -1) {
        print(todoList[index].title);
        print(todoList[index].description);

        todoList[index] = todo;
      }
    });
  }

  Future<void> deleteTodo(int id) async {
    await database.delete(
      'AddTodoTask',
      where: 'id = ?',
      whereArgs: [id],
    );
    setState(() {
      todoList.removeWhere((element) => element.id == id);
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void showBottomSheet(bool doedit, [ToDo? todoModelObj]) {
    _titleController.text = doedit ? todoModelObj!.title : '';
    _descriptionController.text = doedit ? todoModelObj!.description : '';
    _dateController.text = doedit ? todoModelObj!.date : '';

    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      isDismissible: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                doedit ? "Edit Task" : "Add Task",
                style: GoogleFonts.quicksand(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromRGBO(0, 0, 0, 1),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(0, 139, 148, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 139, 148, 1)),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Description",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(0, 139, 148, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 139, 148, 1)),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Date",
                    style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(0, 139, 148, 1),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.date_range_rounded),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        borderSide:
                            BorderSide(color: Color.fromRGBO(0, 139, 148, 1)),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2024),
                        lastDate: DateTime(2025),
                      );

                      String formattedDate =
                          DateFormat.yMMMd().format(pickDate!);
                      setState(() {
                        _dateController.text = formattedDate;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                width: 300,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: const Color.fromRGBO(0, 139, 148, 1),
                  ),
                  onPressed: () {
                    doedit
                        ? updateTodo(todoModelObj!)
                        : insertTodo(ToDo(
                            title: _titleController.text.trim(),
                            description: _descriptionController.text.trim(),
                            date: _dateController.text.trim(),
                          ));
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.quicksand(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }

  List<Color> colorList = [
    const Color.fromRGBO(250, 232, 232, 1),
    const Color.fromRGBO(232, 237, 250, 1),
    const Color.fromRGBO(250, 249, 232, 1),
    const Color.fromRGBO(250, 232, 250, 1),
  ];

  List<ToDo> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 167, 177, 1),
        title: Text(
          "To-do List",
          style: GoogleFonts.quicksand(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: const Color.fromRGBO(255, 255, 255, 1),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
            child: Container(
              decoration: BoxDecoration(
                color: colorList[index % colorList.length],
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 10),
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                  )
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.7),
                              offset: Offset(0, 0),
                              blurRadius: 10,
                            )
                          ],
                          color: Color.fromRGBO(255, 255, 255, 1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.image),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              todoList[index].title,
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: const Color.fromRGBO(0, 0, 0, 1),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              todoList[index].description,
                              style: GoogleFonts.quicksand(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromRGBO(84, 84, 84, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        todoList[index].date,
                        style: GoogleFonts.quicksand(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(132, 132, 132, 1),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          showBottomSheet(true, todoList[index]);
                        },
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color.fromRGBO(0, 139, 148, 1),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          deleteTodo(todoList[index].id!);
                        },
                        child: const Icon(
                          Icons.delete_outlined,
                          color: Color.fromRGBO(0, 139, 148, 1),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(0, 139, 148, 1),
        onPressed: () {
          showBottomSheet(false);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
