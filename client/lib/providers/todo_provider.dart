import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/api_service.dart';

class ToDoProvider with ChangeNotifier {
  List<ToDo> _todos = [];
  final ApiService _apiService = ApiService();
  bool _hasFetched = false;

  List<ToDo> get todos => _todos;

  Future<void> fetchToDos(String userId) async {
    if (_hasFetched) return;
    try {
      _todos = await _apiService.getToDos(userId);
      _hasFetched = true;
      notifyListeners();
    } catch (e) {
      _hasFetched = false;
      rethrow;
    }
  }

  Future<void> addToDo(String userId, String title, String description) async {
    await _apiService.addToDo(userId, title, description);
    _hasFetched = false;
    await fetchToDos(userId);
  }

  Future<void> updateToDo(String todoId, String title, String description) async {
    await _apiService.updateToDo(todoId, title, description);
    _hasFetched = false;
    await fetchToDos(_todos.first.userId); // Refresh with existing userId
  }

  Future<void> deleteToDo(String todoId) async {
    await _apiService.deleteToDo(todoId);
    _hasFetched = false;
    await fetchToDos(_todos.first.userId); // Refresh with existing userId
  }

  void reset() {
    _todos = [];
    _hasFetched = false;
    notifyListeners();
  }
}