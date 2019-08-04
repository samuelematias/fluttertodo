import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'services/graphQldata.dart';
import 'todoApp.dart';

void main() => runApp(
      GraphQLProvider(
        client: graphQlObject.client,
        child: CacheProvider(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: TodoApp(),
          ),
        ),
      ),
    );
