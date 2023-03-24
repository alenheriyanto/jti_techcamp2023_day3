import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:techcamp_day3_todolist/model/todo_model.dart';

class ToDoFormPage extends StatefulWidget {
  final ToDoModel? toDoModel;
  // final int? nilai;
  const ToDoFormPage({super.key, this.toDoModel});

  @override
  State<ToDoFormPage> createState() => _ToDoFormPageState();
}

class _ToDoFormPageState extends State<ToDoFormPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (widget.toDoModel != null) {
      judulController.text = widget.toDoModel!.title;
      deskripsiController.text = widget.toDoModel!.description;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.toDoModel == null ? "Tambah To Do List" : "Edit To Do List"),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tidak boleh kosong";
                  }

                  return null;
                },
                controller: judulController,
                decoration:
                    const InputDecoration(label: Text("Judulnya apa ?")),
              ),
              TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Wajib diisi";
                    }

                    return null;
                  },
                  controller: deskripsiController,
                  minLines: 4,
                  maxLines: 4,
                  decoration: const InputDecoration(label: Text("Deskripsi"))),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        //untuk tambah data
                        if (widget.toDoModel == null) {
                          final ToDoModel toDoModel = ToDoModel(
                              title: judulController.text,
                              description: deskripsiController.text,
                              createdAt: DateTime.now().toString());

                          createItem(toDoModel);
                        }
                        //untuk update data
                        else {
                          final ToDoModel toDoModel = ToDoModel(
                              title: judulController.text,
                              description: deskripsiController.text,
                              createdAt: widget.toDoModel!.createdAt,
                              updatedAt: DateTime.now().toString());

                          updateItem(widget.toDoModel!.key!, toDoModel);
                        }
                      }
                    },
                    child: Text(widget.toDoModel == null
                        ? "Simpan To Do List"
                        : "Simpan Perubahan")),
              )
            ],
          ),
        ),
      ),
    );
  }

  final toDoListBox = Hive.box("todo_box");

  Future<void> createItem(ToDoModel toDoModel) async {
    await toDoListBox.add(toDoModel.toJson()).then((value) {
      const snackBar = SnackBar(
        content: Text("Berhasil menambahkan data"),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context, true);
    });

    print("Total data yang ada di todo_box : ${toDoListBox.length}");
  }

  Future<void> updateItem(int key, ToDoModel toDoModel) async {
    await toDoListBox.put(key, toDoModel.toJson()).then((value) {
      const snackBar = SnackBar(
        content: Text("Berhasil menyimpan perubahan"),
        backgroundColor: Colors.orange,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context, true);
    });
  }
}
