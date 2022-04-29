# Rivertion

Extends riverpod by adding the ability to manipulate data via asynchronous mutations / actions.

## Features

- Perform asynchronous data mutations
- Refresh a provider's when mutation complete

## Usage

Define your mutation:

```dart
final addTodo = MutationProvider((ref) {
  return MutationBloc((todo) async {
    await Future.delayed(const Duration(seconds: 2));

    // Call api and add a todo
    _todos = [..._todos, todo];
  });
});
```

Launch your mutation:

```dart
final addTodoState = ref.read(addTodo);

ElevatedButton(
  onPressed: addTodoState.isMutating
      ? null
      : () => ref.read(addTodo.bloc).mutate("New Todo!"),
  child: Text('Add Todo'),
),
```

## Additional information

#### Refresh a provider

You can refresh a provider when a mutation ends:

```dart
final removeTodo = MutationProvider<String, void>((ref) {
  return MutationBloc((todo) async {
    await Future.delayed(const Duration(seconds: 2)); // Api call
  }, onSuccess: (_, __) async {
    await ref.refresh(todos.future);
  });
});
```
