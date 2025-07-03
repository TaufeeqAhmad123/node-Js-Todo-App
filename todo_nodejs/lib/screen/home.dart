import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_nodejs/provider/auth_provider.dart';
import 'package:todo_nodejs/provider/todo_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      todoProvider.fetchTodoData(authProvider.user!.id, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final todoProvider = Provider.of<TodoProvider>(context);
    //final todos = todoProvider.todoList;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => todoProvider.openDialog(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            onPressed: () => authProvider.logout(context),
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          final todos = todoProvider.todoList;
          if (todoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (todos.isEmpty) {
            return const Center(child: Text('No todos found'));
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Card(
                child: ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.desc),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
