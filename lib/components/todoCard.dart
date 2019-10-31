import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final String task;
  final bool isCompleted;
  final Function delete;
  final Function toggleIsCompleted;
  const TodoCard({
    Key key,
    this.task,
    this.isCompleted,
    this.delete,
    this.toggleIsCompleted,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.0,
        top: 8.0,
        right: 12.0,
      ),
      child: InkWell(
        onTap: () {
          toggleIsCompleted();
        },
        child: Card(
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              task,
              style: TextStyle(
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            leading: Padding(
              padding: EdgeInsets.only(left: 18.0),
              child: Icon(
                !isCompleted
                    ? Icons.radio_button_unchecked
                    : Icons.radio_button_checked,
              ),
            ),
            trailing: InkWell(
              onTap: () {
                delete();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
                width: 60,
                height: double.infinity,
                child: Icon(
                  Icons.delete,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
