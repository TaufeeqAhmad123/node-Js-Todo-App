import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_nodejs/model/todo_model.dart';
import 'package:todo_nodejs/model/user_model.dart';
import 'package:todo_nodejs/provider/auth_provider.dart';
import 'package:todo_nodejs/services/Api_services.dart';

class TodoProvider extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  


  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Todo? _todo;
  Todo? get todo => _todo;
  String? _error;
   void _clearControllers() {
    titleController.clear();
    descriptionController.clear();
  }

  Future<void> openDialog(BuildContext context) async {
    _clearControllers();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // title = value;
                },
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // title = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {
                addData(
                  titleController.text,
                  descriptionController.text,
                  context,
                );
                Navigator.of(context).pop();
              },
              child: const Text('ADD'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> addData(final String title, desc, BuildContext context) async {
    try {
      final data = await ApiServices.addData(title, desc, context);
      
      if (data['success'] == true) {
        final newTodo = Todo.fromJson(data['todo']);
        
        // Add to the beginning of the list
        _todoList.insert(0, newTodo);
        
        // Clear controllers after successful addition
        _clearControllers();
        
        print('New todo added: ${newTodo.title}');
        print('Total todos: ${_todoList.length}');
        
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Todo "${newTodo.title}" added successfully')),
          );
        }
      } else {
        _error = data['message'] ?? 'Failed to add todo';
        print('Add failed: ${data['message']}');
        
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_error!), backgroundColor: Colors.red),
          );
        }
      }
      
      _isLoading = false;
      notifyListeners();
    return data;
      
    } catch (e) {
      throw (e);
    }
  }

   List<Todo> _todoList = [];
  List<Todo> get todoList => _todoList;
  Future<void> fetchTodoData(String userId, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = await ApiServices.getUserTodoData(userId, context);
       
      final List<dynamic> rawTodos = data['todo'] ?? [];

      _todoList = rawTodos.map((json) => Todo.fromJson(json)).toList();
      notifyListeners();

    print("Fetched todos raw: ${data['todo']}");


      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch profile: ${e.toString()}';
      notifyListeners();
    }
  }
}
