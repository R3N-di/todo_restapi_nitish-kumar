import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../components/colors.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateEdit;
  final Function(String) deletedById;

  const TodoCard({super.key, required this.index, required this.item, required this.navigateEdit, required this.deletedById});

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: appPrimary, child: Text('${index + 1}')),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          onSelected: (value) {
            if (value == 'edit') {
              // Open Edit Page
              navigateEdit(item);
            } else if (value == 'delete') {
              // delete and remove the item
              deletedById(id);
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text('Edit'),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text('Delete'),
                value: 'delete',
              ),
            ];
          },
        ),
      ),
    );
    ;
  }
}
