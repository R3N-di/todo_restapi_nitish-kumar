import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_restapi/screens/add_page.dart';
import 'package:todo_restapi/services/todo_service.dart';
import 'package:todo_restapi/utils/snack_bar.dart';
import 'package:todo_restapi/widget/todo_card.dart';
import '../components/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appPrimary,
        centerTitle: true,
        title: Text(
          "ToDo App",
          style: TextStyle(color: appText),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        // PULL TO REFRESH ( tarik untuk me refresh )
        replacement: RefreshIndicator(
          // akan refresh fetchTodo
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                'No Todo Item',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  // ambil data dari variable items untuk ditampilkan
                  final item = items[index] as Map;
                  final id = item['_id'] as String;

                  return TodoCard(
                      index: index,
                      item: item,
                      navigateEdit: navigateToEditPage,
                      deletedById: deletedById);
                }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: appPrimary,
          onPressed: navigateToAddPage,
          label: Text(
            'Add Todo',
            style: TextStyle(color: appText),
          )),
    );
  }

  Future<void> deletedById(String id) async {
    // Delete the item
    final isSuccess = await TodoService.deletedById(id);

    if (isSuccess) {
      // Remove item from the List

      // Gunakan metode where() untuk membuat daftar baru hanya dengan elemen elemen yang memenuhi kondisi tertentu
      final filtered = items.where((element) => element['_id'] != id).toList();
      // Perbarui state (tampilan) dengan daftar yang baru
      setState(() {
        items = filtered;
      });
    } else {
      // show error
      showErrorMessage(context, messages: 'Deletion Failed');
    }

    // Remove item from the list
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showErrorMessage(context, messages: 'Something went wrong');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(builder: (context) => AddPage(todo: item));
    await Navigator.push(context, route);
    // auto reload saat mengedit data
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => AddPage());
    await Navigator.push(context, route);
    // auto reload saat menambah data
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }
}
