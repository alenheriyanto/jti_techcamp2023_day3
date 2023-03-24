import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:techcamp_day3_todolist/model/todo_model.dart';
import 'package:techcamp_day3_todolist/pages/todo_form_page.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<ToDoModel> listData = [];
  final toDoListBox = Hive.box("todo_box");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    readItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
      ),
      backgroundColor: Colors.grey.shade200,
      body: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) {
          ToDoModel toDoModel = listData[index];
          return Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toDoModel.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.red),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(toDoModel.description),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${toDoModel.createdAt} | ${toDoModel.getUpdatedAt()}"),
                        Row(
                          children: [
                            //tombol hapus data
                            IconButton(
                                onPressed: () async {
                                  deleteItem(toDoModel.key!);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            //tombol edit data
                            IconButton(
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ToDoFormPage(toDoModel: toDoModel),
                                      ));

                                  if (result != null && result == true) {
                                    readItem();
                                  }
                                },
                                icon: const Icon(Icons.edit_note))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ToDoFormPage(),
              ));

          if (result != null && result == true) {
            readItem();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void readItem() {
    final List<ToDoModel> data = toDoListBox.keys.map((key) {
      final json = Map<String, dynamic>.from(toDoListBox.get(key));
      json['key'] = key;
      return ToDoModel.fromJson(json);
    }).toList();

    setState(() {
      listData = data.reversed.toList();
    });
  }

  Future<void> deleteItem(int key) async {
    await toDoListBox.delete(key).then((value) {
      const snackBar = SnackBar(
        content: Text("Berhasil menghapus data"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      readItem();
    });
  }
}
