import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivertion/rivertion.dart';

var _index = 0;
var _todos = <String>[];

final todos = FutureProvider((ref) async {
  await Future.delayed(const Duration(seconds: 1));

  return _todos;
});

final addTodo = MutationProvider<String, void>((ref) {
  return MutationBloc((todo) async {
    await Future.delayed(const Duration(seconds: 1));

    _todos = [..._todos, todo];
  }, onSuccess: (_, __) async {
    final _ = await ref.refresh(todos.future);
  });
});

final removeTodo = MutationProvider<String, void>((ref) {
  return MutationBloc((todo) async {
    await Future.delayed(const Duration(seconds: 1));

    _todos = _todos.where((e) => e != todo).toList();
  }, onSuccess: (_, __) async {
    final _ = await ref.refresh(todos.future);
  });
});

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rivertion Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Rivertion Example'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosState = ref.watch(todos);
    final addTodoState = ref.watch(addTodo);
    final removeTodoState = ref.watch(removeTodo);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: todosState.maybeWhen(data: (todos) {
                return ListView(
                  children: todos.map((todo) {
                    return ListTile(
                      title: Text(todo),
                      trailing: IconButton(
                        onPressed: removeTodoState.isMutating
                            ? null
                            : () => ref.read(removeTodo.bloc).mutate(todo),
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  }).toList(),
                );
              }, orElse: () {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(double.infinity, 64.0),
                minimumSize: Size(double.infinity, 64.0),
                maximumSize: Size(double.infinity, 64.0),
              ),
              onPressed: addTodoState.isMutating
                  ? null
                  : () => ref.read(addTodo.bloc).mutate("New Todo! ${_index++}"),
              child: Text('Add Todo'),
            ),
          ],
        ),
      ),
    );
  }
}
