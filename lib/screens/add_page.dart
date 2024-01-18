import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_restapi/components/colors.dart';
import 'package:todo_restapi/services/todo_service.dart';
import 'package:todo_restapi/utils/snack_bar.dart';

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({super.key, this.todo});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];

      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimary,
        centerTitle: true,
        title: Text(
          isEdit ? 'Edit Todo' : "Add Todo",
          style: TextStyle(
            color: appText,
          ),
        ),
      ),

      // FOMR
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'What you want to do ?'),
          ),
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Input the detail ...',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(isEdit ? 'Update' : 'Submit'),
              )),
        ],
      ),
    );
  }

  // FORM HANDLING

  // Handling saat update
  Future<void> updateData() async {
    // DAPATKAN DATA DARI FORM
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call updated without todo data');
      return;
    }

    final id = todo['_id'];

    // UPDATE DATANYA KE SERVER
    final isSuccess = await TodoService.updateTodo(id, body);

    if (isSuccess) {
      print("Updation Success");
      showSuccessMessage(context, messages: 'Updation Success');
    } else {
      showErrorMessage(context, messages: "Updation Failed");
      print("Updation Failed");
    }
  }

  // Handling saat submit
  Future<void> submitData() async {

    // SUBMIT DATANYA KE SERVER
    final isSuccess = await TodoService.addTodo(body);

    if (isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      print("Creation Success");
      showSuccessMessage(context, messages: 'Creation Success');
    } else {
      showErrorMessage(context, messages: "Creation Failed");

      print("Creation Failed");
    }
  }

  Map get body{
    // DAPATKAN DATA DARI FORM
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      'title': title,
      'description': description,
      'is_completed': false,
    };
  }
  
}
