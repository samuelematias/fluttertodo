import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'components/todoCard.dart';
import 'services/graphQldata.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

GraphQLClient client;
final TextEditingController controller = TextEditingController();
initMethod(context) {
  client = GraphQLProvider.of(context).value;
}

class _TodoAppState extends State<TodoApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => initMethod(context));
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "Tag",
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context1) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                title: Text("Add task"),
                content: Form(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        autofocus: true,
                        controller: controller,
                        decoration: InputDecoration(labelText: "Task"),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: RaisedButton(
                            elevation: 7,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.black,
                            onPressed: () async {
                              await client.mutate(
                                MutationOptions(
                                  document: addTaskMutation(controller.text),
                                ),
                              );
                              Navigator.pop(context);
                              controller.text = '';
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("To-Do"),
      ),
      body: Center(
        child: Query(
          options: QueryOptions(document: fetchQuery(), pollInterval: 1),
          builder: (QueryResult result, {VoidCallback refetch}) {
            if (result.errors != null) {
              return Text(result.errors.toString());
            }
            if (result.loading) {
              return Text('Loading');
            }

            return ListView.builder(
              itemCount: result.data["todo"].length,
              itemBuilder: (BuildContext context, int index) {
                return TodoCard(
                  key: UniqueKey(),
                  task: result.data["todo"][index]["task"],
                  isCompleted: result.data["todo"][index]["isCompleted"],
                  delete: () async {
                    final Map<String, dynamic> response = (await client.mutate(
                      MutationOptions(
                        document: deleteTaskMutation(result, index),
                      ),
                    ))
                        .data;
                    print(response);
                  },
                  toggleIsCompleted: () async {
                    final Map<String, dynamic> response = (await client.mutate(
                      MutationOptions(
                        document: toggleIsCompletedMutation(result, index),
                      ),
                    ))
                        .data;
                    print(response);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
